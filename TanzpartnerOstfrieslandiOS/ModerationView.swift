//
//  ModerationView.swift
//  TanzpartnerOstfrieslandiOS
//
//  Created by Sven Schley on 14.11.2026.
//

import SwiftUI

struct ModerationView: View {
    @State private var moderationItems: [ModerationItem] = [
        ModerationItem(id: 1, profileName: "Mara", status: .approved, date: Date(), note: nil),
        ModerationItem(id: 2, profileName: "Jan", status: .approved, date: Date(), note: "Sehr engagiert"),
        ModerationItem(id: 3, profileName: "Alva", status: .approved, date: Date(), note: null),
        ModerationItem(id: 4, profileName: "Timo", status: .pending, date: Date(), note: null),
        ModerationItem(id: 5, profileName: "Jule", status: .approved, date: Date(), note: null)
    ]
    
    var body: some View {
        NavigationView {
            List(moderationItems) { item in
                ModerationRow(item: item)
            }
            .navigationTitle("Moderation")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {}) {
                        Label("Hinzufügen", systemImage: "plus.circle.fill")
                    }
                }
            }
        }
    }
}

struct ModerationRow: View {
    let item: ModerationItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            statusCircle(status: item.status)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.profileName)
                    .font(.headline)
                
                HStack(spacing: 8) {
                    Text(item.status.displayText)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(statusColor.opacity(0.1))
                        .cornerRadius(6)
                        .foregroundColor(statusColor)
                    
                    Spacer()
                    
                    Text(item.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let note = item.note {
                    HStack(spacing: 4) {
                        Image(systemName: "note.fill")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(note)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
    
    private var statusColor: Color {
        switch item.status {
        case .pending: return .orange
        case .approved: return .green
        case .returned: return .red
        case .paused: return .gray
        }
    }
    
    private func statusCircle(status: ModerationStatus) -> some View {
        Circle()
            .fill(statusColor)
            .frame(width: 48, height: 48)
            .overlay(
                Image(systemName: status.icon)
                    .foregroundColor(.white)
            )
    }
}

// MARK: - Moderation Models

struct ModerationItem: Identifiable {
    let id: Int
    let profileName: String
    let status: ModerationStatus
    let date: Date
    let note: String?
}

enum ModerationStatus: String, CaseIterable {
    case pending = "Wartet auf Prüfung"
    case approved = "Lokal freigegeben"
    case returned = "Zurückgestellt"
    case paused = "Pausiert"
    
    var displayText: String { rawValue }
    var icon: String {
        switch self {
        case .pending: return "hourglass.fill"
        case .approved: return "checkmark.circle.fill"
        case .returned: return "return.down.back.icon.fill"
        case .paused: return "pause.fill"
        }
    }
}

// MARK: - SettingsView

struct SettingsView: View {
    @State private var enablePushNotifications = true
    @State private var autoSync = true
    @State private var theme: Theme = .auto
    
    enum Theme: String, CaseIterable {
        case auto = "Automatisch"
        case light = "Hell"
        case dark = "Dunkel"
    }
    
    var body: some View {
        List {
            Section(header: Text("Benachrichtigungen")) {
                Toggle(isOn: $enablePushNotifications) {
                    HStack {
                        Image(systemName: "bell.fill")
                        Text("Push-Benachrichtigungen")
                    }
                }
            }
            
            Section(header: Text("Synchronisation")) {
                Toggle(isOn: $autoSync) {
                    HStack {
                        Image(systemName: "arrow.triangle.2.circlepath.fill")
                        Text("Automatisch synchronisieren")
                    }
                }
                
                HStack {
                    Text("Letzte Synchronisation")
                    Spacer()
                    Text("Gerade eben")
                        .foregroundColor(.secondary)
                }
            }
            
            Section(header: Text("Darstellung")) {
                Picker("Theme", selection: $theme) {
                    ForEach(Theme.allCases, id: \.self) { theme in
                        HStack {
                            Image(systemName: theme == .dark ? "moon.fill" : theme == .light ? "sun.max.fill" : "circle.grid.cross.fill")
                            Text(theme.rawValue)
                        }
                        .tag(theme)
                    }
                }
            }
            
            Section(header: Text("Über")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("0.1.0")
                        .foregroundColor(.secondary)
                }
                
                Button("Datenschutz") {}
                Button("Impressum") {}
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Einstellungen")
    }
}