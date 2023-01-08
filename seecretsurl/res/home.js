document.addEventListener('DOMContentLoaded', function() {
    main();
 }, false);

function main() {
    const queryString = window.location.search;
    const urlParams = new URLSearchParams(queryString);

    if (urlParams.has('l') == false || urlParams.get('l') == '') {
        location.replace('./new/');
        return;
    }

    let URLString = atob(urlParams.get('l'));

    try {
        _ = new URL(URLString);
    } catch (err) {
        window.alert(err);
    }
    
    window.location.replace(URLString);
}