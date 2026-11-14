import test from 'node:test';
import assert from 'node:assert/strict';
import {spawn} from 'node:child_process';
import {mkdtemp,rm} from 'node:fs/promises';
import {tmpdir} from 'node:os';
import {join} from 'node:path';
import {once} from 'node:events';
test('SQL-API übersteht Neustart und schützt vor Konflikten',async()=>{
 const dir=await mkdtemp(join(tmpdir(),'tanz-api-'));let child;
 const base='http://127.0.0.1:14379';
 const start=async()=>{child=spawn(process.execPath,['server.mjs'],{cwd:import.meta.dirname,env:{...process.env,PORT:'14379',TANZ_DB_PATH:join(dir,'data.sqlite')},stdio:['ignore','pipe','pipe']});await Promise.race([once(child.stdout,'data'),once(child,'exit').then(()=>{throw Error('Testserver fehlgeschlagen');})]);};
 const stop=async()=>{const ended=once(child,'exit');child.kill();await ended;child=null;};
 const key='/api/state/tanzpartner-local-profile-v02';
 const put=(value,revision,origin)=>fetch(base+key,{method:'PUT',headers:{'Content-Type':'application/json',...(origin?{Origin:origin}:{})},body:JSON.stringify({value,revision})});
 const value={number:'TEST-API',token:'test-token',status:'approved',note:'',data:{name:'SQL Test',city:'Norden',style:'Discofox',role:'Beides',level:'Grundkenntnisse',goal:'Wieder einsteigen',time:'Abends',bio:'Fiktives Profil'}};
 try{
  await start();
  assert.equal((await (await fetch(base+'/api/profiles')).json()).length,8);
  assert.equal((await put(value,0)).status,200);
  assert.equal((await put(value,0)).status,409);
  assert.equal((await put(value,1,'https://example.org')).status,403);
  assert.equal((await put({...value,status:'invalid'},1)).status,400);
  await stop();await start();
  assert.deepEqual((await (await fetch(base+key)).json()).value,value);
  assert.equal((await fetch(base+'/data.sqlite')).status,404);
  assert.equal((await put(null,1)).status,200);
  const deleted=await (await fetch(base+key)).json();assert.equal(deleted.value,null);assert.equal(deleted.revision,2);
 }finally{if(child)await stop();await rm(dir,{recursive:true,force:true});}
});
