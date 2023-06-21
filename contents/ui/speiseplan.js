/**
 * Funktion, die den Speiseplan der Mensa Lübeck abruft
 * @param {Function} setSpeiseplan Die Funktion, an die der Speiseplan übergeben wird
 */
function fetchSpeiseplan(setSpeiseplan) {
    const xhr = new XMLHttpRequest();
    xhr.addEventListener("readystatechange", function () {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                const responseText = xhr.responseText;
                const result = JSON.parse(responseText);
                setSpeiseplan(result);
            } else {
                console.error("Fehler beim Abrufen des Speiseplans. Statuscode: " + xhr.status);
            }
        }
    });

    xhr.open("GET", "https://speiseplan.mcloud.digital/meals");
    xhr.send();
}  
