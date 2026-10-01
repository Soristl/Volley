const fs = require("fs")
const path = require("path")
const crypto = require("crypto")

function filesAt(input) {
	const stat = fs.statSync(input)
	if (stat.isFile()) return [input]
	if (!stat.isDirectory()) throw new Error(`Unsupported input: ${input}`)
	return fs.readdirSync(input)
		.sort((a, b) => a.localeCompare(b, "en") || (a < b ? -1 : a > b ? 1 : 0))
		.flatMap(name => filesAt(path.join(input, name)))
}

function assemble(input, options = {}) {
	const files = input.flatMap(filesAt)
	if (!files.length) throw new Error("No source files")
	return files.map((file, index) => {
		const source = fs.readFileSync(file, "utf8")
		const before = options.delimeterBefore || ""
		const after = options.delimeterAfter || ""
		const heading = before || after
			? `${index ? "\n\n" : ""}${before}${file.replace(/\\/g, "/")}${after}\n\n`
			: ""
		return heading + source + "\n"
	}).join("")
}

// Publish only complete, validated content. A failed build leaves the old output intact.
function publish(output, source) {
	if (!source.trim()) throw new Error("Empty build output")
	const temporary = `${output}.${process.pid}.${crypto.randomBytes(6).toString("hex")}.tmp`
	try {
		fs.writeFileSync(temporary, source, { flag: "wx" })
		fs.renameSync(temporary, output)
	} finally {
		if (fs.existsSync(temporary)) fs.unlinkSync(temporary)
	}
}

module.exports = function combine(input, output, options = {}) {
	let source = assemble(input, options)
	if (options.transform) source = options.transform(source)
	if (options.validate) options.validate(source)
	publish(output, source)
	return source
}
module.exports.assemble = assemble
module.exports.publish = publish
