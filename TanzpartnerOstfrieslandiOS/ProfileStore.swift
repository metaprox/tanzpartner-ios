//
//  ProfileStore.swift
//  TanzpartnerOstfrieslandiOS
//

import Foundation
import Combine

/// Zentrale Datenquelle für die App: hält alle Profile, persistiert sie als
/// JSON-Datei im Documents-Ordner und wird über `environmentObject` an alle
/// Views verteilt (Tanzpartner-Tab UND Moderations-Tab teilen sich diese Daten).
final class ProfileStore: ObservableObject {

    @Published private(set) var profiles: [Profile] = []

    private let fileURL: URL

    init() {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileURL = documents.appendingPathComponent("profiles.json")

        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([Profile].self, from: data) {
            profiles = decoded
        } else {
            // Erster Start: mit Beispieldaten befüllen und direkt speichern
            profiles = Self.seedProfiles()
            persist()
        }
    }

    // MARK: - Mutationen

    /// Fügt ein neues Profil hinzu oder aktualisiert ein bestehendes (gleiche ID).
    func upsert(_ profile: Profile) {
        var updated = profile
        updated.updatedAt = Date()

        if let index = profiles.firstIndex(where: { $0.id == profile.id }) {
            profiles[index] = updated
        } else {
            profiles.append(updated)
        }
        persist()
    }

    func delete(_ profile: Profile) {
        profiles.removeAll { $0.id == profile.id }
        persist()
    }

    /// Nächste freie ID für neue Profile.
    func nextID() -> Int {
        (profiles.map(\.id).max() ?? 0) + 1
    }

    /// Setzt alle lokalen Profile auf die 8 Ausgangs-Beispieldaten zurück (für Präsentationen).
    func resetToSeedProfiles() {
        profiles = Self.seedProfiles()
        persist()
    }

    // MARK: - Persistenz (JSON im Documents-Ordner)

    private func persist() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let data = try encoder.encode(profiles)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Profile konnten nicht gespeichert werden:", error)
        }
    }

    // MARK: - Beispieldaten (nur beim allerersten Start)

    static func seedProfiles() -> [Profile] {
        [
            Profile(id: 1, name: "Mara", city: "Norden", styles: ["Standard / Latein"], role: "Folgend", level: "Ohne Vorkenntnisse", goal: "Ersten Kurs beginnen", places: ["Norden", "Aurich"], time: "Dienstag oder Donnerstag abends", bio: "Ich möchte die ersten Schritte lernen und suche jemanden, der mit Geduld und Freude einen Grundkurs beginnt.", status: .approved),
            Profile(id: 2, name: "Jan", city: "Emden", styles: ["Discofox", "Standard / Latein"], role: "Führend", level: "Grundkenntnisse", goal: "Wieder einsteigen", places: ["Emden", "Norden"], time: "Freitag abends", bio: "Nach einigen Jahren Pause möchte ich wieder aufs Parkett. Ein entspannter Wiedereinstieg wäre schön.", status: .approved, note: "Sehr engagiert"),
            Profile(id: 3, name: "Alva", city: "Aurich", styles: ["Standard / Latein"], role: "Beides", level: "Fortgeschritten", goal: "Kenntnisse vertiefen", places: ["Aurich"], time: "Mittwoch abends oder am Wochenende", bio: "Die Grundlagen sitzen. Jetzt möchte ich an Haltung und Technik arbeiten und gemeinsam einen weiterführenden Kurs besuchen.", status: .approved),
            Profile(id: 4, name: "Timo", city: "Norden", styles: ["Salsa"], role: "Führend", level: "Ohne Vorkenntnisse", goal: "Ersten Kurs beginnen", places: ["Norden"], time: "Montag abends", bio: "Salsa macht mir schon beim Zuhören Spaß. Für meinen ersten Kurs suche ich einen ebenso neugierigen Menschen.", status: .pending),
            Profile(id: 5, name: "Jule", city: "Emden", styles: ["Salsa"], role: "Folgend", level: "Grundkenntnisse", goal: "Regelmäßig tanzen", places: ["Emden", "Aurich"], time: "Samstag nachmittags oder abends", bio: "Ich möchte meine Schritte regelmäßig üben. Die Freude an der Musik ist mir wichtiger als Perfektion.", status: .approved),
            Profile(id: 6, name: "Lukas", city: "Aurich", styles: ["Tango"], role: "Führend", level: "Fortgeschritten", goal: "Regelmäßig tanzen", places: ["Aurich", "Norden"], time: "Dienstag und Donnerstag abends", bio: "Ich liebe den Ausdruck des Tangos. Suche einen Partner für regelmäßige Übungsstunden.", status: .pending),
            Profile(id: 7, name: "Sarah", city: "Norden", styles: ["Rock'n'Roll", "Standard / Latein"], role: "Beides", level: "Grundkenntnisse", goal: "Regelmäßig tanzen", places: ["Norden", "Emden"], time: "Mittwoch abends", bio: "Ich tanze seit Jahren und suche nun einen festen Tanzpartner für Übungen und gemeinsame Kurse.", status: .approved),
            Profile(id: 8, name: "Finn", city: "Emden", styles: ["Standard / Latein"], role: "Führend", level: "Ohne Vorkenntnisse", goal: "Ersten Kurs beginnen", places: ["Emden", "Aurich"], time: "Freitag abends", bio: "Ich habe noch keine Erfahrung, möchte aber gerne tanzen lernen. Freue mich auf gemeinsame Stunden!", status: .paused, note: "Wartet auf Bestätigung")
        ]
    }
}
