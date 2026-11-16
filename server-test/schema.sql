-- Referenz des bestehenden Testschemas. Nur für eine neue, leere Testdatenbank.
-- Nicht erneut auf der bestehenden Datenbank ausführen; keine Daten löschen.
CREATE TABLE demo_gesuche (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    anzeigename VARCHAR(80) NOT NULL,
    ort VARCHAR(100) NOT NULL,
    tanzstil VARCHAR(80) NOT NULL,
    beschreibung TEXT NOT NULL,
    ablaufdatum DATE NOT NULL
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;
