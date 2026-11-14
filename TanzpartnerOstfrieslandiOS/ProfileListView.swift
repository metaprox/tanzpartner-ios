//
//  ProfileListView.swift
//  TanzpartnerOstfrieslandiOS
//
//  Created by Sven Schley on 14.11.2026.
//

import SwiftUI

struct ProfileListView: View {
    @StateObject private var viewModel = ProfileListViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                FilterBar(viewModel: viewModel)
                    .padding(.horizontal)
                
                List(viewModel.filteredProfiles) { profile in
                    ProfileRow(profile: profile)
                        .onTapGesture {
                            // Öffne Detailansicht oder nutze WebView für Profil
                        }
                }
                .listStyle(PlainListStyle())
                
                if viewModel.isLoading {
                    ProgressView("Lade Tanzpartner...")
                        .padding()
                }
            }
            .navigationTitle("Tanzpartner")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink(
                        destination: ProfileEditorView(),
                        label: {
                            Label("Neues Profil", systemImage: "plus")
                        }
                    )
                }
            }
        }
    }
}

// MARK: - FilterBar

struct FilterBar: View {
    @ObservedObject var viewModel: ProfileListViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Suche...", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: viewModel.toggleFilterSheet) {
                    Label("Filter", systemImage: "slider.horizontal.3")
                }
            }
            
            HStack(spacing: 12) {
                FilterPill(
                    label: "Ort",
                    value: viewModel.selectedCity ?? "Alle",
                    isActive: viewModel.selectedCity != nil
                )
                
                FilterPill(
                    label: "Stil",
                    value: viewModel.selectedStyle ?? "Alle",
                    isActive: viewModel.selectedStyle != nil
                )
                
                FilterPill(
                    label: "Rolle",
                    value: viewModel.selectedRole ?? "Beide",
                    isActive: viewModel.selectedRole != nil
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

// MARK: - ProfileListViewModel

class ProfileListViewModel: ObservableObject {
    @Published var profiles: [Profile] = []
    @Published var filteredProfiles: [Profile] = []
    @Published var isLoading = false
    @Published var searchText = ""
    @Published var selectedCity: String?
    @Published var selectedStyle: String?
    @Published var selectedRole: String?
    
    private let cities = ["Norden", "Emden", "Aurich"]
    private let styles = ["Standard / Latein", "Salsa", "Discofox", "Tango", "Rock'n'Roll"]
    private let roles = ["Führend", "Folgend", "Beides"]
    
    @Published var filterSheetVisible = false
    
    init() {
        loadProfiles()
    }
    
    func loadProfiles() {
        isLoading = true
        // Simuliere API-Abruf
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.profiles = [
                Profile(id: 1, name: "Mara", city: "Norden", styles: ["Standard / Latein"], role: "Folgend", level: "Ohne Vorkenntnisse", goal: "Ersten Kurs beginnen", places: ["Norden", "Aurich"], time: "Dienstag oder Donnerstag abends", bio: "Ich möchte die ersten Schritte lernen und suche jemanden, der mit Geduld und Freude einen Grundkurs beginnt."),
                Profile(id: 2, name: "Jan", city: "Emden", styles: ["Discofox", "Standard / Latein"], role: "Führend", level: "Grundkenntnisse", goal: "Wieder einsteigen", places: ["Emden", "Norden"], time: "Freitag abends", bio: "Nach einigen Jahren Pause möchte ich wieder aufs Parkett. Ein entspanter Wiedereinstieg wäre schön."),
                Profile(id: 3, name: "Alva", city: "Aurich", styles: ["Standard / Latein"], role: "Beides", level: "Fortgeschritten", goal: "Kenntnisse vertiefen", places: ["Aurich"], time: "Mittwoch abends oder am Wochenende", bio: "Die Grundlagen sitzen. Jetzt möchte ich an Haltung und Technik arbeiten und gemeinsam einen weiterführenden Kurs besuchen."),
                Profile(id: 4, name: "Timo", city: "Norden", styles: ["Salsa"], role: "Führend", level: "Ohne Vorkenntnisse", goal: "Ersten Kurs beginnen", places: ["Norden"], time: "Montag abends", bio: "Salsa macht mir schon beim Zuhören Spaß. Für meinen ersten Kurs suche ich einen ebenso neugierigen Menschen."),
                Profile(id: 5, name: "Jule", city: "Emden", styles: ["Salsa"], role: "Folgend", level: "Grundkenntnisse", goal: "Regelmäßig tanzen", places: ["Emden", "Aurich"], time: "Samstag nachmittags oder abends", bio: "Ich möchte meine Schritte regelmäßig üben. Die Freude an der Musik ist mir wichtiger als Perfektion."),
                Profile(id: 6, name: "Lukas", city: "Aurich", styles: ["Tango"], role: "Führend", level: "Fortgeschritten", goal: "Regelmäßig tanzen", places: ["Aurich", "Norden"], time: "Dienstag und Donnerstag abends", bio: "Ich liebe den Ausdruck des Tangos. Suche einen Partner für regelmäßige Übungsstunden."),
                Profile(id: 7, name: "Sarah", city: "Norden", styles: ["Rock'n'Roll", "Standard / Latein"], role: "Beides", level: "Grundkenntnisse", goal: "Regelmäßig tanzen", places: ["Norden", "Emden"], time: "Mittwoch abends", bio: "Ich tanze seit Jahren und suche nun einen festen Tanzpartner für Übungen und gemeinsame Kurse."),
                Profile(id: 8, name: "Finn", city: "Emden", styles: ["Standard / Latein"], role: "Führend", level: "Ohne Vorkenntnisse", goal: "Ersten Kurs beginnen", places: ["Emden", "Aurich"], time: "Freitag abends", bio: "Ich habe noch keine Erfahrung, möchte aber gerne tanzen lernen. Freue mich auf gemeinsame Stunden!")
            ]
            
            self.applyFilters()
            self.isLoading = false
        }
    }
    
    func applyFilters() {
        filteredProfiles = profiles.filter { profile in
            // Suchtext-Filter
            let matchesSearch = searchText.isEmpty ||
                profile.name.lowercased().contains(searchText.lowercased()) ||
                profile.city.lowercased().contains(searchText.lowercased())
            
            // Ort-Filter
            let matchesCity = selectedCity == nil || profile.city == selectedCity
            
            // Stil-Filter
            let matchesStyle = selectedStyle == nil ||
                profile.styles.contains { $0 == selectedStyle }
            
            // Rolle-Filter
            let matchesRole = selectedRole == nil || profile.role == selectedRole
            
            return matchesSearch && matchesCity && matchesStyle && matchesRole
        }
    }
    
    func toggleFilterSheet() {
        filterSheetVisible.toggle()
    }
}

// MARK: - Profile Model

struct Profile: Identifiable, Hashable {
    let id: Int
    let name: String
    let city: String
    let styles: [String]
    let role: String?
    let level: String
    let goal: String
    let places: [String]
    let time: String
    let bio: String
    
    // Berechnete Werte für UI
    var displayName: String { name }
    var displayCity: String { city }
}

// MARK: - ProfileEditorView

struct ProfileEditorView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var city = "Norden"
    @State private var styles: [String] = []
    @State private var role = "Führend"
    @State private var level = "Ohne Vorkenntnisse"
    @State private var goal = "Ersten Kurs beginnen"
    @State private var time = "Dienstag oder Donnerstag abends"
    @State private var bio = ""
    
    let cities = ["Norden", "Emden", "Aurich"]
    let allStyles = ["Standard / Latein", "Salsa", "Discofox", "Tango", "Rock'n'Roll", "Bachata", "Zumba"]
    let roles = ["Führend", "Folgend", "Beides"]
    let levels = ["Ohne Vorkenntnisse", "Grundkenntnisse", "Fortgeschritten"]
    let goals = [
        "Ersten Kurs beginnen",
        "Wieder einsteigen",
        "Regelmäßig tanzen",
        "Kenntnisse vertiefen"
    ]
    
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
                    
                    TextField("VerfügbareZeiten", text: $time)
                }
                
                Section(header: Text("Über dich")) {
                    TextArea(text: $bio, placeholder: "Erzähle etwas über dich...")
                        .lineLimit(5...10)
                }
            }
            .navigationTitle("Neues Profil")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { presentationMode.wrappedValue.dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern") { saveProfile() }
                        .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func saveProfile() {
        // Speichere Profil in SQLite
        let profile = Profile(
            id: Int.random(in: 100...999),
            name: name,
            city: city,
            styles: styles,
            role: role,
            level: level,
            goal: goal,
            places: [city],
            time: time,
            bio: bio
        )
        
        print("Gespeichertes Profil:", profile)
        // TODO: Speichere in SQLite via store.mjs API
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
                }
            }
        }
    }
    
    private func toggle(_ option: String) {
        if isSelected(option) {
            selectedOptions.remove(at: selectedOptions.firstIndex(of: option)!)
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