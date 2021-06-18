var CanOpenApp = true;
currentApplication = "";
OpenedChatData = {
    number: null,
}

CallActive = false;
IsOpen = false;
ShowingNoti = false;
PlayerData= {};
MetaData= {};
PlayerJob= {};

robberyName = '';

function OpenPhone() {
    //$(".phoneNot").animate({top: '-13vh'});
    //console.log(JSON.stringify(PlayerJob))
    if(PlayerJob.name == "police") {
        $("#anonChat-block").hide();
        $("#parties-block").hide();
        $("#racing-block").hide();
    } else {
        $("#anonChat-block").show();
        $("#parties-block").show();
        $("#racing-block").show();
    }
    $(".phoneNot").hide();
    $('.ph-frame').show();
    setTimeout(function(){ 
        $(".ph-frame").animate({left: '-23%'});
    }, 500);
    IsOpen = true
}

function ClosePhone() {
    //$(".phoneNot").animate({top: '13vh'});
    $(".ph-frame").animate({left: '23%'});
    setTimeout(function(){ 
        $(".ph-frame").hide();
        $.post('http://lcrp-phone/Close');
    }, 500);
    IsOpen = false
}

function closeCurrentApplication() {
    if(currentApplication == 'twitch') {
        player.stopVideo();
        $("."+currentApplication+"-app").css("display","none");
        CanOpenApp = true;
        $(".phone-application-container").hide();
        $(".ph-frame").css({'transform' : 'rotate(-0deg)'});
        $(".ph-frame").css({'top' : '0%'});
        $(".ph-frame").css({'left' : '-40vh'});
        HeaderTextColor("white", 300);
    }
    if(currentApplication == "valet") {
        $(".valet-starter").css("display","none");
        $(".valet-cars").css("display","none");
        $(".valet-cars-header").css("display","none");
        $(".valet-vehicle").css("display","none");
        /*
        $(".disclaimer-valet").css("display","none");
        $(".request-valet").css("display","none");
        $(".exit-valet").css("display","none");
        $(".valet-header").css("display","none");
        $(".valet-header").css("top","32%");
        */
    }
    $("."+currentApplication+"-app").fadeOut();
    currentApplication = "";
}

LoadPhoneData = function(data) {
    PlayerData = data.PlayerData;
    PlayerJob = data.PlayerJob;
    MetaData = data.PhoneData.MetaData;
    LoadMetaData(data.PhoneData.MetaData);
    LoadContacts(data.PhoneData.Contacts);
    console.log("Phone succesfully loaded!");
}

$(document).ready(function(){
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "open":
                if (ShowCalling) {
                    $(".phone-currentcall-container").fadeIn(150)
                }
                $(".call-notifications").css({"display":"none"});
                $(".call-notifications").animate({
                    right: -5+"vh"
                }, 400);
                $(".phone-call-app").fadeOut(150)
                $(".phone-application-container").fadeOut(150)
                OpenPhone();
                break;
            case "LoadPhoneData":
                LoadPhoneData(event.data);
                break;
            case "UpdateTime":
                UpdateTime(event.data);
                break;
            case "Notification":
                addNotification(event.data.NotifyData.icon, event.data.NotifyData.title, event.data.NotifyData.content, "default", event.data.NotifyData.timeout);
                break;
            case "PhoneNotification":
                addNotification(event.data.PhoneNotify.icon, event.data.PhoneNotify.title, event.data.PhoneNotify.text, event.data.PhoneNotify.color, event.data.PhoneNotify.timeout, event.data.PhoneNotify.isMuted);
                break;
            case "UpdateMentionedTweets":
                LoadMentionedTweets(event.data.Tweets);
                break;
            case "UpdateBank":
                event.data.NewBalance = checkString(event.data.NewBalance)
                $(".bank-app-account-balance").html("&dollar; "+event.data.NewBalance);
                $(".bank-app-account-balance").data('balance', event.data.NewBalance);
                break;
            case "UpdateChat":
                if (currentApplication == "whatsapp") {
                    if (OpenedChatData.number !== null && OpenedChatData.number == event.data.chatNumber) {
                        console.log('Chat reloaded')
                        SetupChatMessages(event.data.chatData);
                    } else {
                        console.log('Chats reloaded')
                        LoadWhatsappChats(event.data.Chats);
                    }
                }
                break;
            case "UpdateHashtags":
                LoadHashtags(event.data.Hashtags);
                break;
            case "RefreshWhatsappAlerts":
                ReloadWhatsappAlerts(event.data.Chats);
                break;
            case "CancelOutgoingCall":
                $.post('http://lcrp-phone/HasPhone', JSON.stringify({}), function(HasPhone){
                    if (HasPhone) {
                        CancelOutgoingCall();
                    }
                });
                break;
            case "IncomingCallAlert":
                $.post('http://lcrp-phone/HasPhone', JSON.stringify({}), function(HasPhone){
                    if (HasPhone) {
                        IncomingCallAlert(event.data.CallData, event.data.Canceled, event.data.AnonymousCall);
                    }
                });
                break;
            case "SetupHomeCall":
                SetupCurrentCall(event.data.CallData);
                break;
            case "AnswerCall":
                AnswerCall(event.data.CallData);
                break;
            case "UpdateCallTime":
                var CallTime = event.data.Time;
                var date = new Date(null);
                date.setSeconds(CallTime);
                var timeString = date.toISOString().substr(11, 8);

                timeString = checkString(timeString)
                event.data.Name = checkString(event.data.Name)
                if (!IsOpen) {
                    if ($(".call-notifications").css("right") !== "52.1px") {
                        $(".call-notifications").css({"display":"block"});
                        $(".call-notifications").animate({right: 5+"vh"});
                    }

                    $(".call-notifications-title").html("Call ongoing ("+timeString+")");
                    $(".call-notifications-content").html("Call with "+event.data.Name);
                    $(".call-notifications").removeClass('call-notifications-shake');
                } else {
                    $(".call-notifications").animate({
                        right: -35+"vh"
                    }, 400, function(){
                        $(".call-notifications").css({"display":"none"});
                    });
                }

                $(".phone-call-ongoing-time").html(timeString);
                $(".phone-currentcall-title").html("In call ("+timeString+")");
                break;
            case "CancelOngoingCall":
                $(".phone-currentcall-container").fadeOut(150)
                $(".call-notifications").animate({right: -35+"vh"}, function(){
                    $(".call-notifications").css({"display":"none"});
                });
                $(".phone-application-container").fadeOut(150)
                setTimeout(function(){
                    $(".phone-call-app").css("display", "none");
                    $(".phone-application-container").css({"display":"none"});
                }, 400)
                HeaderTextColor("white", 300);

                CallActive = false;
                currentApplication = null;
                break;
            case "RefreshContacts":
                LoadContacts(event.data.Contacts);
                break;
            case "UpdateMails":
               SetupMails(event.data.Mails);
                break;
            case "RefreshAdverts":
                if (currentApplication == "advert") {
                    RefreshAdverts(event.data.Adverts);
                }
                break;
            case "AddPoliceAlert":
                AddPoliceAlert(event.data);
                break;
            case "UpdateAnonChat":
                updateAnonChatAll(event.data.AnonChat);
                break;
            case "receiveRobInvite":
                insertInvite(event.data.InviteFN, event.data.InviteLN, event.data.id, event.data.size);
                break;
            case "joinedRobGroup":
                addNotification("fas fa-mask", event.data.InviteFN+" "+event.data.InviteLN+" joined!");
                updateUsers(currentGroupId)
                break;
            case "declineRobGroup":
                addNotification("fas fa-mask", event.data.InviteFN+" "+event.data.InviteLN+" declined!");
                break;
            case "raceNotification":
                $(".racing-finder").fadeOut(400)
                $(".racing-starter").fadeIn(400)
                addNotification("fas fa-flag-checkered", "Race found!", "Go to the point on your GPS and talk to the event host", "default", 5000);
                break;
            case "groupRobFound":
                $(".parties-app .groups-invite").fadeOut(400);
                $("#toggle-parties").fadeOut(400);
                //aceita o convite
                addNotification("fas fa-mask", "You've joined a group");
                currentGroupId=parseInt(event.data.group)
                updateUsers(parseInt(event.data.group))
                $(".parties-ripple").fadeOut(400);
                $(".parties-ripple-txt").fadeOut(400);
                $(".parties-cancel").fadeOut(400);
                break;
            case "kickedRobGroup":
                currentGroupId = -1;
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
            case "notifyRobLeave":
                if(event.data.id == currentGroupId) {
                    currentGroupId = -1;
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
                break;
            case "playerRobFound":
                updateUsers(currentGroupId)
                break;
            case "newRobNoti":
                robberyName = event.data.robbery
                addRobNotification()
                //addNotification("fas fa-running", "Heists", "New job found!");
                $(".groups-find-job").html("FIND JOB");
                $(".parties-elipse").fadeOut(200);
                findingJob = false
                $(".parties-acceptjob-jobname").html("Job Found");
                $(".parties-app .groups").fadeOut(400);
                $(".parties-app .groups-user").fadeOut(400);
                $(".groups-find-job").fadeOut(400);
                $(".groups-toggle").fadeOut(400);
                $(".groups-invite").fadeOut(400);
                $(".groups-exit").fadeOut(400);
                $(".parties-acceptjob").fadeIn(400);
                break;
            case "robberyFound":
                $(".parties-app .groups").fadeOut(400);
                $(".parties-app .groups-user").fadeOut(400);
                $(".parties-acceptjob").fadeOut();
                $(".groups-find-job").html("FIND JOB");
                $(".groups-find-job").fadeOut(400);
                $(".groups-toggle").fadeOut(400);
                $(".groups-invite").fadeOut(400);
                $(".groups-exit").fadeOut(400);
                $(".timeline").fadeIn(400);
                $(".rob1").fadeIn(400);
                partiesAppReseted = false
                onRob = true;
                break;
            case "resetRob":
                addNotification("fas fa-mask", "Jobs", "Job Time ended");
                if (!partiesAppReseted){
                    resetRob()
                }
                break;
            case "rob2":
                addNotification("fas fa-mask", "Approach Carefully", "Be silent! Pick the lock and steal what you can.");
                $('.rob2').fadeIn(400)
                break;
            case "rob3":
                addNotification("fas fa-mask", "House emptied", "Get out of there, follow your GPS and deliver the goods.");
                $('.rob3').fadeIn(400)
                break;
            case "rob4":
                addNotification("fas fa-mask", "Goods Delivered", "A job well done.");
                $('.rob4').fadeIn(400)
                setTimeout(function () {
                    resetRob()
                    $.post('http://lcrp-phone/jobCompleted', JSON.stringify({}), function(data){});
                }, 10000);
                break;
        }
    })
});

UpdateTime = function(data) {
    var NewDate = new Date();
    var NewHour = NewDate.getHours();
    var NewMinute = NewDate.getMinutes();
    var Minutessss = NewMinute;
    var Hourssssss = NewHour;
    if (NewHour < 10) {
        Hourssssss = "0" + Hourssssss;
    }
    if (NewMinute < 10) {
        Minutessss = "0" + NewMinute;
    }
    $("#phone-time").html(" <span style='font-size: 1.1vh;'>" + Number(data.InGameTime.hour) + ":" + Number(data.InGameTime.minute) + "</span>");
}

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESCAPE
            closeCurrentApplication();
            ClosePhone();
            break;
    }
});

$(document).on('click', '.phone-application', function(e){
    e.preventDefault();
    var PressedApplication = $(this).attr('data-appslot');
    //console.log(PressedApplication)
    var AppObject = $("."+PressedApplication+"-app");
    if (AppObject.length !== 0) {
                currentApplication = PressedApplication;
                $(".phone-application-container").fadeIn(150)
                AppObject.show();
                if (PressedApplication == "settings") {
                    $.post('http://lcrp-phone/getPlyData', JSON.stringify({}), function (datajob) {
                        datajob = JSON.parse(datajob)
                        $("#myPhoneNumber").text(datajob.charinfo.phone)
                    });
                } else if (PressedApplication == "airLines"){
                    $.post('http://lcrp-phone/getPlyData', JSON.stringify({}), function (datajob) {
                        datajob = JSON.parse(datajob)
                        if(datajob.job.name != "airlines") {
                            $(".get-new").hide();
                        } else {
                            $(".get-new").show();
                        }
                    });
                    $.post('http://lcrp-phone/GetFlights', JSON.stringify({}), function(put){
                        var flights = put.flights
                        var curTime = put.time
                        $( ".airLines-flights-ul" ).empty();
                        if(flights.length != 0) {
                            var i;
                            for (i = 0; i < flights.length; i++) {
                                if(flights[i].departs - curTime > 0) {
                                    $(".airLines-flights-ul").append(' <div class="flight" id="' + flights[i]["id"]+ '"><div class="flight-info-1"><p class="destinationid">'+ flights[i]["destination"] + ' #' + flights[i]["id"] + '</p><p class="hour">Departure: ' +  Math.round((flights[i].departs - curTime)/60) + ' min</p></div><div class="flight-info-2"><p class="nocu">' + flights[i]["takenSeats"] + '/' + flights[i]["seats"] + '</p><p class="preco">' + flights[i]["price"] + ' $</p></div><div class="buy-ticket">BUY</div></div>');
                                }
                            }
                        }
                    });
                    $(".airLines-flights").show();
                    $(".buy-flight").show();
                    $(".ticket-number").show();
                    $(".airLines-form").hide();
                    $(".submit-flight").hide();
                } else if(PressedApplication == "twitch") {
                    $(".ph-frame").css({'transform' : 'rotate(-90deg)'});
                    $(".ph-frame").css({'top' : '135vh'});
                    $(".ph-frame").css({'left' : '20vw'});
                    $(".ph-frame").css({'transform-origin' : 'center center'});
                    if(window.screen.width > 1920) {
                        $(".ph-frame").css({'right' : '-20vh'});
                    } else {
                        $(".ph-frame").css({'right' : '-50vh'});
                    }
                    $(".ph-frame").css({'bottom' : '-15%'});
                    $.post('http://lcrp-weazelnews/getLive', JSON.stringify({}), function(isLive){
                        if(isLive.status) {
                            var videoId = isLive.videoId
                            $(".youtube-frame").show();
                            $(".youtube-unavailable").hide();
                            player.seekTo(0);
                            player.unMute()
                            player.loadVideoById(videoId)
                        } else {
                            $(".youtube-frame").hide();
                            $(".youtube-unavailable").show();
                        }
                    })
                } else if (PressedApplication == "twitter") {
                    //addNotification("fas fa-phone", "Phone", "You are already busy!");
                    //$(".phone-notification-container").fadeIn(150)
                    $.post('http://lcrp-phone/GetMentionedTweets', JSON.stringify({}), function(MentionedTweets){
                        LoadMentionedTweets(MentionedTweets)
                    })
                    $.post('http://lcrp-phone/GetHashtags', JSON.stringify({}), function(Hashtags){
                        LoadHashtags(Hashtags)
                    })
                    $.post('http://lcrp-phone/GetTweets', JSON.stringify({}), function(Tweets){
                        LoadTweets(Tweets);
                    });
                } else if (PressedApplication == "bank") {
                    DoBankOpen();
                    $.post('http://lcrp-phone/GetBankContacts', JSON.stringify({}), function(contacts){
                        LoadContactsWithNumber(contacts);
                    });
                    $.post('http://lcrp-phone/GetInvoices', JSON.stringify({}), function(invoices){
                        LoadBankInvoices(invoices);
                    });
                } else if (PressedApplication == "whatsapp") {
                    $.post('http://lcrp-phone/GetWhatsappChats', JSON.stringify({}), function(chats){
                        LoadWhatsappChats(chats);
                    });
                } else if (PressedApplication == "phone") {
                    $.post('http://lcrp-phone/GetMissedCalls', JSON.stringify({}), function(recent){
                        SetupRecentCalls(recent);
                    });
                    $.post('http://lcrp-phone/GetSuggestedContacts', JSON.stringify({}), function(suggested){
                       SetupSuggestedContacts(suggested);
                    });
                    $.post('http://lcrp-phone/ClearGeneralAlerts', JSON.stringify({
                        app: "phone"
                    }));
                } else if (PressedApplication == "mail") {
                    $.post('http://lcrp-phone/GetMails', JSON.stringify({}), function(mails){
                        SetupMails(mails);
                    });
                    $.post('http://lcrp-phone/ClearGeneralAlerts', JSON.stringify({
                        app: "mail"
                    }));
                } else if (PressedApplication == "advert") {
                    $.post('http://lcrp-phone/LoadAdverts', JSON.stringify({}), function(Adverts){
                       RefreshAdverts(Adverts);
                    })
                } else if (PressedApplication == "garage") {
                    $.post('http://lcrp-phone/SetupGarageVehicles', JSON.stringify({}), function(Vehicles){
                        SetupGarageVehicles(Vehicles);
                    })
                } else if (PressedApplication == "houses") {
                    $.post('http://lcrp-phone/GetPlayerHouses', JSON.stringify({}), function(Houses){
                        SetupPlayerHouses(Houses);
                    });
                } else if (PressedApplication == "meos") {
                    SetupMeosHome();
                }  else if (PressedApplication == "skills") {
                    $.post('http://lcrp-phone/GetPlayerSkills', JSON.stringify({}), function(data){
                        SetupSkills(data);
                    });
                } else if (PressedApplication == "general"){
                    $(".general-h").fadeOut(150);
                    $(".notepad-buttons").fadeOut(150);
                    updateNotes();
                } else if (PressedApplication == "valet") {
                    $(".valet-starter").fadeIn(650);
                    $(".valet-levels").fadeOut(650)
                    $(".valet-request-service").fadeIn(650)
                    $('.valet-starter-img').fadeIn(650);
                    $('.valet-starter-txt').fadeIn(650);
                    /*
                    $(".valet-header").fadeIn(650);
                    setTimeout(function(){ 
                        $(".valet-header").animate({top: '16vh'})
                        setTimeout(function(){
                            $(".request-valet").fadeIn(600)
                            $(".exit-valet").fadeIn(600)
                            $(".disclaimer-valet").fadeIn(600)
                        }, 600);
                    }, 400); */
                } else if(PressedApplication == "parties") {
                    updateInvites()
                }
            }
});

$(document).on('click', '.phone-home-container', function(e){
    var AppObject = $("."+currentApplication+"-app");
    AppObject.hide();
    $(".phone-application-container").fadeOut(150)
    if(currentApplication == "valet") {
        /*
        $(".disclaimer-valet").css("display","none");
        $(".request-valet").css("display","none");
        $(".exit-valet").css("display","none");
        $(".valet-header").css("display","none");
        $(".valet-header").css("top","32%");
        */
        $(".valet-starter").css("display","none");
        $(".valet-cars").css("display","none");
        $(".valet-cars-header").css("display","none");
        $(".valet-vehicle").css("display","none");
    }
    currentApplication = "";
});

function HeaderTextColor(newColor, Timeout) {
    $(".phone-header").animate({color: newColor}, Timeout);
}
