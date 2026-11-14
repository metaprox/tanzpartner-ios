import {waitDbReady} from './db.js';
export const keys = new Set(['tanzpartner-local-profile-v02','tanzpartner-moderation-v02']);
export async function openStore() {
 const db = await waitDbReady();
 const run = (sql,args=[]) => new Promise((resolve,reject)=>db.run(sql,args,function(err){err?reject(err):resolve(this)}));
 const get = (sql,args=[]) => new Promise((resolve,reject)=>db.get(sql,args,(err,row)=>err?reject(err):resolve(row)));
 await run('CREATE TABLE IF NOT EXISTS app_state (key TEXT PRIMARY KEY, value TEXT NOT NULL, revision INTEGER NOT NULL)');
 return {
  async read(key) {const row=await get('SELECT value,revision FROM app_state WHERE key=?',[key]);return row?{value:JSON.parse(row.value),revision:row.revision}:{value:null,revision:0};},
  async write(key,value,revision) {
   const json=JSON.stringify(value);
   const result=revision===0
    ? await run('INSERT OR IGNORE INTO app_state(key,value,revision) VALUES(?,?,1)',[key,json])
    : await run('UPDATE app_state SET value=?,revision=revision+1 WHERE key=? AND revision=?',[json,key,revision]);
   return result.changes?{value,revision:revision+1}:null;
  }
 };
}
export function validState(key,value) {
 const statuses=['pending','approved','paused','returned'];
 const fields=['name','city','style','role','level','goal','time','bio'];
 const str=(x,max)=>typeof x==='string'&&x.length<=max;
 if(value===null)return true;
 if(key==='tanzpartner-moderation-v02')return Array.isArray(value)&&value.length<=3&&new Set(value.map(x=>x?.id)).size===value.length&&value.every(x=>[2001,2002,2003].includes(x?.id)&&statuses.includes(x.status)&&str(x.note||'',500)&&fields.every(k=>x[k]===undefined||str(x[k],600)));
 return value&&statuses.includes(value.status)&&str(value.number,80)&&str(value.token,100)&&str(value.note||'',500)&&value.data&&['name','city','style','role','level','goal','time','bio'].every(k=>str(value.data[k],600)&&value.data[k].trim());
}
