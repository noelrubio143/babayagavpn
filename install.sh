<!DOCTYPE html>
<html lang="tl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="robots" content="noindex,nofollow">
<title>BABAYAGA VPS Panel</title>
<style>
:root{--bg:#0b0e0d;--panel:#121715;--panel2:#171e1b;--line:#243029;--text:#e8e4d8;--muted:#8a9a90;--ember:#ff7a3d;--ember-dim:#3a2217;--ok:#5fd68a;--bad:#ff6b6b;
--serif:Georgia,'Times New Roman',serif;--sans:system-ui,-apple-system,'Segoe UI',Roboto,sans-serif;--mono:ui-monospace,Menlo,Consolas,monospace}
*{box-sizing:border-box}html{-webkit-text-size-adjust:100%}
body{margin:0;background:var(--bg);color:var(--text);font:15px/1.5 var(--sans);padding:env(safe-area-inset-top,0) 0 calc(76px + env(safe-area-inset-bottom,0))}
header{padding:20px 16px 4px;max-width:780px;margin:0 auto}
header h1{font:800 24px/1.1 var(--serif);margin:0}
header p{margin:6px 0 0;color:var(--muted);font-size:13px}
#cur{display:inline-block;margin-top:8px;font:12px var(--mono);color:var(--ember);border:1px solid var(--ember-dim);padding:3px 10px;border-radius:99px}
main{max-width:780px;margin:0 auto;padding:6px 16px 24px}
section{display:none}section.on{display:block}
h2{font:600 18px/1.2 var(--serif);margin:18px 0 10px}
.hint{color:var(--muted);font-size:13px;margin:0 0 12px}
nav{position:fixed;left:0;right:0;bottom:0;background:#0e1311ee;backdrop-filter:blur(8px);border-top:1px solid var(--line);display:flex;padding:6px 6px calc(6px + env(safe-area-inset-bottom,0));z-index:5}
nav button{flex:1;background:none;border:0;color:var(--muted);font:500 13px var(--sans);padding:12px 4px;border-radius:10px}
nav button.on{color:var(--text);background:var(--ember-dim)}
.grid{display:grid;grid-template-columns:1fr 1fr;gap:10px}.grid .wide{grid-column:1/-1}
label.f{display:block;font-size:12.5px;color:var(--muted)}label.f>span{display:block;margin-bottom:4px}
input[type=text],input[type=number],input[type=password],select{width:100%;background:var(--panel2);color:var(--text);border:1px solid var(--line);border-radius:10px;padding:10px 11px;font:14px var(--mono);outline:none}
input:focus,select:focus{border-color:var(--ember)}
.chk{display:flex;flex-wrap:wrap;gap:8px;margin:6px 0}
.chk label{display:flex;align-items:center;gap:6px;background:var(--panel2);border:1px solid var(--line);border-radius:99px;padding:6px 12px;font-size:13px}
.chk input{accent-color:var(--ember)}
.btn{background:var(--panel2);color:var(--text);border:1px solid var(--line);border-radius:10px;padding:10px 14px;font:500 14px var(--sans)}
.btn.pri{background:var(--ember);border-color:var(--ember);color:#1a0d05;font-weight:600}
.btn.dng{color:var(--bad)}.btn.sm{padding:6px 10px;font-size:13px}.btn:disabled{opacity:.5}
.row{display:flex;gap:8px;flex-wrap:wrap;margin:10px 0}
.card{background:var(--panel);border:1px solid var(--line);border-radius:14px;margin:0 0 10px;padding:12px 14px}
.card.sel{border-color:var(--ember)}
.top{display:flex;gap:10px;align-items:center}
.dot{width:9px;height:9px;border-radius:50%;background:#56615b;flex:none}.dot.on{background:var(--ok)}.dot.bad{background:var(--bad)}
.ttl{flex:1;min-width:0}.ttl strong{display:block;font-weight:600;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.ttl small{display:block;color:var(--muted);font:12px var(--mono);overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.chip{font:11px var(--mono);color:var(--ember);border:1px solid var(--ember-dim);padding:2px 8px;border-radius:99px}
.chip.exp{color:var(--bad);border-color:#5a2a2a}
.empty{border:1px dashed var(--line);border-radius:14px;padding:22px 16px;text-align:center;color:var(--muted);margin-bottom:12px}
.kv{display:grid;grid-template-columns:auto 1fr;gap:4px 14px;font-size:14px}.kv b{color:var(--muted);font-weight:400}
.mono{font-family:var(--mono);font-size:12.5px;word-break:break-all}
.bar{height:6px;background:#222c27;border-radius:3px;overflow:hidden;margin:4px 0 10px}.bar i{display:block;height:100%;background:var(--ember)}
.link{display:flex;gap:8px;align-items:center;margin:6px 0}.link span{flex:1;min-width:0;font:12px var(--mono);color:var(--muted);overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.res{background:#0e1311;border:1px solid var(--ok);border-radius:12px;padding:12px;margin:10px 0;white-space:pre-wrap;font:12.5px/1.5 var(--mono)}
.warn{background:var(--ember-dim);border:1px solid #5a3321;border-radius:12px;padding:10px 12px;font-size:13px;margin:10px 0}
#login{display:none;max-width:780px;margin:0 auto;padding:6px 16px}body.noauth #login{display:block}body.noauth main{display:none}
#msg{position:fixed;left:12px;right:12px;bottom:calc(84px + env(safe-area-inset-bottom,0));max-width:756px;margin:0 auto;background:#1d2823;border:1px solid var(--line);border-radius:12px;padding:12px 14px;font-size:14px;display:none;z-index:9}
#msg.ok{border-color:var(--ok)}#msg.bad{border-color:var(--bad)}
@media(min-width:560px){.grid{grid-template-columns:1fr 1fr 1fr}}
</style>
</head>
<body>
<header><h1>BABAYAGA VPS Panel</h1><p>SSH at Xray accounts sa lahat ng VPS mo.</p><span id="cur">walang napiling VPS</span></header>
<div id="login"><h2>Mag-login</h2><p class="hint">Ilagay ang URL at token ng master VPS (isang beses lang). Ang master na ang kokonekta sa lahat ng ibang VPS.</p><label class="f"><span>URL ng master</span><input type="text" id="l-url" placeholder="https://IP-ng-master:8443" autocapitalize="off"></label><label class="f" style="margin-top:10px"><span>Token ng master</span><input type="password" id="l-token" autocomplete="off"></label><div class="row"><button class="btn pri" id="l-go">Pumasok</button></div><div id="l-err" class="warn" style="display:none"></div></div>
<main>
<section id="t-vps" class="on">
  <h2>Mga VPS</h2>
  <div id="vpsList"></div>
  <h2>Magdagdag ng VPS</h2>
  <div class="grid">
    <label class="f"><span>Pangalan</span><input type="text" id="n-name" placeholder="Alibaba SG"></label>
    <label class="f wide"><span>URL ng agent</span><input type="text" id="n-url" placeholder="https://IP-ng-ibang-vps:8443" autocapitalize="off"></label>
    <label class="f wide"><span>Token ng VPS na idadagdag</span><input type="password" id="n-token" autocomplete="off"></label>
  </div>
  <div class="row"><button class="btn pri" id="addVps">Subukan at idagdag</button></div>
  <div class="warn">Naka-save ang mga token ng ibang VPS sa master server (hindi sa browser). Isang link at isang token lang ang kailangan mo.</div>
</section>

<section id="t-ov">
  <h2>Overview</h2><div id="ov"><div class="empty">Pumili muna ng VPS.</div></div>
</section>

<section id="t-ssh">
  <h2>Gumawa ng SSH account</h2>
  <div class="grid">
    <label class="f"><span>Username</span><input type="text" id="s-user" autocapitalize="off" autocomplete="off" placeholder="juan"></label>
    <label class="f"><span>Password</span><input type="text" id="s-pass" autocomplete="off"></label>
    <label class="f"><span>Araw</span><input type="number" id="s-days" value="30" min="1"></label>
  </div>
  <div class="chk" id="s-targets"></div>
  <div class="row"><button class="btn pri" id="s-create">Gumawa</button><button class="btn" id="s-gen">Gumawa ng password</button></div>
  <div id="s-result"></div>
  <h2>Mga SSH account</h2><div id="s-list"></div>
</section>

<section id="t-xr">
  <h2>Gumawa ng Xray account</h2>
  <div class="grid">
    <label class="f"><span>Username</span><input type="text" id="x-user" autocapitalize="off" autocomplete="off" placeholder="juan"></label>
    <label class="f"><span>Araw</span><input type="number" id="x-days" value="30" min="1"></label>
  </div>
  <p class="hint">Protocols:</p>
  <div class="chk" id="x-protos"></div>
  <p class="hint">Gagawin sa:</p>
  <div class="chk" id="x-targets"></div>
  <div class="row"><button class="btn pri" id="x-create">Gumawa</button></div>
  <div id="x-result"></div>
  <h2>Mga Xray account</h2><div id="x-list"></div>
</section>
</main>
<div id="msg"></div>
<nav>
  <button data-tab="vps" class="on">VPS</button><button data-tab="ov">Overview</button><button data-tab="ssh">SSH</button><button data-tab="xr">Xray</button>
</nav>

<script>
(function(){
"use strict";
const $=s=>document.querySelector(s);
const esc=s=>String(s??"").replace(/[&<>"']/g,c=>({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[c]));
const KEY="bby-master-v2";
const PROTOS=[["vless-ws","VLESS WS"],["vmess-ws","VMess WS"],["trojan-ws","Trojan WS"],["vless-xhttp","VLESS xhttp"],["vmess-xhttp","VMess xhttp"],["trojan-xhttp","Trojan xhttp"],["vless-slip","VLESS Slipstream"]];
const PATHS={"vless-ws":"/vless","vmess-ws":"/vmess","trojan-ws":"/trojan-ws","vless-xhttp":"/xhttp-vless","vmess-xhttp":"/xhttp-vmess","trojan-xhttp":"/xhttp-trojan"};
let F={token:"",master:"",cur:null}, V=[], INFO={};
try{const r=localStorage.getItem(KEY);if(r)F=JSON.parse(r)}catch(e){}
const save=()=>{try{localStorage.setItem(KEY,JSON.stringify(F))}catch(e){}};
const cur=()=>V.find(v=>v.id===F.cur);
function msg(t,k){const m=$("#msg");m.textContent=t;m.className=k||"";m.style.display="block";clearTimeout(msg.t);msg.t=setTimeout(()=>m.style.display="none",4500)}
async function api(v,path,body){
  const url=(F.master||"").replace(/\/+$/,"")+(v?"/api/v/"+v.id+path.slice(4):path);
  let r;
  try{r=await fetch(url,{method:body?"POST":"GET",headers:Object.assign({Authorization:"Bearer "+F.token},body?{"Content-Type":"application/json"}:{}),body:body?JSON.stringify(body):undefined})}
  catch(e){throw new Error("Hindi maabot ang master VPS. Buksan muna ang URL niya sa Chrome at i-accept ang certificate, at siguraduhing bukas ang port.")}
  let j={};try{j=await r.json()}catch(e){}
  if(r.status===401&&j.error==="Invalid token"){F.token="";save();document.body.classList.add("noauth");throw new Error("Maling token.")}
  if(!r.ok||j.ok===false)throw new Error(j.error||("HTTP "+r.status));
  return j;
}
const copy=async t=>{try{await navigator.clipboard.writeText(t);msg("Nakopya na.","ok")}catch(e){msg("Hindi nakopya. Piliin nang manu-mano.","bad")}};
const days=iso=>Math.ceil((new Date(iso+"T23:59:59")-new Date())/864e5);
const expChip=iso=>{if(!iso)return `<span class="chip">walang expiry</span>`;const d=days(iso);return `<span class="chip ${d<0?"exp":""}">${d<0?"expired":d+" araw"} · ${esc(iso)}</span>`};
const fmtUp=s=>{const d=Math.floor(s/86400),h=Math.floor(s%86400/3600);return d+"d "+h+"h"};

/* tabs */
document.querySelectorAll("nav button").forEach(b=>b.onclick=()=>{
  if(document.body.classList.contains("noauth"))return msg("Mag-login muna sa taas.","bad");
  document.querySelectorAll("nav button").forEach(x=>x.classList.toggle("on",x===b));
  document.querySelectorAll("section").forEach(s=>s.classList.toggle("on",s.id==="t-"+b.dataset.tab));
  window.scrollTo(0,0);load(b.dataset.tab);
});
function load(tab){
  if(tab==="vps")renderVps();
  if(!cur()&&tab!=="vps")return;
  if(tab==="ov")loadOv(); if(tab==="ssh")loadSsh(); if(tab==="xr")loadXr();
}

/* VPS list */
function head(){$("#cur").textContent=cur()?cur().name:"walang napiling VPS"}
async function loadFleet(){const r=await api(null,"/api/fleet");V=r.vps;if(!cur())F.cur=V[0]?V[0].id:null;save()}
function renderVps(){
  head();
  $("#vpsList").innerHTML=V.length?V.map(v=>`<div class="card ${v.id===F.cur?"sel":""}"><div class="top"><span class="dot" id="d-${esc(v.id)}"></span>
    <span class="ttl"><strong>${esc(v.name)}</strong><small>${esc(v.url)}</small></span></div>
    <div class="row"><button class="btn sm" data-use="${esc(v.id)}">${v.id===F.cur?"Napili":"Piliin"}</button>${v.id==="local"?"":`<button class="btn sm dng" data-rm="${esc(v.id)}">Alisin</button>`}</div></div>`).join("")
    :`<div class="empty">Wala pang VPS.</div>`;
  V.forEach(v=>api(v,"/api/status").then(()=>{const d=$("#d-"+v.id);if(d)d.className="dot on"}).catch(()=>{const d=$("#d-"+v.id);if(d)d.className="dot bad"}));
}
$("#vpsList").addEventListener("click",async e=>{
  const b=e.target.closest("button");if(!b)return;
  if(b.dataset.use){F.cur=b.dataset.use;save();renderVps()}
  if(b.dataset.rm&&confirm("Alisin ang VPS na ito sa panel? (Hindi nito binubura ang server.)")){
    try{await api(null,"/api/fleet/delete",{id:b.dataset.rm});await loadFleet();renderVps()}catch(er){msg(er.message,"bad")}
  }
});
$("#addVps").onclick=async()=>{
  const v={name:$("#n-name").value.trim()||"VPS",url:$("#n-url").value.trim(),token:$("#n-token").value.trim()};
  if(!/^https:\/\//.test(v.url)||!v.token)return msg("Kulang ang URL (https://…) o token.","bad");
  $("#addVps").disabled=true;
  try{await api(null,"/api/fleet",v);$("#n-name").value=$("#n-url").value=$("#n-token").value="";await loadFleet();renderVps();msg("Naidagdag na.","ok")}
  catch(e){msg(e.message,"bad")}finally{$("#addVps").disabled=false}
};

/* overview */
async function loadOv(){
  const v=cur();$("#ov").innerHTML=`<div class="empty">Kinukuha…</div>`;
  try{
    const s=await api(v,"/api/status");INFO[v.id]=s;
    const mp=s.mem_total_mb?Math.round((s.mem_total_mb-s.mem_avail_mb)/s.mem_total_mb*100):0, dp=s.disk_total_gb?Math.round(s.disk_used_gb/s.disk_total_gb*100):0;
    $("#ov").innerHTML=`<div class="card"><div class="kv"><b>Domain</b><span class="mono">${esc(s.domain||"—")}</span><b>NS domain</b><span class="mono">${esc(s.ns_domain||"—")}</span>
      <b>Uptime</b><span>${fmtUp(s.uptime_s)}</span><b>Load</b><span>${esc(s.load.join("  "))}</span><b>SSH ports</b><span class="mono">${esc(s.ssh_ports.join(", ")||"—")}</span></div></div>
      <div class="card"><div>RAM ${mp}% (${s.mem_total_mb-s.mem_avail_mb}/${s.mem_total_mb} MB)</div><div class="bar"><i style="width:${mp}%"></i></div>
      <div>Disk ${dp}% (${s.disk_used_gb}/${s.disk_total_gb} GB)</div><div class="bar"><i style="width:${dp}%"></i></div></div>
      <div class="card">${Object.entries(s.services).map(([k,ok])=>`<div class="top" style="margin:4px 0"><span class="dot ${ok?"on":"bad"}"></span><span class="mono">${esc(k)}</span></div>`).join("")}</div>`;
  }catch(e){$("#ov").innerHTML=`<div class="empty">${esc(e.message)}</div>`}
}
async function info(v){if(!INFO[v.id])INFO[v.id]=await api(v,"/api/status");return INFO[v.id]}

/* targets */
function renderTargets(el){
  el.innerHTML=V.map(v=>`<label><input type="checkbox" value="${v.id}" ${v.id===F.cur?"checked":""}> ${esc(v.name)}</label>`).join("");
}
const picked=el=>[...el.querySelectorAll("input:checked")].map(i=>V.find(v=>v.id===i.value)).filter(Boolean);
async function multi(targets,fn){
  const out=[];
  for(const v of targets){try{out.push({v,r:await fn(v)})}catch(e){out.push({v,err:e.message})}}
  return out;
}

/* SSH */
async function loadSsh(){
  renderTargets($("#s-targets"));
  const v=cur();$("#s-list").innerHTML=`<div class="empty">Kinukuha…</div>`;
  try{
    const r=await api(v,"/api/ssh");
    $("#s-list").innerHTML=r.users.length?r.users.map(u=>`<div class="card"><div class="top"><span class="dot ${u.sessions?"on":""}"></span>
      <span class="ttl"><strong>${esc(u.user)}</strong><small>${u.sessions} aktibong session</small></span>${expChip(u.exp)}</div>
      <div class="row"><button class="btn sm" data-renew="${esc(u.user)}">Dagdag na araw</button><button class="btn sm dng" data-del="${esc(u.user)}">Burahin</button></div></div>`).join("")
      :`<div class="empty">Wala pang SSH account.</div>`;
  }catch(e){$("#s-list").innerHTML=`<div class="empty">${esc(e.message)}</div>`}
}
const rnd=n=>{const c="abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789";const a=new Uint32Array(n);crypto.getRandomValues(a);return [...a].map(x=>c[x%c.length]).join("")};
$("#s-gen").onclick=()=>$("#s-pass").value=rnd(10);
$("#s-create").onclick=async()=>{
  const user=$("#s-user").value.trim().toLowerCase(),pass=$("#s-pass").value||rnd(10),d=+$("#s-days").value,t=picked($("#s-targets"));
  if(!user||!t.length)return msg("Ilagay ang username at pumili ng VPS.","bad");
  $("#s-pass").value=pass;$("#s-create").disabled=true;
  const res=await multi(t,v=>api(v,"/api/ssh",{user,password:pass,days:d}));
  let html="";
  for(const x of res){
    if(x.err){html+=`<div class="warn"><b>${esc(x.v.name)}</b>: ${esc(x.err)}</div>`;continue}
    let s={};try{s=await info(x.v)}catch(e){}
    const txt=`BABAYAGA VPN · SSH\nServer: ${s.domain||x.v.url}\nPorts: ${(s.ssh_ports||[]).join(", ")}\nUsername: ${user}\nPassword: ${pass}\nExpires: ${x.r.exp}`;
    html+=`<div class="res">${esc(txt)}</div><div class="row"><button class="btn sm" data-copy="${esc(txt)}">Kopyahin</button></div>`;
  }
  $("#s-result").innerHTML=html;$("#s-create").disabled=false;loadSsh();
};
$("#s-list").addEventListener("click",async e=>{
  const b=e.target.closest("button");if(!b)return;const v=cur();
  try{
    if(b.dataset.renew){const d=prompt("Ilang araw ang idadagdag?","30");if(!d)return;const r=await api(v,"/api/ssh/renew",{user:b.dataset.renew,days:+d});msg("Bagong expiry: "+r.exp,"ok");loadSsh()}
    if(b.dataset.del&&confirm("Burahin ang account na "+b.dataset.del+"?")){await api(v,"/api/ssh/delete",{user:b.dataset.del});msg("Nabura na.","ok");loadSsh()}
  }catch(er){msg(er.message,"bad")}
});

/* Xray */
function makeLinks(dom,u,e){
  const n=encodeURIComponent(u+"-"+e.proto),p=PATHS[e.proto];if(!p)return null;
  const [k,net]=e.proto.split("-"),ep=encodeURIComponent(p);
  const x=net==="xhttp"?"&mode=auto":"";
  if(k==="vless")return `vless://${e.secret}@${dom}:443?encryption=none&security=tls&sni=${dom}&type=${net}&host=${dom}&path=${ep}${x}#${n}`;
  if(k==="trojan")return `trojan://${e.secret}@${dom}:443?security=tls&sni=${dom}&type=${net}&host=${dom}&path=${ep}${x}#${n}`;
  return "vmess://"+btoa(JSON.stringify({v:"2",ps:u+"-"+e.proto,add:dom,port:"443",id:e.secret,aid:"0",scy:"auto",net:net,type:"none",host:dom,path:p,tls:"tls",sni:dom}));
}
function xrCard(dom,u){
  const links=u.entries.map(e=>{const l=makeLinks(dom,u.user,e);const label=(PROTOS.find(p=>p[0]===e.proto)||[0,e.proto])[1];
    return l?`<div class="link"><span>${esc(label)}</span><button class="btn sm" data-copy="${esc(l)}">Kopyahin</button></div>`
            :`<div class="link"><span>${esc(label)} · UUID: ${esc(e.secret)}</span><button class="btn sm" data-copy="${esc(e.secret)}">Kopyahin</button></div>`}).join("");
  return `<div class="card"><div class="top"><span class="dot on"></span><span class="ttl"><strong>${esc(u.user)}</strong><small>${u.entries.length} protocol</small></span>${expChip(u.exp)}</div>
    <details style="margin-top:8px"><summary class="hint" style="cursor:pointer">Mga link</summary>${links}</details>
    <div class="row"><button class="btn sm" data-renew="${esc(u.user)}">Dagdag na araw</button><button class="btn sm dng" data-del="${esc(u.user)}">Burahin</button></div></div>`;
}
async function loadXr(){
  renderTargets($("#x-targets"));
  if(!$("#x-protos").children.length)$("#x-protos").innerHTML=PROTOS.map(p=>`<label><input type="checkbox" value="${p[0]}" ${p[0]==="vless-slip"?"":"checked"}> ${p[1]}</label>`).join("");
  const v=cur();$("#x-list").innerHTML=`<div class="empty">Kinukuha…</div>`;
  try{
    const [r,s]=await Promise.all([api(v,"/api/xray"),info(v)]);
    $("#x-list").innerHTML=r.users.length?r.users.map(u=>xrCard(s.domain||"DOMAIN",u)).join(""):`<div class="empty">Wala pang Xray account.</div>`;
  }catch(e){$("#x-list").innerHTML=`<div class="empty">${esc(e.message)}</div>`}
}
$("#x-create").onclick=async()=>{
  const user=$("#x-user").value.trim().toLowerCase(),d=+$("#x-days").value,t=picked($("#x-targets")),protos=[...$("#x-protos").querySelectorAll("input:checked")].map(i=>i.value);
  if(!user||!t.length||!protos.length)return msg("Ilagay ang username, protocol at VPS.","bad");
  $("#x-create").disabled=true;
  const res=await multi(t,v=>api(v,"/api/xray",{user,days:d,protos}));
  let html="";
  for(const x of res){
    if(x.err){html+=`<div class="warn"><b>${esc(x.v.name)}</b>: ${esc(x.err)}</div>`;continue}
    let s={};try{s=await info(x.v)}catch(e){}
    const dom=s.domain||"DOMAIN";
    const ls=x.r.protos.map(p=>makeLinks(dom,user,{proto:p,secret:x.r.secret})||("Slipstream UUID: "+x.r.secret));
    const txt=`BABAYAGA VPN · Xray (${x.v.name})\nUser: ${user}\nExpires: ${x.r.exp}\n\n`+ls.join("\n\n");
    html+=`<div class="res">${esc(txt)}</div><div class="row"><button class="btn sm" data-copy="${esc(txt)}">Kopyahin lahat</button></div>`;
  }
  $("#x-result").innerHTML=html;$("#x-create").disabled=false;loadXr();
};
$("#x-list").addEventListener("click",async e=>{
  const b=e.target.closest("button");if(!b||b.dataset.copy)return;const v=cur();
  try{
    if(b.dataset.renew){const d=prompt("Ilang araw ang idadagdag?","30");if(!d)return;const r=await api(v,"/api/xray/renew",{user:b.dataset.renew,days:+d});msg("Bagong expiry: "+r.exp,"ok");loadXr()}
    if(b.dataset.del&&confirm("Burahin ang "+b.dataset.del+" sa lahat ng Xray protocol? Magre-restart ang Xray sandali.")){await api(v,"/api/xray/delete",{user:b.dataset.del});msg("Nabura na.","ok");loadXr()}
  }catch(er){msg(er.message,"bad")}
});
document.addEventListener("click",e=>{const b=e.target.closest("[data-copy]");if(b)copy(b.dataset.copy)});

async function start(){
  if(!F.master&&location.port)F.master=location.origin;   /* served by the agent itself */
  $("#l-url").value=F.master||"";
  if(!F.token||!F.master){document.body.classList.add("noauth");return}
  document.body.classList.remove("noauth");
  try{await loadFleet();$("#l-err").style.display="none"}
  catch(e){
    document.body.classList.add("noauth");
    const old=/not found|HTTP 404/i.test(e.message);
    $("#l-err").textContent=old?"Luma pa ang agent ng master na ito (walang multi-VPS). I-run ulit ang install.sh sa master VPS, tapos subukan ulit.":e.message;
    $("#l-err").style.display="block";return}
  renderVps();
}
$("#l-go").onclick=()=>{
  const u=$("#l-url").value.trim().replace(/\/+$/,""),t=$("#l-token").value.trim();
  if(!/^https:\/\/[^\s\/]+$/.test(u)||!t)return msg("Ilagay ang https:// URL at token.","bad");
  F.master=u;F.token=t;save();$("#l-token").value="";start();
};
start();
})();
</script>
</body>
</html>
