const fs = require('fs');
const path = require('path');

const filePath = path.join(__dirname, 'src', 'services', 'casinoService.ts');
let content = fs.readFileSync(filePath, 'utf8');

// Replace all occurrences of 'where: { countryId:' with 'where: { casinoId:'
content = content.replace(/where: \{ countryId:/g, 'where: { casinoId:');

fs.writeFileSync(filePath, content, 'utf8');
console.log('✅ Fixed all countryId → casinoId in casinoService.ts');
