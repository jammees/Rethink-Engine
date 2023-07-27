// janky way of disabling the footer
// but as they say it, if it works, don't fix it
try {
    const element = document.querySelector('.md-footer')
    element.style.display = 'none'
} catch (errorMessage) {
    console.warn(errorMessage)
}