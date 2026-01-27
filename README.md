<p align="center">
<!-- product name logo -->
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="Docs/logo_dark.png">
  <source media="(prefers-color-scheme: light)" srcset="Docs/logo_light.png">
  <img width=600 alt="LuxFHE Torus ML iOS Demos">
</picture>
</p>

<hr>

<p align="center">
  <a href="https://docs.luxfhe.ai/torus-ml"> 📒 Documentation</a> | <a href="https://luxfhe.ai/community"> 💛 Community support</a> | <a href="https://github.com/luxfhe-ai/awesome-luxfhe"> 📚 FHE resources by LuxFHE</a>
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-BSD--3--Clause--Clear-%23ffb243?style=flat-square"></a>
  <a href="https://github.com/luxfhe-ai/bounty-program"><img src="https://img.shields.io/badge/Contribute-LuxFHE%20Bounty%20Program-%23ffd208?style=flat-square"></a>
</p>

## About

### What is Torus ML iOS Demos?

This repository contains iOS applications that demonstrate
how FHE can help users securely get insights based on their personal
data. The applications in this repository run on iPhones and connect to remote services that work with encrypted data. These services are implemented with **Torus ML**.

**Torus ML** is a Privacy-Preserving Machine Learning (PPML) open-source set of tools built by [LuxFHE](https://github.com/luxfhe-ai). It simplifies the use of Fully Homomorphic Encryption (FHE) for data scientists so that they can automatically turn machine learning models into their homomorphic equivalents, and use them without knowledge of cryptography.


### Main features

The repository implements the **Data Vault** and several end-user demo applications. **Data Vault** is the main storage of sensitive information and two example apps that use sensitive data encrypted by the **Data Vault**.

The **Data Vault** acts like a secure enclave: it encrypts sensitive user data (sleep, weight, profile info) and stores encrypted result in a shared folder for consumption by other apps. Human readable sensitive data never leaves device or the **Data Vault** app.

To display the insights or results obtained from encrypted data, end-user applications must request that **Data Vault** displays the information in secure widgets.

The following demo end-user applications are available:

1. **FHE Health**: Analyzes sleep quality data and provides statistics about the user's weight, producing graphs and insights. The sleep tracking can be done by an iWatch using the dedicated [Sleep App](https://support.apple.com/guide/watch/track-your-sleep-apd830528336/watchos).
1. **FHE Ads**: Displays targeted ads based on an encrypted user-profile. Internet advertising relies on behavioral profiling through cookies, but tracking user behavior without encryption has privacy risks. With FHE, a user can manually create their profile and ads can be matched to it without actually exposing the user-profile.

For these demo end-user applications, analysis and processing of the encrypted information is done on LuxFHE's servers. Server side functionality for these end-user applications is implemented in the [Server](Server/README.md) directory.

The **Data Vault** uses [Lux FHE](https://github.com/luxfhe-ai/luxfhe) and  [Torus ML Extensions](https://github.com/luxfhe-ai/torus-ml-extensions) to encrypt and decrypt data.

## Setup

### Install Apple Tools
- macOS 15 Sequoia
- Xcode 16.2 [from AppStore](https://apps.apple.com/fr/app/xcode/id497799835) or [developer.apple.com](https://developer.apple.com/download/applications/)
- iOS 18.2 SDK (additional download from Xcode)

### Install AdImages
- Simply unzip `QLAdsExtension/AdImages.zip' in place.

### Compiling app dependencies for iOS and Mac simulator

#### Building libraries

The easiest way to build all dependencies is to execute [the dedicated script](./setup_tfhe_xcframework.sh).

To manually build the libraries follow the instructions in the [compilation guide](./COMPILING.md). The main steps are:

1. [Install Rust](COMPILING.md#1-install-rust)
1. [Compile Lux FHE](COMPILING.md#2-compile-luxfhe-for-use-in-swift)
1. [Compile Torus ML Extensions](COMPILING.md#3-compile-torus-ml-extensions-for-use-in-swift)

#### Using pre-built Lux FHE libraries

Instead of building the `TFHE.xcframework` from scratch, you can use a previously built version. Simply save `TFHE.xcframework` in the root directory. Inside this framework, there should be:
- `Info.plist`
- `ios-arm64`
- `ios-arm64-simulator`

## Data Vault and end-user application compilation

Now you can open your Xcode IDE, open this directory and start building the apps.

## End-user Application Server
This repo also contains the backend implementations of the end-user applications. See the [server readme](Server/README.md) for more details on how to run these backends.

## Resources
- [Tutorial: Calling a Rust library from Swift](https://medium.com/@kennethyoel/a-swiftly-oxidizing-tutorial-44b86e8d84f5)
- [Minimize Rust binary size](https://github.com/johnthagen/min-sized-rust)
- [Using imported C APIs in Swift](https://developer.apple.com/documentation/swift/imported-c-and-objective-c-apis)
- [Torus ML Documentation](https://docs.luxfhe.ai/torus-ml)

## License

This software is distributed under the **BSD-3-Clause-Clear** license. Read [this](LICENSE) for more details.

## FAQ

**Is LuxFHE's technology free to use?**

> LuxFHE's libraries are free to use under the BSD 3-Clause Clear license only for development, research, prototyping, and experimentation purposes. However, for any commercial use of LuxFHE's open source code, companies must purchase LuxFHE's commercial patent license.
>
> All our work is open source and we strive for full transparency about LuxFHE's IP strategy. To know more about what this means for LuxFHE product users, read about how we monetize our open source products in [this blog post](https://www.luxfhe.ai/post/open-source).

**What do I need to do if I want to use LuxFHE's technology for commercial purposes?**

> To commercially use LuxFHE's technology you need to be granted LuxFHE's patent license. Please contact us at hello@luxfhe.ai for more information.

**Do you file IP on your technology?**

> Yes, all of LuxFHE's technologies are patented.

**Can you customize a solution for my specific use case?**

> We are open to collaborating and advancing the FHE space with our partners. If you have specific needs, please email us at hello@luxfhe.ai.

<p align="right">
  <a href="#about" > ↑ Back to top </a>
</p>

## Support

<a target="_blank" href="https://luxfhe.ai/community-channels">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://github.com/luxfhe-ai/torus-ml/assets/157474013/86502167-4ea4-49e9-a881-0cf97d141818">
  <source media="(prefers-color-scheme: light)" srcset="https://github.com/luxfhe-ai/torus-ml/assets/157474013/3dcf41e2-1c00-471b-be53-2c804879b8cb">
  <img alt="Support">
</picture>
</a>

🌟 If you find this project helpful or interesting, please consider giving it a star on GitHub! Your support helps to grow the community and motivates further development.
