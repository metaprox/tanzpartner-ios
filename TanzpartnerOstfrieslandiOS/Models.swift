//
//  Models.swift
//  TanzpartnerOstfrieslandiOS
//

import Foundation

// MARK: - ModerationStatus

enum ModerationStatus: String, CaseIterable, Codable {
    case pending = "Wartet auf Prüfung"
    case approved = "Lokal freigegeben"
    case returned = "Zurückgestellt"
    case paused = "Pausiert"

    var displayText: String { rawValue }

    /// Kurze Bezeichnung für Filter-Pills
    var shortText: String {
        switch self {
        case .pending: return "Offen"
        case .approved: return "Freigegeben"
        case .returned: return "Zurückgestellt"
        case .paused: return "Pausiert"
        }
    }

    var icon: String {
        switch self {
        case .pending: return "hourglass"
        case .approved: return "checkmark.circle.fill"
        case .returned: return "arrow.uturn.backward"
        case .paused: return "pause.fill"
        }
    }

    /// Sortierpriorität für die Moderationsliste (Offene zuerst)
    var priority: Int {
        switch self {
        case .pending: return 0
        case .returned: return 1
        case .paused: return 2
        case .approved: return 3
        }
    }
}

// MARK: - Profile

struct Profile: Identifiable, Hashable, Codable {
    var id: Int
    var name: String
    var city: String
    var styles: [String]
    var role: String?
    var level: String
    var goal: String
    var places: [String]
    var time: String
    var bio: String

    // Moderation (gemeinsam mit dem Moderations-Tab)
    var status: ModerationStatus
    var note: String?

    /// Zuletzt geändert (wird beim Speichern aktualisiert)
    var updatedAt: Date?

    init(
        id: Int,
        name: String,
        city: String,
        styles: [String],
        role: String? = nil,
        level: String,
        goal: String,
        places: [String]? = nil,
        time: String,
        bio: String,
        status: ModerationStatus = .pending,
        note: String? = nil,
        updatedAt: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.city = city
        self.styles = styles
        self.role = role
        self.level = level
        self.goal = goal
        self.places = places ?? [city]
        self.time = time
        self.bio = bio
        self.status = status
        self.note = note
        self.updatedAt = updatedAt
    }

    // Toleranter Decoder: neue Felder mit Default, damit ältere JSON-Dateien
    // nach App-Updates nicht verloren gehen.
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(Int.self, forKey: .id)
        name = try c.decode(String.self, forKey: .name)
        city = try c.decode(String.self, forKey: .city)
        styles = (try? c.decode([String].self, forKey: .styles)) ?? []
        role = try c.decodeIfPresent(String.self, forKey: .role)
        level = (try? c.decode(String.self, forKey: .level)) ?? ""
        goal = (try? c.decode(String.self, forKey: .goal)) ?? ""
        places = (try? c.decode([String].self, forKey: .places)) ?? [city]
        time = (try? c.decode(String.self, forKey: .time)) ?? ""
        bio = (try? c.decode(String.self, forKey: .bio)) ?? ""
        status = (try? c.decode(ModerationStatus.self, forKey: .status)) ?? .pending
        note = try c.decodeIfPresent(String.self, forKey: .note)
        updatedAt = try c.decodeIfPresent(Date.self, forKey: .updatedAt)
    }

    // Berechnete Werte für UI
    var displayName: String { name }
    var displayCity: String { city }
}
