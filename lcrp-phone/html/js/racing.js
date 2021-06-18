$(document).on('click', '.racing-app .racing-find', function(e){
    $(".racing-starter").fadeOut(400)
    $(".racing-finder").fadeIn(400)
    $.post('http://lcrp-phone/findRace', JSON.stringify({
        join: true
    }));
});

$(document).on('click', '.racing-app .racing-cancel', function(e){
    $(".racing-finder").fadeOut(400)
    $(".racing-starter").fadeIn(400)
    $.post('http://lcrp-phone/findRace', JSON.stringify({
        join: false
    }));
});