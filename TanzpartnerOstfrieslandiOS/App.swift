//
//  App.swift
//  TanzpartnerOstfrieslandiOS
//

import SwiftUI

@main
struct TanzpartnerOstfrieslandiOSApp: App {
    @StateObject private var store = ProfileStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environment(\.colorScheme, .light)
        }
    }
}
