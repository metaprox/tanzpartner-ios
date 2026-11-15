//
//  ModerationView.swift
//  TanzpartnerOstfrieslandiOS
//
//  Created by Sven Schley on 14.11.2026.
//

import SwiftUI

struct ModerationView: View {
    @EnvironmentObject private var store: ProfileStore

    /// nil = alle Status anzeigen
    @State private var selectedStatus: ModerationStatus?

    // Bearbeiten-Zustand
    @State private var editingProfile: Profile?
    @State private var showingNewProfile = false

    /// Offene Fälle zuerst, danach nach Name
    private var sortedProfiles: [Profile] {
        store.profiles
            .filter { selectedStatus == nil || $0.status == selectedStatus }
            .sorted { lhs, rhs in
                if lhs.status.priority != rhs.status.priority {
                    return lhs.status.priority < rhs.status.priority
                }
                return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
            }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                statusFilterBar

                List(sortedProfiles) { profile in
                    ModerationRow(profile: profile)
                        .contentShape(Rectangle())
                        .onTapGesture { editingProfile = profile }
                }
                .listStyle(PlainListStyle())

                if sortedProfiles.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        Text("Keine Einträge in dieser Kategorie")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
            }
            .navigationTitle("Moderation")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingNewProfile = true }) {
                        Label("Hinzufügen", systemImage: "plus.circle.fill")
                    }
                }
            }
            .sheet(item: $editingProfile) { profile in
                ProfileEditorView(profile: profile)
            }
            .sheet(isPresented: $showingNewProfile) {
                ProfileEditorView()
            }
        }
    }

    // MARK: - Status-Filter (horizontal scrollbar)

    private var statusFilterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterPill(
                    label: "Alle",
                    value: "\(store.profiles.count)",
                    isActive: selectedStatus == nil
                )
                .onTapGesture { selectedStatus = nil }

                ForEach(ModerationStatus.allCases, id: \.self) { status in
                    FilterPill(
                        label: status.shortText,
                        value: "\(store.profiles.filter { $0.status == status }.count)",
                        isActive: selectedStatus == status
                    )
                    .onTapGesture { selectedStatus = status }
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 48)
    }
}

// MARK: - ModerationRow

struct ModerationRow: View {
    let profile: Profile

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            statusCircle(status: profile.status)

            VStack(alignment: .leading, spacing: 4) {
                Text(profile.name)
                    .font(.headline)

                HStack(spacing: 8) {
                    Text(profile.status.displayText)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(statusColor.opacity(0.1))
                        .cornerRadius(6)
                        .foregroundColor(statusColor)

                    Spacer()

                    if let updatedAt = profile.updatedAt {
                        Text(updatedAt, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                if let note = profile.note {
                    HStack(spacing: 4) {
                        Image(systemName: "note.text")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(note)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }

            Spacer()

            Image(systemName: "pencil")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }

    private var statusColor: Color {
        switch profile.status {
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
        NavigationStack {
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
                            Image(systemName: "arrow.triangle.2.circlepath")
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
}
