import fs from 'node:fs';
import path from 'node:path';
function files(root) { return fs.readdirSync(root,{withFileTypes:true}).flatMap(e=>e.isDirectory()?files(path.join(root,e.name)):[path.join(root,e.name)]); }
const failures=[];
for(const file of files('lib').filter(p=>p.endsWith('.dart')&&!/\.(g|freezed)\.dart$/.test(p))) {
 const source=fs.readFileSync(file,'utf8');
 const imports=[...source.matchAll(/(?:import|export)\s+['"]([^'"]+)['"]/g)].map(m=>m[1]);
 if(file.includes(`${path.sep}domain${path.sep}`)) {
  for(const dependency of imports) if(/package:(flutter|supabase|http)\b|\/data\/|\/presentation\/|dart:(ffi|ui)/.test(dependency)) failures.push(`${file}: domain depends on ${dependency}`);
 }
 if(file.includes(`${path.sep}presentation${path.sep}`)) {
  for(const dependency of imports) if(/supabase_flutter|\/data\/|package:http\//.test(dependency)) failures.push(`${file}: presentation depends on ${dependency}`);
 }
 if(/^(<<<<<<< |=======|>>>>>>> )/m.test(source)) failures.push(`${file}: merge conflict`);
}
if(failures.length) { console.error(failures.join('\n'));process.exitCode=1; }
else console.log('Architecture: domain independent, no infrastructure imports in presentation, no conflict markers.');
