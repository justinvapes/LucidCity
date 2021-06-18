

window.addEventListener('message', function(event) {
    let item = event.data;

    if (item.response == 'openTarget') {
        $(".target-label").html("");
        $('.target-wrapper').show();
        $(".target-eye").css("color", "black");
    } else if (item.response == 'closeTarget') {
        $(".target-label").html("");
        $('.target-wrapper').hide();
    } else if (item.response == 'validTarget') {
        let plyDuty = item.plyDuty
        let isInVeh = item.inVehicle
        let storeVeh = false
        $(".target-label").html("");
    $.each(item.data, function (index, item) {
        if (item.onlyInVeh == undefined) {
            item.onlyInVeh = false
        } 
        if (item.duty == undefined) {
            item.duty = false
        }
        if (plyDuty == item.duty || item.duty == false) {
            if (item.onlyInVeh == true) {
                if (isInVeh) {
                    $(".target-label").append("<div id='target-"+index+"'<li><span class='target-icon'><i class='"+item.icon+"'></i></span>&nbsp"+item.label+"</li></div>");
                }
            } else {
                if (!storeVeh) {
                    if (item.storeVeh == true && isInVeh == true) {
                        $(".target-label").append("<div id='target-"+index+"'<li><span class='target-icon'><i class='"+item.icon+"'></i></span>&nbspStore Vehicle"+"</li></div>");
                        storeVeh = true
                    } else if (item.parameters == "duty" && plyDuty == item.duty) {
                        $(".target-label").append("<div id='target-"+index+"'<li><span class='target-icon'><i class='"+item.icon+"'></i></span>&nbsp"+item.label+"</li></div>");
                    } else if ( !(item.parameters == "duty") && !(item.storeVeh == false) ) {
                        if (item.label != "Take vehicle back" || (item.label == "Take vehicle back" && item.owner)) {
                            $(".target-label").append("<div id='target-"+index+"'<li><span class='target-icon'><i class='"+item.icon+"'></i></span>&nbsp"+item.label+"</li></div>");
                        }
                    } else if (item.bsTray){
                        $(".target-label").append("<div id='target-"+index+"'<li><span class='target-icon'><i class='"+item.icon+"'></i></span>&nbsp"+item.label+"</li></div>");
                    } 
                    else {
                        
                    }
                }
            }

            $("#target-"+index).hover((e)=> {
                $("#target-"+index).css("color",e.type === "mouseenter"?"rgb(30,144,255)":"white")
            })
            
            $("#target-"+index+"").css("padding-top", "7px");
            $("#target-"+index).data('TargetData', item);
        }
    });
    if ($(".target-label").children().length > 0) {
        $(".target-eye").css("color", "rgb(30,144,255)");
    }
    } else if (item.response == 'leftTarget') {
        $(".target-label").html("");
        $(".target-eye").css("color", "black");
    }
});

$(document).on('mousedown', (event) => {
    let element = event.target;

    if (element.id.split("-")[0] === 'target') {
        let TargetData = $("#"+element.id).data('TargetData');

        $.post('http://lcrp-interact/selectTarget', JSON.stringify({
            event: TargetData.event,
            parameters: TargetData.parameters,
            serverEvent: TargetData.serverEvent,
        }));

        $(".target-label").html("");
        $('.target-wrapper').hide();
    }
});

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
            $(".target-label").html("");
            $('.target-wrapper').hide();
            $.post('http://lcrp-interact/closeTarget');
            break;
    }
});
