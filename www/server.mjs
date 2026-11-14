import {createServer} from 'node:http';
import {readFile} from 'node:fs/promises';
import {openStore,keys,validState} from './store.mjs';
import {profiles} from './profiles.js';
const store=await openStore();
if((await store.read('base-profiles')).revision===0)await store.write('base-profiles',profiles,0);
const files={'/storage.js':'storage.js','/moderation.js':'moderation.js','/workflow.js':'workflow.js','/':'index.html','/index.html':'index.html','/style.css':'style.css','/app.js':'app.js','/profiles.js':'profiles.js','/impressum.html':'impressum.html','/datenschutz.html':'datenschutz.html'};
const types={html:'text/html; charset=utf-8',css:'text/css; charset=utf-8',js:'text/javascript; charset=utf-8'};
const port=Number(process.env.PORT||4173);
createServer(async(req,res)=>{
 const json=(status,data)=>{res.writeHead(status,{'Content-Type':'application/json','Cache-Control':'no-store'});res.end(JSON.stringify(data));};
 if(![`127.0.0.1:${port}`,`localhost:${port}`].includes(req.headers.host))return json(403,{error:'Host nicht erlaubt'});
 const origin=`http://${req.headers.host}`;
 if(req.headers.origin&&req.headers.origin!==origin)return json(403,{error:'Origin nicht erlaubt'});
 const path=new URL(req.url,origin).pathname;
 try {
  if(path==='/api/profiles'&&req.method==='GET')return json(200,(await store.read('base-profiles')).value);
  if(path.startsWith('/api/state/')){
   const key=path.slice('/api/state/'.length);
   if(!keys.has(key))return json(404,{error:'Unbekannter Speicher'});
   if(req.method==='GET')return json(200,await store.read(key));
   if(req.method!=='PUT')return json(405,{error:'Methode nicht erlaubt'});
   if(!req.headers['content-type']?.startsWith('application/json'))return json(415,{error:'JSON erforderlich'});
   let body='';for await(const chunk of req){body+=chunk;if(Buffer.byteLength(body)>20000)return json(413,{error:'Zu groß'});}
   let data;try{data=JSON.parse(body);}catch{return json(400,{error:'Ungültiges JSON'});}
   if(!Number.isSafeInteger(data.revision)||data.revision<0||!validState(key,data.value))return json(400,{error:'Ungültiger Zustand'});
   const saved=await store.write(key,data.value,data.revision);
   return json(saved?200:409,saved||{error:'Stand inzwischen geändert'});
  }
  if(req.method!=='GET')return json(405,{error:'Methode nicht erlaubt'});
  const file=files[path];if(!file)return json(404,{error:'Nicht gefunden'});
  const body=await readFile(new URL(file,import.meta.url));
  res.writeHead(200,{'Content-Type':types[file.split('.').pop()],'Cache-Control':'no-store'});res.end(body);
 }catch{json(500,{error:'Lokaler Speicher nicht verfügbar'});}
}).listen(port,'127.0.0.1',()=>console.log(`Lokale SQL-Werkstatt: http://127.0.0.1:${port}`));
