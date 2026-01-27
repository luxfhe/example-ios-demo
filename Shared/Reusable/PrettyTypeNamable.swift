// Copyright © 2025 Lux. All rights reserved.

protocol PrettyTypeNamable {}
extension PrettyTypeNamable {
    var prettyTypeName: String {
        String(describing: self)
            .replacingOccurrences(of: "_", with: " ")
            .localizedCapitalized
    }
}
