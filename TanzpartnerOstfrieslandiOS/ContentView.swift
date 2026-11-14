//
//  ContentView.swift
//  TanzpartnerOstfrieslandiOS
//
//  Created by Sven Schley on 14.11.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ProfileListView()
                .tabItem {
                    Label("Tanzpartner", systemImage: "person.2.fill")
                }
                .tag(0)
            
            ModerationView()
                .tabItem {
                    Label("Moderation", systemImage: "checkmark.circle.fill")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Label("Einstellungen", systemImage: "gearshape.fill")
                }
                .tag(2)
        }
        .accentColor(.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}