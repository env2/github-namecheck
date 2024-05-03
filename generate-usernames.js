const fs = require('fs');

// Generate character sets
const letters = 'abcdefghijklmnopqrstuvwxyz';  // All lowercase letters
const alphanum = 'abcdefghijklmnopqrstuvwxyz0123456789';  // All possible lowercase alphanumeric characters

// Function to generate all combinations
function generateNames() {
    let names2 = [];
    let names3 = [];
    let names4 = [];

    for (let i = 0; i < letters.length; i++) {
        for (let j = 0; j < alphanum.length; j++) {
            // Generate 2-character names
            names2.push(letters[i] + alphanum[j]);

            for (let k = 0; k < alphanum.length; k++) {
                // Generate 3-character names
                names3.push(letters[i] + alphanum[j] + alphanum[k]);

                if (j < letters.length && k < letters.length) {  // Ensure all characters are alphabetic for 4-char names
                    for (let m = 0; m < letters.length; m++) {
                        // Generate 4-character names (all letters)
                        names4.push(letters[i] + letters[j] + letters[k] + letters[m]);
                    }
                }
            }
        }
    }
    return { names2, names3, names4 };
}

// Generate all combinations and store them in arrays
const { names2, names3, names4 } = generateNames();

// Write the 2-character names to a file
fs.writeFile('2chars.txt', names2.join('\n'), err => {
    if (err) console.error('Error writing to 2chars.txt:', err);
    else console.log(`Generated ${names2.length} two-character screen names.`);
});

// Write the 3-character names to a file
fs.writeFile('3chars.txt', names3.join('\n'), err => {
    if (err) console.error('Error writing to 3chars.txt:', err);
    else console.log(`Generated ${names3.length} three-character screen names.`);
});

// Write the 4-character names to a file
fs.writeFile('4chars.txt', names4.join('\n'), err => {
    if (err) console.error('Error writing to 4chars.txt:', err);
    else console.log(`Generated ${names4.length} four-character screen names.`);
});

