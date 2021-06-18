$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "open") {
            Radio.SlideUp()
        }

        if (event.data.type == "close") {
            Radio.SlideDown()
        }
    });

    document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
            $.post('http://lcrp-radio/escape', JSON.stringify({}));
            Radio.SlideDown()
        } else if (data.which == 13) { // Escape key
            $.post('http://lcrp-radio/joinRadio', JSON.stringify({
                channel: $("#channel").val()
            }));
        }
    };
});

Radio = {}

$(document).on('click', '#volumeUp', function(e){
    e.preventDefault();

    $.post('http://lcrp-radio/volumeUp', JSON.stringify({
        channel: $("#channel").val()
    }));
});

$(document).on('click', '#volumeDown', function(e){
    e.preventDefault();

    $.post('http://lcrp-radio/volumeDown', JSON.stringify({
        channel: $("#channel").val()
    }));
});

$(document).on('click', '#submit', function(e){
    e.preventDefault();

    $.post('http://lcrp-radio/joinRadio', JSON.stringify({
        channel: $("#channel").val()
    }));
});

$(document).on('click', '#volumeUp', function(e){
    e.preventDefault();

    $.post('http://lcrp-radio/volumeUp', JSON.stringify({
        channel: $("#channel").val()
    }));
});

$(document).on('click', '#volumeDown', function(e){
    e.preventDefault();

    $.post('http://lcrp-radio/volumeDown', JSON.stringify({
        channel: $("#channel").val()
    }));
});

$(document).on('click', '#disconnect', function(e){
    e.preventDefault();

    $.post('http://lcrp-radio/leaveRadio');
});

Radio.SlideUp = function() {
    $(".container").css("display", "block");
    $(".radio-container").animate({bottom: "6vh",}, 250);
}

Radio.SlideDown = function() {
    $(".radio-container").animate({bottom: "-110vh",}, 400, function(){
        $(".container").css("display", "none");
    });
}