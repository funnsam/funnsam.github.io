const nav = document.getElementById("navinner");
const ham = document.getElementById("hamburger");

ham.onclick = () => {
    nav.style.display = nav.style.display === "flex" ? "none" : "flex";
    ham.classList.toggle("active");
};

screen.orientation.onchange = () => {
    nav.style.display = "";
};
