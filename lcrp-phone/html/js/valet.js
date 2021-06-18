valetLevelsTxt = false 
$(document).on("click", ".valet-request-service", function(e){
    if(PlayerData.donations.hasValet != null && PlayerData.donations.hasValet > 0) {
        if (PlayerData.fivem != null) {
            updateValetCars();
        }else {
            addNotification("fas fa-exclamation", "Valet", "You do not have access to this service! Link FiveM account");
        }

    } else {
        addNotification("fas fa-exclamation", "Valet", "You do not have access to this service!");
    }
});

$(document).on("click", ".valet-starter-plusinfo", function(e){
    if(valetLevelsTxt) {
        valetLevelsTxt = false
        $(".valet-levels").fadeOut(400);
        $(".valet-starter-txt").fadeIn(650);
    } else {
        valetLevelsTxt = true
        $(".valet-starter-txt").fadeOut(400);
        $(".valet-levels").fadeIn(650);
    }
});

$(document).on("click", ".valet-request-back", function(e){
    $(".valet-cars").fadeOut(400);
    $(".valet-cars-header").fadeOut(400);
    $(".valet-vehicle").fadeOut(400);
    $('.valet-request-back').fadeOut(400);
    $('.valet-request-service').fadeIn(650);
    $('.valet-starter-img').fadeIn(650);
    if(valetLevelsTxt) {
        $(".valet-levels").hide();
        $(".valet-starter-txt").fadeIn(650);
    } else {
        $(".valet-starter-txt").hide();
        $(".valet-levels").fadeIn(650);
    }
    $('.valet-starter-plusinfo').fadeIn(650);
});

$(document).on("click", ".valet-vehicle", function(e){
    if($(this).attr("data") == "reg" || $(this).attr("data") == "miss" ) {
        $(".valet-cars").fadeOut(400);
        $(".valet-cars-header").fadeOut(400);
        $(".valet-vehicle").fadeOut(400);
        $(".valet-vehicle-newplate").fadeIn(400);
        
    }
    if($(this).attr("data") == "car") {
        $.post('http://lcrp-phone/ValetService', JSON.stringify({state: 1, plate: $(this).attr("plate")}), function(notification){
            addNotification("fas fa-exclamation", "Valet", notification[1]);
        });
        $(".valet-levels").fadeOut(650)
        $('.valet-request-service').fadeIn(650);
        $('.valet-request-back').fadeOut(400);
        $('.valet-starter-img').fadeIn(650);
        if(valetLevelsTxt) {
            $(".valet-levels").hide();
            $(".valet-starter-txt").fadeIn(650);
        } else {
            $(".valet-starter-txt").hide();
            $(".valet-levels").fadeIn(650);
        }
        $('.valet-starter-plusinfo').fadeIn(650);
    }
    $('.valet-cars').fadeOut(250);
    $(".valet-cars-header").fadeOut(400);
});

$(document).on("click", ".valet-vehicle-register", function(e){
    var platenum = $(".valet-vehicle-platereg").val();
    $.post('http://lcrp-phone/ValetService', JSON.stringify({state: 2, plate: platenum}), function(notification){
        $(".valet-vehicle-newplate").fadeOut(400);
        updateValetCars();
        addNotification("fas fa-exclamation", "Valet", notification[1]);
    });
});

$(document).on("click", ".valet-vehicle-cancel", function(e){
        $(".valet-vehicle-newplate").fadeOut(400);
        updateValetCars();
});

function updateValetCars() {
    $.post('http://lcrp-phone/GetValetCars', JSON.stringify({}), function(cars){
        $(".valet-cars").html("")
        for(var i = 0; i < PlayerData.donations.valetData.cars; i++) {
            if(cars[i] == "Add a car to the valet service!") {
                $(".valet-cars").append('<div class="valet-vehicle" data="reg" plate="">Register vehicle</div>');
            } else if (cars[i] == "Missing Car Data") {
                $(".valet-cars").append('<div class="valet-vehicle" data="miss" plate="">Missing vehicle data</div>');
            } else {
                if (cars[i].state == 0) {
                    $(".valet-cars").append('<div class="valet-vehicle" data="car" plate="'+cars[i].plate+'"><p class="valet-vehicle-name">'+cars[i].carName.substring(0,24)+'</p><p class="valet-vehicle-plate">'+cars[i].plate+'</p><p class="valet-vehicle-pound">$'+ parseInt(cars[i].Impoundprice  + 1000) +'</p></div>');
                } else {
                    $(".valet-cars").append('<div class="valet-vehicle" data="car" plate="'+cars[i].plate+'"><p class="valet-vehicle-name">'+cars[i].carName+'</p><p class="valet-vehicle-plate">'+cars[i].plate+'</p><p class="valet-vehicle-pound">$'+ 1000 +'</p></div>');
                }
            }
        }
        $('.valet-request-service').fadeOut(250);
        $('.valet-starter-plusinfo').fadeOut(250);
        $('.valet-starter-img').fadeOut(250);
        $('.valet-starter-txt').fadeOut(250);
        $('.valet-levels').fadeOut(250);
        $(".valet-cars-header").fadeIn(400);
        $('.valet-cars').fadeIn(250);
        $(".valet-cars .valet-vehicle").each(function(i) {
            $(this).delay(100 * i).fadeIn(500);
        });
        $('.valet-request-back').fadeIn(250);
    });
}