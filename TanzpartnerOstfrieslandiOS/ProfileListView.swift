//
//  ProfileListView.swift
//  TanzpartnerOstfrieslandiOS
//

import SwiftUI

struct ProfileListView: View {
    @EnvironmentObject private var store: ProfileStore

    // Filter-Zustand
    @State private var searchText = ""
    @State private var selectedCity: String?
    @State private var selectedStyle: String?
    @State private var selectedRole: String?
    @State private var filterSheetVisible = false

    // Bearbeiten-Zustand
    @State private var editingProfile: Profile?
    @State private var showingNewProfile = false

    let cities = Profile.cities
    let styles = Profile.availableStyles
    let roles = Profile.roles

    var filteredProfiles: [Profile] {
        store.profiles.filter { profile in
            // Nur freigegebene Profile in der öffentlichen Tanzpartner-Liste anzeigen
            let matchesStatus = profile.status == .approved

            // Suchtext-Filter (Name, Hauptort und weitere Tanzorte)
            let query = searchText.lowercased()
            let matchesSearch = searchText.isEmpty ||
                profile.name.lowercased().contains(query) ||
                profile.city.lowercased().contains(query) ||
                profile.places.contains { $0.lowercased().contains(query) }

            // Ort-Filter (Hauptort oder mögliche Tanzorte)
            let matchesCity = selectedCity.map { city in
                profile.city == city || profile.places.contains(city)
            } ?? true

            // Stil-Filter
            let matchesStyle = selectedStyle == nil ||
                profile.styles.contains { $0 == selectedStyle }

            // Rolle-Filter
            let matchesRole = selectedRole == nil || profile.role == selectedRole

            return matchesStatus && matchesSearch && matchesCity && matchesStyle && matchesRole
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                FilterBar(
                    searchText: $searchText,
                    selectedCity: $selectedCity,
                    selectedStyle: $selectedStyle,
                    selectedRole: $selectedRole,
                    onFilterTap: { filterSheetVisible = true }
                )
                .padding(.horizontal)

                List {
                    ForEach(filteredProfiles) { profile in
                        ProfileRow(profile: profile)
                            .contentShape(Rectangle())
                            .onTapGesture { editingProfile = profile }
                    }
                    .onDelete(perform: deleteProfiles)
                }
                .listStyle(PlainListStyle())

                if filteredProfiles.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "person.2.slash.fill")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        Text("Keine Tanzpartner gefunden")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
            }
            .navigationTitle("Tanzpartner")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingNewProfile = true }) {
                        Label("Neues Profil", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $filterSheetVisible) {
                FilterSheet(
                    selectedCity: $selectedCity,
                    selectedStyle: $selectedStyle,
                    selectedRole: $selectedRole,
                    cities: cities,
                    styles: styles,
                    roles: roles
                )
            }
            .sheet(item: $editingProfile) { profile in
                ProfileEditorView(profile: profile)
            }
            .sheet(isPresented: $showingNewProfile) {
                ProfileEditorView()
            }
        }
    }

    private func deleteProfiles(at offsets: IndexSet) {
        for index in offsets {
            store.delete(filteredProfiles[index])
        }
    }
}

// MARK: - FilterBar

struct FilterBar: View {
    @Binding var searchText: String
    @Binding var selectedCity: String?
    @Binding var selectedStyle: String?
    @Binding var selectedRole: String?
    let onFilterTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Suche...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: onFilterTap) {
                    Label("Filter", systemImage: "slider.horizontal.3")
                }
            }

            HStack(spacing: 12) {
                FilterPill(
                    label: "Ort",
                    value: selectedCity ?? "Alle",
                    isActive: selectedCity != nil
                )

                FilterPill(
                    label: "Stil",
                    value: selectedStyle ?? "Alle",
                    isActive: selectedStyle != nil
                )

                FilterPill(
                    label: "Rolle",
                    value: selectedRole ?? "Beide",
                    isActive: selectedRole != nil
                )
            }
        }
    }
}

struct FilterPill: View {
    let label: String
    let value: String
    let isActive: Bool

    var body: some View {
        HStack(spacing: 6) {
            Text(label)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(isActive ? .blue : .secondary)

            Text(value)
                .font(.subheadline)
                .foregroundColor(isActive ? .primary : .secondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(isActive ? Color.blue.opacity(0.1) : Color.secondary.opacity(0.1))
        .cornerRadius(8)
    }
}

// MARK: - FilterSheet

struct FilterSheet: View {
    @Binding var selectedCity: String?
    @Binding var selectedStyle: String?
    @Binding var selectedRole: String?

    let cities: [String]
    let styles: [String]
    let roles: [String]

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Ort")) {
                    Picker("Ort", selection: $selectedCity) {
                        Text("Alle").tag(String?.none)
                        ForEach(cities, id: \.self) { city in
                            Text(city).tag(String?.some(city))
                        }
                    }
                }

                Section(header: Text("Tanzstil")) {
                    Picker("Stil", selection: $selectedStyle) {
                        Text("Alle").tag(String?.none)
                        ForEach(styles, id: \.self) { style in
                            Text(style).tag(String?.some(style))
                        }
                    }
                }

                Section(header: Text("Rolle")) {
                    Picker("Rolle", selection: $selectedRole) {
                        Text("Beide").tag(String?.none)
                        ForEach(roles, id: \.self) { role in
                            Text(role).tag(String?.some(role))
                        }
                    }
                }

                Button("Filter zurücksetzen", role: .destructive) {
                    selectedCity = nil
                    selectedStyle = nil
                    selectedRole = nil
                }
            }
            .navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { presentationMode.wrappedValue.dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("OK") { presentationMode.wrappedValue.dismiss() }
                }
            }
        }
    }
}

// MARK: - ProfileRow

struct ProfileRow: View {
    let profile: Profile

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.blue, .indigo],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 56, height: 56)
                .overlay(
                    Text(profile.name.prefix(1))
                        .font(.title2)
                        .foregroundColor(.white)
                        .bold()
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(profile.name)
                    .font(.headline)

                HStack(spacing: 8) {
                    Image(systemName: "location.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(profile.city)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Spacer()

                    if let role = profile.role {
                        Text(role)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(6)
                            .foregroundColor(.green)
                    }
                }

                Text(profile.bio)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - ProfileEditorView

struct ProfileEditorView: View {
    @EnvironmentObject private var store: ProfileStore
    @Environment(\.presentationMode) var presentationMode

    /// nil = neues Profil, sonst wird dieses bearbeitet
    let profile: Profile?

    @State private var name = ""
    @State private var city = "Norden"
    @State private var places: [String] = []
    @State private var styles: [String] = []
    @State private var role = "Führend"
    @State private var level = "Ohne Vorkenntnisse"
    @State private var goal = "Ersten Kurs beginnen"
    @State private var time = ""
    @State private var bio = ""

    // Moderation
    @State private var status: ModerationStatus = .pending
    @State private var note = ""

    let cities = Profile.cities
    let allStyles = Profile.availableStyles
    let roles = Profile.roles
    let levels = Profile.levels
    let goals = Profile.goals

    init(profile: Profile? = nil) {
        self.profile = profile
        _name = State(initialValue: profile?.name ?? "")
        _city = State(initialValue: profile?.city ?? "Norden")
        _places = State(initialValue: profile?.places ?? [])
        _styles = State(initialValue: profile?.styles ?? [])
        _role = State(initialValue: profile?.role ?? "Führend")
        _level = State(initialValue: profile?.level ?? "Ohne Vorkenntnisse")
        _goal = State(initialValue: profile?.goal ?? "Ersten Kurs beginnen")
        _time = State(initialValue: profile?.time ?? "")
        _bio = State(initialValue: profile?.bio ?? "")
        _status = State(initialValue: profile?.status ?? .pending)
        _note = State(initialValue: profile?.note ?? "")
    }

    private var isNew: Bool { profile == nil }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Persönliche Angaben")) {
                    TextField("Name", text: $name)
                    Picker("Ort", selection: $city) {
                        ForEach(cities, id: \.self) { city in
                            Text(city).tag(city)
                        }
                    }

                    MultiSelectPicker(
                        title: "Mögliche Tanzorte",
                        options: cities,
                        selectedOptions: $places
                    )

                    MultiSelectPicker(
                        title: "Tanzstil",
                        options: allStyles,
                        selectedOptions: $styles
                    )
                }

                Section(header: Text("Erfahrung")) {
                    Picker("Rolle", selection: $role) {
                        ForEach(roles, id: \.self) { role in
                            Text(role).tag(role)
                        }
                    }

                    Picker("Erfahrungsstufe", selection: $level) {
                        ForEach(levels, id: \.self) { level in
                            Text(level).tag(level)
                        }
                    }
                }

                Section(header: Text("Ziel & Zeit")) {
                    Picker("Ziel", selection: $goal) {
                        ForEach(goals, id: \.self) { goal in
                            Text(goal).tag(goal)
                        }
                    }

                    TextField("Verfügbare Zeiten", text: $time)
                }

                Section(header: Text("Über dich")) {
                    TextArea(text: $bio, placeholder: "Erzähle etwas über dich...")
                        .lineLimit(5...10)
                }

                Section(header: Text("Moderation")) {
                    Picker("Status", selection: $status) {
                        ForEach(ModerationStatus.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }

                    TextField("Notiz", text: $note, prompt: Text("z. B. Sehr engagiert").foregroundColor(.secondary))
                }
            }
            .navigationTitle(isNew ? "Neues Profil" : "Profil bearbeiten")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { presentationMode.wrappedValue.dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern") { saveProfile() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func saveProfile() {
        var updated = profile ?? Profile(
            id: store.nextID(),
            name: "",
            city: city,
            styles: [],
            level: "",
            goal: "",
            time: "",
            bio: ""
        )

        updated.name = name.trimmingCharacters(in: .whitespaces)
        updated.city = city
        updated.styles = styles
        updated.role = role
        updated.level = level
        updated.goal = goal
        // Hauptort bleibt immer Teil von places; weitere gewählte Orte bleiben erhalten
        var updatedPlaces = places.filter { !$0.isEmpty }
        if !updatedPlaces.contains(city) {
            updatedPlaces.insert(city, at: 0)
        }
        updated.places = updatedPlaces
        updated.time = time
        updated.bio = bio
        updated.status = status
        updated.note = note.isEmpty ? nil : note

        store.upsert(updated)
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - MultiSelectPicker

struct MultiSelectPicker: View {
    let title: String
    let options: [String]
    @Binding var selectedOptions: [String]

    private func isSelected(_ option: String) -> Bool { selectedOptions.contains(option) }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(options, id: \.self) { option in
                    Button(action: { toggle(option) }) {
                        HStack {
                            Text(option)
                            Spacer()
                            if isSelected(option) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(isSelected(option) ? Color.blue.opacity(0.1) : nil)
                        .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func toggle(_ option: String) {
        if isSelected(option) {
            selectedOptions.removeAll { $0 == option }
        } else {
            selectedOptions.append(option)
        }
    }
}

// MARK: - TextArea

struct TextArea: View {
    @Binding var text: String
    let placeholder: String

    var body: some View {
        UITextViewWrapper(text: $text, placeholder: placeholder)
            .frame(minHeight: 120)
            .accentColor(.blue)
    }
}

struct UITextViewWrapper: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.font = .systemFont(ofSize: 16)
        textView.backgroundColor = .clear
        textView.delegate = context.coordinator

        // UITextView hat kein attributedPlaceholder – Placeholder als grauen Text emulieren
        if text.isEmpty {
            textView.text = placeholder
            textView.textColor = .secondaryLabel
        }

        // Notification for text changes
        NotificationCenter.default.addObserver(
            context.coordinator,
            selector: #selector(Coordinator.textChanged),
            name: UITextView.textDidChangeNotification,
            object: textView
        )

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        let showsPlaceholder = !uiView.isFirstResponder && uiView.text == placeholder

        if text.isEmpty {
            // Leeres Binding → grauen Placeholder zeigen (wenn noch nicht geschehen)
            if !uiView.isFirstResponder && uiView.text != placeholder {
                uiView.text = placeholder
                uiView.textColor = .secondaryLabel
            }
        } else if !showsPlaceholder && uiView.text != text {
            // Externe Änderung → synchronisieren (während des Tippens überspringen)
            uiView.text = text
            uiView.textColor = .label
        } else if showsPlaceholder {
            // Externer Text kam, während der Placeholder angezeigt wurde
            uiView.text = text
            uiView.textColor = .label
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, placeholder: placeholder)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        let placeholder: String

        init(text: Binding<String>, placeholder: String) {
            _text = text
            self.placeholder = placeholder
        }

        @objc func textChanged(_ notification: Notification) {
            guard let textView = notification.object as? UITextView else { return }
            // Der graue Placeholder-Text ist kein echter Inhalt
            text = (textView.text == placeholder && !textView.isFirstResponder) ? "" : textView.text
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == placeholder {
                textView.text = ""
                textView.textColor = .label
            }
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = placeholder
                textView.textColor = .secondaryLabel
            } else if textView.textColor == .secondaryLabel {
                textView.textColor = .label
            }
        }
    }
}
