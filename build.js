const fs = require("fs");
const combine = require("./combine");
const luamin = require("luamin");

combine(
  [
    "src/printf.lua",
    "src/translations.lua",
    "src/timer.lua",
    "src/globals",
    "src/configuration",
    "src/main.lua",
    "src/events",
    "src/functions",
    "src/ui",
    "src/init.lua"
  ],
  "volley.lua",
  {
    delimeterBefore: "--[[ ",
    delimeterAfter: " ]]--"
  }
);

if (process.argv[2] === "minify") {
  console.log("\x1b[32m%s\x1b[0m", "Minifying script...\n");
  
  fs.readFile("volley.lua", "utf8", function (err, data) {
    if (err) {
      console.log("\x1b[31m%s\x1b[0m", err);
      process.exit(1);
    }
    const minified = luamin.minify(data);
    fs.writeFileSync("volley.lua", minified);
    console.log("\x1b[32m%s\x1b[0m", "Finished minifying!\n");
  });
}