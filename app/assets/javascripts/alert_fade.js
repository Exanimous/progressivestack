function fadeOutNotification(delay) {

    window.setTimeout(function() {
        $(".alert").alert('close')
    }, delay);
}