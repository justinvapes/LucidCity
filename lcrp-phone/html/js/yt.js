
$(document).on('click', '.out-yt', function(e){
    e.preventDefault();
    player.stopVideo();
    $("."+currentApplication+"-app").css("display","none");
    CanOpenApp = true;
    currentApplication = null;
    $(".phone-application-container").hide();
    $(".ph-frame").css({'transform' : 'rotate(-0deg)'});
    $(".ph-frame").css({'top' : '0%'});
    $(".ph-frame").css({'left' : '-40vh'});
    HeaderTextColor("white", 300);
});

$(document).on('click', '.plus-yt', function(e){
    e.preventDefault();
    volume = player.getVolume() + 10;
    if(volume  >= 100) {
        volume = 100
    }
    player.setVolume(volume);
});

$(document).on('click', '.minus-yt', function(e){
    e.preventDefault();
    volume = player.getVolume() - 10;
    if(volume  <= 0) {
        volume = 0
    }
    player.setVolume(volume);
});