$(document).on('click', '.get-new', function(e){
    e.preventDefault();
    $(".airLines-flights").hide();
    $(".ticket-number").hide();
    $(".airLines-form").show();
    $(".submit-flight").show();
});

$(document).on('click', '.buy-ticket', function(e){
    e.preventDefault();
    id = $(this).parent().attr("id");
    $.post('http://lcrp-phone/BuyTicket', JSON.stringify({ flightId: id, }), function(bought){
        if(bought.state) {
            addNotification("fas fa-check", "LC Airlines", "You bought a ticket!");
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
        } else {
            if(bought.reason === "money") {
                addNotification("fas fa-exclamation-circle", "LC Airlines", "You don't have enough money!");
            }
            if(bought.reason === "full") {
                addNotification("fas fa-exclamation-circle", "LC Airlines", "The flight is full!");
            }
            if(bought.reason === "noflight") {
                addNotification("fas fa-exclamation-circle", "LC Airlines", "Couldn't find given id!");
            }
        }
    });
});

$(document).on('click', '.submit-flight', function(e){
    e.preventDefault();
    var erro = 0;
    if($("#air-preco").val() <= 99) {
        $(".air-preco-txt").css("color", "#f57d7d");
        erro = 1;
    } else {
        $(".air-preco-txt").css("color", "white");
    }

    if($("#air-nocu").val() < 1 || $("#air-nocu").val() > 15) {
        $(".air-nocu-txt").css("color", "#f57d7d");
        erro = 1;
    } else {
        $(".air-nocu-txt").css("color", "white");
    }

    if($("#air-hour").val() < 5 || $("#air-hour").val() > 60) {
        $(".air-hour-txt").css("color", "#f57d7d");
        erro = 1;
    } else {
        $(".air-hour-txt").css("color", "white");
    }

    if(erro == 0) {
        $.post('http://lcrp-phone/registerFlight', JSON.stringify({
            price: $("#air-preco").val(),
            seats: $("#air-nocu").val(),
            departs: $("#air-hour").val(),
            destination: $("#air-destinations").val(),
        }));
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
    } else {
        addNotification("fas fa-exclamation-circle", "LC Airlines", "Invalid Flight!");
    }
});



$(document).on('click', '.flight .destinationid', function(e){
    e.preventDefault();
    $.post('http://lcrp-phone/getPlyData', JSON.stringify({}), function (plyData) {
        plyData = JSON.parse(plyData)
        if (plyData.job.name == "airlines") {
            $.post('http://lcrp-phone/GetPassengers', JSON.stringify({ flightId: $(this).attr("id"), }), function(passengers){
            $( ".airLines-flights-ul" ).empty();
            if(passengers.state != false) {
                var i;
                for (i = 0; i < passengers.list.length; i++) {
                    $(".airLines-flights-ul").append(' <div class="passenger"><div class="flight-info-1"><p class="destinationid">'+ passengers.list[i] + '</p><p class="hour"></p></div><div class="flight-info-2"><p class="nocu"></p><p class="preco"></p></div></div>');
                }
            } else {
                addNotification("fas fa-exclamation-circle", "LC Airlines", "No passengers yet!");
            }
        });
    
        }
    });
});


$(document).on('click', '.airLines-logo', function(e){
    e.preventDefault();
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
});