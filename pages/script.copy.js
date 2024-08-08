const nav = document.getElementById("navinner");

document.getElementById("hamburger").onclick = () => {
    nav.style.display = nav.style.display === "flex" ? "none" : "flex";
};

screen.orientation.onchange = () => {
    nav.style.display = "";
};
