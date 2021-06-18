var ContactSearchActive = false;
var CurrentFooterTab = "contacts";
var CallData = {};
var ClearNumberTimer = null;
var SelectedSuggestion = null;
var AmountOfSuggestions = 0;
var notificationTimeout;
var CallActive = false;
ShowCalling = false;
AnonymousCallGlobal = false;

function addNotification(icon, title, text, color, timeout, isMuted = false) {
    icon = checkString(icon)
    title = checkString(title)
    text = checkString(text)
    if (text == undefined) {
        text = ""
    }
    $.post('http://lcrp-phone/HasPhone', JSON.stringify({}), function (HasPhone) {
        if (HasPhone) {
            if (timeout == null && timeout == undefined) {
                timeout = 1500;
            }
            if (notificationTimeout == undefined || notificationTimeout == null) {
                if (color != null || color != undefined) {
                    $(".notification-icon").css({"color": color});
                    $(".notification-title").css({"color": color});
                } else if (color == "default" || color == null || color == undefined) {
                    $(".notification-icon").css({"color": "#e74c3c"});
                    $(".notification-title").css({"color": "#e74c3c"});
                }
                if(IsOpen == false) {
                    $(".phoneNotBG").css("color", color);
                    $(".phoneNotTxt").html(title)
                    if(text.length > 27) {
                        $(".phoneNotTitle").html(text.substring(0,25) + "..")
                    } else {
                        $(".phoneNotTitle").html(text)
                    }
                    $(".phoneNot").fadeIn(100)
                    $("#phoneNotFas").removeClass();
                    $("#phoneNotFas").addClass(""+icon);
                    $(".phoneNot").animate({top: '-14vh'})
                    setTimeout(function(){ 
                        $(".phoneNot").animate({top: '14vh'})
                    }, 3000);
                } else {
                    $(".phone-notification-container").fadeIn(150)
                    $(".notification-icon").html('<i class="' + icon + '"></i>');
                    $(".notification-title").html(title);
                    $(".notification-text").html(text);
                }

                if (notificationTimeout !== undefined || notificationTimeout !== null) {
                    clearTimeout(notificationTimeout);
                }
                notificationTimeout = setTimeout(function () {
                    $(".phone-notification-container").fadeOut(150);
                    notificationTimeout = null;
                }, timeout);
            } else {
                if (color != null || color != undefined) {
                    $(".notification-icon").css({"color": color});
                    $(".notification-title").css({"color": color});
                } else {
                    $(".notification-icon").css({"color": "#e74c3c"});
                    $(".notification-title").css({"color": "#e74c3c"});
                }
                $(".notification-icon").html('<i class="' + icon + '"></i>');
                $(".notification-title").html(title);
                $(".notification-text").html(text);
                if (notificationTimeout !== undefined || notificationTimeout !== null) {
                    clearTimeout(notificationTimeout);
                }
                notificationTimeout = setTimeout(function () {
                    $(".phone-notification-container").fadeOut(150);
                    notificationTimeout = null;
                }, timeout);
            }
        }
    });
}

$(document).on('click', '.phone-app-footer-button', function(e){
    e.preventDefault();

    var PressedFooterTab = $(this).data('phonefootertab');

    if (PressedFooterTab !== CurrentFooterTab) {
        var PreviousTab = $(this).parent().find('[data-phonefootertab="'+CurrentFooterTab+'"');

        $('.phone-app-footer').find('[data-phonefootertab="'+CurrentFooterTab+'"').removeClass('phone-selected-footer-tab');
        $(this).addClass('phone-selected-footer-tab');

        $(".phone-"+CurrentFooterTab).hide();
        $(".phone-"+PressedFooterTab).show();

        if (PressedFooterTab == "recent") {
            $.post('http://lcrp-phone/ClearRecentAlerts');
        } else if (PressedFooterTab == "suggestedcontacts") {
            $.post('http://lcrp-phone/ClearRecentAlerts');
        }

        CurrentFooterTab = PressedFooterTab;
    }
});

$(document).on("click", "#phone-search-icon", function(e){
    e.preventDefault();

    if (!ContactSearchActive) {
        $("#phone-plus-icon").animate({
            opacity: "0.0",
            "display": "none"
        }, 150, function(){
            $("#contact-search").css({"display":"block"}).animate({
                opacity: "1.0",
            }, 150);
        });
    } else {
        $("#contact-search").animate({
            opacity: "0.0"
        }, 150, function(){
            $("#contact-search").css({"display":"none"});
            $("#phone-plus-icon").animate({
                opacity: "1.0",
                display: "block",
            }, 150);
        });
    }

    ContactSearchActive = !ContactSearchActive;
});

function SetupRecentCalls(recentcalls) {
    $(".phone-recent-calls").html("");

    recentcalls = recentcalls.reverse();

    $.each(recentcalls, function(i, recentCall){
        var FirstLetter = (recentCall.name).charAt(0);
        var TypeIcon = 'fas fa-phone-slash';
        var IconStyle = "color: #e74c3c;";
        if (recentCall.type === "outgoing") {
            TypeIcon = 'fas fa-phone-volume';
            var IconStyle = "color: #2ecc71; font-size: 1.4vh;";
        }
        if (recentCall.anonymous) {
            FirstLetter = "A";
            recentCall.name = "Anonymous";
        }
        var elem = '<div class="phone-recent-call" id="recent-'+i+'"><div class="phone-recent-call-image">'+FirstLetter+'</div> <div class="phone-recent-call-name">'+recentCall.name+'</div> <div class="phone-recent-call-type"><i class="'+TypeIcon+'" style="'+IconStyle+'"></i></div> <div class="phone-recent-call-time">'+recentCall.time+'</div> </div>'

        $(".phone-recent-calls").append(elem);
        $("#recent-"+i).data('recentData', recentCall);
    });
}

$(document).on('click', '.phone-recent-call', function(e){
    e.preventDefault();

    var RecendId = $(this).attr('id');
    var RecentData = $("#"+RecendId).data('recentData');

    cData = {
        number: RecentData.number,
        name: RecentData.name
    }

    $.post('http://lcrp-phone/CallContact', JSON.stringify({
        ContactData: cData,
        Anonymous: AnonymousCallGlobal,
    }), function(status){
        $.post('http://lcrp-phone/getPhoneNumber', JSON.stringify({}), function(number) {
            if (cData.number !== number) {
                if (status.IsOnline) {
                    if (status.CanCall) {
                        if (!status.InCall) {
                            if (AnonymousCallGlobal) {
                                addNotification("fas fa-phone", "Phone", "You have started an anonymous call!");
                            }
                            $(".phone-call-outgoing").css({"display":"block"});
                            $(".phone-call-incoming").css({"display":"none"});
                            $(".phone-call-ongoing").css({"display":"none"});
                            $(".phone-call-outgoing-caller").html(cData.name);

                            HeaderTextColor("white", 400);
                            $(".phone-application-container").fadeOut(150)

                            setTimeout(function(){
                                $(".phone-app").css({"display":"none"});
                                $(".phone-application-container").fadeIn(150)
                                $(".phone-call").css("display","block")
                            }, 450);
                            ShowCalling = true
                            CallData.name = cData.name;
                            CallData.number = cData.number;
                            closeCurrentApplication();
                            currentApplication = "phone-call";
                            $(".phone-call-app").fadeIn(150)
                        } else {
                            addNotification("fas fa-phone", "Phone", "You are already busy!");
                        }
                    } else {
                    addNotification("fas fa-phone", "Phone", "This person is talking!");
                    }
                } else {
                    addNotification("fas fa-phone", "Phone", "This person is not available!");
                }
            } else {
                addNotification("fas fa-phone", "Phone", "You cannot call your own number!");
            }
        });
    });
});

$(document).on('click', ".phone-keypad-key-call", function(e){
    e.preventDefault();

    var InputNum = $("#phone-keypad-input").text();

    cData = {
        number: InputNum,
        name: InputNum,
    }

    $.post('http://lcrp-phone/CallContact', JSON.stringify({
        ContactData: cData,
        Anonymous: AnonymousCallGlobal,
    }), function(status){
        $.post('http://lcrp-phone/getPhoneNumber', JSON.stringify({}), function(number){
            if (cData.number !== number) {
                if (status.IsOnline) {
                    if (status.CanCall) {
                        if (!status.InCall) {
                            if (AnonymousCallGlobal) {
                                addNotification("fas fa-phone", "Phone", "You have started an anonymous call!");
                            }
                            $(".phone-call-outgoing").css({"display":"block"});
                            $(".phone-call-incoming").css({"display":"none"});
                            $(".phone-call-ongoing").css({"display":"none"});
                            $(".phone-call-outgoing-caller").html(cData.name);
                            
                            HeaderTextColor("white", 400);
                            $(".phone-application-container").fadeOut(150)


                            setTimeout(function(){
                                $(".services-app").css({"display":"none"});
                                $(".phone-application-container").fadeIn(150)
                                $(".phone-call").css("display","block")
                            }, 450);

                            ShowCalling = true
                            CallData.name = cData.name;
                            CallData.number = cData.number;
                            closeCurrentApplication();
                            currentApplication = "phone-call";
                            $(".phone-call-app").fadeIn(150)
                        } else {
                            addNotification("fas fa-phone", "Phone", "You are already busy!");
                        }
                    } else {
                        addNotification("fas fa-phone", "Phone", "This person is in call!");
                    }
                } else {
                    addNotification("fas fa-phone", "Phone", "This person is not available!");
                }
            } else {
               addNotification("fas fa-phone", "Phone", "You cannot call your own number!");
            }
        });
    });
});

function LoadContacts(myContacts) {
    var ContactsObject = $(".phone-contact-list");
    $(ContactsObject).html("");
    var TotalContacts = 0;

    $(".phone-contacts").hide();
    $(".phone-recent").hide();
    $(".phone-keypad").hide();

    $(".phone-"+CurrentFooterTab).show();

    $("#contact-search").on("keyup", function() {
        var value = $(this).val().toLowerCase();
        $(".phone-contact-list .phone-contact").filter(function() {
          $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
        });
    });

    if (myContacts !== null) {
        $.each(myContacts, function(i, contact){
            var ContactElement = '<div class="phone-contact" data-contactid="'+i+'"><div class="phone-contact-firstletter" style="background-color: #e74c3c;">'+((contact.name).charAt(0)).toUpperCase()+'</div><div class="phone-contact-name">'+contact.name+'</div><div class="phone-contact-actions"><i class="fas fa-sort-down"></i></div><div class="phone-contact-action-buttons"> <i class="fas fa-phone-volume" id="phone-start-call"></i> <i class="fab fa-whatsapp" id="new-chat-phone" style="font-size: 2.5vh;"></i> <i class="fas fa-user-edit" id="edit-contact"></i> </div></div>'
            if (contact.status) {
                ContactElement = '<div class="phone-contact" data-contactid="'+i+'"><div class="phone-contact-firstletter" style="background-color: #2ecc71;">'+((contact.name).charAt(0)).toUpperCase()+'</div><div class="phone-contact-name">'+contact.name+'</div><div class="phone-contact-actions"><i class="fas fa-sort-down"></i></div><div class="phone-contact-action-buttons"> <i class="fas fa-phone-volume" id="phone-start-call"></i> <i class="fab fa-whatsapp" id="new-chat-phone" style="font-size: 2.5vh;"></i> <i class="fas fa-user-edit" id="edit-contact"></i> </div></div>'
            }
            TotalContacts = TotalContacts + 1
            $(ContactsObject).append(ContactElement);
            $("[data-contactid='"+i+"']").data('contactData', contact);
        });
        $("#total-contacts").text(TotalContacts+ " contacts");
    } else {
        $("#total-contacts").text("0 conctacts");
    }
};

$(document).on('click', '#new-chat-phone', function(e){
    var ContactId = $(this).parent().parent().data('contactid');
    var ContactData = $("[data-contactid='"+ContactId+"']").data('contactData');
    $.post('http://lcrp-phone/getPhoneNumber', JSON.stringify({}), function(number){
        if (ContactData.number !== number) {
            $.post('http://lcrp-phone/GetWhatsappChats', JSON.stringify({}), function(chats){
                LoadWhatsappChats(chats);
            });
        
            $('.phone-application-container').animate({
                top: -160+"%"
            });
            HeaderTextColor("white", 400);
            setTimeout(function(){
                $('.phone-application-container').animate({
                    top: 0+"%"
                });
                
                $(".phone-app").css("display","none");
                $(".whatsapp-app").css("display","block");
                currentApplication = "whatsapp";
            
                $.post('http://lcrp-phone/GetWhatsappChat', JSON.stringify({phone: ContactData.number}), function(chat){
                   SetupChatMessages(chat, {
                        name: ContactData.name,
                        number: ContactData.number
                    });
                });
            
                $('.whatsapp-openedchat-messages').animate({scrollTop: 9999}, 150);
                $(".whatsapp-openedchat").css({"display":"block"});
                $(".whatsapp-openedchat").css({left: 0+"vh"});
                $(".whatsapp-chats").animate({left: 30+"vh"},100, function(){
                    $(".whatsapp-chats").css({"display":"none"});
                });
            }, 400)
        } else {
            addNotification("fa fa-phone-alt", "Phone", "You can't message yourself, go find friends", "default", 3500);
        }     
    });
});

var CurrentEditContactData = {}

$(document).on('click', '#edit-contact', function(e){
    e.preventDefault();
    var ContactId = $(this).parent().parent().data('contactid');
    var ContactData = $("[data-contactid='"+ContactId+"']").data('contactData');

    CurrentEditContactData.name = ContactData.name
    CurrentEditContactData.number = ContactData.number

    $(".phone-edit-contact-header").text(ContactData.name+" Edit")
    $(".phone-edit-contact-name").val(ContactData.name);
    $(".phone-edit-contact-number").val(ContactData.number);
    if (ContactData.iban != null && ContactData.iban != undefined) {
        $(".phone-edit-contact-iban").val(ContactData.iban);
        CurrentEditContactData.iban = ContactData.iban
    } else {
        $(".phone-edit-contact-iban").val("");
        CurrentEditContactData.iban = "";
    }
    $(".phone-edit-contact").fadeIn(150)
    
});

$(document).on('click', '#edit-contact-save', function(e){
    e.preventDefault();

    var ContactName = $(".phone-edit-contact-name").val();
    var ContactNumber = $(".phone-edit-contact-number").val();
    var ContactIban = $(".phone-edit-contact-iban").val();

    if (ContactName != "" && ContactNumber != "") {
        $.post('http://lcrp-phone/EditContact', JSON.stringify({
            CurrentContactName: ContactName,
            CurrentContactNumber: ContactNumber,
            CurrentContactIban: ContactIban,
            OldContactName: CurrentEditContactData.name,
            OldContactNumber: CurrentEditContactData.number,
            OldContactIban: CurrentEditContactData.iban,
        }), function(PhoneContacts){
           LoadContacts(PhoneContacts);
        });
        $(".phone-edit-contact").fadeOut(150)
        
        setTimeout(function(){
            $(".phone-edit-contact-number").val("");
            $(".phone-edit-contact-name").val("");
        }, 250)
    } else {
        addNotification("fas fa-exclamation-circle", "Contact edit", "Fill everything!");
    }
});

$(document).on('click', '#edit-contact-delete', function(e){
    e.preventDefault();

    var ContactName = $(".phone-edit-contact-name").val();
    var ContactNumber = $(".phone-edit-contact-number").val();
    var ContactIban = $(".phone-edit-contact-iban").val();

    $.post('http://lcrp-phone/DeleteContact', JSON.stringify({
        CurrentContactName: ContactName,
        CurrentContactNumber: ContactNumber,
        CurrentContactIban: ContactIban,
    }), function(PhoneContacts){
        LoadContacts(PhoneContacts);
    });
    $(".phone-edit-contact").fadeOut(150)
    
    setTimeout(function(){
        $(".phone-edit-contact-number").val("");
        $(".phone-edit-contact-name").val("");
    }, 250);
});

$(document).on('click', '#edit-contact-cancel', function(e){
    e.preventDefault();
    $(".phone-edit-contact").fadeOut(150)
    
    setTimeout(function(){
        $(".phone-edit-contact-number").val("");
        $(".phone-edit-contact-name").val("");
    }, 250)
});

$(document).on('click', '.phone-keypad-key', function(e){
    e.preventDefault();

    var PressedButton = $(this).data('keypadvalue');

    if (!isNaN(PressedButton)) {
        var keyPadHTML = $("#phone-keypad-input").text();
        $("#phone-keypad-input").text(keyPadHTML + PressedButton)
    } else if (PressedButton == "#") {
        var keyPadHTML = $("#phone-keypad-input").text();
        $("#phone-keypad-input").text(keyPadHTML + PressedButton)
    } else if (PressedButton == "*") {
        if (ClearNumberTimer == null) {
            $("#phone-keypad-input").text("Cleared")
            ClearNumberTimer = setTimeout(function(){
                $("#phone-keypad-input").text("");
                ClearNumberTimer = null;
            }, 750);
        }
    }
})

var OpenedContact = null;

$(document).on('click', '.phone-contact-actions', function(e){
    e.preventDefault();

    var FocussedContact = $(this).parent();
    var ContactId = $(FocussedContact).data('contactid');

    if (OpenedContact === null) {
        $(FocussedContact).animate({
            "height":"12vh"
        }, 150, function(){
            $(FocussedContact).find('.phone-contact-action-buttons').fadeIn(100);
        });
        OpenedContact = ContactId;
    } else if (OpenedContact == ContactId) {
        $(FocussedContact).find('.phone-contact-action-buttons').fadeOut(100, function(){
            $(FocussedContact).animate({
                "height":"4.5vh"
            }, 150);
        });
        OpenedContact = null;
    } else if (OpenedContact != ContactId) {
        var PreviousContact = $(".phone-contact-list").find('[data-contactid="'+OpenedContact+'"]');
        $(PreviousContact).find('.phone-contact-action-buttons').fadeOut(100, function(){
            $(PreviousContact).animate({
                "height":"4.5vh"
            }, 150);
            OpenedContact = ContactId;
        });
        $(FocussedContact).animate({
            "height":"12vh"
        }, 150, function(){
            $(FocussedContact).find('.phone-contact-action-buttons').fadeIn(100);
        });
    }
});


$(document).on('click', '#phone-plus-icon', function(e){
    e.preventDefault();
    
    $(".phone-add-contact").fadeIn(150)
   
});

$(document).on('click', '#add-contact-save', function(e){
    e.preventDefault();

    var ContactName = $(".phone-add-contact-name").val();
    var ContactNumber = $(".phone-add-contact-number").val();
    var ContactIban = $(".phone-add-contact-iban").val();

    if (ContactName != "" && ContactNumber != "") {
        $.post('http://lcrp-phone/AddNewContact', JSON.stringify({
            ContactName: ContactName,
            ContactNumber: ContactNumber,
            ContactIban: ContactIban,
        }), function(PhoneContacts){
            LoadContacts(PhoneContacts);
        });
        $(".phone-add-contact").fadeOut(150)
        setTimeout(function(){
            $(".phone-add-contact-number").val("");
            $(".phone-add-contact-name").val("");
        }, 250)

        if (SelectedSuggestion !== null) {
            $.post('http://lcrp-phone/RemoveSuggestion', JSON.stringify({
                data: $(SelectedSuggestion).data('SuggestionData')
            }));
            $(SelectedSuggestion).remove();
            SelectedSuggestion = null;
            var amount = parseInt(AmountOfSuggestions);
            if ((amount - 1) === 0) {
                amount = 0
            }
            $(".amount-of-suggested-contacts").html(amount + " contacts");
        }
    } else {
       addNotification("fas fa-exclamation-circle", "Contact add", "Fill everything!");
    }
});

$(document).on('click', '#add-contact-cancel', function(e){
    e.preventDefault();

    $(".phone-add-contact").fadeOut(150)
   
    setTimeout(function(){
        $(".phone-add-contact-number").val("");
        $(".phone-add-contact-name").val("");
    }, 250)
});

$(document).on('click', '#phone-start-call', function(e){
    e.preventDefault();   
    
    var ContactId = $(this).parent().parent().data('contactid');
    var ContactData = $("[data-contactid='"+ContactId+"']").data('contactData');
    
    SetupCall(ContactData);
});

SetupCall = function(cData) {
    var retval = false;
    $.post('http://lcrp-phone/CallContact', JSON.stringify({
        ContactData: cData,
        Anonymous: AnonymousCallGlobal,
    }), function(status){
        $.post('http://lcrp-phone/getPhoneNumber', JSON.stringify({}), function(number){
            if (cData.number !== number) {
                if (status.IsOnline) {
                    if (status.CanCall) {
                        if (!status.InCall) {
                            $(".phone-call-outgoing").css({"display":"block"});
                            $(".phone-call-incoming").css({"display":"none"});
                            $(".phone-call-ongoing").css({"display":"none"});
                            $(".phone-call-outgoing-caller").html(cData.name);
                            HeaderTextColor("white", 400);
                            $(".phone-application-container").fadeOut(150)
                            
                            setTimeout(function(){
                                $(".phone-app").css({"display":"none"});
                                $(".phone-application-container").fadeIn(150)
                                $(".phone-call-app").css("display", "block")
                                
                            }, 450);
                            ShowCalling = true
                            CallData.name = cData.name;
                            CallData.number = cData.number;
                            closeCurrentApplication()
                            currentApplication = "phone-call";
                        } else {
                            addNotification("fas fa-phone", "Phone", "You are already busy!");
                        }
                    } else {
                        addNotification("fas fa-phone", "Phone", "This person is talking!");
                    }
                } else {
                    addNotification("fas fa-phone", "Phone", "This person is not available!");
                }
            } else {
                addNotification("fas fa-phone", "Phone", "You cannot call your own number!");
            }
        });
    });
}

CancelOutgoingCall = function() {
    if (currentApplication == "phone-call") {
        $(".phone-application-container").fadeOut(150)
        
        closeCurrentApplication()
        HeaderTextColor("white", 300);
    
        CallActive = false;
        ShowCalling = false
        $(".phone-currentcall-container").fadeOut(150)
        currentApplication = null;
    }
}

$(document).on('click', '#outgoing-cancel', function(e){
    e.preventDefault();

    $.post('http://lcrp-phone/CancelOutgoingCall');
});

$(document).on('click', '#incoming-deny', function(e){
    e.preventDefault();

    $.post('http://lcrp-phone/DenyIncomingCall');
});

$(document).on('click', '#ongoing-cancel', function(e){
    e.preventDefault();
    
    $.post('http://lcrp-phone/CancelOngoingCall');
});

IncomingCallAlert = function(CallData, Canceled, AnonymousCall) {
    if (!Canceled) {
        if (!CallActive) {
            $(".phone-application-container").fadeOut(150)
            closeCurrentApplication()
            setTimeout(function(){
                var Label = "You have an incoming call from "+CallData.name
                if (AnonymousCall) {
                    Label = "You have an incoming call by an anonymous number"
                }
 
                $(".call-notifications-title").html("Incoming Call");
                $(".call-notifications-content").html(Label);
                $(".call-notifications").css({"display":"block"});
                $(".call-notifications").animate({
                    right: 5+"vh"
                }, 400);
                
                $(".phone-call-outgoing").css({"display":"none"});
                $(".phone-call-incoming").css({"display":"block"});
                $(".phone-call-ongoing").css({"display":"none"});
                $(".phone-call-incoming-caller").html(CallData.name);
                $(".phone-app").css({"display":"none"});
                HeaderTextColor("white", 400);
                
                $(".phone-call-app").css({"display":"block"});
                setTimeout(function(){
                    $(".phone-application-container").fadeIn(150);
                    
                }, 400);
            }, 400);
        
            currentApplication = "phone-call";
            CallActive = true;
        }
        setTimeout(function(){
            $(".call-notifications").addClass('call-notifications-shake');
            setTimeout(function(){
                $(".call-notifications").removeClass('call-notifications-shake');
            }, 1000);
        }, 400);
    } else {
        $(".call-notifications").animate({
            right: -35+"vh"
        }, 400);
        $(".phone-application-container").fadeOut(150);
        
        closeCurrentApplication()
       
        setTimeout(function(){
            $("."+currentApplication+"-app").css({"display":"none"});
            $(".phone-call-outgoing").css({"display":"none"});
            $(".phone-call-incoming").css({"display":"none"});
            $(".phone-call-ongoing").css({"display":"none"});
            $(".call-notifications").css({"display":"block"});
        }, 400)
        HeaderTextColor("white", 300);
        CallActive = false;
        currentApplication = null;
    }
}

SetupCurrentCall = function(cData) {
    if (cData.InCall) {
        CallData = cData;
        $(".phone-currentcall-container").css({"display":"block"});

        if (cData.CallType == "incoming") {
            $(".phone-currentcall-title").html("Incoming call");
        } else if (cData.CallType == "outgoing") {
            $(".phone-currentcall-title").html("Outgoing call");
        } else if (cData.CallType == "ongoing") {
            $(".phone-currentcall-title").html("Calling ("+cData.CallTime+")");
        }

        $(".phone-currentcall-contact").html("with "+cData.TargetData.name);
    } else {
        $(".phone-currentcall-container").css({"display":"none"});
    }
}

$(document).on('click', '.phone-currentcall-container', function(e){
    e.preventDefault();

    if (CallData.CallType == "incoming") {
        $(".phone-call-incoming").css({"display":"block"});
        $(".phone-call-outgoing").css({"display":"none"});
        $(".phone-call-ongoing").css({"display":"none"});
    } else if (CallData.CallType == "outgoing") {
        $(".phone-call-incoming").css({"display":"none"});
        $(".phone-call-outgoing").css({"display":"block"});
        $(".phone-call-ongoing").css({"display":"none"});
    } else if (CallData.CallType == "ongoing") {
        $(".phone-call-incoming").css({"display":"none"});
        $(".phone-call-outgoing").css({"display":"none"});
        $(".phone-call-ongoing").css({"display":"block"});
    }
    $(".phone-call-ongoing-caller").html(CallData.name);

    HeaderTextColor("white", 500);
    $(".phone-application-container").fadeIn(150);

    $(".phone-call-app").fadeIn(150);
  
    $(".phone-call-app").css("display", "block")

                
    currentApplication = "phone-call";
});

$(document).on('click', '#incoming-answer', function(e){
    e.preventDefault();

    $.post('http://lcrp-phone/AnswerCall');
});

function AnswerCall(CallData) {
    $(".phone-call-incoming").css({"display":"none"});
    $(".phone-call-outgoing").css({"display":"none"});
    $(".phone-call-ongoing").css({"display":"block"});
    $(".phone-call-ongoing-caller").html(CallData.TargetData.name);

    ClosePhone();
}

function SetupSuggestedContacts(Suggested) {
    $(".suggested-contacts").html("");
    AmountOfSuggestions = Suggested.length;
    if (AmountOfSuggestions > 0) {
        $(".amount-of-suggested-contacts").html(AmountOfSuggestions + " contacts");
        Suggested = Suggested.reverse();
        $.each(Suggested, function(index, suggest){
            var elem = '<div class="suggested-contact" id="suggest-'+index+'"> <i class="fas fa-exclamation-circle"></i> <span class="suggested-name">'+suggest.name[0]+' '+suggest.name[1]+' &middot; <span class="suggested-number">'+suggest.number+'</span></span> </div>';
            $(".suggested-contacts").append(elem);
            $("#suggest-"+index).data('SuggestionData', suggest);
        });
    } else {
        $(".amount-of-suggested-contacts").html("0 contacts");
    }
}

$(document).on('click', '.suggested-contact', function(e){
    e.preventDefault();

    var SuggestionData = $(this).data('SuggestionData');
    SelectedSuggestion = this;

    $(".phone-add-contact").fadeIn(150)

    
    $(".phone-add-contact-name").val(SuggestionData.name[0] + " " + SuggestionData.name[1]);
    $(".phone-add-contact-number").val(SuggestionData.number);
    $(".phone-add-contact-iban").val(SuggestionData.bank);
});