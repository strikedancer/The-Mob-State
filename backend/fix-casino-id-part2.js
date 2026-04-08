const fs = require('fs');
const path = require('path');

const filePath = path.join(__dirname, 'src', 'services', 'casinoService.ts');
let content = fs.readFileSync(filePath, 'utf8');

// Replace casino.countryId with casinoId in where clauses
content = content.replace(/where: \{ casinoId: casino\.countryId \}/g, 'where: { casinoId: casinoId }');

fs.writeFileSync(filePath, content, 'utf8');
console.log('✅ Fixed all casino.countryId → casinoId in casinoService.ts');
