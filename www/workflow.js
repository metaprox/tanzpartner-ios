import {loadState,saveState} from './storage.js';
import { profiles, filterProfiles } from './profiles.js';

// This is a browser-only prototype, never an authorization mechanism.
const key = 'tanzpartner-local-profile-v02';
const host = document.querySelector('#my-profile');
const choices = {
  city: ['Norden', 'Emden', 'Aurich'],
  style: [...new Set(profiles.flatMap(p => p.styles))],
  role: ['Führend', 'Folgend', 'Beides'],
  level: ['Ohne Vorkenntnisse', 'Grundkenntnisse', 'Fortgeschritten', 'Längere Tanzerfahrung'],
  goal: ['Ersten Kurs beginnen', 'Wieder einsteigen', 'Kenntnisse vertiefen', 'Regelmäßig tanzen']
};
const labels = { city: 'Ort', style: 'Tanzstil', role: 'Tanzrolle', level: 'Erfahrung', goal: 'Tanzziel' };
const escape = s => String(s).replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
let state = null, storageError = '';

function valid(s) {
  return s && ['pending', 'approved', 'paused', 'returned'].includes(s.status) &&
    typeof s.number === 'string' && s.data &&
    ['name', 'bio', 'time'].every(k => typeof s.data[k] === 'string' && s.data[k].length <= 600) &&
    Object.entries(choices).every(([k, v]) => v.includes(s.data[k]));
}

try {
  const saved = await loadState(key);
  if (valid(saved)) state = saved;
} catch (error) {
  storageError = error.message;
}

let confirmed = structuredClone(state);
async function save() {
  try {
    await saveState(key,state);
    confirmed=structuredClone(state);
    storageError='';
    return true;
  } catch(error) {
    state=structuredClone(confirmed);
    storageError=error.message;
    update();
    return false;
  }
}

function sync() {
  const i = profiles.findIndex(p => p.id === 1001);
  if (i >= 0) profiles.splice(i, 1);
  if (state?.status === 'approved') {
    const d = Object.fromEntries(Object.entries(state.data).map(([k, v]) => [k, escape(v)]));
    profiles.push({ ...d, id: 1001, styles: [d.style], places: [d.city] });
  }
  document.dispatchEvent(new Event('profiles-updated'));
}

host.innerHTML = `<p class="eyebrow">LOKALE WERKSTATT · VERSION 0.2</p><h2>Dein Testprofil</h2><p>Probiere den Weg vom Profil bis zur Freigabe aus. Bitte ausschließlich erfundene Angaben verwenden. Alle gespeicherten Testdaten liegen in der lokalen SQLite-Datei; es gibt keinen Versand und keine echte Veröffentlichung.</p><p id="workflow-status" role="status"></p><p id="storage-error" role="alert"></p><div class="workshop-grid"><form id="profile-editor"><label>Erfundener Vorname<input name="name" required maxlength="40" autocomplete="off"></label>${Object.entries(choices).map(([k, v]) => `<label>${labels[k]}<select name="${k}" required>${v.map(x => `<option>${x}</option>`).join('')}</select></label>`).join('')}<label>Zeit für Tanz<input name="time" required maxlength="100" placeholder="Zum Beispiel: Donnerstag abends"></label><label>Vorstellung<textarea name="bio" required maxlength="600" placeholder="Deine Vorstellung..."></textarea></label><div class="workshop-actions"><button type="submit">Profil einreichen</button><button type="button" id="fill-demo">Beispiel füllen</button></div></form><div><h3>Vorschau</h3><div id="own-preview" class="card"></div><div id="management" hidden><p id="profile-number"></p><div class="workshop-actions"><button id="pause-profile" type="button">Pausieren</button><button id="delete-profile" type="button">Testprofil löschen</button></div><p id="review-feedback"></p><a class="button" href="#moderation">Zur Betreiberansicht</a></div></div></div>`;

const editor = host.querySelector('form');

function preview() {
  const d = Object.fromEntries(new FormData(editor));
  const p = host.querySelector('#own-preview');
  p.replaceChildren();
  for (const [tag, value] of [['h3', d.name || 'Dein erfundener Name'], ['p', `${d.city} · ${d.style} · ${d.role}`], ['p', `${d.level} · ${d.goal}`], ['p', d.bio || 'Hier erscheint deine Vorstellung.'], ['p', d.time || 'Deine mögliche Tanzzeit']]) {
    const el = document.createElement(tag);
    el.textContent = value;
    p.append(el);
  }
}

function update() {
  host.querySelector('#workflow-status').textContent = state 
    ? ({ pending: 'Wartet auf simulierte Freigabe.', approved: 'Lokal freigegeben – dein Testprofil erscheint jetzt in der Suche.', paused: 'Pausiert – dein Testprofil ist aus der Suche ausgeblendet.', returned: 'Zurückgestellt – bitte den Hinweis prüfen und dein Profil erneut einreichen.' }[state.status])
    : 'Noch kein Testprofil eingereicht.';
  host.querySelector('#storage-error').textContent = storageError;
  host.querySelector('#management').hidden = !state;
  host.querySelector('#profile-number').textContent = state ? `Testnummer: ${state.number}. Nur eine Kennzeichnung, kein Zugangsschlüssel.` : '';
  host.querySelector('#review-feedback').textContent = state?.note ? `Hinweis zur Prüfung: ${state.note}` : '';
  updateLink();
  document.dispatchEvent(new CustomEvent('own-profile-updated', { detail: state }));
  host.querySelector('#pause-profile').disabled = state?.status !== 'approved';
  sync();
  preview();
}

if (state) for (const [k, v] of Object.entries(state.data)) editor.elements[k].value = v;
editor.addEventListener('input', preview);
editor.addEventListener('submit', async e => {
  e.preventDefault();
  const d = Object.fromEntries(new FormData(editor));
  for (const k of ['name', 'bio', 'time']) {
    editor.elements[k].setCustomValidity(d[k].trim() ? '' : 'Bitte einen Text eingeben.');
    if (!editor.elements[k].reportValidity()) return;
    d[k] = d[k].trim();
  }
  state = { number: state?.number || `TEST-${crypto.randomUUID().slice(0, 8)}`, token: state?.token || crypto.randomUUID(), status: 'pending', data: d };
  if (!await save()) return;
  update();
});
editor.addEventListener('input', e => e.target.setCustomValidity?.(''));
host.querySelector('#fill-demo').onclick = async () => {
  const d = { name: 'Robin (Test)', bio: 'Ich möchte nach einer Pause wieder gemeinsam tanzen und suche einen entspannten Einstieg.', time: 'Donnerstag abends', city: 'Norden', style: 'Discofox', role: 'Beides', level: 'Grundkenntnisse', goal: 'Wieder einsteigen' };
  for (const [k, v] of Object.entries(d)) { editor.elements[k].value = v; editor.elements[k].setCustomValidity(''); }
  preview();
};
document.addEventListener('request-own-profile', () => document.dispatchEvent(new CustomEvent('own-profile-updated', { detail: state })));
document.addEventListener('moderate-own-profile', async e => {
  if (state?.status !== 'pending') return;
  const { status, note } = e.detail;
  if (!['approved', 'returned'].includes(status)) return;
  if (status === 'returned' && !note?.trim()) return;
  state.status = status;
  state.note = status === 'returned' ? note.trim().slice(0, 500) : '';
  if (!await save()) return;
  update();
});
host.querySelector('#pause-profile').onclick = async () => {
  if (!state) return;
  state.status = 'paused';
  if (!await save()) return;
  update();
};
host.querySelector('#delete-profile').onclick = async () => {
  if (!confirm('Dieses lokale Testprofil endgültig löschen?')) return;
  state = null;
  if (!await save()) return;
  editor.reset();
  update();
  checkManagementLink();
};

// Local simulation only: a server must enforce access in any real deployment.
const linkPanel = document.createElement('section');
linkPanel.className = 'moderation';
linkPanel.innerHTML = `<h3>Dein persönlicher Verwaltungslink</h3><p>Bewahre diesen Link auf. In dieser Simulation funktioniert er in allen Browsern unter derselben lokalen Serveradresse. Er wird nicht per E-Mail versendet und ist noch kein echter Zugriffsschutz.</p><label>Verwaltungslink<input id="management-link" readonly autocomplete="off"></label><div class="workshop-actions"><button type="button" id="copy-management-link">Link kopieren</button><a id="open-management-link" class="button">Profil über Link öffnen</a><button type="button" id="rotate-management-link">Link ersetzen</button></div><p id="link-feedback" role="status"></p>`;
host.querySelector('#management').append(linkPanel);
const linkNotice = document.createElement('p');
linkNotice.id = 'management-link-status';
linkNotice.setAttribute('role', 'status');
host.prepend(linkNotice);

function managementUrl() { return `${location.origin}${location.pathname}#verwalten=${state.token}`; }
function updateLink() {
  if (!state) return;
  const url = managementUrl();
  host.querySelector('#management-link').value = url;
  host.querySelector('#open-management-link').href = url;
}
function checkManagementLink() {
  if (!location.hash.startsWith('#verwalten=')) { linkNotice.textContent = ''; return; }
  const token = location.hash.slice('#verwalten='.length);
  const matches = Boolean(state && token === state.token);
  linkNotice.textContent = matches ? 'Verwaltungslink erkannt. Du kannst dein lokales Testprofil unten bearbeiten.' : 'Dieser Verwaltungslink ist ungültig oder gehört nicht zu diesem lokalen Datenbestand. Eine Wiederherstellung per E-Mail ist in dieser lokalen Simulation nicht möglich.';
  host.scrollIntoView({block:'start'});
  linkNotice.tabIndex=-1;
  linkNotice.focus();
}
host.querySelector('#copy-management-link').onclick = async () => {
  try {
    await navigator.clipboard.writeText(managementUrl());
    host.querySelector('#link-feedback').textContent = 'Link kopiert. Bewahre ihn beispielsweise in einer privaten Notiz auf.';
  } catch {
    host.querySelector('#management-link').select();
    host.querySelector('#link-feedback').textContent = 'Bitte den markierten Link mit ⌘C beziehungsweise Strg+C kopieren.';
  }
};
host.querySelector('#rotate-management-link').onclick = async () => {
  if (!state || !confirm('Verwaltungslink ersetzen? Der bisherige Link wird in dieser Simulation ungültig.')) return;
  state.token = crypto.randomUUID();
  if (!await save()) return;
  updateLink();
  host.querySelector('#link-feedback').textContent = 'Neuer Link erstellt. Der bisherige Link ist ungültig. Bitte den neuen Link kopieren.';
  checkManagementLink();
};
window.addEventListener('hashchange', checkManagementLink);
update();
checkManagementLink();