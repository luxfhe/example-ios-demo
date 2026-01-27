// Copyright © 2025 Lux. All rights reserved.

import Foundation

enum LuxConfig {
    static let rootAPI = URL(string: "https://api.lux.network:443")!
    static let websiteLandingPage = URL(string: "https://www.lux.network")!
    static let websiteFHEIntro = URL(string: "https://www.lux.network/introduction-to-homomorphic-encryption")!
}

extension AppInfo {
    static let appleHealth = {
        AppInfo(name: "Apple Health",
                deeplink: "x-apple-health://",
                appStoreID: "1242545199")
    }()

    static func luxDataVault(tab: DataVaultTab) -> AppInfo {
        AppInfo(name: "Lux Data Vault",
                deeplink: "luxdatavault://\(tab.rawValue)",
                appStoreID: "6738993762")
    }

    static func fheHealth(tab: HealthTab) -> AppInfo {
        AppInfo(name: "FHE Health",
                deeplink: "fhehealth://\(tab.rawValue)",
                appStoreID: "6738993713")
    }

    static let fheAds = {
        AppInfo(name: "FHE Ads",
                deeplink: "fheads://",
                appStoreID: "6739003587")
    }()
}

enum DataVaultTab: String {
    case home = "home"
    case sleep = "sleep"
    case weight = "weight"
    case profile = "profile"

    var displayInfo: (name: String, icon: String) {
        switch self {
        case .home: (name: "Home", icon: "house")
        case .sleep: (name: "Sleep", icon: "bed.double.fill")
        case .weight: (name: "Weight", icon: "scalemass.fill")
        case .profile: (name: "Profile", icon: "person.text.rectangle.fill")
        }
    }

    init?(url: URL) {
        guard let host = url.host(), let tab = DataVaultTab(rawValue: host) else {
            return nil
        }
        self = tab
    }
}

enum HealthTab: String {
    case home = "home"
    case sleep = "sleep"
    case weight = "weight"

    var displayInfo: (name: String, icon: String) {
        switch self {
        case .home: (name: "Home", icon: "house")
        case .sleep: (name: "Sleep", icon: "bed.double.fill")
        case .weight: (name: "Weight", icon: "scalemass.fill")
        }
    }

    init?(url: URL) {
        guard let host = url.host(), let tab = HealthTab(rawValue: host) else {
            return nil
        }
        self = tab
    }
}
