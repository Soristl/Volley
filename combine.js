const fs = require("fs")
const watch = require("watch")

// Recursively get all files, sorted alphabetically for deterministic output
function getAllFiles(dir) {
	const entries = fs.readdirSync(dir, { withFileTypes: true })
	// Sort ensures consistent order across all OS/filesystems
	entries.sort((a, b) => a.name.localeCompare(b.name))

	let files = []
	for (let entry of entries) {
		const fullPath = `${dir}/${entry.name}`
		if (entry.isDirectory()) {
			files = files.concat(getAllFiles(fullPath))
		} else if (entry.isFile()) {
			files.push(fullPath)
		}
	}
	return files
}

var self = (module.exports = function (input, outputPath, options) {
	var inputAllFiles = []
	if (typeof options === "undefined") {
		options = {}
	}
	options.delimeterBefore = options.delimeterBefore || ""
	options.delimeterAfter = options.delimeterAfter || ""
	options.watchDir = options.watchDir || "src"

	if (process.argv[2] === "watch" && typeof currentlyWatching === "undefined") {
		console.log("\x1b[32m%s\x1b[0m", "Watching for changes...")
		currentlyWatching = true
		return watch.watchTree(options.watchDir, function () {
			self(input, outputPath, options)
		})
	}

	console.log("\x1b[32m%s\x1b[0m", "Combining files...")

	fs.writeFileSync(outputPath, "")
	const outputFile = fs.createWriteStream(outputPath, { flags: "a" })

	input.forEach(function (inputPath) {
		if (fs.lstatSync(inputPath).isDirectory()) {
			inputAllFiles = inputAllFiles.concat(getAllFiles(inputPath))
		} else if (fs.lstatSync(inputPath).isFile()) {
			inputAllFiles.push(inputPath)
		}
	})

	inputAllFiles.forEach(function (inputPath, index) {
		if (
			options.delimeterBefore.length > 0 ||
			options.delimeterAfter.length > 0
		) {
			outputFile.write(
				(index === 0 ? "" : "\n\n") +
					options.delimeterBefore +
					inputPath +
					options.delimeterAfter +
					"\n\n"
			)
		}

		const fileContents = fs.readFileSync(inputPath, "utf8")
		outputFile.write(fileContents + "\n")
		console.log("\tAdded " + inputPath)
	})

	outputFile.end()
	console.log("\x1b[32m%s\x1b[0m", "Finished combining!")
})
