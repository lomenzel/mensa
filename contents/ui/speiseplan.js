let debug = false

if (debug) {
    const fs = require("fs");
    fs.readFile("example.html", function (err, data) {
        data = data.toString()
        console.log(parseResponse(data))
    })
}

function fetchSpeiseplan(setSpeiseplan) {
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function () {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                var responseText = xhr.responseText;


                var result = parseResponse(responseText)

                print(JSON.stringify(result))
                setSpeiseplan(result)

            } else {
                console.error("Fehler beim Abrufen des Speiseplans. Statuscode: " + xhr.status);
            }
        }
    };

    xhr.open("GET", "https://studentenwerk.sh/de/mensen-in-luebeck?ort=3&mensa=8#mensaplan");
    xhr.send();
}

function parseResponse(responseText) {
    let parsedlines = []
    const lines = responseText.split("\n");
    for (let line of lines) {
        if (line.includes("data-day"))
            parsedlines.push(line)
    }
    parsedlines = parsedlines
        .map(e => e
            .replace(/<(\/[^<>]*)>/g, "<$1>\n")
            .split(/\n/)
            .filter(e => !e.includes("data-day") || e.includes("tag_headline"))
            .filter(e => !e.includes("mb_day_short"))
            .filter(e => e.trim() !== "</div>")
            .filter(e => e.trim() !== "")
            .filter(e => e.trim() !== "<div>")
            .filter(e => !e.includes("mb_week"))
            .filter(e => e.startsWith("<div"))
            .filter(e => !e.includes("Studierende"))
            .filter(e =>
                e.includes("data-day") ||
                e.includes("mensatyp") ||
                e.includes("menu_name") ||
                e.includes("alt=\"") ||
                e.includes("menu_preis")
            )
            .map(e => {
                if (e.includes("data-day")) {
                    return {
                        day: e.match(/\d{4}-\d\d-\d\d/)[0]
                    }
                } else if (e.includes("mensatyp")) {
                    return {
                        mensatyp: e.includes("Mensa") ? "Mensa" : "Cafeteria"
                    }
                } else if (e.includes("menu_name")) {
                    return {
                        name: e.replace("<div class=\"menu_name\">", "")
                            .replace("</div>", "")
                            .replace(/<[^<>]*>/g, ", ")
                            .trim().replace(/,+$/g, "")
                    }
                } else if (e.includes("alt=\"")) {
                    return {
                        veg: e.includes("vegan") ? "vegan" : e.includes("vegetarisch") ? "vegetarisch" : "fleisch"
                    }
                } else if (e.includes("menu_preis")) {
                    return {
                        preis: e.match(/\d,\d\d/)[0] + "€"
                    }
                }
                return e
            })
        ).filter(e => e.length > 0)[0]
    let result = []
    for (let e of parsedlines) {
        if (e.day) {
            result.push({
                day: e.day,
                gerichte: []
            })
        } else if (e.mensatyp) {
            result[result.length - 1].gerichte.push ({
                mensatyp: e.mensatyp
            })
        } else if (e.name) {
            result[result.length - 1].gerichte[result[result.length-1].gerichte.length -1] = {
                name: e.name
            }
        } else if(e.veg){
            result[result.length - 1].gerichte[result[result.length-1].gerichte.length -1].veg = e.veg
        } else if(e.preis){
            result[result.length - 1].gerichte[result[result.length-1].gerichte.length -1].preis = e.preis
        }
    }
    return result
}
