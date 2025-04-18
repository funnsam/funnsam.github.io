const nav = document.getElementById("navinner");
const ham = document.getElementById("hamburger");
let ongoing_bounce = 0;

ham.onclick = () => {
    nav.style.setProperty("--height", `${nav.scrollHeight}px`);
    nav.classList.toggle("expand");
    let expanding = nav.classList.contains("expand");

    ham.firstElementChild.classList.toggle("fa-bars");
    ham.firstElementChild.classList.toggle("fa-xmark");

    ham.firstElementChild.classList.add("fa-bounce");

    clearTimeout(ongoing_bounce);
    ongoing_bounce = setTimeout(() => {
        ham.firstElementChild.classList.remove("fa-bounce");
    }, 1000);
};

screen.orientation.onchange = () => {
    nav.style.display = "";
};
