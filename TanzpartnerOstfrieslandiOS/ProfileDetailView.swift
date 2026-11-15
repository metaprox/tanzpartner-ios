//
//  ProfileDetailView.swift
//  TanzpartnerOstfrieslandiOS
//

import SwiftUI

struct ProfileDetailView: View {
    @EnvironmentObject private var store: ProfileStore
    let profileID: Int

    @State private var showingEditor = false
    @State private var messageText = ""
    @State private var didInitializeMessage = false
    @State private var simulationSent = false

    private var profile: Profile? {
        store.profiles.first { $0.id == profileID }
    }

    var body: some View {
        Group {
            if let profile {
                List {
                    headerSection(profile: profile)

                    if !profile.bio.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Section("Über mich") {
                            Text(profile.bio)
                                .font(.body)
                                .padding(.vertical, 4)
                        }
                    }

                    Section("Tanzdetails") {
                        if let role = profile.role, !role.isEmpty {
                            detailRow(title: "Tanzrolle", value: role, systemImage: "figure.socialdance")
                        }
                        if !profile.level.isEmpty {
                            detailRow(title: "Erfahrung", value: profile.level, systemImage: "star.fill")
                        }
                        if !profile.goal.isEmpty {
                            detailRow(title: "Tanzziel", value: profile.goal, systemImage: "target")
                        }
                        if !profile.places.isEmpty {
                            detailRow(
                                title: "Mögliche Kursorte",
                                value: profile.places.joined(separator: ", "),
                                systemImage: "mappin.and.ellipse"
                            )
                        }
                        if !profile.time.isEmpty {
                            detailRow(title: "Verfügbare Zeiten", value: profile.time, systemImage: "clock.fill")
                        }
                    }

                    contactSimulationSection(profile: profile)
                }
                .listStyle(.insetGrouped)
                .navigationTitle(profile.name)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Bearbeiten") {
                            showingEditor = true
                        }
                    }
                }
                .sheet(isPresented: $showingEditor) {
                    ProfileEditorView(profile: profile)
                }
                .onAppear {
                    if !didInitializeMessage {
                        messageText = defaultGreeting(for: profile.name)
                        didInitializeMessage = true
                    }
                }
            } else {
                ContentUnavailableView(
                    "Profil nicht verfügbar",
                    systemImage: "person.slash",
                    description: Text("Dieses Profil wurde gelöscht oder zurückgezogen.")
                )
            }
        }
    }

    // MARK: - Sektionen

    private func headerSection(profile: Profile) -> some View {
        Section {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 14) {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .indigo],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 64, height: 64)
                        .overlay(
                            Text(profile.name.prefix(1))
                                .font(.title)
                                .foregroundColor(.white)
                                .bold()
                        )

                    VStack(alignment: .leading, spacing: 4) {
                        Text("FIKTIVES BEISPIELPROFIL")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)

                        Text("\(profile.name) aus \(profile.city)")
                            .font(.title2)
                            .fontWeight(.bold)

                        Label(profile.status.displayText, systemImage: profile.status.icon)
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }

                if !profile.styles.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(profile.styles, id: \.self) { style in
                                Text(style)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.blue.opacity(0.12))
                                    .foregroundColor(.blue)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }

    private func detailRow(title: String, value: String, systemImage: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: systemImage)
                .foregroundColor(.blue)
                .frame(width: 22)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
            }
        }
        .padding(.vertical, 2)
    }

    private func contactSimulationSection(profile: Profile) -> some View {
        Section(header: Text("Gemeinsam tanzen? Einfach ausprobieren.")) {
            if simulationSent {
                VStack(alignment: .leading, spacing: 10) {
                    Label("Simulation abgeschlossen", systemImage: "checkmark.circle.fill")
                        .font(.headline)
                        .foregroundColor(.green)

                    Text("So könnte eine Kontaktanfrage aussehen. Es wurde keine Nachricht verschickt. \(profile.name) ist eine erfundene Person.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Button("Neue Simulation starten") {
                        messageText = defaultGreeting(for: profile.name)
                        withAnimation {
                            simulationSent = false
                        }
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.vertical, 4)
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Diese Anfrage ist eine Simulation. Es wird nichts versendet oder gespeichert. Bitte keine persönlichen Daten eingeben.")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    TextField("Beispielnachricht", text: $messageText, axis: .vertical)
                        .lineLimit(3...6)
                        .padding(10)
                        .background(Color.secondary.opacity(0.08))
                        .cornerRadius(8)

                    Button {
                        withAnimation {
                            simulationSent = true
                        }
                    } label: {
                        Label("Kontaktanfrage simulieren", systemImage: "paperplane.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.vertical, 4)
            }
        }
    }

    private func defaultGreeting(for name: String) -> String {
        "Hallo \(name), ich würde gerne gemeinsam tanzen. Wollen wir überlegen, welcher Kurs zu unseren Zielen passt?"
    }
}
