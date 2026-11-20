# K03 – Abläufe, Fristen und Texte

Stand: 20.11.2026, **Entwurf** (Claude). Grundlage: [K02-DATENMODELL-API.md](K02-DATENMODELL-API.md) (bestätigt) und [ROADMAP.md](../ROADMAP.md). Kein Code. Mit „**Vorschlag**“ markierte Punkte sind noch vom Nutzer zu bestätigen (Liste am Ende). Alle Texte sind Entwürfe. Sie werden in P02 mit der Datenschutzerklärung abgeglichen.

Platzhalter in Texten: `{anzeigename}`, `{gesuch_id}`, `{sichtbar_bis}`, `{bestaetigungslink}`, `{verwaltungslink}`, `{grund}`, `{name}` (Absender einer Kontaktnachricht).

## 1. Ansprache und Grundregeln

- **Ansprache „du“** (Vorschlag) in App und Mails. Das ist in Tanzkursen üblich und passt zu einer Hobby-Börse. Die bisherigen Datenschutz- und Impressumstexte in der App siezen; sie werden in F15/P02 angepasst.
- **Absender aller Mails:** „Tanzpartner Ostfriesland“ `<kontakt@tanzpartner-ostfriesland.de>`, Versand per SMTP über das Versandpostfach. Text-Mails ohne HTML, UTF-8, Quoted-Printable kodiert. Keine Bilder, kein Tracking.
- **Fußzeile jeder Mail an Nutzer:**

  ```text
  --
  Tanzpartner Ostfriesland – eine private, nicht gewerbliche Tanzpartner-Börse
  Impressum und Datenschutz: https://tanzpartner-ostfriesland.de/impressum
  Du bekommst diese E-Mail, weil deine Adresse in der App angegeben wurde.
  ```

- **Reaktionszeit des Betreibers** (Vorschlag): Neue Gesuche und Meldungen werden in der Regel innerhalb von **2 Tagen** geprüft. Diese Angabe steht so auch in der App (Apple 1.2 verlangt zeitnahe Reaktion).

## 2. Abläufe

### 2.1 Gesuch aufgeben und bestätigen

1. In der App das Formular ausfüllen. Pflichtfelder sind markiert. Ein Hinweis unter dem Freitext sagt, dass keine Kontaktdaten hineingehören.
2. Die Person setzt zwei Häkchen, „mindestens 18 Jahre“ und „Datenschutzhinweis gelesen“. Danach „Gesuch absenden“.
3. Der Server prüft die Eingaben. Bei Fehlern markiert die App die Felder mit den Texten des Servers, die Eingaben bleiben erhalten.
4. Der Server legt das Gesuch als `unbestaetigt` an und sendet **M1 Bestätigung**. Besteht für die Adresse schon ein Gesuch, sendet er stattdessen **M2** (siehe K02).
5. Die App zeigt **T5** (Erfolg) und leert das Formular.
6. Die Person öffnet den Link aus M1. Die Webseite zeigt das Gesuch und den Knopf „Gesuch bestätigen“.
7. Nach dem Klick ist der Status `wartet`. Der Betreiber erhält **A1**, die Person **M3** mit Verwaltungslink.
8. Ohne Bestätigung innerhalb von **24 Stunden** wird das Gesuch gelöscht. Es gibt keine Mail dazu.

### 2.2 Freigabe oder Ablehnung

1. Der Betreiber öffnet die Admin-Webseite. Sie zeigt alle Gesuche mit Status `wartet`, ältestes zuerst, mit automatischem Prüfhinweis.
2. **Freigeben:** Status `sichtbar`, `sichtbar_bis` = heute + 30 Tage. Die Person erhält **M4**.
3. **Ablehnen:** Der Betreiber wählt einen Grund aus einer Liste oder schreibt einen eigenen (Vorschlag für die Liste: „Kontaktdaten im Text“, „kein Tanzgesuch“, „unangemessener Inhalt“, „doppeltes Gesuch“). Status `abgelehnt`, die Person erhält **M5**. Nach **7 Tagen** wird das Gesuch gelöscht.
4. Eine Änderung durch den Betreiber gibt es nicht. Wer korrigieren will, gibt ein neues Gesuch auf (nach Ablehnung ist das sofort möglich, weil abgelehnte Gesuche nicht als „offen“ zählen).

### 2.3 Erinnerung, Ablauf und Verlängerung

1. Ein täglicher Cronjob (Vorschlag: 6 Uhr) sendet **5 Tage vor** `sichtbar_bis` die Mail **M6** (nur einmal je Laufzeit, `erinnert_am`).
2. Ist `sichtbar_bis` überschritten, setzt der Cronjob den Status `abgelaufen` und sendet **M7**.
3. **Verlängern** über den Verwaltungslink, solange das Gesuch `sichtbar` oder `abgelaufen` ist: `sichtbar_bis` = heute + 30 Tage, `erinnert_am` wird zurückgesetzt. Keine erneute Freigabe nötig, weil sich der Inhalt nicht ändert. Die Webseite bestätigt das neue Datum, eine Mail gibt es nicht.
4. **14 Tage** nach Ablauf ohne Verlängerung wird das Gesuch gelöscht. Es gibt keine Mail dazu, M7 kündigt das an.

### 2.4 Löschen durch die Person

1. Verwaltungslink öffnen, „Gesuch endgültig löschen“ wählen und auf der Folgeseite noch einmal bestätigen.
2. Das Gesuch und alle zugehörigen Daten werden sofort gelöscht. Die Webseite zeigt „Dein Gesuch wurde gelöscht.“ Die Person erhält **M9** als Beleg, die Adresse wird danach nicht mehr verwendet.
3. In der App verschwindet das Gesuch beim nächsten Laden der Liste.

### 2.5 Kontakt aufnehmen

1. In der Detailansicht eines Gesuchs „Nachricht schreiben“ wählen. Das Formular zeigt **T8**.
2. Die Person füllt Name, E-Mail und Nachricht aus und setzt die Häkchen für Alter und Datenschutz.
3. Der Server prüft Sperrliste und Begrenzungen und sendet **M8** an die Adresse des Gesuchs, mit `Reply-To` auf die Adresse des Absenders. Es gibt keine Kopie an den Absender, damit keine Mails an fremde Adressen ausgelöst werden können.
4. Die App zeigt **T9**. Antwortet die Person des Gesuchs, läuft alles Weitere direkt per E-Mail.
5. Gespeichert wird nur ein Protokolleintrag (Hash, Zeit, Gesuchsnummer), nicht die Nachricht.

### 2.6 Melden

1. In der Detailansicht „Gesuch melden“ wählen, einen Grund auswählen und optional einen Text schreiben.
2. Der Server speichert die Meldung, der Betreiber erhält **A2**. Die App zeigt **T11**.
3. **Ausblenden** (Vorschlag): Das Gesuch wird sofort `ausgeblendet`, wenn
   - zwei Meldungen von verschiedenen IP-Adressen vorliegen oder
   - eine Meldung mit Grund `minderjaehrig` eingeht.
   Sonst bleibt es sichtbar, bis der Betreiber entscheidet.
4. Der Betreiber entscheidet in der Admin-Webseite:
   - **unbegründet:** Meldungen werden geschlossen. Ein ausgeblendetes Gesuch ist wieder `sichtbar`, die Laufzeit bleibt unverändert.
   - **entfernen:** Das Gesuch wird gelöscht, die Person erhält **M10**.
   - **entfernen und sperren:** wie „entfernen“, zusätzlich kommt die Adresse auf die Sperrliste.
5. Die meldende Person erhält keine Rückmeldung über das Ergebnis, weil keine Adresse erfasst wird.

### 2.7 Sperre

- Gesperrt wird nur durch den Betreiber, aus einem Gesuch heraus („entfernen und sperren“) oder durch Eingabe einer Adresse auf der Admin-Webseite, z. B. nach Beschwerden über Kontaktnachrichten.
- Wirkung: Diese Adresse kann weder Gesuche aufgeben noch Kontaktnachrichten senden. Die App zeigt dann nur **T13**, ohne Hinweis auf eine Sperre.
- Eine Sperre gilt unbefristet. Aufheben kann sie nur der Betreiber, auf Anfrage per Mail.
- Beschwerden über eine Kontaktnachricht: Die betroffene Person leitet sie an `kontakt@` weiter, der Betreiber sperrt die Absenderadresse von Hand.

## 3. Fristen und Speicherung

| Daten | Wo | Wie lange | Danach |
|---|---|---|---|
| Unbestätigtes Gesuch inkl. Adresse | `gesuche` | 24 Stunden | gelöscht (Cronjob stündlich) |
| Gesuch, wartet auf Freigabe | `gesuche` | bis zur Entscheidung | – |
| Sichtbares Gesuch inkl. Adresse | `gesuche` | 30 Tage, verlängerbar | `abgelaufen` |
| Abgelaufenes Gesuch | `gesuche` | 14 Tage | gelöscht |
| Abgelehntes Gesuch | `gesuche` | 7 Tage | gelöscht |
| Tokens, Zuordnungen, Meldungen | eigene Tabellen | wie das Gesuch | mit dem Gesuch gelöscht |
| Kontaktnachricht | – | nicht gespeichert | nur im Postfach des Empfängers |
| Protokoll (Hash von IP/Adresse) | `protokoll` | 7 Tage | gelöscht (Cronjob täglich) |
| Sperrliste (nur Hash) | `sperrliste` | unbefristet | Aufhebung auf Anfrage |
| Gesendete Mails | – | nicht aufbewahrt (SMTP-Versand legt keine Kopie im Ordner „Gesendet“ ab; in S04 kurz prüfen) | – |
| Mails an den Betreiber (A1, A2) | Postfach `kontakt@` | Vorschlag: nach Erledigung löschen, spätestens nach 30 Tagen | – |
| Zugriffsprotokolle des Webservers | Hoster | laut Hoster | in P01 klären |
| Datensicherungen | Hoster | laut Hoster | in S04/P01 klären; gelöschte Daten können bis zum Ende der Aufbewahrung in Backups stehen |

Benötigte Cronjobs (für S04): stündlich unbestätigte Gesuche löschen; täglich Erinnerungen und Ablauf, Löschung abgelaufener und abgelehnter Gesuche, Protokoll bereinigen.

## 4. Mails an Nutzer

### M1 – Bestätigung

```text
Betreff: Bitte bestätige dein Tanzgesuch

Hallo {anzeigename},

du hast in der App „Tanzpartner Ostfriesland“ ein Gesuch aufgegeben. Bitte bestätige es innerhalb von 24 Stunden über diesen Link:

{bestaetigungslink}

Danach prüfen wir dein Gesuch und schalten es frei, meist innerhalb von 2 Tagen.

Warst du das nicht? Dann ignoriere diese E-Mail einfach. Das Gesuch wird nach 24 Stunden automatisch gelöscht.
```

### M2 – Gesuch besteht bereits

```text
Betreff: Du hast bereits ein Tanzgesuch

Hallo,

für diese E-Mail-Adresse gibt es schon ein Gesuch. Pro Adresse ist ein Gesuch gleichzeitig möglich. Über diesen Link kannst du es verlängern oder löschen und danach ein neues aufgeben:

{verwaltungslink}

Warst du das nicht? Dann ignoriere diese E-Mail einfach.
```

Ist das bestehende Gesuch noch unbestätigt, enthält M2 stattdessen den Bestätigungslink.

### M3 – Bestätigt, wartet auf Freigabe

```text
Betreff: Dein Tanzgesuch ist bestätigt

Hallo {anzeigename},

danke! Dein Gesuch ist bestätigt und wird jetzt geprüft. Sobald es freigeschaltet ist, bekommst du eine E-Mail.

Über diesen Link kannst du dein Gesuch jederzeit verlängern oder löschen. Bitte bewahre diese E-Mail auf:

{verwaltungslink}
```

### M4 – Freigegeben

```text
Betreff: Dein Tanzgesuch ist online

Hallo {anzeigename},

dein Gesuch ist jetzt in der App sichtbar, bis zum {sichtbar_bis}. Wenn dir jemand schreibt, bekommst du die Nachricht per E-Mail und kannst direkt antworten. Deine Adresse sieht erst, wem du antwortest.

Verlängern oder löschen:
{verwaltungslink}

Viel Erfolg bei der Suche!
```

### M5 – Abgelehnt

```text
Betreff: Dein Tanzgesuch wurde nicht freigeschaltet

Hallo {anzeigename},

leider können wir dein Gesuch nicht veröffentlichen. Grund: {grund}

Du kannst in der App jederzeit ein neues Gesuch aufgeben. Dein bisheriges Gesuch wird in 7 Tagen automatisch gelöscht. Fragen? Antworte einfach auf diese E-Mail.
```

### M6 – Erinnerung vor Ablauf

```text
Betreff: Dein Tanzgesuch läuft am {sichtbar_bis} ab

Hallo {anzeigename},

dein Gesuch ist noch bis zum {sichtbar_bis} sichtbar. Wenn du weitersuchen möchtest, verlängere es um 30 Tage:

{verwaltungslink}

Hast du schon jemanden gefunden? Dann freuen wir uns und du kannst das Gesuch über denselben Link löschen.
```

### M7 – Abgelaufen

```text
Betreff: Dein Tanzgesuch ist abgelaufen

Hallo {anzeigename},

dein Gesuch ist nicht mehr sichtbar. Du kannst es noch 14 Tage lang um 30 Tage verlängern:

{verwaltungslink}

Danach wird es mit allen Daten automatisch gelöscht.
```

### M8 – Kontaktnachricht (Weiterleitung)

```text
Betreff: Nachricht zu deinem Tanzgesuch von {name}
Reply-To: <Adresse des Absenders>

Hallo {anzeigename},

{name} hat dir über die App „Tanzpartner Ostfriesland“ geschrieben:

----------
{nachricht}
----------

Wenn du antworten möchtest, antworte einfach auf diese E-Mail. Damit sieht {name} deine E-Mail-Adresse. Wenn du nicht antworten möchtest, musst du nichts tun.

Ist die Nachricht belästigend oder Spam? Leite sie bitte an kontakt@tanzpartner-ostfriesland.de weiter.

Dein Gesuch verwalten: {verwaltungslink}
```

### M9 – Gelöscht

```text
Betreff: Dein Tanzgesuch wurde gelöscht

Hallo {anzeigename},

dein Gesuch und alle dazu gespeicherten Daten wurden gelöscht. Du kannst jederzeit ein neues Gesuch aufgeben.
```

### M10 – Nach Meldung entfernt

```text
Betreff: Dein Tanzgesuch wurde entfernt

Hallo {anzeigename},

dein Gesuch wurde nach einer Prüfung entfernt, weil es nicht den Regeln der App entspricht. Grund: {grund}

Fragen? Antworte einfach auf diese E-Mail.
```

## 5. Mails an den Betreiber

Empfänger: `kontakt@tanzpartner-ostfriesland.de`. Ohne Adressen der Nutzer, nur mit Link zur Admin-Webseite.

### A1 – Neues Gesuch zur Freigabe

```text
Betreff: [Tanzpartner] Neues Gesuch #{gesuch_id} wartet auf Freigabe

Anzeigename: {anzeigename}
Ort: {ort}
Prüfhinweis: {pruefhinweis oder „keiner“}

Freigeben oder ablehnen: https://tanzpartner-ostfriesland.de/admin/
```

### A2 – Neue Meldung

```text
Betreff: [Tanzpartner] Meldung zu Gesuch #{gesuch_id}: {grund}

Grund: {grund}
Text: {text oder „–“}
Meldungen zu diesem Gesuch: {anzahl}
Status: {sichtbar | ausgeblendet}

Entscheiden: https://tanzpartner-ostfriesland.de/admin/
```

## 6. Texte in der App

| Nr. | Wo | Text |
|---|---|---|
| T1 | Liste, leer | „Gerade gibt es keine Gesuche. Gib doch selbst eins auf!“ |
| T2 | Liste, Filter ohne Treffer | „Keine Gesuche passen zu deinen Filtern.“ (Knopf „Filter zurücksetzen“) |
| T3 | Kein Netz | „Keine Internetverbindung. Bitte prüfe deine Verbindung und versuche es erneut.“ (Knopf „Erneut versuchen“) |
| T4 | Serverfehler / 503 | „Der Dienst ist gerade nicht erreichbar. Bitte versuche es später noch einmal.“ |
| T5 | Gesuch abgeschickt | Text aus der Server-Antwort (K02): „Fast geschafft: Wir haben dir eine E-Mail geschickt …“ |
| T6 | Formular, unter Freitext | „Bitte keine E-Mail-Adresse, Telefonnummer oder Links. Wer dich kontaktieren möchte, schreibt dir über die App. Deine Adresse bleibt verborgen.“ |
| T7 | Formular, Häkchen | „Ich bin mindestens 18 Jahre alt.“ · „Ich habe den [Datenschutzhinweis] gelesen. Mein Gesuch wird nach Prüfung 30 Tage lang öffentlich in der App angezeigt; meine E-Mail-Adresse nie.“ |
| T8 | Kontaktformular, oben | „Deine Nachricht wird per E-Mail an {anzeigename} weitergeleitet. Es gibt keinen Chat in der App: Wenn {anzeigename} antworten möchte, bekommst du die Antwort direkt per E-Mail. Dabei sieht {anzeigename} deine E-Mail-Adresse.“ |
| T9 | Kontakt gesendet | Text aus der Server-Antwort (K02). |
| T10 | Melden, oben | „Verstößt dieses Gesuch gegen die Regeln? Wir prüfen jede Meldung, meist innerhalb von 2 Tagen.“ |
| T11 | Meldung gesendet | Text aus der Server-Antwort (K02). |
| T12 | Zu viele Anfragen (429) | „Du hast das heute schon oft gemacht. Bitte versuche es morgen wieder.“ |
| T13 | Abgewiesen (403) | „Das ist leider nicht möglich. Bei Fragen schreib an kontakt@tanzpartner-ostfriesland.de.“ |
| T14 | Einstellungen, „Regeln“ | „Tanzpartner Ostfriesland ist eine Börse für Tanzpartner – für Kurse, Übung und Tanzabende, keine Partnervermittlung. Alle Gesuche werden vor der Veröffentlichung geprüft. Nicht erlaubt: Kontaktdaten im Text, beleidigende oder anstößige Inhalte, Werbung, Gesuche ohne Tanzbezug. Teilnahme ab 18 Jahren.“ |
| T15 | Einstellungen, „Kontakt“ | „Fragen, Beschwerden oder Löschwünsche: kontakt@tanzpartner-ostfriesland.de“ |

Die Datenschutzhinweise selbst (Link in T7) entstehen in P02.

## 7. Noch zu bestätigen (Nutzer)

1. **Ansprache „du“** in App und Mails.
2. **Reaktionszeit** „meist innerhalb von 2 Tagen“ für Freigabe und Meldungen. Das ist eine Zusage, die du als Betreiber einhalten musst.
3. **Meldeschwelle:** sofort ausblenden bei 2 Meldungen oder bei Grund „minderjährig“.
4. **Erinnerung** 5 Tage vor Ablauf, Cronjob täglich um 6 Uhr.
5. **Sperren** unbefristet, nur durch den Betreiber.
6. **Ablehnungsgründe** als Auswahlliste (Abschnitt 2.2).
7. **Keine Kopie** der Kontaktnachricht an den Absender.
8. **Mails M9 (gelöscht) und M7 (abgelaufen)** werden verschickt; unbestätigte und endgültig gelöschte abgelaufene Gesuche ohne Mail.
