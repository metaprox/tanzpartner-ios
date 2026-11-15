//
//  App.swift
//  TanzpartnerOstfrieslandiOS
//

import SwiftUI

@main
struct TanzpartnerOstfrieslandiOSApp: App {
    @StateObject private var store = ProfileStore()
    @AppStorage("appTheme") private var selectedThemeRaw = AppTheme.auto.rawValue

    private var selectedTheme: AppTheme {
        AppTheme(rawValue: selectedThemeRaw) ?? .auto
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .preferredColorScheme(selectedTheme.colorScheme)
        }
    }
}
