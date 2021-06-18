var InventoryOption = "120, 10, 20";

var totalWeight = 0;
var totalWeightOther = 0;

var playerMaxWeight = 0;
var otherMaxWeight = 0;

var otherLabel = "";

var ClickedItemData = {};
var loadedImg = 0;
var loadedGender = 0;

var SelectedAttachment = null;
var AttachmentScreenActive = false;
var ControlPressed = false;
var ShiftPressed = false;
var disableRightMouse = false;
var selectedItem = null;
var cash = 0;
var globalcash = 0;

var IsDragging = false;

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
            Inventory.Close();
            break;
        case 9: // TAB
            Inventory.Close();
            break;
        case 17: // CONTROL
            ControlPressed = true;
            break;
        case 16: // SHIFT
            ShiftPressed = true;
            break;
    }
});

$(document).on('keyup', function(){
    switch(event.keyCode) {
        case 17: // ctrl
            ControlPressed = false;
            break;
        case 16: // shift
            ShiftPressed = false;
            break;
    }
});

$(document).keydown(function(objEvent) {
    if (objEvent.keyCode == 112) {  //tab pressed
        objEvent.preventDefault(); // stops its action
    }
})

$(document).on("mouseenter", ".item-slot", function(e){
    e.preventDefault();
    if ($(this).data("item") != null) {
        $(".ply-iteminfo-container").fadeIn(150);
        $(".inv-options-container").fadeIn(150);
        FormatItemInfo($(this).data("item"));
    } else {
        $(".ply-iteminfo-container").fadeOut(100);
        $(".inv-options-container").fadeOut(100);
    }
});

$(document).on("mouseenter", ".inv-stats-sil-head", function(e){
    e.preventDefault();
    $(".inv-option-warning-p").html("Your head hurts!");
    $(".inv-option-warning").fadeIn(200);
});

$(document).on("mouseenter", ".inv-stats-sil-upperbody", function(e){
    e.preventDefault();
    $(".inv-option-warning-p").html("Your upper body is bruised!");
    $(".inv-option-warning").fadeIn(200);
});

$(document).on("mouseenter", ".inv-stats-sil-rarm", function(e){
    e.preventDefault();
    $(".inv-option-warning-p").html("Your right arm is injured!");
    $(".inv-option-warning").fadeIn(200);
});

$(document).on("mouseenter", ".inv-stats-sil-larm", function(e){
    e.preventDefault();
    $(".inv-option-warning-p").html("Your left arm is injured!");
    $(".inv-option-warning").fadeIn(200);
});

$(document).on("mouseenter", ".inv-stats-sil-rleg", function(e){
    e.preventDefault();
    $(".inv-option-warning-p").html("Your right leg is feeling painful!");
    $(".inv-option-warning").fadeIn(200);
});

$(document).on("mouseenter", ".inv-stats-sil-lleg", function(e){
    e.preventDefault();
    $(".inv-option-warning-p").html("Your left leg is feeling painful!");
    $(".inv-option-warning").fadeIn(200);
});

$(document).on("mouseleave", ".inv-bdy", function(e){
    e.preventDefault();
    $(".inv-option-warning").fadeOut(150);
});

$(document).on("mouseenter", ".inv-option-item", function(e){
    e.preventDefault();
    $(".inv-options-desctop").html("Enter SPLIT AMOUNT");
    $(".inv-options-desctop").fadeIn(150);
});

$(document).on("mouseleave", ".inv-option-item", function(e){
    e.preventDefault();
    $(".inv-options-desctop").fadeOut(100);
});

$(document).on("mouseenter", ".inv-option-stack", function(e){
    e.preventDefault();
    $(".inv-options-desctop").html("Stack ALL INVENTORY ITEMS");
    $(".inv-options-desctop").fadeIn(150);
});

$(document).on("mouseleave", ".inv-option-stack", function(e){
    e.preventDefault();
    $(".inv-options-desctop").fadeOut(100);
});

$(document).on("mouseenter", ".inv-option-trash", function(e){
    e.preventDefault();
    $(".inv-options-desctop").html("Drop to DELETE ITEM");
    $(".inv-options-desctop").fadeIn(150);
});

$(document).on("mouseleave", ".inv-option-trash", function(e){
    e.preventDefault();
    $(".inv-options-desctop").fadeOut(100);
});

$(document).on('mouseenter', '.item-slot', function () {
    item = $(this).data('item')
    fi = $(this).parent().attr("data-inventory")
    $(window).on('keydown', function (e) {
        var code = e.which ||e.keyCode;
        if (code == 71 && item != null) {
            if(fi === "player") {
                Inventory.Close();
                $.post("http://lcrp-inventory/GiveItem", JSON.stringify({
                    inventory: fi,
                    item: item,
                }));
            } else {
                fromSlot = $(this).attr("data-slot");
                fromInventory = $(this).parent();
                InventoryError(fromInventory, fromSlot);
            }
        } else if (code == 70) {
            if(fi === "player") {
                if(item.useable != null) {
                    if(item.useable) {
                        if (item.shouldClose) {
                            Inventory.Close();
                        }
                        $.post("http://lcrp-inventory/UseItem", JSON.stringify({
                            inventory: fi,
                            item: item,
                        }));
                    } else {
                        fromSlot = $(this).attr("data-slot");
                        fromInventory = $(this).parent();
                        InventoryError(fromInventory, fromSlot);
                    }
                } else {
                    fromSlot = $(this).attr("data-slot");
                fromInventory = $(this).parent();
                InventoryError(fromInventory, fromSlot);
                }
            } else {
                fromSlot = $(this).attr("data-slot");
                fromInventory = $(this).parent();
                InventoryError(fromInventory, fromSlot);
             }
        }
    });
});
$(document).on('mouseleave', '.item-slot', function () {
    $(window).off('keydown');
});

// Autostack Quickmove
function GetFirstFreeSlot($toInv, $fromSlot) {
    var retval = null;
    $.each($toInv.find('.item-slot'), function(i, slot){
        if ($(slot).data('item') === undefined) {
            if (retval === null) {
                retval = (i + 1);
            }
        }
    });
    return retval;
}

function CanQuickMove() {
    var otherinventory = otherLabel.toLowerCase();
    var retval = true;
    // if (otherinventory == "grond") {
    //     retval = false
    // } else if (otherinventory.split("-")[0] == "dropped") {
    //     retval = false;
    // }
    if (otherinventory.split("-")[0] == "player") {
        retval = false;
    }
    return retval;
}

$(document).on('mousedown', '.item-slot', function(event){
    switch(event.which) {
        case 3:
            fromSlot = $(this).attr("data-slot");
            fromInventory = $(this).parent();

            if ($(fromInventory).attr('data-inventory') == "player") {
                toInventory = $(".other-inventory");
            } else {
                toInventory = $(".player-inventory");
            }
            toSlot = GetFirstFreeSlot(toInventory, $(this));
            if ($(this).data('item') === undefined) {
                return;
            }
            toAmount = $(this).data('item').amount;
            if (ControlPressed) {
                if (toAmount > 1) {
                    toAmount = Math.round(toAmount / 2)
                }
                if (toSlot === null) {
                    toInventory = toInventory = $(".player-inventory");
                    toSlot = GetFirstFreeSlot(toInventory = $(".player-inventory"), $(this));
                }
            }
            if(ShiftPressed) {
                if (toAmount > 1) {
                    toAmount = $("#item-amount").val();
                }
                if (toSlot === null) {
                    toInventory = toInventory = $(".player-inventory");
                    toSlot = GetFirstFreeSlot(toInventory = $(".player-inventory"), $(this));
                }
            }
            if($(this).data("item") != null) {
                if($(this).data("item").price != null) {
                    InventoryError(fromInventory, fromSlot);
                    return;
                }
            }
            if (CanQuickMove()) {
                if (toSlot === null) {
                    InventoryError(fromInventory, fromSlot);
                    return;
                }
                if (fromSlot == toSlot && fromInventory == toInventory) {
                    return;
                }
                if (toAmount >= 0) {
                    if (updateweights(fromSlot, toSlot, fromInventory, toInventory, toAmount)) {
                        swap(fromSlot, toSlot, fromInventory, toInventory, toAmount);
                    }
                }
            } else {
                InventoryError(fromInventory, fromSlot);
            }
            break;
    }
});

$(document).on("click", ".item-slot", function(e){
    e.preventDefault();
    var ItemData = $(this).data("item");

    if (ItemData !== null && ItemData !== undefined) {
        if (ItemData.name !== undefined) {
            if ((ItemData.name).split("_")[0] == "weapon") {
                if (!$("#weapon-attachments").length) {
                    // if (ItemData.info.attachments !== null && ItemData.info.attachments !== undefined && ItemData.info.attachments.length > 0) {
                    $(".inv-options-list").append('<div class="inv-option-item" id="weapon-attachments"><p>ATTACHMENTS</p></div>');
                    $("#weapon-attachments").hide().fadeIn(250);
                    ClickedItemData = ItemData;
                    // }
                } else if (ClickedItemData == ItemData) {
                    $("#weapon-attachments").fadeOut(250, function(){
                        $("#weapon-attachments").remove();
                    });
                    ClickedItemData = {};
                } else {
                    ClickedItemData = ItemData;
                }
            } else {
                ClickedItemData = {};
                if ($("#weapon-attachments").length) {
                    $("#weapon-attachments").fadeOut(250, function(){
                        $("#weapon-attachments").remove();
                    });
                }
            }
        } else {
            ClickedItemData = {};
            if ($("#weapon-attachments").length) {
                $("#weapon-attachments").fadeOut(250, function(){
                    $("#weapon-attachments").remove();
                });
            } 
        }
    } else {
        ClickedItemData = {};
        if ($("#weapon-attachments").length) {
            $("#weapon-attachments").fadeOut(250, function(){
                $("#weapon-attachments").remove();
            });
        } 
    }
});

$(document).on('click', '.weapon-attachments-back', function(e){
    e.preventDefault();
    $("#qbus-inventory").css({"display":"block"});
    $("#qbus-inventory").animate({
        left: 0+"vw"
    }, 200);
    $(".weapon-attachments-container").animate({
        left: -100+"vw"
    }, 200, function(){
        $(".weapon-attachments-container").css({"display":"none"});
    });
    AttachmentScreenActive = false;
});

function FormatAttachmentInfo(data) {
    $.post("http://lcrp-inventory/GetWeaponData", JSON.stringify({
        weapon: data.name,
        ItemData: ClickedItemData
    }), function(data){
        var AmmoLabel = "9mm";
        var Durability = 100;
        if (data.WeaponData.ammotype == "AMMO_RIFLE") {
            AmmoLabel = "7.62"
        } else if (data.WeaponData.ammotype == "AMMO_SHOTGUN") {
            AmmoLabel = "12 Gauge"
        }
        if (ClickedItemData.info.quality !== undefined) {
            Durability = ClickedItemData.info.quality;
        }

        $(".weapon-attachments-container-title").html(data.WeaponData.label + " | " + AmmoLabel);
        $(".weapon-attachments-container-description").html(data.WeaponData.description);
        $(".weapon-attachments-container-details").html('<span style="font-weight: bold; letter-spacing: .1vh;">Serial number</span><br> ' + ClickedItemData.info.serie + '<br><br><span style="font-weight: bold; letter-spacing: .1vh;">Durability - ' + Durability.toFixed() + '% </span> <div class="weapon-attachments-container-detail-durability"><div class="weapon-attachments-container-detail-durability-total"></div></div>')
        $(".weapon-attachments-container-detail-durability-total").css({
            width: Durability + "%"
        });
        $(".weapon-attachments-container-image").attr('src', './attachment_images/' + data.WeaponData.name + '.png');
        $(".weapon-attachments").html("");

        if (data.AttachmentData !== null && data.AttachmentData !== undefined) {
            if (data.AttachmentData.length > 0) {
                $(".weapon-attachments-title").html('<span style="font-weight: bold; letter-spacing: .1vh;">Attachments</span>');
                $.each(data.AttachmentData, function(i, attachment){
                    var WeaponType = (data.WeaponData.ammotype).split("_")[1].toLowerCase();
                    $(".weapon-attachments").append('<div class="weapon-attachment" id="weapon-attachment-'+i+'"> <div class="weapon-attachment-label"><p>' + attachment.label + '</p></div> <div class="weapon-attachment-img"><img src="./images/' + WeaponType + '_' + attachment.attachment + '.png"></div> </div>')
                    attachment.id = i;
                    $("#weapon-attachment-"+i).data('AttachmentData', attachment)
                });
            } else {
                $(".weapon-attachments-title").html('<span style="font-weight: bold; letter-spacing: .1vh;">This weapon does not contain attachments</span>');
            }
        } else {
            $(".weapon-attachments-title").html('<span style="font-weight: bold; letter-spacing: .1vh;">This weapon does not contain attachments</span>');
        }

        handleAttachmentDrag()
    });
}

var AttachmentDraggingData = {};

function handleAttachmentDrag() {
    $(".weapon-attachment").draggable({
        helper: 'clone',
        appendTo: "body",
        scroll: true,
        revertDuration: 0,
        revert: "invalid",
        start: function(event, ui) {
           var ItemData = $(this).data('AttachmentData');
           $(this).addClass('weapon-dragging-class');
           AttachmentDraggingData = ItemData
        },
        stop: function() {
            $(this).removeClass('weapon-dragging-class');
        },
    });
    $(".weapon-attachments-remove").droppable({
        accept: ".weapon-attachment",
        hoverClass: 'weapon-attachments-remove-hover',
        drop: function(event, ui) {
            $.post('http://lcrp-inventory/RemoveAttachment', JSON.stringify({
                AttachmentData: AttachmentDraggingData,
                WeaponData: ClickedItemData,
            }), function(data){
                if (data.Attachments !== null && data.Attachments !== undefined) {
                    if (data.Attachments.length > 0) {
                        $("#weapon-attachment-" + AttachmentDraggingData.id).fadeOut(150, function(){
                            $("#weapon-attachment-" + AttachmentDraggingData.id).remove();
                            AttachmentDraggingData = null;
                        });
                    } else {
                        $("#weapon-attachment-" + AttachmentDraggingData.id).fadeOut(150, function(){
                            $("#weapon-attachment-" + AttachmentDraggingData.id).remove();
                            AttachmentDraggingData = null;
                            $(".weapon-attachments").html("");
                        });
                        $(".weapon-attachments-title").html('<span style="font-weight: bold; letter-spacing: .1vh;">This weapon does not contain attachments</span>');
                    }
                } else {
                    $("#weapon-attachment-" + AttachmentDraggingData.id).fadeOut(150, function(){
                        $("#weapon-attachment-" + AttachmentDraggingData.id).remove();
                        AttachmentDraggingData = null;
                        $(".weapon-attachments").html("");
                    });
                    $(".weapon-attachments-title").html('<span style="font-weight: bold; letter-spacing: .1vh;">This weapon does not contain attachments</span>');
                }
            });
        },
    });
}

$(document).on('click', '#weapon-attachments', function(e){
    e.preventDefault();
    if (!Inventory.IsWeaponBlocked(ClickedItemData.name)) {
        $(".weapon-attachments-container").css({"display":"block"})
        $("#qbus-inventory").animate({
            left: 100+"vw"
        }, 200, function(){
            $("#qbus-inventory").css({"display":"none"})
        });
        $(".weapon-attachments-container").animate({
            left: 0+"vw"
        }, 200);
        AttachmentScreenActive = true;
        FormatAttachmentInfo(ClickedItemData);    
    } else {
        $.post('http://lcrp-inventory/Notify', JSON.stringify({
            message: "Attachments aren't available for this weapon.",
            type: "error"
        }))
    }
});

function FormatItemInfo(itemData) {
    if (itemData != null && itemData.info != "") {
        var gender = "Man";
        if (itemData.info.gender == 1) {
            gender = "Women";
        }
        if (itemData.name == "id_card") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p><strong>SSN: </strong><span>' + itemData.info.citizenid + '</span></p><p><strong>First Name: </strong><span>' + itemData.info.firstname + '</span></p><p><strong>Last Name: </strong><span>' + itemData.info.lastname + '</span></p><p><strong>Date of birth: </strong><span>' + itemData.info.birthdate + '</span></p><p><strong>Gender: </strong><span>' + gender + '</span></p><p><strong>Nationality: </strong><span>' + itemData.info.nationality + '</span></p>');
        } else if (itemData.name == "badge") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p><strong>Callsign: </strong><span>' + itemData.info.callsign + '</span></p><p><strong>Job: </strong><span>' + itemData.info.job + ' | ' + itemData.info.jobrole + '</span></p><p><strong>First Name: </strong><span>' + itemData.info.firstname + '</span></p><p><strong>Last Name: </strong><span>' + itemData.info.lastname + '</span></p><p><strong>Date of birth: </strong><span>' + itemData.info.birthdate + '</span></p><p><strong>Gender: </strong><span>' + gender + '</span></p><p><strong>Nationality: </strong><span>' + itemData.info.nationality + '</span></p>');
        } else if (itemData.name == "driver_license") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p><strong>First Name: </strong><span>' + itemData.info.firstname + '</span></p><p><strong>Last Name: </strong><span>' + itemData.info.lastname + '</span></p><p><strong>Date of birth: </strong><span>' + itemData.info.birthdate + '</span></p><p><strong>Licenses: </strong><span>' + itemData.info.type + '</span></p>');
        } else if (itemData.name == "lawyerpass") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p><strong>ID: </strong><span>' + itemData.info.id + '</span></p><p><strong>First Name: </strong><span>' + itemData.info.firstname + '</span></p><p><strong>Last Name: </strong><span>' + itemData.info.lastname + '</span></p><p><strong>SSN: </strong><span>' + itemData.info.citizenid + '</span></p>');
        } else if (itemData.name == "harness") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p>You can use it for '+itemData.info.uses+'x times.</p>');
        } else if (itemData.type == "weapon") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            if (itemData.info.ammo == undefined) {
                itemData.info.ammo = 0;
            } else {
                itemData.info.ammo != null ? itemData.info.ammo : 0;
            }
            if (itemData.info.attachments != null) {
                var attachmentString = "";
                $.each(itemData.info.attachments, function (i, attachment) {
                    if (i == (itemData.info.attachments.length - 1)) {
                        attachmentString += attachment.label
                    } else {
                        attachmentString += attachment.label + ", "
                    }
                });
                if (itemData.info.firstname == undefined || itemData.info.lastname == undefined) {
                    $(".item-info-description").html('<p><strong>Serial Number: </strong><span>' + itemData.info.serie + '</span></p><p><strong>Attachments: </strong><span>' + attachmentString + '</span></p><p><strong>Not Registered</strong><span>' + '</span></p>');
                } else if (itemData.info.bought == undefined)
                {
                    $(".item-info-description").html('<p><strong>Serial Number: </strong><span>' + itemData.info.serie + '</span></p><p>' + itemData.description + '</span></p><p><strong>Attachments: </strong><span>' + attachmentString + '</span></p><p><strong> Registered To: </strong><span>' + itemData.info.firstname + ' ' + itemData.info.lastname + '</p>');
                } else {
                    $(".item-info-description").html('<p><strong>Serial Number: </strong><span>' + itemData.info.serie + '</span></p><p>' + itemData.description + '</span></p><p><strong> Registered To: </strong><span>' + itemData.info.firstname + ' ' + itemData.info.lastname + '</p><p><strong>Sold by: </strong><span>' + itemData.info.bought +'</span></p>');

                }
            } else
            {
        
                if (itemData.info.firstname == undefined || itemData.info.lastname == undefined) {
                    $(".item-info-description").html('<p><strong>Serial Number: </strong><span>' + itemData.info.serie + '</span></p><p>' + itemData.description + '</span></p><p><strong>Not Registered</strong><span>' + '</p>');
                } else if (itemData.info.bought == undefined)
                {
                    $(".item-info-description").html('<p><strong>Serial Number: </strong><span>' + itemData.info.serie + '</span></p><p>' + itemData.description + '</span></p><p><strong> Registered To: </strong><span>' + itemData.info.firstname + ' ' + itemData.info.lastname + '</p>');
                } else {
                    $(".item-info-description").html('<p><strong>Serial Number: </strong><span>' + itemData.info.serie + '</span></p><p>' + itemData.description + '</span></p><p><strong> Registered To: </strong><span>' + itemData.info.firstname + ' ' + itemData.info.lastname + '</p><p><strong>Sold by: </strong><span>' + itemData.info.bought +'</span></p>');

                }
            }

        } else if (itemData.name == "evidence_report") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            if (itemData.info.type == "dna") {
                $(".item-info-description").html('<p><strong>Evidence: </strong><span>' + itemData.info.label + '</span></p><p><strong>Blood group: </strong><span>' + itemData.info.bloodtype + '</span></p><p><strong>DNA Code: </strong><span>' + itemData.info.dnalabel + '</span></p><p><strong>Crime scene: </strong><span>' + itemData.info.street + '</span></p><p><strong>Suspect: </strong><span>' + itemData.info.suspect + '</span></p><br /><p>' + itemData.description + '</p>');
            }
        } else if (itemData.name == "filled_evidence_bag") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            if (itemData.info.type == "casing") {
                $(".item-info-description").html('<p><strong>Evidence: </strong><span>' + itemData.info.label + '</span></p><p><strong>Type number: </strong><span>' + itemData.info.ammotype + '</span></p><p><strong>Caliber: </strong><span>' + itemData.info.ammolabel + '</span></p><p><strong>Serial Number: </strong><span>' + itemData.info.serie + '</span></p><p><strong>Crime scene: </strong><span>' + itemData.info.street + '</span></p><br /><p>' + itemData.description + '</p>');
            }else if (itemData.info.type == "blood") {
                $(".item-info-description").html('<p><strong>Evidence: </strong><span>' + itemData.info.label + '</span></p><p><strong>Blood group: </strong><span>' + itemData.info.bloodtype + '</span></p><p><strong>DNA Code: </strong><span>' + itemData.info.dnalabel + '</span></p><p><strong>Crime scene: </strong><span>' + itemData.info.street + '</span></p><br /><p>' + itemData.description + '</p>');
            }else if (itemData.info.type == "fingerprint") {
                $(".item-info-description").html('<p><strong>Evidence: </strong><span>' + itemData.info.label + '</span></p><p><strong>Finger pattern: </strong><span>' + itemData.info.fingerprint + '</span></p><p><strong>Crime scene: </strong><span>' + itemData.info.street + '</span></p><br /><p>' + itemData.description + '</p>');
            }else if (itemData.info.type == "dna") {
                $(".item-info-description").html('<p><strong>Evidence: </strong><span>' + itemData.info.label + '</span></p><p><strong>DNA Code: </strong><span>' + itemData.info.dnalabel + '</span></p><br /><p>' + itemData.description + '</p>');
            }
        } else if (itemData.info.costs != undefined && itemData.info.costs != null) {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p>'+ itemData.info.costs + '</p>');
        } else if (itemData.name == "weaponblueprint") {
            $(".item-info-description").html('<p><strong>Type: </strong><span>' + itemData.info.type + '</span></p>');
        } else if (itemData.name == "stickynote") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p>'+ itemData.info.label + '</p>');
        } else if (itemData.name == "moneybag") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p><strong>Cash amount: </strong><span>$' + itemData.info.cash + '</span></p>');
        } else if (itemData.name == "markedbills") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p><strong>Worth: </strong><span>$' + itemData.info.worth + '</span></p>');
        } else if (itemData.name == "labkey") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p>Lab: ' + itemData.info.lab + '</p>');
        } else if (itemData.name == "cryptostick") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            var s =""
            if(itemData.info.type == undefined){
                s = s + '<p>Type: Unregistered</p>'
            } else {
                s = s + '<p>Type: ' + itemData.info.type + '</p>';
            }
            if(itemData.info.password == undefined){
                s = s + '<p>Password: Not Set</p>';
            } else {
                s = s + '<p>Password: ' + itemData.info.password + '</p>';
            }
            if(itemData.info.firstname == undefined || itemData.info.lastname == undefined){
                s = s + '<p>Resgistered to: Not Registered</p>';
            } else {
                s = s + '<p><strong> Registered To: </strong><span>' + itemData.info.firstname + ' ' + itemData.info.lastname + '</p>';
            }
            $(".item-info-description").html(s)
            
        } else {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p>' + itemData.description + '</p>')
        }
    } else {
        $(".item-info-title").html('<p>'+itemData.label+'</p>')
        $(".item-info-description").html('<p>' + itemData.description + '</p>')
    }
 }

function handleDragDrop() {
    $(".item-drag").draggable({
        helper: 'clone',
        appendTo: "body",
        scroll: true,
        revertDuration: 0,
        revert: "invalid",
        cancel: ".item-nodrag",
        start: function(event, ui) {
            if($(this).parent().attr("class") === "player-inventory") {
                $(".inv-option-trash").show();
            }
            IsDragging = true;
           // $(this).css("background", "rgba(20,20,20,1.0)");
            $(this).find("img").css("filter", "brightness(50%)");

            $(".item-slot").css("border", "1px solid rgba(255, 255, 255, 0.1)")

            var itemData = $(this).data("item");
            var dragAmount = 0;
            if(ControlPressed) {
                dragAmount = Math.round(itemData.amount/2);
            }
            if(ShiftPressed) {
                dragAmount = $("#item-amount").val();
            }
            if (!itemData.useable) {
                $("#item-use").css("background", "rgba(35,35,35, 0.5");
            }
            if ( dragAmount == 0) {
                if (itemData.price != null) {
                    $(".ui-draggable-dragging").find(".item-slot-amount p").html('('+itemData.amount+') $' + itemData.price);
                    $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    if ($(this).parent().attr("data-inventory") == "hotbar") {
                        // $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    }
                } else {
                    $(".ui-draggable-dragging").find(".item-slot-amount p").html(itemData.amount + ' (' + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + ')');
                    $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    if ($(this).parent().attr("data-inventory") == "hotbar") {
                        // $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    }
                }
            } else if(dragAmount > itemData.amount) {
                if (itemData.price != null) {
                    $(this).find(".item-slot-amount p").html('('+itemData.amount+') $' + itemData.price);
                    if ($(this).parent().attr("data-inventory") == "hotbar") {
                        // $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    }
                } else {
                    $(this).find(".item-slot-amount p").html(itemData.amount + ' (' + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + ')');
                    if ($(this).parent().attr("data-inventory") == "hotbar") {
                        // $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    }
                }
                InventoryError($(this).parent(), $(this).attr("data-slot"));
            } else if(dragAmount > 0) {
                if (itemData.price != null) {
                    $(this).find(".item-slot-amount p").html('('+itemData.amount+') $' + itemData.price);
                    $(".ui-draggable-dragging").find(".item-slot-amount p").html('('+itemData.amount+') $' + itemData.price);
                    $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    if ($(this).parent().attr("data-inventory") == "hotbar") {
                        // $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    }
                } else {
                    $(this).find(".item-slot-amount p").html((itemData.amount - dragAmount) + ' (' + ((itemData.weight * (itemData.amount - dragAmount)) / 1000).toFixed(1) + ')');
                    $(".ui-draggable-dragging").find(".item-slot-amount p").html(dragAmount + ' (' + ((itemData.weight * dragAmount) / 1000).toFixed(1) + ')');
                    $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    if ($(this).parent().attr("data-inventory") == "hotbar") {
                        // $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    }
                }
            } else {
                if ($(this).parent().attr("data-inventory") == "hotbar") {
                    // $(".ui-draggable-dragging").find(".item-slot-key").remove();
                }
                $(".ui-draggable-dragging").find(".item-slot-key").remove();
                $(this).find(".item-slot-amount p").html(itemData.amount + ' (' + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + ')');
                InventoryError($(this).parent(), $(this).attr("data-slot"));
            }
        },
        stop: function() {
            setTimeout(function(){
                IsDragging = false;
            }, 300)
            $(".inv-option-trash").hide();
            $(this).find("img").css("filter", "brightness(100%)");
            $("#item-use").css("background", "rgba("+InventoryOption+", 0.3)");
        },
    });

    $(".item-slot").droppable({
        hoverClass: 'item-slot-hoverClass',
        drop: function(event, ui) {
            setTimeout(function(){
                IsDragging = false;
            }, 300)
            fromSlot = ui.draggable.attr("data-slot");
            fromInventory = ui.draggable.parent();
            toSlot = $(this).attr("data-slot");
            toInventory = $(this).parent();
            toAmount = 0;
            if(ControlPressed) {
                toAmount = Math.round(fromInventory.find("[data-slot=" + ui.draggable.attr("data-slot") +"]").data("item").amount/2);
            }
            if(ShiftPressed) {
                toAmount = $("#item-amount").val();
            }
            if (fromSlot == toSlot && fromInventory == toInventory) {
                return;
            }
            if(ui.draggable.data("item").price != null) {
                if(ControlPressed === false && ShiftPressed === false) {
                    toAmount = 1;
                }
            }
            if (toAmount >= 0) {
                if (updateweights(fromSlot, toSlot, fromInventory, toInventory, toAmount)) {
                    swap(fromSlot, toSlot, fromInventory, toInventory, toAmount);
                }
            }
        },
    });

    $("#item-use").droppable({
        hoverClass: 'button-hover',
        drop: function(event, ui) {
            setTimeout(function(){
                IsDragging = false;
            }, 300)
            fromData = ui.draggable.data("item");
            fromInventory = ui.draggable.parent().attr("data-inventory");
            if(fromData.useable) {
                if (fromData.shouldClose) {
                    Inventory.Close();
                }
                $.post("http://lcrp-inventory/UseItem", JSON.stringify({
                    inventory: fromInventory,
                    item: fromData,
                }));
            }
        }
    });

    // Drag item to close button
    $("#close-inv").droppable({
        hoverClass: 'button-hover',
        drop: function(event, ui) {
            setTimeout(function(){
                IsDragging = false;
            }, 300)
            Inventory.Close();
        }
    });
    // Press Close Button
    $(".close-inv").click(function(){
        Inventory.Close();
    });
    $("#item-stack").click(function(){
        var fromInventory = $(".player-inventory");
        var toInventory = $(".player-inventory");
        $('.player-inventory').children().each(function () {
            if($(this).attr("data-slot") != null && $(this).data("item") != null) {
                if($(this).data("item").unique === false) {
                    var name = $(this).data("item").name;
                    var toSlot = $(this).attr("data-slot");
                    $('.player-inventory').children().each(function () {
                        if($(this).attr("data-slot") != null && $(this).data("item") != null) {
                            if($(this).data("item").name === name && $(this).attr("data-slot") != toSlot) {
                                fromSlot = $(this).attr("data-slot");
                                toAmount = 0;
                                if (updateweights(fromSlot, toSlot, fromInventory, toInventory, toAmount)) {
                                    swap(fromSlot, toSlot, fromInventory, toInventory, toAmount);
                                }
                            }
                        }
                    });
                }
            }   
        });
    });
    $("#item-sort").click(function(){
        if($("#item-sort-span").attr("class") === "fas fa-sort-amount-down fa-lg") {
            $('#item-sort-span').removeClass('fas fa-sort-amount-down fa-lg').addClass('fas fa-sort-amount-up fa-lg');
            //sort ascending a-z
            var fromInventory = $(".player-inventory");
            var toInventory = $(".player-inventory");
            $('.player-inventory').children().each(function () {
                if($(this).attr("data-slot") != null && $(this).data("item") != null) {
                    var name = $(this).data("item").name;
                    var toSlot = $(this).attr("data-slot");
                    $('.player-inventory').children().each(function () {
                        if($(this).attr("data-slot") != null && $(this).data("item") != null) {
                            if($(this).data("item").name.localeCompare(name)  === -1) {
                                fromSlot = $(this).attr("data-slot");
                                toAmount = 0;
                                if (updateweights(fromSlot, toSlot, fromInventory, toInventory, toAmount)) {
                                    swap(fromSlot, toSlot, fromInventory, toInventory, toAmount);
                                }
                            }
                        }
                    });
                }
            });
        } else {
            $('#item-sort-span').removeClass('fas fa-sort-amount-up fa-lg').addClass('fas fa-sort-amount-down fa-lg');
            //sort descending z-a
            var fromInventory = $(".player-inventory");
            var toInventory = $(".player-inventory");
            $('.player-inventory').children().each(function () {
                if($(this).attr("data-slot") != null && $(this).data("item") != null) {
                    var name = $(this).data("item").name;
                    var fromSlot = $(this).attr("data-slot");
                    $('.player-inventory').children().each(function () {
                        if($(this).attr("data-slot") != null && $(this).data("item") != null) {
                            if($(this).data("item").name.localeCompare(name)  === -1) {
                                toSlot = $(this).attr("data-slot");
                                toAmount = 0;
                                if (updateweights(fromSlot, toSlot, fromInventory, toInventory, toAmount)) {
                                    swap(fromSlot, toSlot, fromInventory, toInventory, toAmount);
                                }
                            }
                        }
                    });
                }
            });
        }
    });
    $("#give-item").droppable({
        hoverClass: 'button-hover',
        drop: function(event, ui) {
            setTimeout(function(){
                IsDragging = false;
            }, 300)
            fromData = ui.draggable.data("item");
            fromInventory = ui.draggable.parent().attr("data-inventory");

            Inventory.Close();
            $.post("http://lcrp-inventory/GiveItem", JSON.stringify({
                inventory: fromInventory,
                item: fromData,
            }));
        }
    });
    $(".inv-option-trash").droppable({
        hoverClass: 'button-hover',
        drop: function(event, ui) {
            setTimeout(function(){
                IsDragging = false;
            }, 300)
            lvlamnt = parseInt(ui.draggable.data("item").amount);
            amount =  parseInt(ui.draggable.data("item").amount);
            fromSlot =ui.draggable.attr("data-slot");
            fromInv = $(".player-inventory");
            if(ControlPressed) {
                amount =  Math.round(parseInt(ui.draggable.data("item").amount)/2);
                ui.draggable.data("item").amount = amount;
            }
            if(ShiftPressed) {
                if($("#item-amount").val() >= amount) {
                    amount = amount;
                    fromInv.find("[data-slot=" + fromSlot + "]").removeClass("item-drag");
                    fromInv.find("[data-slot=" + fromSlot + "]").addClass("item-nodrag");
                    fromInv.find("[data-slot=" + fromSlot + "]").removeData("item");
                    if(fromSlot < 6) {
                        fromInv.find("[data-slot=" + fromSlot + "]").html('<div class="item-slot-key"><p>' + fromSlot + '</p></div><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div>');
                    } else {
                        fromInv.find("[data-slot=" + fromSlot + "]").html('<div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div>');
                    }
                    $.post("http://lcrp-inventory/PlayDropSound", JSON.stringify({}));
                    $.post("http://lcrp-inventory/SetInventoryData", JSON.stringify({
                        fromInventory: "remove",
                        toInventory: "",
                        fromSlot: fromSlot,
                        toSlot: 0,
                        fromAmount: amount,
                    }));
                    return;
                } else {
                    amount = $("#item-amount").val();
                    fromInv.find("[data-slot=" + fromSlot + "]").data("item").amount = lvlamnt - amount;
                }
            }

            if(amount < lvlamnt) {
                fromInv.find("[data-slot=" + fromSlot + "]").data("item").amount = lvlamnt - amount;
            } else {
                fromInv.find("[data-slot=" + fromSlot + "]").removeClass("item-drag");
                fromInv.find("[data-slot=" + fromSlot + "]").addClass("item-nodrag");
                fromInv.find("[data-slot=" + fromSlot + "]").removeData("item");
                if(fromSlot < 6) {
                    fromInv.find("[data-slot=" + fromSlot + "]").html('<div class="item-slot-key"><p>' + fromSlot + '</p></div><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div>');
                } else {
                    fromInv.find("[data-slot=" + fromSlot + "]").html('<div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div>');
                }
            }
            $.post("http://lcrp-inventory/PlayDropSound", JSON.stringify({}));
            $.post("http://lcrp-inventory/SetInventoryData", JSON.stringify({
                fromInventory: "remove",
                toInventory: "",
                fromSlot: fromSlot,
                toSlot: 0,
                fromAmount: amount,
            }));
        }
    });

    $("#item-drop").droppable({
        hoverClass: 'item-slot-hoverClass',
        drop: function(event, ui) {
            setTimeout(function(){
                IsDragging = false;
            }, 300)
            fromData = ui.draggable.data("item");
            fromInventory = ui.draggable.parent().attr("data-inventory");
            amount = $("#item-amount").val();
            if (amount == 0) {amount=fromData.amount}
            $(this).css("background", "rgba(0,127,0, 0.7");
            $.post("http://lcrp-inventory/DropItem", JSON.stringify({
                inventory: fromInventory,
                item: fromData,
                amount: parseInt(amount),
            }));
        }
    })
}

function updateweights($fromSlot, $toSlot, $fromInv, $toInv, $toAmount) {
    var otherinventory = otherLabel.toLowerCase();
    if (otherinventory.split("-")[0] == "dropped") {
        toData = $toInv.find("[data-slot=" + $toSlot + "]").data("item");
        if (toData !== null && toData !== undefined) {
            InventoryError($fromInv, $fromSlot);
            return false;
        }
    }

    if (($fromInv.attr("data-inventory") == "hotbar" && $toInv.attr("data-inventory") == "player") || ($fromInv.attr("data-inventory") == "player" && $toInv.attr("data-inventory") == "hotbar") || ($fromInv.attr("data-inventory") == "player" && $toInv.attr("data-inventory") == "player") || ($fromInv.attr("data-inventory") == "hotbar" && $toInv.attr("data-inventory") == "hotbar")) {
        return true;
    }

    if (($fromInv.attr("data-inventory").split("-")[0] == "itemshop" && $toInv.attr("data-inventory").split("-")[0] == "itemshop") || ($fromInv.attr("data-inventory") == "crafting" && $toInv.attr("data-inventory") == "crafting")) {
        itemData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
        if ($fromInv.attr("data-inventory").split("-")[0] == "itemshop") {
            $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + itemData.image + '" alt="' + itemData.name + '" /></div><div class="item-slot-amount"><p>('+itemData.amount+') $'+itemData.price+'</p></div><div class="item-slot-label"><p>' + itemData.label + '</p></div>');
        } else {
            $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + itemData.image + '" alt="' + itemData.name + '" /></div><div class="item-slot-amount"><p>'+itemData.amount + ' (' + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + itemData.label + '</p></div>');

        }

        InventoryError($fromInv, $fromSlot);
        return false;
    }

    if ($toAmount == 0 && ($fromInv.attr("data-inventory").split("-")[0] == "itemshop" || $fromInv.attr("data-inventory") == "crafting")) {
        itemData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
        if ($fromInv.attr("data-inventory").split("-")[0] == "itemshop") {
            $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + itemData.image + '" alt="' + itemData.name + '" /></div><div class="item-slot-amount"><p>('+itemData.amount+') $'+itemData.price+'</p></div><div class="item-slot-label"><p>' + itemData.label + '</p></div>');
        } else {
            $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + itemData.image + '" alt="' + itemData.name + '" /></div><div class="item-slot-amount"><p>'+itemData.amount + ' (' + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + itemData.label + '</p></div>');
        }
 
        InventoryError($fromInv, $fromSlot);
        return false;
    }

    if ($toInv.attr("data-inventory").split("-")[0] == "itemshop" || $toInv.attr("data-inventory") == "crafting") {
        itemData = $toInv.find("[data-slot=" + $toSlot + "]").data("item");
        if ($toInv.attr("data-inventory").split("-")[0] == "itemshop") {
            $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src="images/' + itemData.image + '" alt="' + itemData.name + '" /></div><div class="item-slot-amount"><p>('+itemData.amount+') $'+itemData.price+'</p></div><div class="item-slot-label"><p>' + itemData.label + '</p></div>');
        } else {
            $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src="images/' + itemData.image + '" alt="' + itemData.name + '" /></div><div class="item-slot-amount"><p>'+itemData.amount + ' (' + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + itemData.label + '</p></div>');
        }
 
        InventoryError($fromInv, $fromSlot);
        return false;
    }

    if ($fromInv.attr("data-inventory") != $toInv.attr("data-inventory")) {
        fromData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
        toData = $toInv.find("[data-slot=" + $toSlot + "]").data("item");
        var oldTotalWeight = totalWeight
        if ($toAmount == 0) {$toAmount=fromData.amount}
        if (toData == null || fromData.name == toData.name) {
            if ($fromInv.attr("data-inventory") == "player" || $fromInv.attr("data-inventory") == "hotbar") {
                totalWeight = totalWeight - (fromData.weight * $toAmount);
                totalWeightOther = totalWeightOther + (fromData.weight * $toAmount);
            } else {
                if (stashName == "stash-policeevidence" && plyJobGrade < 9 || stashName == "stash-policeevidence2" && plyJobGrade < 9) {
                    InventoryError($fromInv, $fromSlot);
                    return false;
                } else {
                    totalWeight = totalWeight + (fromData.weight * $toAmount);
                    totalWeightOther = totalWeightOther - (fromData.weight * $toAmount);
                }
            }
        } else {
            if ($fromInv.attr("data-inventory") == "player" || $fromInv.attr("data-inventory") == "hotbar") {
                totalWeight = totalWeight - (fromData.weight * $toAmount);
                totalWeight = totalWeight + (toData.weight * toData.amount)

                totalWeightOther = totalWeightOther + (fromData.weight * $toAmount);
                totalWeightOther = totalWeightOther - (toData.weight * toData.amount);
            } else {
                totalWeight = totalWeight + (fromData.weight * $toAmount);
                totalWeight = totalWeight - (toData.weight * toData.amount)

                totalWeightOther = totalWeightOther - (fromData.weight * $toAmount);
                totalWeightOther = totalWeightOther + (toData.weight * toData.amount);
            }
        }
    }

    if (totalWeight > playerMaxWeight || (totalWeightOther > otherMaxWeight && $fromInv.attr("data-inventory").split("-")[0] != "itemshop" && $fromInv.attr("data-inventory") != "crafting")) {
        totalWeight = oldTotalWeight
        InventoryError($fromInv, $fromSlot);
        return false;
    }

    $("#player-inv-weight").html("Weight: " + (parseInt(totalWeight) / 1000).toFixed(2) + " / " + (playerMaxWeight / 1000).toFixed(2));
    if ($fromInv.attr("data-inventory").split("-")[0] != "itemshop" && $toInv.attr("data-inventory").split("-")[0] != "itemshop" && $fromInv.attr("data-inventory") != "crafting" && $toInv.attr("data-inventory") != "crafting") {
        $("#other-inv-label").html(otherLabel)
        $("#other-inv-weight").html("Weight: " + (parseInt(totalWeightOther) / 1000).toFixed(2) + " / " + (otherMaxWeight / 1000).toFixed(2))
    }

    return true;
}

var combineslotData = null;

$(document).on('click', '.CombineItem', function(e){
    e.preventDefault();
    if (combineslotData.toData.combinable.anim != null) {
        $.post('http://lcrp-inventory/combineWithAnim', JSON.stringify({
            combineData: combineslotData.toData.combinable,
            usedItem: combineslotData.toData.name,
            requiredItem: combineslotData.fromData.name
        }))
    } else {
        $.post('http://lcrp-inventory/combineItem', JSON.stringify({
            reward: combineslotData.toData.combinable.reward,
            toItem: combineslotData.toData.name,
            fromItem: combineslotData.fromData.name
        }))
    }
    Inventory.Close();
});

$(document).on('click', '.SwitchItem', function(e){
    e.preventDefault();
    $(".combine-option-container").hide();

    optionSwitch(combineslotData.fromSlot, combineslotData.toSlot, combineslotData.fromInv, combineslotData.toInv, combineslotData.toAmount, combineslotData.toData, combineslotData.fromData)
});

function optionSwitch($fromSlot, $toSlot, $fromInv, $toInv, $toAmount, toData, fromData) {
    fromData.slot = parseInt($toSlot);
    
    $toInv.find("[data-slot=" + $toSlot + "]").data("item", fromData);

    $toInv.find("[data-slot=" + $toSlot + "]").addClass("item-drag");
    $toInv.find("[data-slot=" + $toSlot + "]").removeClass("item-nodrag");

    
    if ($toSlot < 6) {
        $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>' + $toSlot + '</p></div><div class="item-slot-img"><img src="images/' + fromData.image + '" alt="' + fromData.name + '" /></div><div class="item-slot-amount"><p>' + fromData.amount + ' (' + ((fromData.weight * fromData.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + fromData.label + '</p></div>');
    } else {
        $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src="images/' + fromData.image + '" alt="' + fromData.name + '" /></div><div class="item-slot-amount"><p>' + fromData.amount + ' (' + ((fromData.weight * fromData.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + fromData.label + '</p></div>');
    }

    toData.slot = parseInt($fromSlot);

    $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-drag");
    $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-nodrag");
    
    $fromInv.find("[data-slot=" + $fromSlot + "]").data("item", toData);

    if ($fromSlot < 6) {
        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>' + $fromSlot + '</p></div><div class="item-slot-img"><img src="images/' + toData.image + '" alt="' + toData.name + '" /></div><div class="item-slot-amount"><p>' + toData.amount + ' (' + ((toData.weight * toData.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + toData.label + '</p></div>');
    } else {
        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + toData.image + '" alt="' + toData.name + '" /></div><div class="item-slot-amount"><p>' + toData.amount + ' (' + ((toData.weight * toData.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + toData.label + '</p></div>');
    }

    if($fromInv.find("[data-slot=" + $fromSlot + "]").data("item") != null) {
        if($fromInv.find("[data-slot=" + $fromSlot + "]").data("item").price != null) {
            price = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item").price;
            if(cash >= price * toAmount) {
                cash = cash - price * $toAmount;
            } else {
                if(globalcash >= price * toAmount) {
                    globalcash = globalcash - price * $toAmount;
                }
            }
            $(".inv-stats-list-cash").html('' + cash + ' $');
        }
    }
    $.post("http://lcrp-inventory/SetInventoryData", JSON.stringify({
        fromInventory: $fromInv.attr("data-inventory"),
        toInventory: $toInv.attr("data-inventory"),
        fromSlot: $fromSlot,
        toSlot: $toSlot,
        fromAmount: $toAmount,
        toAmount: toData.amount,
    }));
}

function swap($fromSlot, $toSlot, $fromInv, $toInv, $toAmount) {
    fromData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
    toData = $toInv.find("[data-slot=" + $toSlot + "]").data("item");
    var otherinventory = otherLabel.toLowerCase();
    if(fromData.price != null) {
        totalprice = parseInt(toAmount) * parseInt (fromData.price);
        if (fromData.name == "casinochips2") {
            if(totalprice > dirtymoney) {
                InventoryError($fromInv, $fromSlot);
                return;
            } 
        } else {
            if(totalprice > globalcash && totalprice > cash) {
                InventoryError($fromInv, $fromSlot);
                return;
            }
        }
    }

    if (otherinventory.split("-")[0] == "dropped") {
        if (toData !== null && toData !== undefined) {
            InventoryError($fromInv, $fromSlot);
            return;
        }
    } 

    if (fromData !== undefined && fromData.amount >= $toAmount) {       
        if (($fromInv.attr("data-inventory") == "player" || $fromInv.attr("data-inventory") == "hotbar") && $toInv.attr("data-inventory").split("-")[0] == "itemshop" && $toInv.attr("data-inventory") == "crafting") {
            InventoryError($fromInv, $fromSlot);
            return;
        }

        if ($toAmount == 0 && $fromInv.attr("data-inventory").split("-")[0] == "itemshop" && $fromInv.attr("data-inventory") == "crafting") {
            InventoryError($fromInv, $fromSlot);
            return;
        } else if ($toAmount == 0) {
            $toAmount=fromData.amount
        }
        if((toData != undefined || toData != null) && toData.name == fromData.name && !fromData.unique) {
            var newData = [];
            newData.name = toData.name;
            newData.label = toData.label;
            newData.amount = (parseInt($toAmount) + parseInt(toData.amount));
            newData.type = toData.type;
            newData.description = toData.description;
            newData.image = toData.image;
            newData.weight = toData.weight;
            newData.info = toData.info;
            newData.useable = toData.useable;
            newData.unique = toData.unique;
            newData.slot = parseInt($toSlot);

            if (fromData.amount == $toAmount) {
                $toInv.find("[data-slot=" + $toSlot + "]").data("item", newData);
    
                $toInv.find("[data-slot=" + $toSlot + "]").addClass("item-drag");
                $toInv.find("[data-slot=" + $toSlot + "]").removeClass("item-nodrag");

                var ItemLabel = '<div class="item-slot-label"><p>' + newData.label + '</p></div>';
                if ((newData.name).split("_")[0] == "weapon") {
                    if (!Inventory.IsWeaponBlocked(newData.name)) {
                        ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + newData.label + '</p></div>';                       
                    }
                }

                if ($toSlot < 6 && $toInv.attr("data-inventory") == "player") {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>' + $toSlot + '</p></div><div class="item-slot-img"><img src="images/' + newData.image + '" alt="' + newData.name + '" /></div><div class="item-slot-amount"><p>' + newData.amount + ' (' + ((newData.weight * newData.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                } else if ($toSlot == 41 && $toInv.attr("data-inventory") == "player") {
                    // $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"><img src="images/' + newData.image + '" alt="' + newData.name + '" /></div><div class="item-slot-amount"><p>' + newData.amount + ' (' + ((newData.weight * newData.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                } else {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src="images/' + newData.image + '" alt="' + newData.name + '" /></div><div class="item-slot-amount"><p>' + newData.amount + ' (' + ((newData.weight * newData.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                }
                
                if ((newData.name).split("_")[0] == "weapon") {
                    if (!Inventory.IsWeaponBlocked(newData.name)) {
                        if (newData.info.quality == undefined) { newData.info.quality = 100.0; }
                        var QualityColor = "rgb(39, 174, 96)";
                        if (newData.info.quality < 25) {
                            QualityColor = "rgb(192, 57, 43)";
                        } else if (newData.info.quality > 25 && newData.info.quality < 50) {
                            QualityColor = "rgb(230, 126, 34)";
                        } else if (newData.info.quality >= 50) {
                            QualityColor = "rgb(39, 174, 96)";
                        }
                        if (newData.info.quality !== undefined) {
                            qualityLabel = (newData.info.quality).toFixed();
                        } else {
                            qualityLabel = (newData.info.quality);
                        }
                        if (newData.info.quality == 0) {
                            qualityLabel = "BROKEN";
                        }
                        $toInv.find("[data-slot=" + $toSlot + "]").find(".item-slot-quality-bar").css({
                            "width": qualityLabel + "%",
                            "background-color": QualityColor
                        }).find('p').html(qualityLabel);
                    }
                }

                $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-drag");
                $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-nodrag");

                $fromInv.find("[data-slot=" + $fromSlot + "]").removeData("item");
                $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div>');
            } else if(fromData.amount > $toAmount) {
                var newDataFrom = [];
                newDataFrom.name = fromData.name;
                newDataFrom.label = fromData.label;
                newDataFrom.amount = parseInt((fromData.amount - $toAmount));
                newDataFrom.type = fromData.type;
                newDataFrom.description = fromData.description;
                newDataFrom.image = fromData.image;
                newDataFrom.weight = fromData.weight;
                newDataFrom.price = fromData.price;
                newDataFrom.info = fromData.info;
                newDataFrom.useable = fromData.useable;
                newDataFrom.unique = fromData.unique;
                newDataFrom.slot = parseInt($fromSlot);

                $toInv.find("[data-slot=" + $toSlot + "]").data("item", newData);
    
                $toInv.find("[data-slot=" + $toSlot + "]").addClass("item-drag");
                $toInv.find("[data-slot=" + $toSlot + "]").removeClass("item-nodrag");

                var ItemLabel = '<div class="item-slot-label"><p>' + newData.label + '</p></div>';
                if ((newData.name).split("_")[0] == "weapon") {
                    if (!Inventory.IsWeaponBlocked(newData.name)) {
                        ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + newData.label + '</p></div>';                       
                    }
                }

                if ($toSlot < 6 && $toInv.attr("data-inventory") == "player") {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>' + $toSlot + '</p></div><div class="item-slot-img"><img src="images/' + newData.image + '" alt="' + newData.name + '" /></div><div class="item-slot-amount"><p>' + newData.amount + ' (' + ((newData.weight * newData.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                } else if ($toSlot == 41 && $toInv.attr("data-inventory") == "player") {
                    // $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"><img src="images/' + newData.image + '" alt="' + newData.name + '" /></div><div class="item-slot-amount"><p>' + newData.amount + ' (' + ((newData.weight * newData.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                } else {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src="images/' + newData.image + '" alt="' + newData.name + '" /></div><div class="item-slot-amount"><p>' + newData.amount + ' (' + ((newData.weight * newData.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                }

                if ((newData.name).split("_")[0] == "weapon") {
                    if (!Inventory.IsWeaponBlocked(newData.name)) {
                        if (newData.info.quality == undefined) { newData.info.quality = 100.0; }
                        var QualityColor = "rgb(39, 174, 96)";
                        if (newData.info.quality < 25) {
                            QualityColor = "rgb(192, 57, 43)";
                        } else if (newData.info.quality > 25 && newData.info.quality < 50) {
                            QualityColor = "rgb(230, 126, 34)";
                        } else if (newData.info.quality >= 50) {
                            QualityColor = "rgb(39, 174, 96)";
                        }
                        if (newData.info.quality !== undefined) {
                            qualityLabel = (newData.info.quality).toFixed();
                        } else {
                            qualityLabel = (newData.info.quality);
                        }
                        if (newData.info.quality == 0) {
                            qualityLabel = "BROKEN";
                        }
                        $toInv.find("[data-slot=" + $toSlot + "]").find(".item-slot-quality-bar").css({
                            "width": qualityLabel + "%",
                            "background-color": QualityColor
                        }).find('p').html(qualityLabel);
                    }
                }
                
                // From Data zooi
                $fromInv.find("[data-slot=" + $fromSlot + "]").data("item", newDataFrom);
    
                $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-drag");
                $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-nodrag");

                if ($fromInv.attr("data-inventory").split("-")[0] == "itemshop") {
                    $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + newDataFrom.image + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>('+newDataFrom.amount+') $'+newDataFrom.price+'</p></div><div class="item-slot-label"><p>' + newDataFrom.label + '</p></div>');
                } else {
                    var ItemLabel = '<div class="item-slot-label"><p>' + newDataFrom.label + '</p></div>';
                    if ((newDataFrom.name).split("_")[0] == "weapon") {
                        if (!Inventory.IsWeaponBlocked(newDataFrom.name)) {
                            ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + newDataFrom.label + '</p></div>';                       
                        }
                    }

                    if ($fromSlot < 6 && $fromInv.attr("data-inventory") == "player") {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>' + $fromSlot + '</p></div><div class="item-slot-img"><img src="images/' + newDataFrom.image + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>' + newDataFrom.amount + ' (' + ((newDataFrom.weight * newDataFrom.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                    } else if ($fromSlot == 41 && $fromInv.attr("data-inventory") == "player") {
                        //$fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"><img src="images/' + newDataFrom.image + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>' + newDataFrom.amount + ' (' + ((newDataFrom.weight * newDataFrom.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                    } else {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + newDataFrom.image + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>' + newDataFrom.amount + ' (' + ((newDataFrom.weight * newDataFrom.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                    }

                    if ((newDataFrom.name).split("_")[0] == "weapon") {
                        if (!Inventory.IsWeaponBlocked(newDataFrom.name)) {
                            if (newDataFrom.info.quality == undefined) { newDataFrom.info.quality = 100.0; }
                            var QualityColor = "rgb(39, 174, 96)";
                            if (newDataFrom.info.quality < 25) {
                                QualityColor = "rgb(192, 57, 43)";
                            } else if (newDataFrom.info.quality > 25 && newDataFrom.info.quality < 50) {
                                QualityColor = "rgb(230, 126, 34)";
                            } else if (newDataFrom.info.quality >= 50) {
                                QualityColor = "rgb(39, 174, 96)";
                            }
                            if (newDataFrom.info.quality !== undefined) {
                                qualityLabel = (newDataFrom.info.quality).toFixed();
                            } else {
                                qualityLabel = (newDataFrom.info.quality);
                            }
                            if (newDataFrom.info.quality == 0) {
                                qualityLabel = "BROKEN";
                            }
                            $fromInv.find("[data-slot=" + $fromSlot + "]").find(".item-slot-quality-bar").css({
                                "width": qualityLabel + "%",
                                "background-color": QualityColor
                            }).find('p').html(qualityLabel);
                        }
                    }
                }    
            }

            if($fromInv.find("[data-slot=" + $fromSlot + "]").data("item") != null) {
                if($fromInv.find("[data-slot=" + $fromSlot + "]").data("item").price != null) {
                    price = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item").price;
                    if(cash >= price * toAmount) {
                        cash = cash - price * $toAmount;
                    } else {
                        if(globalcash >= price * toAmount) {
                            globalcash = globalcash - price * $toAmount;
                        }
                    }
                    $(".inv-stats-list-cash").html('' + cash + ' $');
                }
            }
            $.post("http://lcrp-inventory/PlayDropSound", JSON.stringify({}));
            $.post("http://lcrp-inventory/SetInventoryData", JSON.stringify({
                fromInventory: $fromInv.attr("data-inventory"),
                toInventory: $toInv.attr("data-inventory"),
                fromSlot: $fromSlot,
                toSlot: $toSlot,
                fromAmount: $toAmount,
            }));
        } else {
            if (fromData.amount == $toAmount) {
                if (toData != undefined && toData.combinable != null && isItemAllowed(fromData.name, toData.combinable.accept)) {
                    $.post('http://lcrp-inventory/getCombineItem', JSON.stringify({item: toData.combinable.reward}), function(item){
                        $('.combine-option-text').html("<p>If you combine this item you will get: <b>"+item.label+"</b></p>");
                    })
                    $(".combine-option-container").fadeIn(100);
                    combineslotData = []
                    combineslotData.fromData = fromData
                    combineslotData.toData = toData
                    combineslotData.fromSlot = $fromSlot
                    combineslotData.toSlot = $toSlot
                    combineslotData.fromInv = $fromInv
                    combineslotData.toInv = $toInv
                    combineslotData.toAmount = $toAmount
                    return
                }

                fromData.slot = parseInt($toSlot);
    
                $toInv.find("[data-slot=" + $toSlot + "]").data("item", fromData);
    
                $toInv.find("[data-slot=" + $toSlot + "]").addClass("item-drag");
                $toInv.find("[data-slot=" + $toSlot + "]").removeClass("item-nodrag");

                var ItemLabel = '<div class="item-slot-label"><p>' + fromData.label + '</p></div>';
                if ((fromData.name).split("_")[0] == "weapon") {
                    if (!Inventory.IsWeaponBlocked(fromData.name)) {
                        ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + fromData.label + '</p></div>';                       
                    }
                }

                if ($toSlot < 6 && $toInv.attr("data-inventory") == "player") {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>' + $toSlot + '</p></div><div class="item-slot-img"><img src="images/' + fromData.image + '" alt="' + fromData.name + '" /></div><div class="item-slot-amount"><p>' + fromData.amount + ' (' + ((fromData.weight * fromData.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                } else if ($toSlot == 41 && $toInv.attr("data-inventory") == "player") {
                    //$toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"><img src="images/' + fromData.image + '" alt="' + fromData.name + '" /></div><div class="item-slot-amount"><p>' + fromData.amount + ' (' + ((fromData.weight * fromData.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                } else {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src="images/' + fromData.image + '" alt="' + fromData.name + '" /></div><div class="item-slot-amount"><p>' + fromData.amount + ' (' + ((fromData.weight * fromData.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                }

                if ((fromData.name).split("_")[0] == "weapon") {
                    if (!Inventory.IsWeaponBlocked(fromData.name)) {
                        if (fromData.info.quality == undefined) { fromData.info.quality = 100.0; }
                        var QualityColor = "rgb(39, 174, 96)";
                        if (fromData.info.quality < 25) {
                            QualityColor = "rgb(192, 57, 43)";
                        } else if (fromData.info.quality > 25 && fromData.info.quality < 50) {
                            QualityColor = "rgb(230, 126, 34)";
                        } else if (fromData.info.quality >= 50) {
                            QualityColor = "rgb(39, 174, 96)";
                        }
                        if (fromData.info.quality !== undefined) {
                            qualityLabel = (fromData.info.quality).toFixed();
                        } else {
                            qualityLabel = (fromData.info.quality);
                        }
                        if (fromData.info.quality == 0) {
                            qualityLabel = "BROKEN";
                        }
                        $toInv.find("[data-slot=" + $toSlot + "]").find(".item-slot-quality-bar").css({
                            "width": qualityLabel + "%",
                            "background-color": QualityColor
                        }).find('p').html(qualityLabel);
                    }
                }
    
                if (toData != undefined) {
                    toData.slot = parseInt($fromSlot);
    
                    $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-drag");
                    $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-nodrag");
                    
                    $fromInv.find("[data-slot=" + $fromSlot + "]").data("item", toData);

                    var ItemLabel = '<div class="item-slot-label"><p>' + toData.label + '</p></div>';
                    if ((toData.name).split("_")[0] == "weapon") {
                        if (!Inventory.IsWeaponBlocked(toData.name)) {
                            ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + toData.label + '</p></div>';                       
                        }
                    }
 
                    if ($fromSlot < 6 && $fromInv.attr("data-inventory") == "player") {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>' + $fromSlot + '</p></div><div class="item-slot-img"><img src="images/' + toData.image + '" alt="' + toData.name + '" /></div><div class="item-slot-amount"><p>' + toData.amount + ' (' + ((toData.weight * toData.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                    } else if ($fromSlot == 41 && $fromInv.attr("data-inventory") == "player") {
                        //$fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"><img src="images/' + toData.image + '" alt="' + toData.name + '" /></div><div class="item-slot-amount"><p>' + toData.amount + ' (' + ((toData.weight * toData.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                    } else {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + toData.image + '" alt="' + toData.name + '" /></div><div class="item-slot-amount"><p>' + toData.amount + ' (' + ((toData.weight * toData.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                    }

                    if ((toData.name).split("_")[0] == "weapon") {
                        if (!Inventory.IsWeaponBlocked(toData.name)) {
                            if (toData.info.quality == undefined) { toData.info.quality = 100.0; }
                            var QualityColor = "rgb(39, 174, 96)";
                            if (toData.info.quality < 25) {
                                QualityColor = "rgb(192, 57, 43)";
                            } else if (toData.info.quality > 25 && toData.info.quality < 50) {
                                QualityColor = "rgb(230, 126, 34)";
                            } else if (toData.info.quality >= 50) {
                                QualityColor = "rgb(39, 174, 96)";
                            }
                            if (toData.info.quality !== undefined) {
                                qualityLabel = (toData.info.quality).toFixed();
                            } else {
                                qualityLabel = (toData.info.quality);
                            }
                            if (toData.info.quality == 0) {
                                qualityLabel = "BROKEN";
                            }
                            $fromInv.find("[data-slot=" + $fromSlot + "]").find(".item-slot-quality-bar").css({
                                "width": qualityLabel + "%",
                                "background-color": QualityColor
                            }).find('p').html(qualityLabel);
                        }
                    }

                    if($fromInv.find("[data-slot=" + $fromSlot + "]").data("item") != null) {
                        if($fromInv.find("[data-slot=" + $fromSlot + "]").data("item").price != null) {
                            price = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item").price;
                            if(cash >= price * toAmount) {
                                cash = cash - price * $toAmount;
                            } else {
                                if(globalcash >= price * toAmount) {
                                    globalcash = globalcash - price * $toAmount;
                                }
                            }
                            $(".inv-stats-list-cash").html('' + cash + ' $');
                        }
                    }
                    $.post("http://lcrp-inventory/SetInventoryData", JSON.stringify({
                        fromInventory: $fromInv.attr("data-inventory"),
                        toInventory: $toInv.attr("data-inventory"),
                        fromSlot: $fromSlot,
                        toSlot: $toSlot,
                        fromAmount: $toAmount,
                        toAmount: toData.amount,
                    }));
                } else {
                    $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-drag");
                    $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-nodrag");
    
                    $fromInv.find("[data-slot=" + $fromSlot + "]").removeData("item");

                    if ($fromSlot < 6 && $fromInv.attr("data-inventory") == "player") {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>' + $fromSlot + '</p></div><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div>');
                    } else if ($fromSlot == 41 && $fromInv.attr("data-inventory") == "player") {
                        //$fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div>');
                    } else {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div>');
                    }

                    if($fromInv.find("[data-slot=" + $fromSlot + "]").data("item") != null) {
                        if($fromInv.find("[data-slot=" + $fromSlot + "]").data("item").price != null) {
                            price = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item").price;
                            if(cash >= price * toAmount) {
                                cash = cash - price * $toAmount;
                            } else {
                                if(globalcash >= price * toAmount) {
                                    globalcash = globalcash - price * $toAmount;
                                }
                            }
                            $(".inv-stats-list-cash").html('' + cash + ' $');
                        }
                    }
                    $.post("http://lcrp-inventory/SetInventoryData", JSON.stringify({
                        fromInventory: $fromInv.attr("data-inventory"),
                        toInventory: $toInv.attr("data-inventory"),
                        fromSlot: $fromSlot,
                        toSlot: $toSlot,
                        fromAmount: $toAmount,
                    }));
                }
                $.post("http://lcrp-inventory/PlayDropSound", JSON.stringify({}));
            } else if(fromData.amount > $toAmount && (toData == undefined || toData == null)) {
                var newDataTo = [];
                newDataTo.name = fromData.name;
                newDataTo.label = fromData.label;
                newDataTo.amount = parseInt($toAmount);
                newDataTo.type = fromData.type;
                newDataTo.description = fromData.description;
                newDataTo.image = fromData.image;
                newDataTo.weight = fromData.weight;
                newDataTo.info = fromData.info;
                newDataTo.useable = fromData.useable;
                newDataTo.unique = fromData.unique;
                newDataTo.slot = parseInt($toSlot);
    
                $toInv.find("[data-slot=" + $toSlot + "]").data("item", newDataTo);
    
                $toInv.find("[data-slot=" + $toSlot + "]").addClass("item-drag");
                $toInv.find("[data-slot=" + $toSlot + "]").removeClass("item-nodrag");

                var ItemLabel = '<div class="item-slot-label"><p>' + newDataTo.label + '</p></div>';
                if ((newDataTo.name).split("_")[0] == "weapon") {
                    if (!Inventory.IsWeaponBlocked(newDataTo.name)) {
                        ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + newDataTo.label + '</p></div>';                       
                    }
                }

                if ($toSlot < 6 && $toInv.attr("data-inventory") == "player") {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>' + $toSlot + '</p></div><div class="item-slot-img"><img src="images/' + newDataTo.image + '" alt="' + newDataTo.name + '" /></div><div class="item-slot-amount"><p>' + newDataTo.amount + ' (' + ((newDataTo.weight * newDataTo.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                } else if ($toSlot == 41 && $toInv.attr("data-inventory") == "player") {
                    //$toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"><img src="images/' + newDataTo.image + '" alt="' + newDataTo.name + '" /></div><div class="item-slot-amount"><p>' + newDataTo.amount + ' (' + ((newDataTo.weight * newDataTo.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                } else {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src="images/' + newDataTo.image + '" alt="' + newDataTo.name + '" /></div><div class="item-slot-amount"><p>' + newDataTo.amount + ' (' + ((newDataTo.weight * newDataTo.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                }

                if ((newDataTo.name).split("_")[0] == "weapon") {
                    if (!Inventory.IsWeaponBlocked(newDataTo.name)) {
                        if (newDataTo.info.quality == undefined) { 
                            newDataTo.info.quality = 100.0; 
                        }
                        var QualityColor = "rgb(39, 174, 96)";
                        if (newDataTo.info.quality < 25) {
                            QualityColor = "rgb(192, 57, 43)";
                        } else if (newDataTo.info.quality > 25 && newDataTo.info.quality < 50) {
                            QualityColor = "rgb(230, 126, 34)";
                        } else if (newDataTo.info.quality >= 50) {
                            QualityColor = "rgb(39, 174, 96)";
                        }
                        if (newDataTo.info.quality !== undefined) {
                            qualityLabel = (newDataTo.info.quality).toFixed();
                        } else {
                            qualityLabel = (newDataTo.info.quality);
                        }
                        if (newDataTo.info.quality == 0) {
                            qualityLabel = "BROKEN";
                        }
                        $toInv.find("[data-slot=" + $toSlot + "]").find(".item-slot-quality-bar").css({
                            "width": qualityLabel + "%",
                            "background-color": QualityColor
                        }).find('p').html(qualityLabel);
                    }
                }

                var newDataFrom = [];
                newDataFrom.name = fromData.name;
                newDataFrom.label = fromData.label;
                newDataFrom.amount = parseInt((fromData.amount - $toAmount));
                newDataFrom.type = fromData.type;
                newDataFrom.description = fromData.description;
                newDataFrom.image = fromData.image;
                newDataFrom.weight = fromData.weight;
                newDataFrom.price = fromData.price;
                newDataFrom.info = fromData.info;
                newDataFrom.useable = fromData.useable;
                newDataFrom.unique = fromData.unique;
                newDataFrom.slot = parseInt($fromSlot);
    
                $fromInv.find("[data-slot=" + $fromSlot + "]").data("item", newDataFrom);
    
                $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-drag");
                $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-nodrag");
    
                if ($fromInv.attr("data-inventory").split("-")[0] == "itemshop") {
                    $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + newDataFrom.image + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>('+newDataFrom.amount+') $'+newDataFrom.price+'</p></div><div class="item-slot-label"><p>' + newDataFrom.label + '</p></div>');
                } else {

                    var ItemLabel = '<div class="item-slot-label"><p>' + newDataFrom.label + '</p></div>';
                    if ((newDataFrom.name).split("_")[0] == "weapon") {
                        if (!Inventory.IsWeaponBlocked(newDataFrom.name)) {
                            ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + newDataFrom.label + '</p></div>';                       
                        }
                    }

                    if ($fromSlot < 6 && $fromInv.attr("data-inventory") == "player") {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>' + $fromSlot + '</p></div><div class="item-slot-img"><img src="images/' + newDataFrom.image + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>' + newDataFrom.amount + ' (' + ((newDataFrom.weight * newDataFrom.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                    } else if ($fromSlot == 41 && $fromInv.attr("data-inventory") == "player") {
                        //$fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"><img src="images/' + newDataFrom.image + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>' + newDataFrom.amount + ' (' + ((newDataFrom.weight * newDataFrom.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                    } else {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + newDataFrom.image + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>' + newDataFrom.amount + ' (' + ((newDataFrom.weight * newDataFrom.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                    }

                    if ((newDataFrom.name).split("_")[0] == "weapon") {
                        if (!Inventory.IsWeaponBlocked(newDataFrom.name)) {
                            if (newDataFrom.info.quality == undefined) { newDataFrom.info.quality = 100.0; }
                            var QualityColor = "rgb(39, 174, 96)";
                            if (newDataFrom.info.quality < 25) {
                                QualityColor = "rgb(192, 57, 43)";
                            } else if (newDataFrom.info.quality > 25 && newDataFrom.info.quality < 50) {
                                QualityColor = "rgb(230, 126, 34)";
                            } else if (newDataFrom.info.quality >= 50) {
                                QualityColor = "rgb(39, 174, 96)";
                            }
                            if (newDataFrom.info.quality !== undefined) {
                                qualityLabel = (newDataFrom.info.quality).toFixed();
                            } else {
                                qualityLabel = (newDataFrom.info.quality);
                            }
                            if (newDataFrom.info.quality == 0) {
                                qualityLabel = "BROKEN";
                            }
                            $fromInv.find("[data-slot=" + $fromSlot + "]").find(".item-slot-quality-bar").css({
                                "width": qualityLabel + "%",
                                "background-color": QualityColor
                            }).find('p').html(qualityLabel);
                        }
                    }
                }
                if($fromInv.find("[data-slot=" + $fromSlot + "]").data("item") != null) {
                    if($fromInv.find("[data-slot=" + $fromSlot + "]").data("item").price != null) {
                        price = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item").price;
                        if(cash >= price * toAmount) {
                            cash = cash - price * $toAmount;
                        } else {
                            if(globalcash >= price * toAmount) {
                                globalcash = globalcash - price * $toAmount;
                            }
                        }
                        $(".inv-stats-list-cash").html('' + cash + ' $');
                    }
                }
                $.post("http://lcrp-inventory/PlayDropSound", JSON.stringify({}));
                $.post("http://lcrp-inventory/SetInventoryData", JSON.stringify({
                    fromInventory: $fromInv.attr("data-inventory"),
                    toInventory: $toInv.attr("data-inventory"),
                    fromSlot: $fromSlot,
                    toSlot: $toSlot,
                    fromAmount: $toAmount,
                }));
            } else {
                InventoryError($fromInv, $fromSlot);
            }
        }
    } else {
        //InventoryError($fromInv, $fromSlot);
    }
    handleDragDrop();
}

function isItemAllowed(item, allowedItems) {
    var retval = false
    $.each(allowedItems, function(index, i){
        if (i == item) {
            retval = true;
        }
    });
    return retval
}

function InventoryError($elinv, $elslot) {
    $elinv.find("[data-slot=" + $elslot + "]").css("background", "rgba(156, 20, 20, 0.5)").css("transition", "background 500ms");
    setTimeout(function() {
        $elinv.find("[data-slot=" + $elslot + "]").css("background", "rgba(255, 255, 255, 0.03)");
    }, 500)
    $.post("http://lcrp-inventory/PlayDropFail", JSON.stringify({}));
}

var requiredItemOpen = false;

(() => {
    Inventory = {};

    Inventory.slots = 40;

    Inventory.dropslots = 30;
    Inventory.droplabel = "Trashbin (ITEM WILL DISAPPEAR)";
    Inventory.dropmaxweight = 100000

    Inventory.Error = function() {
        $.post("http://lcrp-inventory/PlayDropFail", JSON.stringify({}));
    }

    Inventory.IsWeaponBlocked = function(WeaponName) {
        var DurabilityBlockedWeapons = [ 
            "weapon_unarmed"
        ]

        var retval = false;
        $.each(DurabilityBlockedWeapons, function(i, name) {
            if (name == WeaponName) {
                retval = true;
            }
        });
        return retval;
    }

    Inventory.QualityCheck = function(item, IsHotbar, IsOtherInventory) {
        if (!Inventory.IsWeaponBlocked(item.name)) {
            if ((item.name).split("_")[0] == "weapon") {
                if (item.info.quality == undefined) { item.info.quality = 100; }
                var QualityColor = "rgb(39, 174, 96)";
                if (item.info.quality < 25) {
                    QualityColor = "rgb(192, 57, 43)";
                } else if (item.info.quality > 25 && item.info.quality < 50) {
                    QualityColor = "rgb(230, 126, 34)";
                } else if (item.info.quality >= 50) {
                    QualityColor = "rgb(39, 174, 96)";
                }
                if (item.info.quality !== undefined) {
                    qualityLabel = (item.info.quality).toFixed();
                } else {
                    qualityLabel = (item.info.quality);
                }
                if (item.info.quality == 0) {
                    qualityLabel = "BROKEN";
                    if (!IsOtherInventory) {
                        if (!IsHotbar) {
                            $(".player-inventory").find("[data-slot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                                "width": "100%",
                                "background-color": QualityColor
                            }).find('p').html(qualityLabel);
                        } else {
                            $(".z-hotbar-inventory").find("[data-zhotbarslot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                                "width": "100%",
                                "background-color": QualityColor
                            }).find('p').html(qualityLabel);
                        }
                    } else {
                        $(".other-inventory").find("[data-slot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                            "width": "100%",
                            "background-color": QualityColor
                        }).find('p').html(qualityLabel);
                    }
                } else {
                    if (!IsOtherInventory) {
                        if (!IsHotbar) {
                            $(".player-inventory").find("[data-slot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                                "width": qualityLabel + "%",
                                "background-color": QualityColor
                            }).find('p').html(qualityLabel);
                        } else {
                            $(".z-hotbar-inventory").find("[data-zhotbarslot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                                "width": qualityLabel + "%",
                                "background-color": QualityColor
                            }).find('p').html(qualityLabel);
                        }
                    } else {
                        $(".other-inventory").find("[data-slot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                            "width": qualityLabel + "%",
                            "background-color": QualityColor
                        }).find('p').html(qualityLabel);
                    }
                }
            }
        }
    }

    Inventory.Open = function(data) {
        totalWeight = 0;
        totalWeightOther = 0;
        plyJobGrade = data.jobgrade;
        $(".player-inventory").find(".item-slot").remove();
        $(".ply-hotbar-inventory").find(".item-slot").remove();
        $(".inv-option-trash").hide();
        $(".inv-option-warning").hide();

        if (requiredItemOpen) {
            $(".requiredItem-container").hide();
            requiredItemOpen = false;
        }

        $("#qbus-inventory").fadeIn(300);
        if(data.other != null && data.other != "") {
            $(".other-inventory").attr("data-inventory", data.other.name);
            stashName = data.other.name;
        } else {
            $(".other-inventory").attr("data-inventory", 0);
        }
        // First 5 Slots
        for(i = 1; i < 6; i++) {
            $(".player-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-key"><p>' + i + '</p></div><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
        }
        // Inventory
        for(i = 6; i < (data.slots + 1); i++) {
            if (i == 41) {
                //$(".player-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
            } else {
                $(".player-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
            }
        }

        $.post('http://lcrp-inventory/GetPlayerData', function(player){
            player = JSON.parse(player)
            cash = parseInt(player.cash);
            globalcash = parseInt(player.bank);
            dirtymoney = parseInt(player.dirtymoney)
            $(".inv-stats-sil").empty();
            if(player.gender == 1) {
                $('.inv-stats-sil').append('<img class="inv-stats-sil-img" style="width: auto; height: 45%; margin-top: 2vh; margin-left: 14%; opacity: 0.7;" src="images/women-sil.png">');
                $('.inv-stats-sil').append('<img class="inv-bdy inv-stats-sil-head" style="width: auto; height: 6%; position: absolute; left:45%; top:6%; opacity: 0.2;" src="images/head-w.png">');
                $('.inv-stats-sil').append('<img class="inv-bdy inv-stats-sil-upperbody" style="width: auto; height: 13%; position: absolute; left:43%; top:12%; opacity: 0.2;" src="images/upperbody-w.png">');
                $('.inv-stats-sil').append('<img class="inv-bdy inv-stats-sil-rarm" style="width: auto; height: 10%; position: absolute; left:35%; top:6.2%; opacity: 0.2;" src="images/rarm-w.png">');
                $('.inv-stats-sil').append('<img class="inv-bdy inv-stats-sil-larm" style="width: auto; height: 13%; position: absolute; left:56.7%; top:11.5%; opacity: 0.2;" src="images/larm-w.png">');
                $('.inv-stats-sil').append('<img class="inv-bdy inv-stats-sil-rleg" style="width: auto; height: 20%; position: absolute; left:41%; top:28%; opacity: 0.2;" src="images/lleg-w.png">');
                $('.inv-stats-sil').append('<img class="inv-bdy inv-stats-sil-lleg" style="width: auto; height: 22%; position: absolute; left:48%; top:27.5%; opacity: 0.2;" src="images/rleg-w.png">');
            } else {
                $('.inv-stats-sil').append('<img class="inv-stats-sil-img" style="width: auto; height: 45%; margin-top: 2vh; margin-left: 30%; opacity: 0.7;" src="images/sil-men.png">');
                $('.inv-stats-sil').append('<img class="inv-bdy inv-stats-sil-head" style="width: auto; height: 9%; position: absolute; left:44%; top:5%; opacity: 0.2;" src="images/head.png">');
                $('.inv-stats-sil').append('<img class="inv-bdy inv-stats-sil-upperbody" style="width: auto; height: 19%; position: absolute; left:36%; top:10.5%; opacity: 0.2;" src="images/upperbody.png">');
                $('.inv-stats-sil').append('<img class="inv-bdy inv-stats-sil-rarm" style="width: auto; height: 16%; position: absolute; left:39%; top:14.5%; opacity: 0.2;" src="images/rarm.png">');
                $('.inv-stats-sil').append('<img class="inv-bdy inv-stats-sil-larm" style="width: auto; height: 17.5%; position: absolute; left:55.5%; top:13%; opacity: 0.2;" src="images/larm.png">');
                $('.inv-stats-sil').append('<img class="inv-bdy inv-stats-sil-rleg" style="width: auto; height: 23%; position: absolute; left:42%; top:26%; opacity: 0.2;" src="images/lleg.png">');
                $('.inv-stats-sil').append('<img class="inv-bdy inv-stats-sil-lleg" style="width: auto; height: 23%; position: absolute; left:48%; top:26%; opacity: 0.2;" src="images/rleg.png">');
            }
            if(player.gender == 1) {
                $(".inv-stats-sil-img").attr("src","images/women-sil.png");
                $(".inv-stats-sil-head").attr("src","images/head-w.png");
                $(".inv-stats-sil-upperbody").attr("src","images/upperbody-w.png");
                $(".inv-stats-sil-rarm").attr("src","images/rarm-w.png");
                $(".inv-stats-sil-larm").attr("src","images/larm-w.png");
                $(".inv-stats-sil-rleg").attr("src","images/lleg-w.png");
                $(".inv-stats-sil-lleg").attr("src","images/rleg-w.png");
            } else {
                $(".inv-stats-sil-img").attr("src","images/sil-men.png");
                $(".inv-stats-sil-head").attr("src","images/head.png");
                $(".inv-stats-sil-upperbody").attr("src","images/upperbody.png");
                $(".inv-stats-sil-rarm").attr("src","images/rarm.png");
                $(".inv-stats-sil-larm").attr("src","images/larm.png");
                $(".inv-stats-sil-rleg").attr("src","images/lleg.png");
                $(".inv-stats-sil-lleg").attr("src","images/rleg.png");
            }
            $(".inv-stats-sil-head").hide();
            $(".inv-stats-sil-upperbody").hide();
            $(".inv-stats-sil-rarm").hide();
            $(".inv-stats-sil-larm").hide();
            $(".inv-stats-sil-rleg").hide();
            $(".inv-stats-sil-lleg").hide();
            if(data.injuries.hasOwnProperty("HEAD") || data.injuries.hasOwnProperty("NECK")) {
                $(".inv-stats-sil-head").show();
            }
            if(data.injuries.hasOwnProperty("UPPER_BODY") || data.injuries.hasOwnProperty("SPINE")) {
                $(".inv-stats-sil-upperbody").show();
            }
            if(data.injuries.hasOwnProperty("RARM") || data.injuries.hasOwnProperty("RHAND")) {
                $(".inv-stats-sil-rarm").show();
            }
            if(data.injuries.hasOwnProperty("LARM") || data.injuries.hasOwnProperty("LHAND")) {
                $(".inv-stats-sil-larm").show();
            }
            if(data.injuries.hasOwnProperty("RLEG") || data.injuries.hasOwnProperty("RFOOT")) {
                $(".inv-stats-sil-rleg").show();
            }
            if(data.injuries.hasOwnProperty("LLEG") || data.injuries.hasOwnProperty("LFOOT")) {
                $(".inv-stats-sil-lleg").show();
            }
            $('.inv-stats-list').append('<div class="inv-stats-list-name">' + player.name + '</div>');
            $('.inv-stats-list').append('<div class="inv-stats-list-cash">' + player.cash + ' $</div>');
            $('.inv-stats-list').append('<progress class="inv-stats-list-hp" max="200" value="' + data.health + '" data-label="' + data.health.toFixed(2) + '/200"></progress>');
            $('.inv-stats-list').append('<progress class="inv-stats-list-hunger" max="100" value="' + player.hunger.toFixed(2) + '" data-label="' + player.hunger.toFixed(2) + '/100"></progress>');
            $('.inv-stats-list').append('<progress class="inv-stats-list-thirst" max="100" value="' + player.thirst.toFixed(2) + '" data-label="' + player.thirst.toFixed(2) + '/100"></progress>');
            $('.inv-stats-list').append('<span class="fas fa-heartbeat"></span>');
            $('.inv-stats-list').append('<span class="fas fa-utensils"></span>');
            $('.inv-stats-list').append('<span class="fas fa-tint"></span>');
        })
        
        if (data.other != null && data.other != "") {
            for(i = 1; i < (data.other.slots + 1); i++) {
                $(".other-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
            }
            $("#other-inv-label").show();
            $("#other-inv-weight").show();
            $('.inv-container').attr('style','left: 0vw');
            $('.inventory-info').attr('style','left: 0vw');
            $('.inv-options-desctop').attr('style','right: 70vw');
            $('.inv-options-container').attr('style','left: 11vw');
            $('.ply-iteminfo-container').attr('style','left: 39.4vw');
            $('.combine-option-container').attr('style','left: -23vw');
        } else {
            $('.combine-option-container').attr('style','left: 5vw');
            $('.inv-container').attr('style','left: 15vw');
            $('.inventory-info').attr('style','left: 15vw');
            $('.inv-options-container').attr('style','left: 26vw');
            $('.inv-options-desctop').attr('style','right: 52.8%');
            $('.ply-iteminfo-container').attr('style','left: 54.4vw');
            $("#other-inv-label").hide();
            $("#other-inv-weight").hide();
        }

        if (data.inventory !== null) {
            $.each(data.inventory, function (i, item) {
                if (item != null) {
                    totalWeight += (item.weight * item.amount);
                    var ItemLabel = '<div class="item-slot-label"><p>' + item.label + '</p></div>';
                    if ((item.name).split("_")[0] == "weapon") {
                        if (!Inventory.IsWeaponBlocked(item.name)) {
                            ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + item.label + '</p></div>';                       
                        }
                    }
                    if (item.slot < 6) {
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-key"><p>' + item.slot + '</p></div><div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>' + item.amount + ' (' + ((item.weight * item.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").data("item", item);
                    //} else if (item.slot == 41) {
                    //    $(".player-inventory").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                    //    $(".player-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>' + item.amount + ' (' + ((item.weight * item.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                    //    $(".player-inventory").find("[data-slot=" + item.slot + "]").data("item", item);
                    } else {
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>' + item.amount + ' (' + ((item.weight * item.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").data("item", item);
                    }
                    Inventory.QualityCheck(item, false, false);
                }
            });
        }

        if ((data.other != null && data.other != "") && data.other.inventory != null) {
            $.each(data.other.inventory, function (i, item) {
                if (item != null) {
                    totalWeightOther += (item.weight * item.amount);
                    var ItemLabel = '<div class="item-slot-label"><p>' + item.label + '</p></div>';
                    if ((item.name).split("_")[0] == "weapon") {
                        if (!Inventory.IsWeaponBlocked(item.name)) {
                            ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + item.label + '</p></div>';                       
                        }
                    }
                    $(".other-inventory").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                    if (item.price != null) {
                        $(".other-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>('+item.amount+') $'+item.price+'</p></div>' + ItemLabel);
                    } else {
                        $(".other-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>' + item.amount + ' (' + ((item.weight * item.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                    }
                    $(".other-inventory").find("[data-slot=" + item.slot + "]").data("item", item);
                    Inventory.QualityCheck(item, false, true);
                }
            });
        }

        $("#player-inv-weight").html("Weight: " + (totalWeight / 1000).toFixed(2) + " / " + (data.maxweight / 1000).toFixed(2));
        playerMaxWeight = data.maxweight;
        if (data.other != null) 
        {
            var name = data.other.name.toString()
            if (name != null && (name.split("-")[0] == "itemshop" || name == "crafting")) {
                $("#other-inv-label").html(data.other.label);
            } else {
                $("#other-inv-label").html(data.other.label)
                $("#other-inv-weight").html("Weight: " + (totalWeightOther / 1000).toFixed(2) + " / " + (data.other.maxweight / 1000).toFixed(2))
            }
            otherMaxWeight = data.other.maxweight;
            otherLabel = data.other.label;
        } else {
            $("#other-inv-label").html(Inventory.droplabel)
            $("#other-inv-weight").html("Weight: " + (totalWeightOther / 1000).toFixed(2) + " / " + (Inventory.dropmaxweight / 1000).toFixed(2))
            otherMaxWeight = Inventory.dropmaxweight;
            otherLabel = Inventory.droplabel;
        }

        $.each(data.maxammo, function(index, ammotype){
            $("#"+index+"_ammo").find('.ammo-box-amount').css({"height":"0%"});
        });

        if (data.Ammo !== null) {
            $.each(data.Ammo, function(i, amount){
                var Handler = i.split("_");
                var Type = Handler[1].toLowerCase();
                if (amount > data.maxammo[Type]) {
                    amount = data.maxammo[Type]
                }
                var Percentage = (amount / data.maxammo[Type] * 100)

                $("#"+Type+"_ammo").find('.ammo-box-amount').css({"height":Percentage+"%"});
                $("#"+Type+"_ammo").find('span').html(amount+"x");
            });
        }

        handleDragDrop();
    };

    Inventory.Close = function() {
        $(".item-slot").css("border", "1px solid rgba(255, 255, 255, 0.1)");
        $(".ply-hotbar-inventory").css("display", "block");
        $(".ply-iteminfo-container").css("display", "none");
        $(".inv-options-container").css("display", "none");
        $("#qbus-inventory").fadeOut(300);
        $(".combine-option-container").hide();
        $(".item-slot").remove();
        $(".card-info").hide();

        $(".inv-stats-list-name").remove();
        $(".inv-stats-list-cash").remove();
        $(".inv-stats-list-hp").remove();
        $(".inv-stats-list-hunger").remove();
        $(".inv-stats-list-thirst").remove();
        $(".fa-heartbeat").remove();
        $(".fa-utensils").remove();
        $(".fa-tint").remove();

        if ($("#rob-money").length) {
            $("#rob-money").remove();
        }
        $.post("http://lcrp-inventory/CloseInventory", JSON.stringify({}));

        if (AttachmentScreenActive) {
            $("#qbus-inventory").css({"left": "0vw"});
            $(".weapon-attachments-container").css({"left": "-100vw"});
            AttachmentScreenActive = false;
        }

        if (ClickedItemData !== null) {
            $("#weapon-attachments").fadeOut(250, function(){
                $("#weapon-attachments").remove();
                ClickedItemData = {};
            });
        }
    };

    Inventory.Update = function(data) {
        totalWeight = 0;
        totalWeightOther = 0;
        $(".player-inventory").find(".item-slot").remove();
        $(".ply-hotbar-inventory").find(".item-slot").remove();
        if (data.error) {
            Inventory.Error();
        }
        for(i = 1; i < (data.slots + 1); i++) {
            if (i == 41) {
                //$(".player-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
            } else {
                $(".player-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
            }        
        }

        $.each(data.inventory, function (i, item) {
            if (item != null) {
                totalWeight += (item.weight * item.amount);
                if (item.slot < 6) {
                    $(".player-inventory").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                    $(".player-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-key"><p>' + item.slot + '</p></div><div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>' + item.amount + ' (' + ((item.weight * item.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + item.label + '</p></div>');
                    $(".player-inventory").find("[data-slot=" + item.slot + "]").data("item", item);
                } else if (item.slot == 41) {
                    $(".player-inventory").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                    $(".player-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>' + item.amount + ' (' + ((item.weight * item.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + item.label + '</p></div>');
                    $(".player-inventory").find("[data-slot=" + item.slot + "]").data("item", item);
                } else {
                    $(".player-inventory").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                    $(".player-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>' + item.amount + ' (' + ((item.weight * item.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + item.label + '</p></div>');
                    $(".player-inventory").find("[data-slot=" + item.slot + "]").data("item", item);
                }
            }
        });

        $("#player-inv-weight").html("Weight: " + (totalWeight / 1000).toFixed(2) + " / " + (data.maxweight / 1000).toFixed(2));

        handleDragDrop();
    };

    Inventory.ToggleHotbar = function(data) {
        if (data.open) {
            $(".z-hotbar-inventory").html("");
            for(i = 1; i < 6; i++) {
                var elem = '<div class="z-hotbar-item-slot" data-zhotbarslot="'+i+'"> <div class="z-hotbar-item-slot-key"><p>'+i+'</p></div><div class="z-hotbar-item-slot-img"></div><div class="z-hotbar-item-slot-label"><p>&nbsp;</p></div></div>'
                $(".z-hotbar-inventory").append(elem);
            }
            //var elem = '<div class="z-hotbar-item-slot" data-zhotbarslot="41"> <div class="z-hotbar-item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="z-hotbar-item-slot-img"></div><div class="z-hotbar-item-slot-label"><p>&nbsp;</p></div></div>'
            //$(".z-hotbar-inventory").append(elem);
            $.each(data.items, function(i, item){
                if (item != null) {
                    var ItemLabel = '<div class="item-slot-label"><p>' + item.label + '</p></div>';
                    if ((item.name).split("_")[0] == "weapon") {
                        if (!Inventory.IsWeaponBlocked(item.name)) {
                            ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + item.label + '</p></div>';                       
                        }
                    }
                    if (item.slot == 41) {
                        $(".z-hotbar-inventory").find("[data-zhotbarslot=" + item.slot + "]").html('<div class="z-hotbar-item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="z-hotbar-item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="z-hotbar-item-slot-amount"><p>' + item.amount + ' (' + ((item.weight * item.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                    } else {
                        $(".z-hotbar-inventory").find("[data-zhotbarslot=" + item.slot + "]").html('<div class="z-hotbar-item-slot-key"><p>' + item.slot + '</p></div><div class="z-hotbar-item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="z-hotbar-item-slot-amount"><p>' + item.amount + ' (' + ((item.weight * item.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                    }
                    Inventory.QualityCheck(item, true, false);
                }
            });
            $(".z-hotbar-inventory").fadeIn(150);
        } else {
            $(".z-hotbar-inventory").fadeOut(150, function(){
                $(".z-hotbar-inventory").html("");
            });
        }
    }

    Inventory.UseItem = function(data) {
        $(".itembox-container").hide();
        $(".itembox-container").fadeIn(250);
        $("#itembox-action").html("<p>Use</p>");
        $("#itembox-label").html("<p>"+data.item.label+"</p>");
        $("#itembox-image").html('<div class="item-slot-img"><img src="images/' + data.item.image + '" alt="' + data.item.name + '" /></div>')
        setTimeout(function(){
            $(".itembox-container").fadeOut(250);
        }, 2000)
    };

    var itemBoxtimer = null;
    var requiredTimeout = null;

    Inventory.itemBox = function(data) {
        if (itemBoxtimer !== null) {
            clearTimeout(itemBoxtimer)
        }
        var type = "Item Used"
        if (data.type == "add") {
            type = "Item Added";
        } else if (data.type == "remove") { 
            type = "Item Removed";
        }

        var $itembox = $(".itembox-container.template").clone();
        $itembox.removeClass('template');
        $itembox.html('<div id="itembox-action"><p>' + type + '</p></div><div id="itembox-label"><p>'+data.item.label+'</p></div><div class="item-slot-img"><img src="images/' + data.item.image + '" alt="' + data.item.name + '" /></div>');
        $(".itemboxes-container").prepend($itembox);
        $itembox.fadeIn(250);
        setTimeout(function() {
            $.when($itembox.fadeOut(300)).done(function() {
                $itembox.remove()
            });
        }, 3000);
    };

    Inventory.RequiredItem = function(data) {
        if (requiredTimeout !== null) {
            clearTimeout(requiredTimeout)
        }
        if (data.toggle) {
            if (!requiredItemOpen) {
                $(".requiredItem-container").html("");
                $.each(data.items, function(index, item){
                    var element = '<div class="requiredItem-box"><div id="requiredItem-action">Required</div><div id="requiredItem-label"><p>'+item.label+'</p></div><div id="requiredItem-image"><div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div></div></div>'
                    $(".requiredItem-container").hide();
                    $(".requiredItem-container").append(element);
                    $(".requiredItem-container").fadeIn(100);
                });
                requiredItemOpen = true;
            }
        } else {
            $(".requiredItem-container").fadeOut(100);
            requiredTimeout = setTimeout(function(){
                $(".requiredItem-container").html("");
                requiredItemOpen = false;
            }, 100)
        }
    };

    window.onload = function(e) {
        window.addEventListener('message', function(event) {
            switch(event.data.action) {
                case "open":
                    Inventory.Open(event.data);
                    break;
                case "close":
                    Inventory.Close();
                    break;
                case "update":
                    Inventory.Update(event.data);
                    break;
                case "itemBox":
                    Inventory.itemBox(event.data);
                    break;
                case "requiredItem":
                    Inventory.RequiredItem(event.data);
                    break;
                case "toggleHotbar":
                    Inventory.ToggleHotbar(event.data);
                    break;
                case "RobMoney":
                    $(".inv-options-list").append('<div class="inv-option-item" id="rob-money"><p>NO MONEY</p></div>');
                    $("#rob-money").data('TargetId', event.data.TargetId);
                    break;
                case "showId":
                    $(".ssn-id").html("" + event.data.ssn);
                    $(".fn-id").html("" + event.data.firstname);
                    $(".ln-id").html("" + event.data.lastname);
                    var gender = "Male";
                    if (event.data.gender == 1) {
                        gender = "Female";
                    }
                    $(".gender-id").html("" + gender);
                    $(".bd-id").html("" + event.data.birthdate);
                    $(".nat-id").html("" + event.data.nationality);
                    $(".sign-id").html("" + event.data.firstname + " " + event.data.lastname);
                    $(".card-info").show();
                    dismissId()
                    break;
                case "showLicense":
                    $(".ssn-driver").html("" + event.data.ssn);
                    $(".fn-driver").html("" + event.data.firstname);
                    $(".ln-driver").html("" + event.data.lastname);
                    var gender = "Male";
                    if (event.data.gender == 1) {
                        gender = "Female";
                    }
                    $(".gender-driver").html("" + gender);
                    $(".bd-driver").html("" + event.data.birthdate);
                    $(".code-driver").html("" + event.data.code);
                    $(".sign-driver").html("" + event.data.firstname + " " + event.data.lastname);
                    $(".driver-info").show();
                    dismissLicense()
                    break;
            }
        })
    }

})();

function dismissLicense() {
    setTimeout(function(){ 
        $(".driver-info").hide();
        $.post('http://lcrp-inventory/hideLicense', JSON.stringify({
    }));
    }, 5000);

}

function dismissId() {
    setTimeout(function(){ 
        $(".card-info").hide();
        $.post('http://lcrp-inventory/hideMugshot', JSON.stringify({
    }));
    }, 5000);

}

$(document).on('click', '#rob-money', function(e){
    e.preventDefault();
    var TargetId = $(this).data('TargetId');
    $.post('http://lcrp-inventory/RobMoney', JSON.stringify({
        TargetId: TargetId
    }));
    $("#rob-money").remove();
});