//
//  SettingsView.swift
//  TanzpartnerOstfrieslandiOS
//

import SwiftUI

// MARK: - AppTheme

enum AppTheme: String, CaseIterable {
    case auto = "Automatisch"
    case light = "Hell"
    case dark = "Dunkel"

    var colorScheme: ColorScheme? {
        switch self {
        case .auto: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }

    var icon: String {
        switch self {
        case .auto: return "circle.grid.cross.fill"
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        }
    }
}

// MARK: - SettingsView

struct SettingsView: View {
    @EnvironmentObject private var store: ProfileStore
    @AppStorage("enablePushNotifications") private var enablePushNotifications = true
    @AppStorage("autoSync") private var autoSync = true
    @AppStorage("appTheme") private var selectedThemeRaw = AppTheme.auto.rawValue

    @State private var showingResetConfirmation = false
    @State private var didResetDemoData = false

    private var themeBinding: Binding<AppTheme> {
        Binding(
            get: { AppTheme(rawValue: selectedThemeRaw) ?? .auto },
            set: { selectedThemeRaw = $0.rawValue }
        )
    }

    private var appVersionText: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Benachrichtigungen")) {
                    Toggle(isOn: $enablePushNotifications) {
                        Label("Push-Benachrichtigungen", systemImage: "bell.fill")
                    }
                }

                Section(header: Text("Synchronisation")) {
                    Toggle(isOn: $autoSync) {
                        Label("Automatisch synchronisieren", systemImage: "arrow.triangle.2.circlepath")
                    }

                    HStack {
                        Text("Speicherort")
                        Spacer()
                        Text("Nur lokal (JSON)")
                            .foregroundColor(.secondary)
                    }
                }

                Section(header: Text("Darstellung")) {
                    Picker("Theme", selection: themeBinding) {
                        ForEach(AppTheme.allCases, id: \.self) { theme in
                            Label(theme.rawValue, systemImage: theme.icon)
                                .tag(theme)
                        }
                    }
                }

                Section(header: Text("Präsentation")) {
                    Button(role: .destructive) {
                        showingResetConfirmation = true
                    } label: {
                        Label("Beispieldaten zurücksetzen", systemImage: "arrow.counterclockwise")
                    }

                    if didResetDemoData {
                        Label("Die 8 Ausgangsprofile wurden wiederhergestellt.", systemImage: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }

                Section(header: Text("Über")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(appVersionText)
                            .foregroundColor(.secondary)
                    }

                    NavigationLink("Datenschutz") {
                        PrivacyPolicyView()
                    }

                    NavigationLink("Impressum") {
                        ImprintView()
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Einstellungen")
            .alert("Beispieldaten zurücksetzen?", isPresented: $showingResetConfirmation) {
                Button("Zurücksetzen", role: .destructive) {
                    store.resetToSeedProfiles()
                    didResetDemoData = true
                }
                Button("Abbrechen", role: .cancel) {}
            } message: {
                Text("Alle selbst angelegten oder geänderten Profile werden verworfen und die 8 Ausgangsprofile wiederhergestellt.")
            }
        }
    }
}

// MARK: - Rechtliche Ansichten

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Stand: 15. November 2026")
                    .font(.caption)
                    .foregroundColor(.secondary)

                legalSection(
                    title: "1. Verantwortlicher",
                    text: "Sven Schley\nAmselstr. 10\n26506 Norden, Deutschland\nE-Mail: sven@schley.org"
                )

                legalSection(
                    title: "2. Umfang dieser App",
                    text: "Diese iOS-App ist ein Prototyp zur regionalen Tanzpartnersuche in Ostfriesland. Die mitgelieferten Beispielprofile sind fiktiv. Es gibt aktuell keine Benutzerkonten und keinen Nachrichtenversand."
                )

                legalSection(
                    title: "3. Lokale Datenspeicherung",
                    text: "Alle angelegten oder bearbeiteten Profile sowie Einstellungen werden ausschließlich lokal auf diesem Gerät gespeichert (profiles.json im App-Dokumentenordner sowie UserDefaults). Es findet derzeit keine Übertragung an einen Server statt."
                )

                legalSection(
                    title: "4. Analyse und Tracking",
                    text: "Es werden keine Analyse-, Tracking- oder Werbedienste eingebunden."
                )

                legalSection(
                    title: "5. Ihre Rechte",
                    text: "Sie haben nach Maßgabe der DSGVO Rechte auf Auskunft, Berichtigung, Löschung, Einschränkung der Verarbeitung und Datenübertragbarkeit. Bei Fragen wenden Sie sich an sven@schley.org. Zuständige Aufsichtsbehörde ist der Landesbeauftragte für den Datenschutz Niedersachsen."
                )
            }
            .padding()
        }
        .navigationTitle("Datenschutz")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func legalSection(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
            Text(text)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

struct ImprintView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Anbieter und Kontakt")
                        .font(.headline)
                    Text("Sven Schley\nAmselstr. 10\n26506 Norden\nDeutschland")
                        .foregroundColor(.secondary)
                    Text("E-Mail: sven@schley.org")
                        .foregroundColor(.secondary)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Über dieses Angebot")
                        .font(.headline)
                    Text("Tanzpartner Ostfriesland ist ein Prototyp zur Erprobung einer regionalen Tanzpartnersuche. Alle dargestellten Beispielprofile sind frei erfunden. Die Plattform ist unabhängig von Tanzschulen und kein Dating-Angebot.")
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle("Impressum")
        .navigationBarTitleDisplayMode(.inline)
    }
}
