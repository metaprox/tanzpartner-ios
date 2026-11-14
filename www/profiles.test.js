import test from 'node:test';
import assert from 'node:assert/strict';
import {profiles,filterProfiles} from './profiles.js';
test('Acht eindeutige Profile in allen drei Orten',()=>{assert.equal(profiles.length,8);assert.equal(new Set(profiles.map(p=>p.id)).size,8);assert.deepEqual([...new Set(profiles.map(p=>p.city))].sort(),['Aurich','Emden','Norden']);});
test('Alle fünf Filter gemeinsam ergeben Mara',()=>assert.deepEqual(filterProfiles({city:'Norden',style:'Standard / Latein',role:'Folgend',level:'Ohne Vorkenntnisse',goal:'Ersten Kurs beginnen'}).map(p=>p.name),['Mara']));
test('Unpassende Kombination ergibt keine Treffer',()=>assert.equal(filterProfiles({city:'Emden',style:'Tango Argentino'}).length,0));
test('Erfahrung und Wiedereinstieg sind unabhängig',()=>assert.equal(filterProfiles({level:'Grundkenntnisse',goal:'Wieder einsteigen'}).length,2));
test('Leere Filter zeigen alle Profile',()=>assert.equal(filterProfiles({city:'',role:'',style:'',level:'',goal:''}).length,8));
test('Wohnort ist unabhängig von möglichen Kursorten',()=>assert.equal(filterProfiles({city:'Norden'}).length,3));
