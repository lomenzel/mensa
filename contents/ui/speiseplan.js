/**
 * Funktion, die den Speiseplan der Mensa Lübeck abruft
 * @param {Function} setSpeiseplan Die Funktion, an die der Speiseplan übergeben wird
 */
function fetchSpeiseplan(setSpeiseplan) {
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function () {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                const responseText = xhr.responseText;
                const result = JSON.parse(responseText);
                //print(responseText)
                setSpeiseplan(applyFilters(result));
            } else {
                console.error("Fehler beim Abrufen des Speiseplans. Statuscode: " + xhr.status);
            }
        }
    };

    xhr.open("GET", "https://speiseplan.mcloud.digital/meals");
    xhr.send();
}  

function applyFilters(raw){
    print(JSON.stringify(plasmoid.configuration))


    let filtered =  raw.map(day => {
        day.meals = day.meals.filter(meal=>{
            if(plasmoid.configuration.vegetarisch){
                if(!meal.vegetarian) {
                    return false
                }
            }
            if(plasmoid.configuration.vegan && !meal.vegan)
                return false
            if(!plasmoid.configuration.mensa && meal.location == "Mensa")
                return false
            if(!plasmoid.configuration.cafeteria && meal.location == "Cafeteria")
                return false
            if(!plasmoid.configuration.zeigeAllergene)
                if(plasmoid.configuration.allergene.filter( e => meal.allergens.map(f => f.code).includes(e) ).length > 0)
                    return false
            return true;
        })
        return day
    })

    return filtered.map(day => {
        day.meals = day.meals.map(meal => {
            meal.allergens = meal.allergens.filter(e =>
            plasmoid.configuration.allergene.includes(e.code));
            return meal});
        return day})
}
