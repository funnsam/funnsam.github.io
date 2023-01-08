document.addEventListener("DOMContentLoaded", function() {
    main();
 }, false);

function main() {
    const queryString = window.location.search;
    const urlParams = new URLSearchParams(queryString);

    if (urlParams.has("l") == false || urlParams.get("l") == "" || urlParams.has("m") == false || urlParams.get("m") == "") {
        location.replace("./new/");
        return;
    }

    if (urlParams.get("m") == "base") {
        let URLString = atob(urlParams.get("l"));

        try {
            _ = new URL(URLString);
        } catch (err) {
            window.alert(err);
        }
        
        window.location.replace(URLString);
    } else if (urlParams.get("m") == "enc") {
        var URLString = CryptoJS.AES.decrypt(urlParams.get("l"), urlParams.get("k")).toString(CryptoJS.enc.Utf8)

        try {
            _ = new URL(URLString);
        } catch (err) {
            window.alert(err);
        }
    } else {
        location.replace("./new/");
        return;
    }
}