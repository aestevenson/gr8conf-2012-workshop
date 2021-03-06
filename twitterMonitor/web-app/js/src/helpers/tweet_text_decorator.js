TM.Helpers.Resources = {
    // each textItem is of the form:
    // [pattern, text to insert before, text to insert after]
    textItems: [
        [/@\w+/gi, "<span class='mention'>", "</span>"],
        [/#\w+/gi, "<span class='hashtag'>", "</span>"]
    ]
}

// Looks for various patterns in a tweet, then wraps the pattern with strings denoted in Resources.textItems
TM.Helpers.tweetTextDecorator = function (text) {
    var items = TM.Helpers.Resources.textItems,
        itemPos = items.length,
        pattern,
        i,
        max,
        results;

    while (itemPos--) {
        results = text.match(items[itemPos][0]);
        if (results) {
            max = results.length;
            for (i = 0; i < max; i++) {
                pattern = new RegExp(results[i], "gi");
                text = text.replace(pattern, items[itemPos][1] +results[i] +items[itemPos][2])
            }
        }
    }

    return text;
};

//Refer to the Instructions at the root of the repo to rebuild me!