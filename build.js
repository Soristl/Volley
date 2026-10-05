const path = require("path")
const combine = require("./combine")
const luamin = require("luamin")

const inputs = [
	"src/printf.lua", "src/translations.lua", "src/gameState.lua", "src/timer.lua", "src/configuration",
	"src/main.lua", "src/globals", "src/events", "src/functions", "src/ui", "src/init.lua"
]

function build(minify = false) {
	return combine(inputs, "volley.lua", {
		delimeterBefore: "--[[ ", delimeterAfter: " ]]--",
		filter: file => path.extname(file) === ".lua",
		transform(source) {
			if (!source.trim()) throw new Error("Empty assembled source")
			// luamin parses the entire chunk before producing output, including readable builds.
			const compact = luamin.minify(source)
			if (!compact.trim()) throw new Error("Build contains no Lua statements")
			return minify ? compact : source
		}
	})
}

if (require.main === module) {
	process.chdir(__dirname)
	const mode = process.argv[2] || "build"
	if (!["build", "minify", "watch"].includes(mode)) {
		console.error(`Unknown build mode: ${mode}`)
		process.exitCode = 1
	} else {
		const run = () => {
			try {
				const source = build(mode === "minify")
				console.log(`Built volley.lua (${Buffer.byteLength(source)} bytes)`)
			} catch (error) {
				console.error(`Build failed: ${error.message}`)
				if (mode !== "watch") process.exitCode = 1
			}
		}
		if (mode === "watch") {
			let pending
			require("watch").watchTree(path.join(__dirname, "src"), () => {
				clearTimeout(pending)
				pending = setTimeout(run, 100)
			})
			console.log("Watching src; failed builds keep the previous volley.lua.")
		} else run()
	}
}
module.exports = { build }
