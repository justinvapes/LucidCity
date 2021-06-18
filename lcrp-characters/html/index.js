var selectedChar = null;
MultiCharacters = {}
$('.container').hide();
var test, test2, test3, test4 

$(document).ready(function (){
    $(".confirm-stage").hide();
    $('#charCreation').hide()
    $('#loginPane').hide()
    window.addEventListener('message', function (event) {
        var item = event.data;

        if (item.action == "openUI") {
            if (item.toggle == true) {
                $('.container').fadeIn(250);
                MultiCharacters.resetAll();
            } else {
                $('.container').fadeOut(250);
                MultiCharacters.resetAll();
            }   
        }
        if (item.action == "setupCharacters") {
            setupCharacters(event.data.characters);
            $(".load-barfill").css("width","32%");
            setTimeout(function (){
                $(".load-barfill").css("width","76%");
            }, 2000);
            setTimeout(function (){
                $(".load-barfill").css("width","100%");
            }, 4000);
            setTimeout(function (){
                $(".loading-container").fadeOut(100);
            }, 5000);
        }
    })
});

async function delayedGreeting() {
    $(".load-barfill").css("width","33%");
    sleep(2000);
    $(".load-barfill").css("width","58%");
    sleep(2000);
    $(".load-barfill").css("width","76%");
     sleep(2000);
    $(".load-barfill").css("width","100%");
    $(".loading-container").fadeOut(100);
}

function sleep(milliseconds) {
    const date = Date.now();
    let currentDate = null;
    do {
      currentDate = Date.now();
    } while (currentDate - date < milliseconds);
  }


function setupCharacters(characters) {
    $.each(characters, function(index, char){
        $('#char-'+char.cid).html("");
        $('#char-'+char.cid).data("citizenid", char.citizenid);
        var gender = "Man"
        if (char.charinfo.gender == 1) { gender = "Woman" }
        $('#char-'+char.cid).removeClass("characterEmpty")
        $('#char-'+char.cid).addClass("selectableCharacter")
        $('#char-'+char.cid).html(
            '<i class="far fa-user fa-2x charMenuCharacterBoxImg"></i><p class="charMenuCharacterBoxText">'+char.charinfo.firstname+' '+char.charinfo.lastname+
            '</p><p class="charMenuCharacterBoxText">'+char.charinfo.birthdate+
            '</p><p class="charMenuCharacterBoxText">'+char.charinfo.nationality+
            '</p><p class="charMenuCharacterBoxText">'+gender+
            '</p><p class="charMenuCharacterBoxText">'+char.job.label+
            '</p><p class="charMenuCharacterBoxText">'+char.money.cash+
            '$</p><p class="charMenuCharacterBoxText">'+char.money.bank+'$</p>')
        setTimeout(function(){
            $('#char-'+char.cid).data('cData', char)
            $('#char-'+char.cid).data('cid', char.cid)
            startDroppable()
        }, 100)
    })
}

$(document).on('click', '.selectableCharacter', function(e) {
    e.preventDefault();
    selectedChar = $(this).attr('id').replace('char-', '')
    var charData = $('#char-'+selectedChar).data('cid');
    if (selectedChar !== null) {
        if (charData !== "") {
            $.post('http://lcrp-characters/selectCharacter', JSON.stringify({
                cData: $('#char-'+selectedChar).data('cData')
            }));
            MultiCharacters.resetAll();
        } else {
            MultiCharacters.fadeInDown('.character-register', '25%', 400);
        }
    }
});

$(document).on('click', '#charNavLiAnnouncements', function(e) {
    $("#charMenuAnnouncements").html('Server is currently on beta stage, please report all bugs to discord')
});

$(document).on('click', '#charNavLiRules', function(e) {
    $("#charMenuAnnouncements").html("Here are the Official Rules on LCRP<br/>http://gg.gg/lcrprules<br/><br/>Here are the General Penalties that you should familiarize yourself with.<br/>http://gg.gg/lcrppenals<br/><br/>Here are the official Gang Guidelines for LCRP<br/>http://gg.gg/lcrpgangguidelines<br/><br/>Please make sure you read through all the rules, especially the Gang Guidelines if you're considering to build a gang.")
});

$(document).on('click', '#charNavLiKeybinds', function(e) {
    $("#charMenuAnnouncements").html('KEYBINDS<br/>[TAB] Opens Inventory<br/>[F1] Opens Interaction Menu<br/>[Shift+H] Changes Voice Proximity<br/>[Z] Hands Up<br/>[X] Cancel Emote/Hands Down<br/>[L] Locks/Unlocks Vehicle<br/>[B] Point/Seatbelt<br/>[M] Phone<br/>[G] Cruise Control/Speed Limiter<br/>[Y] Opens Clothing Menu<br/>[F10] Leaderboard/Check IDs<br/><br/>CHAT COMMANDS<br/>/binds - Set Personal Binds<br/>/report - Sends Report To Staff<br/>/enter - Enters House (Must be Owned or Shared)<br/>/seat (0-3) - Switches Seats in a Vehicle<br/>/911 - Sends a Notification To Active Police & EMS<br/>/givecash (id)(amount)<br/>/e (emotename) - Plays Animation<br/>/emotes (emotename) - Plays Animation<br/><br/>CLOTHING COMMANDS<br/>/shirt - Takes on/off Shirt<br/>KEYBINDS<br/>/pants - Takes on/off Pants<br/>/shoes - Takes on/off Shoes<br/>/hat - Takes on/off Hat<br/>/chain - Takes on/off Chain<br/>/bag - Takes on/off Bag<br/>/glasses - Takes on/off Glasses<br/>/ear - Takes on/off Earpiece<br/>/watch - Takes on/off Watch<br/>/bracelet - Takes on/off Bracelet')
});

$(document).on('click', '#charNavLiFAQ', function(e) {
    $("#charMenuAnnouncements").html('1. MY CHARACTER IS INVISIBLE WHAT DO I DO? <br/>THE SERVER SOMETIMES GETS OVERLOADED WITH ALL THE PEOPLE JOINING, JUST GIVE IT A COUPLE MINUTES AND IF NOTHING CHANGES RELOG<br/><br/>2. I CANNOT JOIN THE SERVER, IT SAYS I NEED TO JOIN THE GUILD?<br/>JUST RESTART DISCORD AND YOU SHOULD BE ABLE TO JOIN.<br/><br/>3. MY TEXTURES AREN\'T LOADING IN?<br/>MAKE SURE YOUR GRAPHIC SETTINGS ARE TURNED TO NORMAL AND TURN YOUR SHADOWS ALL THE WAY OFF.<br/><br/>4. I WAS BANNED FOR NO REASON?<br/>MAKE A TICKET IN THE #BAN-APPEAL CHAT AND WE WILL GET IT SORTED FOR YOU.<br/><br/>5. IS THERE A PATREON FOR THIS SERVER?<br/>NO, THERE IS NOT WE DO NOT HAVE A PATREON OR TAKE DONATIONS.<br/><br/>6. HOW DO I APPLY TO BE A MECHANIC,EMS, PD OR STAFF?<br/>GO TO THE APPLICATIONS PART OF THE DISCORD AND FILL OUT THE APPLICATION. PLEASE REMEMBER THAT APPLICATIONS CAN TAKE UP TO 3 DAYS TO READ, PLEASE BE PATIENT.<br/><br/>7. HOW DO I BUY A HOUSE?<br/>YOU WILL NEED TO TALK TO THE REAL ESTATE AGENT IN GAME TO BUY A HOUSE.<br/><br/>8. HOW DO I GET A WEAPONS PERMIT?<br/>YOU WILL NEED TO GO TO THE POLICE STATION AND APPLY FOR ONE, YOU NEED A PHONE NUMBER, ID AND 2500 DOLLARS TO PURCHASE IT.<br/><br/>9. HOW DO I JOIN THE SERVER?<br/>GO TO #SERVER-CONNECTIONS ON THE DISCORD AND TYPE F8 AND TYPE IN THE URL.<br/><br/>10. WHAT DO I DO WHEN I FIRST JOIN THE SERVER?<br/>FIRSTLY YOU WILL WANT TO JOIN AND CREATE YOUR CHARACTER, THEN YOU WILL WANT TO HEAD OVER TO THE COURTHOUSE AND COLLECT YOUR STARTER CASH, THE COURTHOUSE IS ACROSS THE STREET FROM THE POLICE STATION,THEN YOU WILL WANT TO HEAD OVER TO THE RED BRIEFCASE ON THE MAP AND PICK A JOB.<br/><br/>11. I AM A CONSTRUCTION WORKER, HOW DO I DO TASKS?<br/>WHEN YOU ARRIVE AT THE CONSTRUCTION SITE YOU WILL NEED TO FIND TASKS TO DO ALL AROUND THE SITE, THEY ARE MARKED BY WHITE ARROWS.<br/><br/>12. I AM A TAXI DRIVER, HOW DO I START TAKING FARES?<br/>HOLD F1 AND GO TO PLAYER INTERACTIONS, THERE YOU SHOULD BE ABLE TO START FARES.<br/><br/>13. DOES THIS SERVER USE TEAMSPEAK? AND WHAT IS THE PUSH TO TALK BUTTON?<br/>NO THIS SERVER DOES NOT USE TEAMSPEAK, AND THE DEFAULT BIND FOR PUSH TO TALK IS [N], PLEASE CHECK #KEYBIND-COMMANDS FOR MORE INFO.<br/><br/>14. CAN I CHANGE MY PUSH TO TALK BUTTON?<br/>YES, GO TO GAME SETTINGS THEN KEYBINDS AND THERE YOU SHOULD BE ABLE TO CHANGE IT.<br/><br/>15. IS THERE A CAD SYSTEM FOR THIS SERVER?<br/>NO, THERE IS NOT<br/><br/>16. DO WE GET FREE APARTMENTS?<br/>NO YOU DO NOT')
});

$(document).on('click', '.characterEmpty', function(e){
    e.preventDefault();
    $('#charCreation').show()
    $('#charMenu').hide()
    selectedChar = $(this).attr('id').replace('char-', '')
});

$(document).on('click', '#create', function(e){
    e.preventDefault();
    firstname = $('#first_name').val();
    lastname = $('#last_name').val();
    nationality = $('#nationality').val();
    birthdate = $('#birthdate').val();

    if(firstname != "" && lastname != "" && nationality != "" && birthdate != "") {
        var cDataPed = $('#char-'+selectedChar).data('cData');
        $.post('http://lcrp-characters/cDataPed', JSON.stringify({
                    cData: cDataPed
                }));
    
        $.post('http://lcrp-characters/createNewCharacter', JSON.stringify({
            firstname: $('#first_name').val(),
            lastname: $('#last_name').val(),
            nationality: $('#nationality').val(),
            birthdate: $('#birthdate').val(),
            gender: $('select[name=gender]').val(),
            cid: selectedChar,
        }));
    
        $(".container").fadeOut(150);
        MultiCharacters.resetAll();   
    } else {
        if(firstname === "") {
            $("#charCreationP-fn").css("color","rgb(240, 48, 48)");
        }
        if(lastname === "") {
            $("#charCreationP-ln").css("color","rgb(240, 48, 48)");
        }
        if(nationality === "") {
            $("#charCreationP-nat").css("color","rgb(240, 48, 48)");
        }
        if(birthdate === "") {
            $("#charCreationP-bd").css("color","rgb(240, 48, 48)");
        }
        if(firstname != "") {
            $("#charCreationP-fn").css("color","white");
        }
        if(lastname != "") {
            $("#charCreationP-ln").css("color","white");
        }
        if(nationality != "") {
            $("#charCreationP-nat").css("color","white");
        }
        if(birthdate != "") {
            $("#charCreationP-bd").css("color","white");
        }
    }
});

$(document).on('click', '#cancel', function(e){
    e.preventDefault();
    $('#charCreation').hide()
    $('#charMenu').show()
});

$(document).on('click', '#del-cancel', function(e){
    e.preventDefault();
    $('.confirm-stage').hide()
});

$(document).on('click', '#del-confirm', function(e){
    e.preventDefault();
    $.post('http://lcrp-characters/removeCharacter', JSON.stringify({
        citizenid: $('#char-'+selectedChar).data("citizenid"),
            }))
    refreshCharacters()
});

MultiCharacters.resetAll = function() {
    $('.characters-list').show();
    $('.character-info').show();


    $.post('http://lcrp-characters/setupCharacters');
}

function refreshCharacters() {
    $('#charMenuCharacterSelect').html('<div class="character characterEmpty" id="char-1" data-cid=""><i class="far fa-plus-square fa-3x charMenuNoCharacterBoxImg"></i></div><div class="character characterEmpty" id="char-2" data-cid=""><i class="far fa-plus-square fa-3x charMenuNoCharacterBoxImg"></i></div><div class="character characterEmpty" id="char-3" data-cid=""><i class="far fa-plus-square fa-3x charMenuNoCharacterBoxImg"></i></div><div class="character characterEmpty" id="char-4" data-cid=""><i class="far fa-plus-square fa-3x charMenuNoCharacterBoxImg"></i></div><div class="character characterEmpty" id="char-5" data-cid=""><i class="far fa-plus-square fa-3x charMenuNoCharacterBoxImg"></i></div>')
    setTimeout(function(){
        selectedChar = null;
        $.post('http://lcrp-characters/setupCharacters');
        MultiCharacters.resetAll();
        startDroppable()
    }, 100)
}

function startDroppable(){
    $(".selectableCharacter").draggable({
        revert: true,
        zIndex: 100,
        start: function(event, ui){
            selectedChar = $(this).attr('id').replace('char-', '')

            switch(selectedChar) {
                case "1":
                    test = $("#char-2").html();
                    $("#char-2").html('<i class="far fa-trash-alt fa-4x" style="color:red;"></i>')
                    test2 = $("#char-3").html();
                    $("#char-3").html('<i class="far fa-trash-alt fa-4x" style="color:red;"></i>')
                    test3 = $("#char-4").html();
                    $("#char-4").html('<i class="far fa-trash-alt fa-4x" style="color:red;"></i>')
                    test4 = $("#char-5").html();
                    $("#char-5").html('<i class="far fa-trash-alt fa-4x" style="color:red;"></i>')
                  break;
                case "2":
                    test = $("#char-1").html();
                    $("#char-1").html('<i class="far fa-trash-alt fa-4x" style="color:red;"></i>')
                    test2 = $("#char-3").html();
                    $("#char-3").html('<i class="far fa-trash-alt fa-4x" style="color:red;"></i>')
                    test3 = $("#char-4").html();
                    $("#char-4").html('<i class="far fa-trash-alt fa-4x" style="color:red;"></i>')
                    test4 = $("#char-5").html();
                    $("#char-5").html('<i class="far fa-trash-alt fa-4x" style="color:red;"></i>')
                  break;
                case "3":
                    test = $("#char-2").html();
                    $("#char-2").html('<i class="far fa-trash-alt fa-4x" style="color:red;"></i>')
                    test2 = $("#char-1").html();
                    $("#char-1").html('<i class="far fa-trash-alt fa-4x" style="color:red;"></i>')
                    test3 = $("#char-4").html();
                    $("#char-4").html('<i class="far fa-trash-alt fa-4x" style="color:red;"></i>')
                    test4 = $("#char-5").html();
                    $("#char-5").html('<i class="far fa-trash-alt fa-4x" style="color:red;"></i>')
                break;
                case "4":
                    test = $("#char-2").html();
                    $("#char-2").html('<i class="far fa-trash-alt fa-4x" style="color:red;"></i>')
                    test2 = $("#char-3").html();
                    $("#char-3").html('<i class="far fa-trash-alt fa-4x" style="color:red;"></i>')
                    test3 = $("#char-1").html();
                    $("#char-1").html('<i class="far fa-trash-alt fa-4x" style="color:red;"></i>')
                    test4 = $("#char-5").html();
                    $("#char-5").html('<i class="far fa-trash-alt fa-4x" style="color:red;"></i>')
                break;
                case "5":
                    test = $("#char-2").html();
                    $("#char-2").html('<i class="far fa-trash-alt fa-4x" style="color:red;"></i>')
                    test2 = $("#char-3").html();
                    $("#char-3").html('<i class="far fa-trash-alt fa-4x" style="color:red;"></i>')
                    test3 = $("#char-4").html();
                    $("#char-4").html('<i class="far fa-trash-alt fa-4x" style="color:red;"></i>')
                    test4 = $("#char-1").html();
                    $("#char-1").html('<i class="far fa-trash-alt fa-4x" style="color:red;"></i>')
                break;
                default:
                  // code block
              } 
        },
        stop: function(event, ui){
            switch(selectedChar) {
                case "1":
                    $("#char-2").html(test)
                    $("#char-3").html(test2) 
                    $("#char-4").html(test3)
                    $("#char-5").html(test4)
                  break;
                case "2":
                    $("#char-1").html(test)
                    $("#char-3").html(test2) 
                    $("#char-4").html(test3)
                    $("#char-5").html(test4)
                    break;
                case "3":
                    $("#char-2").html(test)
                    $("#char-1").html(test2) 
                    $("#char-4").html(test3)
                    $("#char-5").html(test4)
                    break;
                case "4":
                    $("#char-2").html(test)
                    $("#char-3").html(test2) 
                    $("#char-1").html(test3)
                    $("#char-5").html(test4)
                  break;
                case "5":
                    $("#char-2").html(test)
                    $("#char-3").html(test2) 
                    $("#char-4").html(test3)
                    $("#char-1").html(test4)
                break;
                default:
                  // code block
              } 
        },
    })

    $( ".character" ).droppable({
        accept: ".selectableCharacter",
        drop: function (event, ui) {
            $("#"+event.target.id).removeClass("hoverable");
            var charData = $('#char-'+selectedChar).data('cid');
            if (selectedChar !== null) {
                if (charData !== "") {
                    $(".confirm-stage").show();
                }
            }
        },
        over: function (event, ui) {
            $("#"+event.target.id).addClass("hoverable");
        },
        out: function (event, ui) {
            $("#"+event.target.id).removeClass("hoverable");
        }
    })
}
