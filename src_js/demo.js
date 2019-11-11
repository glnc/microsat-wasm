const microsat = require("../release/Wrapper.js");

microsat.setModule(require("../release/microsat.js"));
microsat.setWASM("./microsat.wasm");

document.getElementById("run").addEventListener("click", () => {
	document.getElementById("run").disabled = true;

	let input = document.getElementById("input").value;

	let args = document.getElementById("arguments").value.split(" ");
	if (args.length === 1 && args[0] === "") {
		args = [];
	}

	microsat.run(input, args).then(result => {
		document.getElementById("output").value = result;
	}).catch(reason => {
		document.getElementById("output").value = `Execution failed:\n\n${reason}`;
	}).finally(() => {
		document.getElementById("run").disabled = false;
	});
});
