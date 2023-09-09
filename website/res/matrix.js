window.addEventListener('DOMContentLoaded', () => {
	onresize = (_) => reload_matrix();
	reload_matrix();

	setInterval(tick_matrix, 100);
});

let w = 0;
let h = 0;

let line_h = 0;

let text_size = {};

let dropping = [];

function reload_matrix() {
	const _container = document.getElementById("matrix_container");
	if (_container) { _container.remove(); }

	w = window.innerWidth;
	h = window.innerHeight;
	layer = 0;
	line_h = Math.ceil(h / w * 10);
	dropping = [];
	
	text_size = get_text_size("A", "normal", 12, "Cascadia Code");
	document.querySelector(':root').style.setProperty("--line-height", `${text_size.height}px`);

	const container = document.createElement("div");
	container.setAttribute("id", "matrix_container");
	document.body.appendChild(container);

	for (let i = 0; i < w / text_size.width; i++) {
		const text = document.createElement("pre");
		text.setAttribute("class", "matrix_text")
		text.appendChild(document.createTextNode(random_str(line_h)));
		text.style.left = `${i * text_size.width}px`;
		text.style.opacity = "1";

		const height = Math.floor(Math.random() * (h / text_size.height));
		text.style.top = `${(height-line_h) * text_size.height}px`;
		dropping.push(height);

		container.appendChild(text);
	}
}

function tick_matrix() {
	const container = document.getElementById("matrix_container");
	let child = container.children;
	for (let i = child.length-1; i >= 0; i--) {
		const height = (dropping[i] + 1) % (Math.ceil(h / text_size.height) + line_h);
		child[i].style.top = `${(height - line_h) * text_size.height}px`;
		if (height == 0) {
			child[i].innerText = random_str(line_h);
		}
		dropping[i] = height;
	}
}

// https://stackoverflow.com/a/1349426/16731575
function random_str(length) {
    let result = '';
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    const charactersLength = characters.length;
    let counter = 0;
	while (counter < length) {
		result += characters.charAt(Math.floor(Math.random() * charactersLength)) + "\n";
		counter += 1;
    }
    return result;
}

// https://stackoverflow.com/a/21015393/16731575
function get_text_size(text, weight, size, ff) {
	const font = `${weight} ${size}pt ${ff}`;

	const canvas = get_text_size.canvas || (get_text_size.canvas = document.createElement("canvas"));
	const context = canvas.getContext("2d");
	context.font = font;
	const metrics = context.measureText(text);
	return {
		width : metrics.width,
		height: metrics.actualBoundingBoxAscent + metrics.actualBoundingBoxDescent,
	};
}
