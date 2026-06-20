const fs = require('fs');
const path = require('path');

const filePath = path.join(__dirname, 'debug_volley.lua');

if (!fs.existsSync(filePath)) {
    console.error(`Error: File '${filePath}' not found!`);
    process.exit(1);
}

let content = fs.readFileSync(filePath, 'utf8');

// This regex finds inline markers and separates them onto their own lines 
// so the extraction script can read them correctly.
content = content.replace(/(.*)--\[\[\s*(src\/.+?\.lua)\s*\]\]\s*--(.*)/g, '$1\n--[[ $2 ]]--\n$3');

const lines = content.split('\n');
const markers = [];

for (let i = 0; i < lines.length; i++) {
    // Now we safely look for markers that are on their own line (with optional whitespace)
    const match = lines[i].match(/^\s*--\[\[\s*(src\/.+?\.lua)\s*\]\]--\s*$/);
    if (match) {
        markers.push({ line: i, path: match[1] });
    }
}

console.log(`Found ${markers.length} markers`);

for (let i = 0; i < markers.length; i++) {
    const current = markers[i];
    const next = markers[i + 1];

    const startLine = current.line + 1;
    const endLine = next ? next.line : lines.length;

    const sectionLines = lines.slice(startLine, endLine);

    // Remove trailing empty lines
    while (sectionLines.length > 0 && sectionLines[sectionLines.length - 1].trim() === '') {
        sectionLines.pop();
    }
    
    // Remove leading empty lines (caused by the split)
    while (sectionLines.length > 0 && sectionLines[0].trim() === '') {
        sectionLines.shift();
    }

    const sectionContent = sectionLines.join('\n');
    const outputPath = path.join(__dirname, current.path);
    const outputDir = path.dirname(outputPath);
    
    fs.mkdirSync(outputDir, { recursive: true });
    fs.writeFileSync(outputPath, sectionContent + '\n', 'utf8');
    
    console.log(`Wrote ${current.path} (${sectionLines.length} lines)`);
}

console.log(`Done! Extracted ${markers.length} files.`);