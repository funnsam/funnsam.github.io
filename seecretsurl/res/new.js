document.addEventListener('DOMContentLoaded', function() {
    main();
 }, false);

function main() {
    const queryString = window.location.search;
    const urlParams = new URLSearchParams(queryString);

    if (urlParams.has('url') && urlParams.get("m") == "enc") {
        var encrypted = CryptoJS.AES.encrypt(urlParams.get("url"), "Secret Passphrase");
        document.getElementById("seecrets").innerHTML = "https://seecrets.tk?m=enc&l="+encrypted+"&k=Secret";
        document.getElementById("seecrets").href = "https://seecrets.tk?m=enc&l="+encrypted+"&k=Secret";
    } else if (urlParams.has('url')) {
        document.getElementById("seecrets").innerHTML = "https://seecrets.tk?m=base&l="+btoa(urlParams.get('url'));
        document.getElementById("seecrets").href = "https://seecrets.tk?m=base&l="+btoa(urlParams.get('url'));
    }
}