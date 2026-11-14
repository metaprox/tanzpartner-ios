// Lokale gemeinsame Werkstatt: SQLite ist die maßgebliche Quelle.
const cache = new Map();
let saving = false;
export async function loadState(key) {
  const response = await fetch(`/api/state/${key}`, {cache:'no-store'});
  if (!response.ok) throw new Error('SQL-Daten konnten nicht geladen werden. Bitte den lokalen Server neu starten.');
  const entry = await response.json();
  cache.set(key, entry);
  let legacy;
  try { legacy = JSON.parse(localStorage.getItem(key)); } catch {}
  if (entry.revision === 0 && legacy != null && confirm('Vorhandene Browser-Testdaten in die lokale SQLite-Datei übernehmen?')) {
    await saveState(key, legacy);
    // Browserkopie bleibt als Rückfallsicherung erhalten; sie wird nicht mehr aktualisiert.
  }
  return structuredClone(cache.get(key).value);
}
export async function saveState(key, value) {
  const entry = cache.get(key);
  if (!entry) throw new Error('SQL-Daten wurden noch nicht geladen. Seite neu laden.');
  if (saving) throw new Error('Eine Änderung wird bereits gespeichert. Bitte kurz warten.');
  saving = true;
  const controls=[...document.querySelectorAll('#my-profile button, #my-profile input, #my-profile select, #my-profile textarea, #moderation button, #moderation textarea')];
  const disabled=controls.map(el=>el.disabled);
  controls.forEach(el=>el.disabled=true);
  try {
  const response = await fetch(`/api/state/${key}`, {
    method:'PUT', headers:{'Content-Type':'application/json'},
    body:JSON.stringify({revision:entry.revision, value})
  });
  if (!response.ok) throw new Error(response.status === 409 ? 'Der Stand wurde in einem anderen Fenster geändert. Bitte Seite neu laden.' : 'SQL-Speicherung fehlgeschlagen. Bitte erneut versuchen.');
  cache.set(key, await response.json());
  } finally {
    controls.forEach((el,i)=>el.disabled=disabled[i]);
    saving=false;
  }
}
