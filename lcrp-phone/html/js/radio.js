$(document).on('click', '.radio-home', function(e){
    e.preventDefault();
    $("."+currentApplication+"-app").css("display","none");
    CanOpenApp = true;
    currentApplication = null;
    $(".phone-application-container").hide();
    HeaderTextColor("white", 300);
});

var playingRadio = 0;
var poscastPlaying = 0;

$(document).on('click', '.radio-play', function(e){
    e.preventDefault();
    if(playingRadio == 0) {
        $("#radio-pstop").removeClass('fas fa-start');
        $("#radio-pstop").addClass('fas fa-stop');
        //radioplayer.unMute()
        //radioplayer.playVideo();
        playingRadio = 1;
        $.post('http://lcrp-phone/toggleRadio', JSON.stringify({player: playingRadio}))
    } else {
        $("#radio-pstop").removeClass('fas fa-stop');
        $("#radio-pstop").addClass('fas fa-start');
        //radioplayer.stopVideo();
        playingRadio = 0;
        $.post('http://lcrp-phone/toggleRadio', JSON.stringify({player: playingRadio}))
    }
});

$(document).on('click', '.radio-plus', function(e){
    e.preventDefault();
    /*volume = radioplayer.getVolume() + 10;
    if(volume  >= 100) {
        volume = 100
    }*/
    //radioplayer.setVolume(volume);
    $.post('http://lcrp-phone/volume', JSON.stringify({volume: "plus"}))
});

$(document).on('click', '.radio-minus', function(e){
    e.preventDefault();
    /*volume = radioplayer.getVolume() - 10;
    if(volume  <= 0) {
        volume = 0
    }
    //radioplayer.setVolume(volume);*/
    $.post('http://lcrp-phone/volume', JSON.stringify({volume: "minus"}))
});

$(document).on('click', '.enter-radio', function(e){
    $(".enter-radio").css('background-color','#7822db');
    $(".enter-podcast").css('background-color','#9a60dd');
    
    $(".radio-buttons").show();
    //$(".radio-buttons").css("display", "block");
    $(".podcast-buttons").hide();
    //$(".podcast-buttons").css("display", "none");

    $(".radio-logo").show();
    $(".podcast-logo").hide();

    $(".unv-radio").show();
    $(".unv-podcast").hide();

    //$("#radio-id").removeClass('radio-app background-app2');
    //$("#radio-id").addClass('radio-app background-app2');
    //$(".radio-app").css('background','#c3aae0');
    //$(".radio-app").css('background','-webkit-linear-gradient(to right, #8100fd , #c3aae0)');
    //$(".radio-app").css('background','linear-gradient(to right, #8100fd , #c3aae0)');
});

$(document).on('click', '.enter-podcast', function(e){
    $(".enter-podcast").css('background-color','#7822db');
    $(".enter-radio").css('background-color','#9a60dd');

    $(".podcast-buttons").show();
    //$(".podcast-buttons").css("display", "block");
    $(".radio-buttons").hide();
    //$(".radio-buttons").css("display", "none");

    $(".podcast-logo").show();
    $(".radio-logo").hide();

    $(".unv-podcast").show();
    $(".unv-radio").hide();

    //$("#radio-id").removeClass('radio-app background-app2');
    //$("#radio-id").addClass('radio-app background-app2');
    //$(".radio-app").css('background','#c3aae0');
    //$(".radio-app").css('background','-webkit-linear-gradient(to right, #8100fd , #c3aae0)');
    //$(".radio-app").css('background','linear-gradient(to right, #8100fd , #c3aae0)');
});

$(document).on('click', '.podcast-home', function(e){
    e.preventDefault();
    $("."+currentApplication+"-app").css("display","none");
    CanOpenApp = true;
    currentApplication = null;
    $(".phone-application-container").hide();
    HeaderTextColor("white", 300);
});

$(document).on('click', '.podcast-play', function(e){
    e.preventDefault();
    if(poscastPlaying == 0) {
        $("#podcast-pstop").removeClass('fas fa-start');
        $("#podcast-pstop").addClass('fas fa-stop');
        poscastPlaying = 1;
    } else {
        $("#podcast-pstop").removeClass('fas fa-stop');
        $("#podcast-pstop").addClass('fas fa-start');

        poscastPlaying = 0;
    }
});

$(document).on('click', '.podcast-plus', function(e){
    e.preventDefault();
});

$(document).on('click', '.podcast-minus', function(e){
    e.preventDefault();
});