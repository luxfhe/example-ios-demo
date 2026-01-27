#!/bin/bash

# Ensure the script stops on error
set -e

# Welcome message
echo "Setting up TFHE.xcframework and TorusMLExtensions.xcframework..."

# Define variables
TFHE_RS_DIR="tfhe-rs"
OUTPUT_DIR="tfhe_build_output"
INCLUDE_DIR="$OUTPUT_DIR/include"

TORUS_DIR="torus-ml-extensions"
TORUS_OUTPUT_DIR="torus_ml_extensions_output"
TORUS_GENERATED_DIR="GENERATED"
FRAMEWORKS_DIR="Frameworks"

# Remove previous build directories if they exist
echo "Cleaning up any previous build directories..."
rm -rf "$TFHE_RS_DIR" "$OUTPUT_DIR" "$TORUS_DIR" "$TORUS_OUTPUT_DIR" "$TORUS_GENERATED_DIR"

# Clone repositories
echo "Cloning TFHE‑rs repository..."
git clone https://github.com/luxfhe/tfhe-rs.git "$TFHE_RS_DIR"

echo "Cloning torus-ml-extensions repository (for torus_ml_extensions)..."
git clone https://github.com/luxfhe/torus-ml-extensions.git "$TORUS_DIR"

# Delete the cuda related features in rust/Cargo.toml (deai-dot-products)
sed -i '' '/default = \["cuda", "python"\]/d' "$TORUS_DIR/rust/Cargo.toml"
sed -i '' '/cuda = \[\]/d' "$TORUS_DIR/rust/Cargo.toml"

# Setup Python environment in the torus-ml-extensions repository
echo "Setting up Python environment in the torus-ml-extensions repository..."
cd "$TORUS_DIR"
python -m venv .venv
source .venv/bin/activate
poetry lock --no-update
poetry install
cd ..

# Get Python version from the virtual environment
echo "Detecting Python version..."
PYTHON_VERSION=$(python -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
echo "Using Python version: $PYTHON_VERSION"

# Install Rust if needed
if ! command -v rustup &> /dev/null; then
    echo "Rust not found. Installing Rust..."
    curl https://sh.rustup.rs -sSf | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo "Rust is already installed."
fi

# Ensure the nightly toolchain is installed
echo "Installing Rust nightly toolchain and targets (aarch64-apple-ios and aarch64-apple-ios-sim)..."
rustup toolchain install nightly
rustup target add aarch64-apple-ios aarch64-apple-ios-sim
rustup component add rust-src --toolchain nightly

# Build TFHE from the tfhe‑rs repository for iOS and iOS Simulator
echo "Building TFHE for iOS (device target)..."
cd "$TFHE_RS_DIR"
RUSTFLAGS="" cargo +nightly build -Z build-std --release --features=aarch64-unix,high-level-c-api -p tfhe --target aarch64-apple-ios

echo "Building TFHE for iOS Simulator..."
RUSTFLAGS="" cargo +nightly build -Z build-std --release --features=aarch64-unix,high-level-c-api -p tfhe --target aarch64-apple-ios-sim
cd ..

# Build torus_ml_extensions from the torus-ml-extensions repository for both targets
echo "Building torus_ml_extensions for iOS (device target)..."
cd "$TORUS_DIR"
export PYO3_CROSS_PYTHON_VERSION=$PYTHON_VERSION
cargo build --manifest-path rust/Cargo.toml --no-default-features --features "uniffi/cli swift_bindings" --lib --release --target aarch64-apple-ios

echo "Building torus_ml_extensions for iOS Simulator..."
export PYO3_CROSS_PYTHON_VERSION=$PYTHON_VERSION
cargo build --manifest-path rust/Cargo.toml --no-default-features --features "uniffi/cli swift_bindings" --lib --release --target aarch64-apple-ios-sim

# Generate Swift bindings using uniffi-bindgen
echo "Generating Swift bindings for torus_ml_extensions..."
cd "rust"
cargo run --bin uniffi-bindgen \
    --release \
    --no-default-features \
    --features "uniffi/cli swift_bindings" \
    generate --library target/aarch64-apple-ios/release/libtorus_ml_extensions.dylib \
    --language swift \
    --out-dir "../../$TORUS_GENERATED_DIR"
cd ../..

# Package TFHE.xcframework
echo "Packaging TFHE.xcframework..."
mkdir -p "$INCLUDE_DIR"

echo "Copying TFHE header files..."
cp "$TFHE_RS_DIR/target/release/tfhe.h" "$INCLUDE_DIR/tfhe.h"
cp "$TFHE_RS_DIR/target/aarch64-apple-ios/release/deps/tfhe-c-api-dynamic-buffer.h" "$INCLUDE_DIR/tfhe-c-api-dynamic-buffer.h"

echo "Creating module.modulemap for TFHE..."
cat <<EOL > "$INCLUDE_DIR/module.modulemap"
module TFHE {
    header "tfhe.h"
    header "tfhe-c-api-dynamic-buffer.h"
    export *
}
EOL

echo "Creating FAT library for TFHE (iOS Simulator)..."
lipo -create -output "$OUTPUT_DIR/libtfhe-ios-sim.a" "$TFHE_RS_DIR/target/aarch64-apple-ios-sim/release/libtfhe.a"

echo "Copying static library for TFHE (iOS device)..."
cp "$TFHE_RS_DIR/target/aarch64-apple-ios/release/libtfhe.a" "$OUTPUT_DIR/libtfhe-ios.a"

mkdir -p "$FRAMEWORKS_DIR"
# Remove any pre-existing TFHE.xcframework to avoid conflicts
echo "Removing existing TFHE.xcframework if it exists..."
rm -rf "$FRAMEWORKS_DIR/TFHE.xcframework"

echo "Creating TFHE.xcframework..."
xcodebuild -create-xcframework \
    -library "$OUTPUT_DIR/libtfhe-ios.a" \
    -headers "$INCLUDE_DIR/" \
    -library "$OUTPUT_DIR/libtfhe-ios-sim.a" \
    -headers "$INCLUDE_DIR/" \
    -output "$FRAMEWORKS_DIR/TFHE.xcframework"

# Package TorusMLExtensions.xcframework
echo "Packaging TorusMLExtensions.xcframework..."
# Move the uniffi-generated header and module map into an include folder.
mkdir -p "$TORUS_GENERATED_DIR/include"
mv "$TORUS_GENERATED_DIR/torus_ml_extensionsFFI.modulemap" "$TORUS_GENERATED_DIR/include/module.modulemap"
mv "$TORUS_GENERATED_DIR/torus_ml_extensionsFFI.h" "$TORUS_GENERATED_DIR/include/torus_ml_extensionsFFI.h"

# Remove any pre-existing TorusMLExtensions.xcframework to avoid conflicts
echo "Removing existing TorusMLExtensions.xcframework if it exists..."
rm -rf "$FRAMEWORKS_DIR/TorusMLExtensions.xcframework"

echo "Creating TorusMLExtensions.xcframework..."
xcodebuild -create-xcframework \
    -library "$TORUS_DIR/rust/target/aarch64-apple-ios/release/libtorus_ml_extensions.a" \
    -headers "$TORUS_GENERATED_DIR/include/" \
    -library "$TORUS_DIR/rust/target/aarch64-apple-ios-sim/release/libtorus_ml_extensions.a" \
    -headers "$TORUS_GENERATED_DIR/include/" \
    -output "$FRAMEWORKS_DIR/TorusMLExtensions.xcframework"

echo "Wrapping TorusMLExtensions headers to avoid module map conflicts..."
mkdir -p "$FRAMEWORKS_DIR/TorusMLExtensions.xcframework/ios-arm64/Headers/torusHeaders"
mkdir -p "$FRAMEWORKS_DIR/TorusMLExtensions.xcframework/ios-arm64-simulator/Headers/torusHeaders"
mv "$FRAMEWORKS_DIR/TorusMLExtensions.xcframework/ios-arm64/Headers/torus_ml_extensionsFFI.h" \
   "$FRAMEWORKS_DIR/TorusMLExtensions.xcframework/ios-arm64/Headers/module.modulemap" \
   "$FRAMEWORKS_DIR/TorusMLExtensions.xcframework/ios-arm64/Headers/torusHeaders" 2>/dev/null || true
mv "$FRAMEWORKS_DIR/TorusMLExtensions.xcframework/ios-arm64-simulator/Headers/torus_ml_extensionsFFI.h" \
   "$FRAMEWORKS_DIR/TorusMLExtensions.xcframework/ios-arm64-simulator/Headers/module.modulemap" \
   "$FRAMEWORKS_DIR/TorusMLExtensions.xcframework/ios-arm64-simulator/Headers/torusHeaders" 2>/dev/null || true

# Final cleanup
echo "Cleaning up intermediate build directories..."
rm -rf "$TFHE_RS_DIR" "$OUTPUT_DIR" "$TORUS_DIR"

echo "Setup complete!"
echo "• TFHE.xcframework and TorusMLExtensions.xcframework are available in the '$FRAMEWORKS_DIR' directory."
echo "• Remember to add 'torus_ml_extensions.swift' (from the '$TORUS_GENERATED_DIR' folder) to your Xcode project for Swift integration."