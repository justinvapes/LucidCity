option1 = false
option2 = false
toggle = true
findingJob = false
availableInvites = []
currentGroupId = -1;
onRob = false;
partiesAppReseted = true

$(document).on('click', '.parties-app .option-1', function(e){
    $.post('http://lcrp-phone/inRobbery', JSON.stringify({}), function(data){
        if(data.inRobbery){
            addNotification("fas fa-mask", data.notification);
        }else{
            option1 = true
            $(".parties-header-txt").fadeOut(400);
            $(".parties-invites").fadeOut(400);
            $(".no-inv").fadeOut(400);
            $(".parties-app .groups-find-job").hide();
            $(".parties-app .groups-exit").hide();
            $(".parties-app .groups-invite").hide();
            $("#toggle-parties").hide();
            $(".parties-menu").fadeIn(400);
            $(".parties-find").fadeIn(400);
            $(".parties-create").fadeIn(400);
        }
    });   
});

$(document).on('click', '.parties-app .parties-logo-txt', function(e){
    if(onRob == false) {
        if(currentGroupId == -1) {
            option1 = false
            option2 = false
            $(".parties-ripple-txt").fadeOut(400);
            $(".parties-ripple").fadeOut(400);
            $(".parties-cancel").fadeOut(400);
            $(".parties-menu").fadeOut(400);
            $(".parties-header-txt").fadeIn(400);
            $(".parties-invites").fadeIn(400);
            $(".parties-app .groups").fadeOut(400);
            $(".groups .groups-user").fadeOut(400);
            $(".parties-app .groups-invite").fadeOut(400);
            $("#toggle-parties").fadeOut(400);
            $(".parties-app .groups-exit").fadeOut(400);
            $(".parties-app .groups-find-job").fadeOut(400);
            updateInvites();
        } else {
            updateUsers(currentGroupId)
        }
    }
});

$(document).on('click', '.parties-app .parties-find', function(e){
    $(".parties-create").fadeOut(400);
    $(".parties-find").fadeOut(400);
    $(".parties-app .groups-find-job").fadeOut(400);
    $(".parties-app .groups-exit").fadeOut(400);
    $(".parties-app .groups-invite").fadeOut(400);
    $("#toggle-parties").fadeOut(400);
    $(".parties-ripple").fadeIn(400);
    $(".parties-ripple-txt").fadeIn(400);
    $(".parties-cancel").fadeIn(400);
    $.post('http://lcrp-phone/findRobGroup', JSON.stringify({}), function(Id){});
});

$(document).on('click', '.parties-app .parties-cancel', function(e){
    $(".parties-ripple-txt").fadeOut(400);
    $(".parties-ripple").fadeOut(400);
    $(".parties-cancel").fadeOut(400);
    $(".parties-find").fadeIn(400);
    $(".parties-create").fadeIn(400);
    $.post('http://lcrp-phone/cancelFindGroup', JSON.stringify({}), function(Id){});
});

$(document).on('click', '.parties-app .parties-create', function(e){
    $(".parties-ripple-txt").fadeOut(400);
    $(".parties-ripple").fadeOut(400);
    $(".parties-cancel").fadeOut(400);
    $(".parties-find").fadeOut(400);
    $(".parties-create").fadeOut(400);
    $.post('http://lcrp-phone/creategroup', JSON.stringify({}), function(data){
        addNotification("fas fa-mask", "You created a group!");
        $.post('http://lcrp-phone/getPlayerIdGroup', JSON.stringify({}), function(Id){
            updateUsers(Id);
            currentGroupId = Id;
            $(".parties-app .groups-invite").fadeIn(400);
            $(".parties-app .groups-exit").fadeIn(400);
        });
    });
});

$(document).on('click', '.parties-app #toggle-parties', function(e){
    if(toggle == false) {
        $.post('http://lcrp-phone/toggleGroup', JSON.stringify({}), function(data){
            toggle = true
            addNotification("fas fa-mask", "Your group is now closed!");
            $('#toggle-parties').removeClass("fa-toggle-off");
            $('#toggle-parties').addClass("fa-toggle-on");
        });
    } else {
        $.post('http://lcrp-phone/toggleGroup', JSON.stringify({}), function(data){
            toggle = false
            addNotification("fas fa-mask", "Your group is now open!");
            $('#toggle-parties').removeClass("fa-toggle-on");
            $('#toggle-parties').addClass("fa-toggle-off");
        });
    }
});

$(document).on('click', '.parties-app .groups-invite', function(e){
    $('.parties-app .groups').fadeOut(400);
    $('.parties-app .groups-user').fadeOut(400);
    $(".parties-app .groups-invite").fadeOut(400);
    $("#toggle-parties").fadeOut(400);
    $(".parties-app .groups-exit").fadeOut(400);
    $(".parties-app .groups-find-job").fadeOut(400);
    $(".parties-app .parties-newuser").fadeIn(400);
});

$(document).on('click', '.parties-app .parties-newuser-cancel', function(e){
    $(".parties-app .parties-newuser").fadeOut(400);
    $(".parties-app .groups-invite").fadeIn(400);
    $(".parties-app .groups-exit").fadeIn(400);
    updateUsers(currentGroupId);
});

$(document).on('click', '.parties-app .parties-newuser-register', function(e){
    $(".parties-app .parties-newuser").fadeOut(400);
    $(".parties-app .groups-invite").fadeIn(400);
    $("#toggle-parties").fadeOut(400);
    $(".parties-app .groups-exit").fadeIn(400);
    updateUsers(currentGroupId);
    inviteId = $('.parties-userid').val()
    $.post('http://lcrp-phone/invitePlayerById', JSON.stringify({inviteId: inviteId}), function(notification){
        addNotification("fas fa-mask", notification);
    });
});


$(document).on('click', '.parties-invites .fa-check', function(e){
    
    var groupId = $(this).parent().attr('id');
    var pos = inInvites($(this).parent().attr('id'), availableInvites)
    $.post('http://lcrp-phone/acceptGroup', JSON.stringify({groupId: groupId, status: "true"}), function(data){
        if (data.inRobbery){
            if (data.notification == 'Group no longer available') {
                if(pos > -1) {
                    availableInvites.splice(pos, 1);
                }
                updateInvites();
            }
            addNotification("fas fa-mask", data.notification);
        } else {
            $(".parties-app .groups-invite").fadeOut(400);
            $("#toggle-parties").fadeOut(400);
            //aceita o convite
            if(pos > -1) {
                availableInvites.splice(pos, 1);
            }
            $(".parties-header-txt").fadeOut(400);
            $(".parties-invites").fadeOut(400);
            $(".no-inv").fadeOut(400);
            
            addNotification("fas fa-mask", data.notification);
            currentGroupId = groupId
            updateUsers(currentGroupId);
        }
    });
});

$(document).on('click', '.parties-invites .fa-trash-alt', function(e){
    var pos = inInvites($(this).parent().attr('id'), availableInvites)
    if(pos > -1) {
        availableInvites.splice(pos, 1);
    }
    updateInvites();
});

$(document).on('click', '.parties-app .groups-exit', function(e){
    findingJob = false
    toggle = true
    $('#toggle-parties').removeClass("fa-toggle-off");
    $('#toggle-parties').addClass("fa-toggle-on");
    option1 = false
    option2 = false
    $(".parties-ripple-txt").fadeOut(400);
    $(".parties-ripple").fadeOut(400);
    $(".parties-cancel").fadeOut(400);
    $(".parties-invites").fadeIn(400);
    $(".parties-app .groups").fadeOut(400);
    $(".groups .groups-user").fadeOut(400);
    $(".parties-app .groups-invite").fadeOut(400);
    $("#toggle-parties").fadeOut(400);
    $("#timeline").fadeOut(400);
    $(".parties-app .groups-exit").fadeOut(400);
    $(".parties-app .groups-find-job").fadeOut(400);
    $(".groups-find-job").html("FIND JOB");
    $(".parties-elipse").hide();
    $(".parties-menu").fadeOut(400);
    $(".parties-app .groups").css("display","none");
    $(".parties-app .groups-user").css("display","none");
    $(".parties-header-txt").fadeIn(650);
    $('.parties-option option-1').fadeIn(650); 
    $.post('http://lcrp-phone/leaveGroup', JSON.stringify({groupid: currentGroupId}), function(notification){
    addNotification("fas fa-mask", notification);
    });
    updateInvites();
    currentGroupId = -1;
});

$(document).on('click', '.parties-app .groups-user-remove', function(e){
    kickId = $(this).parent().attr('id');
    $.post('http://lcrp-phone/kickFromGroup', JSON.stringify({kickId: kickId, groupId: currentGroupId}), function(notification){
        addNotification("fas fa-mask", "Jobs", notification);
    });
    updateUsers(currentGroupId);
});

$(document).on('click', '.parties-app .groups-find-job', function(e) {
    if(findingJob == true) {
        $.post('http://lcrp-phone/stopSearchRobbery', JSON.stringify({}), function(){
            addNotification("fas fa-mask", "Jobs", "Canceled Search!");
            $(".groups-find-job").html("FIND JOB");
            $(".parties-elipse").fadeOut(200);
            $(".parties-app .groups-invite").fadeIn(400);
            $("#toggle-parties").fadeIn(400)
            findingJob = false
        });
    } else {
        $.post('http://lcrp-phone/findRobberyJob', JSON.stringify({}), function(data){
            if (data.enoughCops) {
                if(data.canSearch) {
                    addNotification("fas fa-mask", "Jobs", "Looking for jobs!");
                    $(".groups-find-job").html("CANCEL");
                    findingJob = true
                    $(".parties-elipse").fadeIn(200);
                    $(".parties-app .groups-invite").hide();
                    $("#toggle-parties").hide()
                } else {
                    addNotification("fas fa-mask", "Jobs", "You can't find jobs alone!");
                }
            } else {
                addNotification("fas fa-mask", "Jobs", "No jobs available right now!");
            }
        });
    }
});

$(document).on('click', '.parties-acceptjob-accept', function(e){
    acceptRobbery();
});

$(document).on('click', '.parties-acceptjob-deny', function(e){
    denyRobbery();
});

$(document).on('click', '#acceptJobInPh', function(e){
    $(".phone-job-notification-container").fadeOut(150);
    acceptRobbery();
});
$(document).on('click', '#denyJobInPh', function(e){
    $(".phone-job-notification-container").fadeOut(150);
    denyRobbery();
});

$(document).on('click', '#acceptJobNot', function(e){
    $(".phoneRobNot").animate({top: '14vh'})
    acceptRobbery();
});
$(document).on('click', '#denyJobNot', function(e){
    $(".phoneRobNot").animate({top: '14vh'})
    denyRobbery();
});

function updateInvites() {
    $(".parties-invites").empty()
    if(availableInvites.length != 0) {
        $(".no-inv").fadeOut(400);
        for(var i = 0; i < availableInvites.length; i++) {
            $(".parties-invites").append('<div class="party-invite" id="'+availableInvites[i].groupid+'" ><p class="invite-groupid">#'+availableInvites[i].groupid+'</p><p class="invite-groupname">'+availableInvites[i].groupname+'</p><i class="fas fa-check"></i><i class="fas fa-trash-alt"></i><p class="invite-size">'+availableInvites[i].groupsize+'/5</p></div>');
        }
        $(".parties-invites .party-invite").each(function(i) {
            $(this).delay(100 * i).fadeIn(500);
        });
    } else {
        $(".parties-invites").fadeOut(400);
        $(".parties-invites .party-invite").hide();
        $(".no-inv").fadeIn(400);
    }
}

function insertInvite(firstname, lastname, id, size) {
    addNotification("fas fa-mask", "Jobs", firstname+ " "+ lastname + " invited you!");
    availableInvites.push({groupid: id, groupname: firstname + " " + lastname, groupsize: size});
}

function updateUsers(groupid) {
    if(groupid != -1) {
        $(".parties-app .groups").empty();
        $.post('http://lcrp-phone/getGroup', JSON.stringify({groupid: groupid}), function(groupPlayers){
            $.post('http://lcrp-phone/getPlayerIdGroup', JSON.stringify({}), function(Id){
                if(currentGroupId == Id) {
                    if (!findingJob){
                        $("#toggle-parties").fadeIn(400)
                    }
                    $(".parties-app .groups-find-job").fadeIn(400);
                } else {
                    $(".parties-app .groups-find-job").hide();
                    $("#toggle-parties").hide()
                }
                for(var i = 0; i < groupPlayers.length; i++) {
                    /*
                    if(currentGroupId == Id) {
                        $(".groups").append('<div class="groups-user"><p class="groups-user-number">'+groupPlayers[i].phone+'</p><p class="groups-user-name">'+groupPlayers[i].name+'</p> <i class="groups-user-remove fas fa-times"></i></div>');
                    } else {
                        $(".groups").append('<div class="groups-user"><p class="groups-user-number">'+groupPlayers[i].phone+'</p><p class="groups-user-name">'+groupPlayers[i].name+'</p></div>');
                    }
                    */
                    $(".groups").append('<div class="groups-user"><p class="groups-user-number">'+groupPlayers[i].phone+'</p><p class="groups-user-name">'+groupPlayers[i].name+'</p></div>');
                }
                $(".parties-app .parties-menu").fadeIn(400);
                $(".parties-app .parties-find").fadeOut(400);
                $(".parties-app .parties-create").fadeOut(400);
                $(".parties-app .parties-cancel").fadeOut(400);
                $(".parties-app .parties-ripple").fadeOut(400);
                $(".parties-app .parties-ripple-txt").fadeOut(400);
                $(".groups").fadeIn(400);
                $(".groups .groups-user").each(function(i) {
                    $(this).delay(100 * i).fadeIn(500);
                });
                $(".parties-app .groups-exit").fadeIn(400);
            });
        });
    }
}

function inInvites(needle,haystack)
{
    var count=haystack.length;
    for(var i=0;i<count;i++)
    {
        if(String(haystack[i]["groupid"])===String(needle)){return i;}
    }
    return -1;
}

function resetRob(){
    partiesAppReseted = true
    findingJob = false
    toggle = true
    $('#toggle-parties').removeClass("fa-toggle-off");
    $('#toggle-parties').addClass("fa-toggle-on");
    option1 = false
    option2 = false
    onRob = false
    $(".parties-ripple-txt").fadeOut(400);
    $(".parties-ripple").fadeOut(400);
    $(".parties-cancel").fadeOut(400);
    $(".parties-invites").fadeIn(400);
    $(".parties-app .groups").fadeOut(400);
    $(".groups .groups-user").fadeOut(400);
    $(".parties-app .groups-invite").fadeOut(400);
    $("#toggle-parties").fadeOut(400);
    $(".parties-app .groups-exit").fadeOut(400);
    $(".parties-app .groups-find-job").fadeOut(400);
    $(".groups-find-job").html("FIND JOB");
    $(".parties-elipse").hide();
    $(".parties-menu").fadeOut(400);
    $(".parties-app .groups").css("display","none");
    $(".parties-app .groups-user").css("display","none");
    $(".parties-header-txt").fadeIn(650);
    $('.parties-option option-1').fadeIn(650);
    $(".timeline").fadeOut(400);
    $(".rob1").fadeOut(400);
    $(".rob2").fadeOut(400);
    $(".rob3").fadeOut(400);
    $(".rob4").fadeOut(400);
    updateInvites();
    currentGroupId = -1;
}

function denyRobbery(){
    addNotification("fas fa-mask", "Jobs", "Job denied!");
    $.post('http://lcrp-phone/stopSearchRobbery', JSON.stringify({}), function(){});
    $(".parties-acceptjob").fadeOut();
    updateUsers(currentGroupId);
    $(".groups-find-job").fadeIn(400);
    $(".groups-toggle").fadeIn(400);
    $(".groups-invite").fadeIn(400);
    $(".groups-exit").fadeIn(400);
}

function acceptRobbery(){
    $.post('http://lcrp-phone/acceptRobbery', JSON.stringify({ robName: robberyName}), function(data){
        if(data.available){
            addNotification("fas fa-mask", "Jobs", "Job Accepted!");
            $(".parties-acceptjob").fadeOut();
            $(".groups-find-job").html("FIND JOB");
            $(".groups-find-job").fadeOut(400);
            $(".groups-toggle").fadeOut(400);
            $(".groups-invite").fadeOut(400);
            $(".groups-exit").fadeOut(400);
            $("parties-elipse").fadeOut(400)
            $(".timeline").fadeIn(400);
            $(".rob1").fadeIn(400);
            onRob = true;
            partiesAppReseted = false
            $.post('http://lcrp-phone/stopSearchRobbery', JSON.stringify({}), function(){});
        }else{
            addNotification("fas fa-mask", "Jobs", "Job no longer available!");
            $(".parties-acceptjob").fadeOut();
            $(".groups-find-job").fadeIn(400);
            $(".groups-toggle").fadeIn(400);
            $(".groups-invite").fadeIn(400);
            $(".groups-exit").fadeIn(400);
            findingJob = true
            $(".parties-elipse").fadeIn(200);
            updateUsers(currentGroupId);
        }
    });
}

function addRobNotification() {
    icon = 'fas fa-mask'
    appName = 'Jobs'
    title = 'New job found!'
    timeout = 5000
    $.post('http://lcrp-phone/HasPhone', JSON.stringify({}), function (HasPhone) {
        if (HasPhone) {
            /* if (timeout == null && timeout == undefined) {
                timeout = 1500;
            } */
            if(IsOpen == false) {
                $.post('http://lcrp-phone/PhoneInPocket', JSON.stringify({timeout: timeout}), function(data){});
                $(".phoneNotRobTxt").html(title)
                $(".phoneNotRobTitle").html(appName)
                $(".phoneRobNot").fadeIn(100)
                $("#phoneNotRobFas").removeClass();
                $("#phoneNotRobFas").addClass(""+icon);
                $(".phoneRobNot").animate({top: '-14vh'})
                setTimeout(function(){ 
                    $(".phoneRobNot").animate({top: '14vh'})
                }, timeout);
            } else {
                if(currentApplication !== 'parties') {
                    $(".phone-job-notification-container").fadeIn(150)
                    $(".notification-icon").html('<i class="' + icon + '"></i>');
                    $(".notification-rob-title").html(appName)//title);
                    $(".notification-rob-text").html(title);
                    setTimeout(function () {
                        $(".phone-job-notification-container").fadeOut(150);
                    }, timeout);
                
                }
                
            }
        }
    });

}