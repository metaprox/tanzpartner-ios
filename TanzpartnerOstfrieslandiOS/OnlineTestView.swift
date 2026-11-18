import SwiftUI
import Foundation

struct OnlineGesuch: Decodable, Identifiable {
    let id: Int
    let anzeigename: String
    let ort: String
    let tanzstil: String
    let beschreibung: String
    let ablaufdatum: String
}

struct GesucheResponse: Decodable {
    let gesuche: [OnlineGesuch]
}

// Never follow redirects with test credentials or persist authentication.
final class TestSessionDelegate: NSObject, URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask,
                    willPerformHTTPRedirection response: HTTPURLResponse,
                    newRequest request: URLRequest,
                    completionHandler: @escaping (URLRequest?) -> Void) {
        completionHandler(nil)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.performDefaultHandling, nil)
    }
}

struct OnlineTestView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var username = ""
    @State private var password = ""
    @State private var gesuche: [OnlineGesuch] = []
    @State private var message: String?
    @State private var loading = false
    @State private var loaded = false
    @State private var requestTask: Task<Void, Never>?
    @State private var requestID = UUID()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Geschützter Server-Test mit fiktiven Gesuchen. Keine echte Partnersuche und keine Kontaktaufnahme.")
                    Text("Der Testzugang wird nur im Arbeitsspeicher gehalten und beim Verlassen dieser Ansicht oder Wechsel in den Hintergrund gelöscht.")
                        .font(.caption).foregroundStyle(.secondary)
                }
                Section("Testzugang") {
                    TextField("Benutzername des Website-Schutzes", text: $username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .disabled(loading)
                    SecureField("Passwort des Website-Schutzes", text: $password)
                        .disabled(loading)
                    Button("Demo-Gesuche laden") { startLoading() }
                        .disabled(loading || username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || password.isEmpty)
                    Button("Zugang und Ergebnisse löschen", role: .destructive) { clearSession() }
                }
                if loading {
                    Section { ProgressView("Gesuche werden geladen …") }
                }
                if let message {
                    Section { Text(message).foregroundStyle(.secondary) }
                }
                if loaded && gesuche.isEmpty {
                    Section { Text("Keine aktiven Demo-Gesuche vorhanden. Abgelaufene Gesuche werden nicht angezeigt.") }
                }
                ForEach(gesuche) { gesuch in
                    Section {
                        Text(gesuch.anzeigename).font(.headline)
                        Text("\(gesuch.ort) · \(gesuch.tanzstil)")
                        Text(gesuch.beschreibung)
                        Text("Gültig bis \(gesuch.ablaufdatum)")
                            .font(.caption).foregroundStyle(.secondary)
                    } header: { Text("Fiktives Testgesuch") }
                }
            }
            .navigationTitle("Online-Test")
        }
        .onDisappear { clearSession() }
        .onChange(of: scenePhase) { _, phase in
            if phase == .background { clearSession() }
        }
    }

    private func clearSession() {
        requestID = UUID()
        requestTask?.cancel()
        requestTask = nil
        username = ""
        password = ""
        gesuche = []
        message = nil
        loaded = false
        loading = false
    }

    private func startLoading() {
        let id = UUID()
        requestID = id
        let user = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !user.contains(":") else {
            message = "Der Benutzername darf keinen Doppelpunkt enthalten."
            return
        }
        let credentials = Data("\(user):\(password)".utf8).base64EncodedString()
        loading = true
        loaded = false
        message = nil
        gesuche = []
        requestTask = Task { @MainActor in
            let config = URLSessionConfiguration.ephemeral
            config.urlCredentialStorage = nil
            config.urlCache = nil
            config.httpCookieStorage = nil
            config.timeoutIntervalForRequest = 20
            config.timeoutIntervalForResource = 30
            let session = URLSession(configuration: config, delegate: TestSessionDelegate(), delegateQueue: nil)
            defer {
                session.invalidateAndCancel()
                if requestID == id { loading = false; requestTask = nil }
            }
            var request = URLRequest(url: URL(string: "https://ios-test.tanzpartner-ostfriesland.de/gesuche.php")!)
            request.setValue("Basic \(credentials)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            do {
                let (data, response) = try await session.data(for: request)
                guard !Task.isCancelled, requestID == id else { return }
                guard let http = response as? HTTPURLResponse else {
                    message = "Die Serverantwort konnte nicht gelesen werden."
                    return
                }
                switch http.statusCode {
                case 200:
                    gesuche = try JSONDecoder().decode(GesucheResponse.self, from: data).gesuche
                    loaded = true
                case 401, 403:
                    password = ""
                    message = "Zugriff verweigert. Bitte den Benutzername und das Passwort des Website-Schutzes prüfen (nicht den Datenbankzugang)."
                case 500...599:
                    message = "Der Server kann die Gesuche gerade nicht laden. Bitte später erneut versuchen."
                default:
                    message = "Unerwartete Serverantwort (HTTP \(http.statusCode)). Bitte die Testadresse prüfen."
                }
            } catch {
                guard !Task.isCancelled, requestID == id else { return }
                if let error = error as? URLError {
                    switch error.code {
                    case .notConnectedToInternet, .networkConnectionLost:
                        message = "Keine Internetverbindung. Bitte die Verbindung prüfen und erneut laden."
                    case .timedOut:
                        message = "Der Server antwortet nicht rechtzeitig. Bitte erneut versuchen."
                    default:
                        message = "Die sichere Verbindung zum Testserver konnte nicht hergestellt werden."
                    }
                } else if error is DecodingError {
                    message = "Die Antwort hat nicht das erwartete Datenformat."
                } else {
                    message = "Die Gesuche konnten nicht geladen werden. Bitte erneut versuchen."
                }
            }
        }
    }
}
