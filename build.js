const path = require("path")
const combine = require("./combine")
const luamin = require("luamin")

// Files inside directory inputs retain combine's recursive ordering.
const phases = [
	{ name: "prelude", inputs: ["src/printf.lua", "src/translations.lua"] },
	{ name: "services and scheduler", inputs: ["src/services.lua", "src/gameState.lua", "src/timer.lua"] },
	{ name: "configuration", inputs: ["src/configuration"] },
	// main also performs the existing host setup and player initialization here.
	{ name: "session state and host setup", inputs: ["src/main.lua"] },
	// globals includes existing initialization effects as well as shared definitions.
	{ name: "shared definitions and initialization", inputs: ["src/globals"] },
	{ name: "host callbacks", inputs: ["src/events"] },
	{ name: "gameplay services", inputs: ["src/functions"] },
	{ name: "presentation", inputs: ["src/ui"] },
	{ name: "initial lobby", inputs: ["src/init.lua"] }
]
const inputs = phases.flatMap(phase => phase.inputs)

function validateFiles(files) {
	const positions = new Map()
	const counts = phases.map(() => 0)
	let previousPhase = -1
	for (const [index, file] of files.entries()) {
		const relative = path.relative(__dirname, path.resolve(file)).replace(/\\/g, "/")
		const identity = process.platform === "win32" ? relative.toLowerCase() : relative
		if (positions.has(identity)) throw new Error(`Duplicate source file: ${relative}`)
		positions.set(identity, index)
		const phaseIndex = phases.findIndex(phase => phase.inputs.some(input =>
			relative === input || (!input.endsWith(".lua") && relative.startsWith(input + "/"))))
		if (phaseIndex < 0) throw new Error(`Source outside declared build phases: ${relative}`)
		if (phaseIndex < previousPhase) throw new Error(`Source out of phase order: ${relative}`)
		previousPhase = phaseIndex
		counts[phaseIndex]++
	}
	let previousPivot = -1
	for (const pivot of inputs.filter(input => input.endsWith(".lua"))) {
		const index = positions.get(process.platform === "win32" ? pivot.toLowerCase() : pivot)
		if (index === undefined) throw new Error(`Missing build pivot: ${pivot}`)
		if (index <= previousPivot) throw new Error(`Build pivot out of order: ${pivot}`)
		previousPivot = index
	}
	for (const [index, count] of counts.entries()) {
		if (!count) throw new Error(`Empty build phase: ${phases[index].name}`)
	}
	if (positions.get("src/init.lua") !== files.length - 1) throw new Error("src/init.lua must be the last source")
}

function build(minify = false) {
	return combine(inputs, "volley.lua", {
		delimeterBefore: "--[[ ", delimeterAfter: " ]]--",
		filter: file => path.extname(file) === ".lua",
		validateFiles,
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
