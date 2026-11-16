<?php
ini_set('display_errors', '0');
header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-store');

try {
    $config = require '/home/sites/site100047965/web/private/db-config.php';

    $db = new PDO(
        "mysql:host={$config['host']};dbname={$config['database']};charset=utf8mb4",
        $config['username'],
        $config['password'],
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
        ]
    );

    $gesuche = $db->query(
        'SELECT id, anzeigename, ort, tanzstil, beschreibung, ablaufdatum
         FROM demo_gesuche
         WHERE ablaufdatum >= CURDATE()
         ORDER BY id'
    )->fetchAll();

    foreach ($gesuche as &$gesuch) {
        $gesuch['id'] = (int) $gesuch['id'];
    }
    unset($gesuch);

    echo json_encode(
        ['gesuche' => $gesuche],
        JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT | JSON_THROW_ON_ERROR
    );
} catch (Throwable $e) {
    http_response_code(500);
    echo '{"fehler":"Gesuche konnten nicht geladen werden."}';
}
