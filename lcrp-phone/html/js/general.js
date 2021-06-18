var checkedNotes = [];
var allNotes = [];
var currrentNoteId = 0;

$(document).on('click', '#general-health', function(e){
    $(this).css("border-bottom",".4vh solid rgb(38, 24, 58)");
    $("#general-job").css("border-bottom","none");
    $("#general-other").css("border-bottom","none");

    $(this).css("background-color","rgb(48, 34, 68)");
    $("#general-job").css("background-color","rgb(61, 47, 80)");
    $("#general-other").css("background-color","rgb(61, 47, 80)");

    updateNotes();

    $(".note-nombre").fadeOut(150)
    $(".general-h").fadeOut(150);
    $(".notepad-buttons").fadeOut(150);
    $(".general-j").fadeOut(150);
    $(".general-o").fadeOut(150);
});

$(document).on('click', '#general-job', function(e){
    $(this).css("border-bottom",".4vh solid rgb(38, 24, 58)");
    $("#general-health").css("border-bottom","none");
    $("#general-other").css("border-bottom","none");

    $(this).css("background-color","rgb(48, 34, 68)");
    $("#general-health").css("background-color","rgb(61, 47, 80)");
    $("#general-other").css("background-color","rgb(61, 47, 80)");

    $.post('http://lcrp-phone/getGeneralDetails', JSON.stringify({}), function(data){
        $(".job-card-name").html(data["playername"]);
        $(".job-card-job").html(data["jobinfo"]["label"]);
        if(data["jobinfo"]["onduty"] && data["jobinfo"]["label"] != "unemployed") {
            $(".job-card-onduty").html("On Duty");
            $(".job-card-onduty").css("color","rgb(159, 233, 90)");
        } else {
            $(".job-card-onduty").html("Off Duty");
            $(".job-card-onduty").css("color","rgb(233, 111, 90)");
        }
        if(data["isOwner"]) {
            $(".owner-card-name").html(data["society"])
            $(".owner-card-funds").html("$"+data["funds"])
            $(".owner-card").fadeIn(150);
        } else {
            $(".owner-card").hide();
        }
    });
    $.post('http://lcrp-phone/getMoneyWashDetails', JSON.stringify({}), function(data){
        console.log(JSON.stringify(data))
        if(data["has"]) {
            $(".moneywash-card").fadeIn(150);
            $(".moneywash-card-name").html(data["content"][0]["name"])
            $(".moneywash-card-funds").html("$"+data["content"][0]["capital"])
            var canWash = data["content"][0]["capital"] - data["content"][0]["hasWashed"]
            $(".moneywash-card-canwash").html("Can Wash: $"+canWash)
            if(data["content"][0]["cooldown"] != undefined) {
                if(data["content"][0]["cooldown"] <= 0) {
                    $(".moneywash-card-cooldown").html("No Cooldown");
                    $(".moneywash-card-cooldown").css("color","rgb(159, 233, 90)");
                } else {
                    var hours = Math.floor(data["content"][0]["cooldown"])
                    var minute = (data["content"][0]["cooldown"] - Math.floor(data["content"][0]["cooldown"])) * 60
                    $(".moneywash-card-cooldown").html(hours +" Hours " + minute.toFixed(0) + " Mins")
                    $(".moneywash-card-cooldown").css("color","rgb(233, 111, 90)");
                }
            } else {
                $(".moneywash-card-cooldown").html("0 Hours")
            }
        } else {
            $(".moneywash-card").hide();
        }
    });

    $(".note-nombre").fadeOut(150)
    $(".general-h").fadeOut(150);
    $(".notepad-buttons").fadeOut(150);
    $(".all-notes").fadeOut(150);
    $(".general-o").fadeOut(150);
    $(".general-j").fadeIn(150);
});

$(document).on('click', '#general-other', function(e){
    $(this).css("border-bottom",".4vh solid rgb(38, 24, 58)");
    $("#general-health").css("border-bottom","none");
    $("#general-job").css("border-bottom","none");

    $(this).css("background-color","rgb(48, 34, 68)");
    $("#general-health").css("background-color","rgb(61, 47, 80)");
    $("#general-job").css("background-color","rgb(61, 47, 80)");
    $(".gym-card").hide();
    //"gym":{"expires":1617730086,"gym":"gym2","active":true}
    $.post('http://lcrp-phone/getGymData', JSON.stringify({}), function(data){
        console.log(data["content"])
        if(data["has"]) {
            var days = Math.floor(data["content"]["expires"] / 24)
            var hours = Math.floor((data["content"]["expires"] - days * 24))
            var minute = (data["content"]["expires"] - Math.floor(data["content"]["expires"])) * 60
            if(days <= 0) {
                if(hours <= 0) {
                    $(".gym-card-time").html(minute.toFixed(0) + " Mins")
                } else {
                    $(".gym-card-time").html(hours + " Hours " + minute.toFixed(0) + " Mins")
                }
            } else {
                $(".gym-card-time").html(days + " Days " + hours + " Hours " + minute.toFixed(0) + " Mins")
            }
            $(".gym-card").fadeIn(150);
        } else {
            $(".no-others").fadeIn(150);
        }
    });

    $(".note-nombre").fadeOut(150)
    $(".general-h").fadeOut(150);
    $(".notepad-buttons").fadeOut(150);
    $(".general-j").fadeOut(150);
    $(".all-notes").fadeOut(150);
    $(".general-o").fadeIn(150);
});

$(document).on('click', '.save-notepad', function(e){
    var string = $(".general-h").val()
    var notename = $(".note-nombre").val()
    $.post('http://lcrp-phone/saveNotepad', JSON.stringify({ id: currrentNoteId,string: string, name: notename}));
    $(".note-nombre").fadeOut(150)
    $(".general-h").fadeOut(150);
    $(".notepad-buttons").fadeOut(150);
    setTimeout(function(){
        updateNotes();
    }, 100);
});

$(document).on('click', '.clear-notepad', function(e){
    $(".general-h").val("")
});

$(document).on('click', '.note-name', function(e){
    currrentNoteId = $(this).parent().attr("id")
    note = getNote();
    $(".general-h").val(note["note"])
    $(".note-nombre").val(note["name"])
    $(".all-notes").fadeOut(150);
    $(".note-nombre").fadeIn(150)
    $(".general-h").fadeIn(150);
    $(".notepad-buttons").fadeIn(150);
});

$(document).on('click', '.note-check', function(e){
    var pos = inArray($(this).parent().attr('id'), checkedNotes)
    if(inArray($(this).parent().attr('id'), checkedNotes) != -1) {
        checkedNotes.splice(pos, 1);
    } else {
        checkedNotes.push($(this).parent().attr('id'))
    }
});

function inArray(needle,haystack)
{
    var count=haystack.length;
    for(var i=0;i<count;i++)
    {
        if(haystack[i]===needle){return i;}
    }
    return -1;
}

function updateNotes() {
    $(".all-notes").fadeOut(150);
    $(".notepads").empty()
    $.post('http://lcrp-phone/getNotepad', JSON.stringify({}), function(data){
        allNotes = data;
        if(data.length != 0) {
            for(var i = 0; i < data.length; i++) {
                $(".notepads").append('<div class="note" id="' + data[i]["noteid"] + '"><p class="note-name">' + data[i]["name"] + '</p><input class="note-check" type="checkbox"></div>')
            }
        }
    });
    $(".all-notes").fadeIn(150);
}

function getNote() {
    var count=allNotes.length;
    for(var i=0;i<count;i++)
    {
        if(allNotes[i]["noteid"]==currrentNoteId){return allNotes[i];}
    }
}

$(document).on('click', '.new-note', function(e){
    $.post('http://lcrp-phone/newNote', JSON.stringify({}));
    setTimeout(function(){
        updateNotes();
    }, 100);
});

$(document).on('click', '.delete-note', function(e){
    $.post('http://lcrp-phone/deleteNotes', JSON.stringify({array: checkedNotes}));
    setTimeout(function(){
        updateNotes();
    }, 100);
});