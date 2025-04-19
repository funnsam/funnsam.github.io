const nav = document.getElementById("navinner");
const ham = document.getElementById("hamburger");
const theme_tog_mob = document.getElementById("theme_tog_mob");
const theme_tog = document.getElementById("theme_tog");
let ham_bounce = 0, theme_bounce = 0;

{
    let theme_icon = theme == "dark" ? "fa-moon" : "fa-sun";

    theme_tog_mob.firstElementChild.classList.add(theme_icon);
    theme_tog.firstElementChild.classList.add(theme_icon);
}

theme_tog_mob.onclick = theme_tog.onclick = () => {
    theme = theme == "dark" ? "light" : "dark";

    if (theme == "dark") to_dark();
        else to_light();

    localStorage.setItem("theme", theme);

    theme_tog_mob.firstElementChild.classList.toggle("fa-sun");
    theme_tog_mob.firstElementChild.classList.toggle("fa-moon");
    theme_tog.firstElementChild.classList.toggle("fa-sun");
    theme_tog.firstElementChild.classList.toggle("fa-moon");

    theme_tog_mob.firstElementChild.classList.add("fa-bounce");
    theme_tog.firstElementChild.classList.add("fa-bounce");

    clearTimeout(theme_bounce);
    theme_bounce = setTimeout(() => {
        theme_tog_mob.firstElementChild.classList.remove("fa-bounce");
        theme_tog.firstElementChild.classList.remove("fa-bounce");
    }, 1000);
};

ham.onclick = () => {
    nav.style.setProperty("--height", `${nav.scrollHeight}px`);
    nav.classList.toggle("expand");
    let expanding = nav.classList.contains("expand");

    ham.firstElementChild.classList.toggle("fa-bars");
    ham.firstElementChild.classList.toggle("fa-xmark");

    ham.firstElementChild.classList.add("fa-bounce");

    clearTimeout(ham_bounce);
    ham_bounce = setTimeout(() => {
        ham.firstElementChild.classList.remove("fa-bounce");
    }, 1000);
};

screen.orientation.onchange = () => nav.style.display = "";
