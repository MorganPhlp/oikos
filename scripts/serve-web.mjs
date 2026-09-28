import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';
import mime from 'mime-types';

const root=path.resolve('build/web');
http.createServer((req,res)=>{
  try {
    const pathname=decodeURIComponent(new URL(req.url,'http://localhost').pathname);
    const requested=path.resolve(root,`.${pathname}`);
    if(requested!==root&&!requested.startsWith(root+path.sep)){res.writeHead(403);res.end();return;}
    const file=fs.existsSync(requested)&&fs.statSync(requested).isFile()?requested:path.join(root,'index.html');
    res.writeHead(200,{'Content-Type':mime.lookup(file)||'application/octet-stream','Cache-Control':'no-store'});
    fs.createReadStream(file).pipe(res);
  } catch {res.writeHead(500);res.end('Build web indisponible.');}
}).listen(3000,'127.0.0.1',()=>console.log('Oikos : http://localhost:3000 (Ctrl+C pour arrêter)'));
