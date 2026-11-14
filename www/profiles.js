export const profiles = [
{id:1,name:'Mara',city:'Norden',styles:['Standard / Latein'],role:'Folgend',level:'Ohne Vorkenntnisse',goal:'Ersten Kurs beginnen',places:['Norden','Aurich'],time:'Dienstag oder Donnerstag abends',bio:'Ich möchte die ersten Schritte lernen und suche jemanden, der mit Geduld und Freude einen Grundkurs beginnt.'},
{id:2,name:'Jan',city:'Emden',styles:['Discofox','Standard / Latein'],role:'Führend',level:'Grundkenntnisse',goal:'Wieder einsteigen',places:['Emden','Norden'],time:'Freitag abends',bio:'Nach einigen Jahren Pause möchte ich wieder aufs Parkett. Ein entspannter Wiedereinstieg wäre schön.'},
{id:3,name:'Alva',city:'Aurich',styles:['Standard / Latein','Discofox'],role:'Beides',level:'Fortgeschritten',goal:'Kenntnisse vertiefen',places:['Aurich','Norden'],time:'Mittwoch abends oder am Wochenende',bio:'Die Grundlagen sitzen. Jetzt möchte ich an Haltung und Technik arbeiten und gemeinsam einen weiterführenden Kurs besuchen.'},
{id:4,name:'Timo',city:'Norden',styles:['Salsa'],role:'Führend',level:'Ohne Vorkenntnisse',goal:'Ersten Kurs beginnen',places:['Norden','Emden'],time:'Montag abends',bio:'Salsa macht mir schon beim Zuhören Spaß. Für meinen ersten Kurs suche ich einen ebenso neugierigen Menschen.'},
{id:5,name:'Jule',city:'Emden',styles:['Salsa','Bachata'],role:'Folgend',level:'Grundkenntnisse',goal:'Regelmäßig tanzen',places:['Emden','Aurich'],time:'Samstag nachmittags oder abends',bio:'Ich möchte meine Schritte regelmäßig üben. Die Freude an der Musik ist mir wichtiger als Perfektion.'},
{id:6,name:'Nico',city:'Aurich',styles:['Discofox'],role:'Beides',level:'Grundkenntnisse',goal:'Wieder einsteigen',places:['Aurich'],time:'Donnerstag abends',bio:'Ein paar Figuren sind noch da, andere brauchen eine Auffrischung. Ich freue mich auf einen lockeren Neustart.'},
{id:7,name:'Frida',city:'Norden',styles:['Tango Argentino'],role:'Folgend',level:'Fortgeschritten',goal:'Kenntnisse vertiefen',places:['Norden','Emden','Aurich'],time:'Am Wochenende',bio:'Ich möchte musikalischer tanzen und gemeinsam an unserer Verbindung und Technik arbeiten.'},
{id:8,name:'Ole',city:'Aurich',styles:['Standard / Latein'],role:'Führend',level:'Längere Tanzerfahrung',goal:'Regelmäßig tanzen',places:['Aurich','Norden'],time:'Dienstag abends und sonntags',bio:'Tanzen gehört für mich zum Alltag. Ich suche jemanden für regelmäßiges Üben und gemeinsame Tanzabende.'}
];
export function filterProfiles(filters){return profiles.filter(p=>(!filters.city||p.city===filters.city)&&(!filters.style||p.styles.includes(filters.style))&&(!filters.role||p.role===filters.role)&&(!filters.level||p.level===filters.level)&&(!filters.goal||p.goal===filters.goal));}

// Node nutzt die Ausgangsdaten zum einmaligen Befüllen; Browser laden aus SQLite.
if (typeof window !== 'undefined') {
 const response=await fetch('/api/profiles',{cache:'no-store'});
 if(!response.ok)throw new Error('Profile konnten nicht aus SQLite geladen werden.');
 profiles.splice(0,profiles.length,...await response.json());
}
