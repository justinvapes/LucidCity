var djName

window.addEventListener('message', function(e) {
	if (e.data.action == "openmenu"){
		$(".dj-table-container").show()
	}
	/*
    if (e.data.dancefloor == 'galaxy') {
		if (e.data.musiccommand == 'playsong') {
			galaxy.unMute()
			galaxy.loadVideoById(e.data.songname)
			playingRadio = 1
			$("#play-btn").removeClass('fas fa-start fa-over');
			$("#play-btn").addClass('fas fa-stop fa-over');
		} else if (e.data.setvolume !== undefined) {
		  if (e.data.setvolume >= 0.0 && e.data.setvolume <= 100) {
			var vol = e.data.setvolume;
			galaxy.setVolume(vol)
			}
		}
	} else if (e.data.dancefloor == 'cockatoos') {
			if (e.data.musiccommand == 'playsong') {
				cockatoos.unMute()
				cockatoos.loadVideoById(e.data.songname)
				playingRadio = 1
				$("#play-btn").removeClass('fas fa-start fa-over');
				$("#play-btn").addClass('fas fa-stop fa-over');
			} else if (e.data.setvolume !== undefined) {
			  if (e.data.setvolume >= 0.0 && e.data.setvolume <= 100) {
				var vol = e.data.setvolume;
				cockatoos.setVolume(vol)
				}
			}
		} else if (e.data.dancefloor == 'vanilla') {
			if (e.data.musiccommand == 'playsong') {
				vanilla.unMute()
				vanilla.loadVideoById(e.data.songname)
				playingRadio = 1
				$("#play-btn").removeClass('fas fa-start fa-over');
				$("#play-btn").addClass('fas fa-stop fa-over');
			} else if (e.data.setvolume !== undefined) {
			  if (e.data.setvolume >= 0.0 && e.data.setvolume <= 100) {
				var vol = e.data.setvolume;
				vanilla.setVolume(vol)
				}
			}
		} else if (e.data.dancefloor == 'bahamas') {
			if (e.data.musiccommand == 'playsong') {
				bahamas.unMute()
				bahamas.loadVideoById(e.data.songname)
				playingRadio = 1
				$("#play-btn").removeClass('fas fa-start fa-over');
				$("#play-btn").addClass('fas fa-stop fa-over');
			} else if (e.data.setvolume !== undefined) {
			  if (e.data.setvolume >= 0.0 && e.data.setvolume <= 100) {
				var vol = e.data.setvolume;
				bahamas.setVolume(vol)
				}
			}
		} else if (e.data.dancefloor == 'casino') {
			if (e.data.musiccommand == 'playsong') {
				casino.unMute()
				casino.loadVideoById(e.data.songname)
				playingRadio = 1
				$("#play-btn").removeClass('fas fa-start fa-over');
				$("#play-btn").addClass('fas fa-stop fa-over');
			} else if (e.data.setvolume !== undefined) {
			  if (e.data.setvolume >= 0.0 && e.data.setvolume <= 100) {
				var vol = e.data.setvolume;
				casino.setVolume(vol)
				}
			}
		}*/
});
/*
var playingRadio = 0;
$(document).on('click', '#play-btn', function(e){
	console.log("hello")
	e.preventDefault();
    if(playingRadio == 0) {
        $("#play-btn").removeClass('fas fa-start');
        $("#play-btn").addClass('fas fa-stop');
		player.playVideo()
        playingRadio = 1;
    } else {
        $("#play-btn").removeClass('fas fa-stop');
        $("#play-btn").addClass('fas fa-start');
        player.pauseVideo()
        playingRadio = 0;
    }
});
*/

$( document ).keyup( function( event ) {
	if ( event.keyCode == 27 ) 
	{
		$(".dj-table-container").hide()
		$.post('http://lcrp-djay/poste', JSON.stringify({
    	}))
	}
} );



$(document).on('click', '#play-btn', function(e){
	e.preventDefault();
	$.post('http://lcrp-djay/sendMusic', JSON.stringify({
    }), function(isPlaying){
		if (isPlaying){
			$("#play-btn").removeClass('fas fa-start');
        	$("#play-btn").addClass('fas fa-stop');
		}else {
			$("#play-btn").removeClass('fas fa-stop');
			$("#play-btn").addClass('fas fa-start');
		}
	})
});

$(document).on('click', '#dj-up', function(e){
	e.preventDefault();
	$.post('http://lcrp-djay/changeVolume', JSON.stringify({input : false
    }))
});

$(document).on('click', '#dj-down', function(e){
	e.preventDefault();
	$.post('http://lcrp-djay/changeVolume', JSON.stringify({input : true
    }))
});

$(document).on('click', '#sync-video', function(e){
	e.preventDefault();
	$.post('http://lcrp-djay/posteDoRafa', JSON.stringify({
    }))
});

function youtube_parser(url){
    var regExp = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#&?]*).*/;
    var match = url.match(regExp);
    return (match&&match[7].length==11)? match[7] : false;
}