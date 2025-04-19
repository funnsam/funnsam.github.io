const p = (p, c) => document.documentElement.style.setProperty("--" + p, c);

function to_light() {
    p("rosewater", "#dc8a78");
    p("flamingo", "#dd7878");
    p("pink", "#ea76cb");
    p("mauve", "#8839ef");
    p("red", "#d20f39");
    p("maroon", "#e64553");
    p("peach", "#fe640b");
    p("yellow", "#df8e1d");
    p("green", "#40a02b");
    p("teal", "#179299");
    p("sky", "#04a5e5");
    p("sapphire", "#209fb5");
    p("blue", "#1e66f5");
    p("lavender", "#7287fd");
    p("text", "#4c4f69");
    p("subt1", "#5c5f77");
    p("subt0", "#6c6f85");
    p("selbg", "#7c7f932f");
    p("over2", "#7c7f93");
    p("over1", "#8c8fa1");
    p("over0", "#9ca0b0");
    p("surf2", "#acb0be");
    p("surf1", "#bcc0cc");
    p("surf0", "#ccd0da");
    p("base", "#eff1f5");
    p("mantle", "#e6e9ef");
    p("crust", "#dce0e8");
}

function to_dark() {
    p("rosewater", "#f5e0dc");
    p("flamingo", "#f2cdcd");
    p("pink", "#f5c2e7");
    p("mauve", "#cba6f7");
    p("red", "#f38ba8");
    p("maroon", "#eba0ac");
    p("peach", "#fab387");
    p("yellow", "#f9e2af");
    p("green", "#a6e3a1");
    p("teal", "#94e2d5");
    p("sky", "#89dceb");
    p("sapphire", "#74c7ec");
    p("blue", "#89b4fa");
    p("lavender", "#b4befe");
    p("text", "#cdd6f4");
    p("subt1", "#bac2de");
    p("subt0", "#a6adc8");
    p("selbg", "#9399b22f");
    p("over2", "#9399b2");
    p("over1", "#7f849c");
    p("over0", "#6c7086");
    p("surf2", "#585b70");
    p("surf1", "#45475a");
    p("surf0", "#313244");
    p("base", "#1e1e2e");
    p("mantle", "#181825");
    p("crust", "#11111b");
}

let theme = localStorage.getItem("theme")
    ?? ((window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches)
        ? "dark" : "light");

if (theme == "dark") to_dark();
    else to_light();
