window.addEventListener('DOMContentLoaded', () => {
	onresize = (_) => reload_matrix();
	reload_matrix();

	setInterval(tick_matrix, 100);
});

let w;
let h;
let text_size;
let dropping;
let context;
let matrix;

function reload_matrix() {
	if (matrix) { matrix.remove(); }

	w = window.innerWidth;
	h = window.innerHeight;
	dropping = [];
	
	matrix = document.createElement("canvas");
	matrix.style.position = "fixed";
	matrix.style.top  = "0";
	matrix.style.left = "0";
	matrix.style.zIndex = "-9999";
	matrix.width  = w;
	matrix.height = h;
	document.body.appendChild(matrix);

	context = matrix.getContext("2d");
	context.font = "normal 12pt Cascadia Code";
	text_size = get_text_size("0");

	for (let i = 0; i < w / text_size.width; i++) {
		dropping.push(Math.floor(Math.random() * Math.ceil(h / text_size.height)));
	}
}

function tick_matrix() {
	context.fillStyle = "#352F4480";
	context.fillRect(0, 0, w, h);

	context.fillStyle = "#5C8374";
	for (let i = 0; i < w / text_size.width; i++) {
		context.fillText(random_char(), i * text_size.width, dropping[i] * text_size.height);

		if (dropping[i]++ * text_size.height > h && Math.random() > .75) {
			dropping[i] = 0;
		}
	}
}

const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
function random_char() {
    const charactersLength = characters.length;
	return characters.charAt(Math.floor(Math.random() * characters.length));
}

// https://stackoverflow.com/a/21015393/16731575
function get_text_size(text) {
	const metrics = context.measureText(text);
	return {
		width : metrics.width,
		height: metrics.actualBoundingBoxAscent + metrics.actualBoundingBoxDescent,
	};
}
