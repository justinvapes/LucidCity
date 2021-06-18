var yPlayer = null;

function callMe(vol, time){
	yPlayer.setVolume(vol);
	yPlayer.playVideo();
	yPlayer.seekTo(time);
	setTimeout(UpdatVolume, 100);
	yPlayer.setVolume(0);
}

function getYoutubeUrlId(url)
{
    var videoId = "";
    if( url.indexOf("youtube") !== -1 ){
        var urlParts = url.split("?v=");
        videoId = urlParts[1].substring(0,11);
    }

    if( url.indexOf("youtu.be") !== -1 ){
        var urlParts = url.replace("//", "").split("/");
        videoId = urlParts[1].substring(0,11);
    }
    return videoId;
}

function UpdatVolume(){
    if(yPlayer){
        yPlayer.setVolume(GetNewVolume() * 100);
    }
    setTimeout(UpdatVolume, 100);
}