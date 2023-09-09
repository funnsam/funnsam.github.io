window.addEventListener('DOMContentLoaded', () => {
	onresize = (_) => reload_matrix();
	reload_matrix();

	setInterval(tick_matrix, 100);
});

let w = 0;
let h = 0;

let layer = 0;

function reload_matrix() {
	const _container = document.getElementById("matrix_container");
	if (_container) { _container.remove(); }

	w = window.innerWidth;
	h = window.innerHeight;
	layer = 0;

	const container = document.createElement("div");
	container.setAttribute("id", "matrix_container");
	document.body.appendChild(container);

	for (let i = 0; i < h / 24; i++) {
		const text = document.createElement("div");
		text.setAttribute("class", "matrix_text")
		text.appendChild(document.createTextNode(random_str(Math.ceil(w / 12 / 0.5859))));
		text.style.top = `${i*24}px`;
		text.style.opacity = "0";
		container.appendChild(text);
	}
}

function tick_matrix() {
	const container = document.getElementById("matrix_container");
	let child = container.children;
	for (let i = child.length-1; i >= 0; i--) {
		if (i != layer) {
			child[i].style.opacity /= h / (h+4000) + 1;
		} else {
			child[i].style.opacity = "1";
		}

		if (i != 0) {
			child[i].innerText = child[i-1].innerText;
		} else {
			child[i].innerText = random_str(Math.ceil(w / 12 / 0.5859));
		}
	}
	layer = (layer+1) % child.length;
}

// https://stackoverflow.com/a/1349426/16731575
function random_str(length) {
    let result = '';
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    const charactersLength = characters.length;
    let counter = 0;
    while (counter < length) {
      result += characters.charAt(Math.floor(Math.random() * charactersLength));
      counter += 1;
    }
    return result;
}
