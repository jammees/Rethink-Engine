var urlBase = 'https://www.roblox.com/games/'
var placeholderLogo = './assets/Placeholder.png'

async function GenerateButtons(gamesList) {
    // convert the json into an array
    gamesList = Object.entries(gamesList)

    // sort the array based on the set priority
    gamesList.sort((a, b) => {
        if (a[1].Priority > b[1].Priority) {
            return -1;
        } else if (a[1].Priority < b[1].Priority) {
            return 1;
        } else {
            return 0;
        }
    });

    // loop over the now sorted array
    for (const [key, value] of gamesList) {
        // create a container to hold the logo and the title
        var cont = document.createElement('div')
        cont.style.width = '180px'
        cont.style.padding = '5px'
        cont.style.cursor = "pointer"
        cont.style.margin = '0 auto'
        cont.style.transition = 'transform 0.3s'
        
        // create base
        var button = document.createElement('img')
    
        // basic properties
        button.width = 200
        button.height = 200
        
        // apply image
        var gameLogo = './assets/pinAssets/' + key + '.png'

        try {
            const response = await fetch(gameLogo)
            if (response.ok) {
                button.src = gameLogo
            } else {
                button.src = placeholderLogo
            }
        } catch (errorMessage) {
            button.src = placeholderLogo
        }

        // create empty div as a title
        var title = document.createElement('div')
        title.style.textAlign = 'left'
        
        // apply text
        title.textContent = `${value.PlaceName}`

        var creator = document.createElement('div')
        creator.style.textAlign = 'left'
        creator.style.color = 'gray'
        creator.textContent = `${value.Creator}`
    
        // append objects to our container
        cont.appendChild(button)
        cont.appendChild(title)
        cont.appendChild(creator)
    
        // add click listener for the image
        cont.addEventListener('click', (function(index) {
            return function() {
                window.location.href = urlBase + index;
            };
        })(key));

        cont.addEventListener('mouseover', (function(container) {
            return function() {
                container.style.transform = 'scale(1.1)'
            }
        })(cont))
        
        cont.addEventListener('mouseout', (function(container) {
            return function() {
                container.style.transform = 'scale(1)'
            }
        })(cont))
    
        // append the completed button to the 'listofgames' element
        document.getElementById('listofgames').appendChild(cont)
    }
}

fetch('gamesList.json')
    .then(response => response.json())
    .then(json => {
        GenerateButtons(json)
    })