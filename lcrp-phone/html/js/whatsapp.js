var WhatsappSearchActive = false;
var OpenedChatPicture = null;

$(document).ready(function(){
    $("#whatsapp-search-input").on("keyup", function() {
        var value = $(this).val().toLowerCase();
        $(".whatsapp-chats .whatsapp-chat").filter(function() {
          $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
        });
    });
});

$(document).on('click', '#whatsapp-search-chats', function(e){
    e.preventDefault();

    if ($("#whatsapp-search-input").css('display') == "none") {
        $("#whatsapp-search-input").fadeIn(150);
        $("#whatsapp-hm").fadeOut(150);
        WhatsappSearchActive = true;
    } else {
        $("#whatsapp-search-input").fadeOut(150);
        $("#whatsapp-hm").fadeIn(150);
        WhatsappSearchActive = false;
    }
});

$(document).on('click', '.whatsapp-chat', function(e){
    e.preventDefault();

    var ChatId = $(this).attr('id');
    var ChatData = $("#"+ChatId).data('chatdata');

    SetupChatMessages(ChatData);

    $.post('http://lcrp-phone/ClearAlerts', JSON.stringify({
        number: ChatData.number
    }));

    if (WhatsappSearchActive) {
        $("#whatsapp-search-input").fadeOut(150);
    }

    $(".whatsapp-openedchat").css({"display":"block"});
    $(".whatsapp-openedchat").animate({
        left: 0+"vh"
    },200);
    
    $(".whatsapp-chats").animate({
        left: 30+"vh"
    },200, function(){
        $(".whatsapp-chats").css({"display":"none"});
    });

    $('.whatsapp-openedchat-messages').animate({scrollTop: 9999}, 150);

    if (OpenedChatPicture == null) {
        OpenedChatPicture = "./img/default.png";
        if (ChatData.picture != null || ChatData.picture != undefined || ChatData.picture != "default") {
            OpenedChatPicture = ChatData.picture
        }
        $(".whatsapp-openedchat-picture").css({"background-image":"url("+OpenedChatPicture+")"});
    }
});

$(document).on('click', '#whatsapp-openedchat-back', function(e){
    e.preventDefault();
    $.post('http://lcrp-phone/GetWhatsappChats', JSON.stringify({}), function(chats){
        LoadWhatsappChats(chats);
    });
    OpenedChatData.number = null;
    $(".whatsapp-chats").css({"display":"block"});
    $(".whatsapp-chats").animate({
        left: 0+"vh"
    }, 200);
    $(".whatsapp-openedchat").animate({
        left: -30+"vh"
    }, 200, function(){
        $(".whatsapp-openedchat").css({"display":"none"});
    });
    OpenedChatPicture = null;
});

function GetLastMessage(messages) {
    var CurrentDate = new Date();
    var CurrentMonth = CurrentDate.getMonth();
    var CurrentDOM = CurrentDate.getDate();
    var CurrentYear = CurrentDate.getFullYear();
    var LastMessageData = {
        time: "00:00",
        message: "nikss"
    }
    $.each(messages[messages.length - 1], function(i, msg){
        var msgData = msg[msg.length - 1];
        LastMessageData.time = msgData.time
        LastMessageData.message = msgData.message
    });

    return LastMessageData
}

GetCurrentDateKey = function() {
    var CurrentDate = new Date();
    var CurrentMonth = CurrentDate.getMonth();
    var CurrentDOM = CurrentDate.getDate();
    var CurrentYear = CurrentDate.getFullYear();
    var CurDate = ""+CurrentDOM+"-"+CurrentMonth+"-"+CurrentYear+"";
    return CurDate;
}

function LoadWhatsappChats(chats) {
    $(".whatsapp-chats").html("");
    $.each(chats, function(i, chat){
        var profilepicture = "./img/default.png";
        if (chat.picture !== "default") {
            profilepicture = chat.picture
        }
        var LastMessage = GetLastMessage(chat.messages);
        var ChatElement = '<div class="whatsapp-chat" id="whatsapp-chat-'+i+'"><div class="whatsapp-chat-picture" style="background-image: url('+profilepicture+');"></div><div class="whatsapp-chat-name"><p>'+chat.name+'</p></div><div class="whatsapp-chat-lastmessage"><p>'+LastMessage.message+'</p></div> <div class="whatsapp-chat-lastmessagetime"><p>'+LastMessage.time+'</p></div><div class="whatsapp-chat-unreadmessages unread-chat-id-'+i+'">1</div></div>';
        
        $(".whatsapp-chats").append(ChatElement);
        $("#whatsapp-chat-"+i).data('chatdata', chat);

        if (chat.Unread > 0 && chat.Unread !== undefined && chat.Unread !== null) {
            $(".unread-chat-id-"+i).html(chat.Unread);
            $(".unread-chat-id-"+i).css({"display":"block"});
        } else {
            $(".unread-chat-id-"+i).css({"display":"none"});
        }
    });
}

function ReloadWhatsappAlerts(chats) {
    $.each(chats, function(i, chat){
        if (chat.Unread > 0 && chat.Unread !== undefined && chat.Unread !== null) {
            $(".unread-chat-id-"+i).html(chat.Unread);
            $(".unread-chat-id-"+i).css({"display":"block"});
        } else {
            $(".unread-chat-id-"+i).css({"display":"none"});
        }
    });
}

const monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

function FormatChatDate(date) {
    var TestDate = date.split("-");
    var NewDate = new Date((parseInt(TestDate[1]) + 1)+"-"+TestDate[0]+"-"+TestDate[2]);

    var CurrentMonth = monthNames[NewDate.getMonth()];
    var CurrentDOM = NewDate.getDate();
    var CurrentYear = NewDate.getFullYear();
    var CurDateee = CurrentDOM + "-" + NewDate.getMonth() + "-" + CurrentYear;
    var ChatDate = CurrentDOM + " " + CurrentMonth + " " + CurrentYear;
    var CurrentDate = GetCurrentDateKey();

    var ReturnedValue = ChatDate;
    if (CurrentDate == CurDateee) {
        ReturnedValue = "Today";
    }

    return ReturnedValue;
}

$(document).on('click', '#whatsapp-openedchat-send', function(e){
    e.preventDefault();
    var Message = $("#whatsapp-openedchat-message").val();

    if (Message !== null && Message !== undefined && Message !== "") {
        $.post('http://lcrp-phone/SendMessage', JSON.stringify({
            ChatNumber: OpenedChatData.number,
            ChatMessage: Message,
            ChatType: "message",
        }));
        $("#whatsapp-openedchat-message").val("");
    } else {
        addNotification("fas fa-comment-dots", "Messages", "You cannot send a blank message!", "#069de1", 1750);
    }
});

$(document).on('keydown', function (e) {
    if (OpenedChatData.number !== null) {
        if(e.which === 13){
            var Message = $("#whatsapp-openedchat-message").val();
    
            if (Message !== null && Message !== undefined && Message !== "") {
                $.post('http://lcrp-phone/SendMessage', JSON.stringify({
                    ChatNumber: OpenedChatData.number,
                    ChatMessage: Message,
                    ChatType: "message",
                }));
                $("#whatsapp-openedchat-message").val("");
            } else {
                addNotification("fas fa-comment-dots", "Messages", "You cannot send a blank message!", "#069de1", 1750);
            }
        }
    }
});

$(document).on('click', '#send-location', function(e){
    e.preventDefault();

    $.post('http://lcrp-phone/SendMessage', JSON.stringify({
        ChatNumber: OpenedChatData.number,
        ChatMessage: "Shared Location",
        ChatType: "location",
    }));
});

// scPhone.Functions.SetupChatMessages = function(cData, NewChatData) {
//     if (cData) {
//         OpenedChatData.number = cData.number;

//         if (OpenedChatPicture == null) {
//             $.post('http://lcrp-phone/GetProfilePicture', JSON.stringify({
//                 number: OpenedChatData.number,
//             }), function(picture){
//                 OpenedChatPicture = "./img/default.png";
//                 if (picture != "default" && picture != null) {
//                     OpenedChatPicture = picture
//                 }
//                 $(".whatsapp-openedchat-picture").css({"background-image":"url("+OpenedChatPicture+")"});
//             });
//         } else {
//             $(".whatsapp-openedchat-picture").css({"background-image":"url("+OpenedChatPicture+")"});
//         }

//         $(".whatsapp-openedchat-name").html("<p>"+cData.name+"</p>");
//         $(".whatsapp-openedchat-messages").html("");

//         $.each(cData.messages, function(i, chat){
//             var ChatDate = FormatChatDate(i);
//             var ChatDiv = '<div class="whatsapp-openedchat-messages-'+i+' unique-chat"><div class="whatsapp-openedchat-date">'+ChatDate+'</div></div>';
    
//             $.each(cData.messages[i], function(index, message){
//                 var Sender = "me";
//                 if (message.sender !== scPhone.Data.PlayerData.citizenid) { Sender = "other"; }
//                 var MessageElement
//                 if (message.type == "message") {
//                     MessageElement = '<div class="whatsapp-openedchat-message whatsapp-openedchat-message-'+Sender+'" data-toggle="tooltip" data-placement="bottom" title="'+ChatDate+'">'+message.message+'<div class="whatsapp-openedchat-message-time">'+message.time+'</div></div><div class="clearfix"></div>'
//                 } else if (message.type == "location") {
//                     MessageElement = '<div class="whatsapp-openedchat-message whatsapp-openedchat-message-'+Sender+' whatsapp-shared-location" data-x="'+message.data.x+'" data-y="'+message.data.y+'" data-toggle="tooltip" data-placement="bottom" title="'+ChatDate+'"><span style="font-size: 1.2vh;"><i class="fas fa-thumbtack" style="font-size: 1vh;"></i> Locatie</span><div class="whatsapp-openedchat-message-time">'+message.time+'</div></div><div class="clearfix"></div>'
//                 }
//                 $(".whatsapp-openedchat-messages").append(MessageElement);

//                 $('[data-toggle="tooltip"]').tooltip();
//             });
//         });
//         $('.whatsapp-openedchat-messages').animate({scrollTop: 9999}, 1);
//     } else {
//         OpenedChatData.number = NewChatData.number;
//         if (OpenedChatPicture == null) {
//             $.post('http://lcrp-phone/GetProfilePicture', JSON.stringify({
//                 number: OpenedChatData.number,
//             }), function(picture){
//                 OpenedChatPicture = "./img/default.png";
//                 if (picture != "default" && picture != null) {
//                     OpenedChatPicture = picture
//                 }
//                 $(".whatsapp-openedchat-picture").css({"background-image":"url("+OpenedChatPicture+")"});
//             });
//         }

//         $(".whatsapp-openedchat-name").html("<p>"+NewChatData.name+"</p>");
//         $(".whatsapp-openedchat-messages").html("");
//         // var NewDate = new Date();
//         // var NewDateMonth = NewDate.getMonth();
//         // var NewDateDOM = NewDate.getDate();
//         // var NewDateYear = NewDate.getFullYear();
//         // var DateString = ""+NewDateDOM+"-"+(NewDateMonth+1)+"-"+NewDateYear;
//         // var ChatDiv = '<div class="whatsapp-openedchat-messages-'+DateString+' unique-chat"></div>';
//         // $(".whatsapp-openedchat-messages").append(ChatDiv);
//     }

//     $('.whatsapp-openedchat-messages').animate({scrollTop: 9999}, 1);
// }

SetupChatMessages = function(cData, NewChatData) {
    if (cData) {
        OpenedChatData.number = cData.number;

        if (OpenedChatPicture == null) {
            $.post('http://lcrp-phone/GetProfilePicture', JSON.stringify({
                number: OpenedChatData.number,
            }), function(picture){
                OpenedChatPicture = "./img/default.png";
                if (picture != "default" && picture != null) {
                    OpenedChatPicture = picture
                }
                $(".whatsapp-openedchat-picture").css({"background-image":"url("+OpenedChatPicture+")"});
            });
        } else {
            $(".whatsapp-openedchat-picture").css({"background-image":"url("+OpenedChatPicture+")"});
        }

        $(".whatsapp-openedchat-name").html("<p>"+cData.name+"</p>");
        $(".whatsapp-openedchat-messages").html("");
        $.post('http://lcrp-phone/getPlyData', JSON.stringify({}), function (plyData) {
            plyData = JSON.parse(plyData)
            postCitizenId = plyData.citizenid
            $.each(cData.messages, function(i, chat){

                var ChatDate = FormatChatDate(chat.date);
                var ChatDiv = '<div class="whatsapp-openedchat-messages-'+i+' unique-chat"><div class="whatsapp-openedchat-date">'+ChatDate+'</div></div>';
    
                $(".whatsapp-openedchat-messages").append(ChatDiv);
                $.each(cData.messages[i].messages, function(index, message){
                    var Sender = "me";
                    if (message.sender !== postCitizenId) { Sender = "other"; }
                    var MessageElement
                    if (message.type == "message") {
                        MessageElement = '<div class="whatsapp-openedchat-message whatsapp-openedchat-message-'+Sender+'">'+message.message+'<div class="whatsapp-openedchat-message-time">'+message.time+'</div></div><div class="clearfix"></div>'
                    } else if (message.type == "location") {
                        MessageElement = '<div class="whatsapp-openedchat-message whatsapp-openedchat-message-'+Sender+' whatsapp-shared-location" data-x="'+message.data.x+'" data-y="'+message.data.y+'"><span style="font-size: 1.2vh;"><i class="fas fa-thumbtack" style="font-size: 1vh;"></i> Location</span><div class="whatsapp-openedchat-message-time">'+message.time+'</div></div><div class="clearfix"></div>'
                    }
                    $(".whatsapp-openedchat-messages-"+i).append(MessageElement);
                });
            });
            $('.whatsapp-openedchat-messages').animate({scrollTop: 9999}, 1);
        });
    } else {
        OpenedChatData.number = NewChatData.number;
        if (OpenedChatPicture == null) {
            $.post('http://lcrp-phone/GetProfilePicture', JSON.stringify({
                number: OpenedChatData.number,
            }), function(picture){
                OpenedChatPicture = "./img/default.png";
                if (picture != "default" && picture != null) {
                    OpenedChatPicture = picture
                }
                $(".whatsapp-openedchat-picture").css({"background-image":"url("+OpenedChatPicture+")"});
            });
        }

        $(".whatsapp-openedchat-name").html("<p>"+NewChatData.name+"</p>");
        $(".whatsapp-openedchat-messages").html("");
        var NewDate = new Date();
        var NewDateMonth = NewDate.getMonth();
        var NewDateDOM = NewDate.getDate();
        var NewDateYear = NewDate.getFullYear();
        var DateString = ""+NewDateDOM+"-"+(NewDateMonth+1)+"-"+NewDateYear;
        var ChatDiv = '<div class="whatsapp-openedchat-messages-'+DateString+' unique-chat"><div class="whatsapp-openedchat-date">Today</div></div>';

        $(".whatsapp-openedchat-messages").append(ChatDiv);
    }

    $('.whatsapp-openedchat-messages').animate({scrollTop: 9999}, 1);
}

$(document).on('click', '.whatsapp-shared-location', function(e){
    e.preventDefault();
    var messageCoords = {}
    messageCoords.x = $(this).data('x');
    messageCoords.y = $(this).data('y');

    $.post('http://lcrp-phone/SharedLocation', JSON.stringify({
        coords: messageCoords,
    }))
});

var ExtraButtonsOpen = false;

$(document).on('click', '#whatsapp-openedchat-message-extras', function(e){
    e.preventDefault();

    if (!ExtraButtonsOpen) {
        $(".whatsapp-extra-buttons").css({"display":"block"}).animate({
            left: 0+"vh"
        }, 250);
        ExtraButtonsOpen = true;
    } else {
        $(".whatsapp-extra-buttons").animate({
            left: -10+"vh"
        }, 250, function(){
            $(".whatsapp-extra-buttons").css({"display":"block"});
            ExtraButtonsOpen = false;
        });
    }
});