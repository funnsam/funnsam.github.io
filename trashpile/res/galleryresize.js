function resize() {
    let col = Math.round(document.getElementById("gallery-container").clientWidth / 400);
    document.body.style.setProperty("--js-cols", col);
}

resize();
addEventListener("resize", (_) => {resize();});