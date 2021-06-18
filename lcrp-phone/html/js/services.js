$(document).on('click', '#realestate-button', function(e){
    $.post('http://lcrp-phone/GetCurrentRealEstate', JSON.stringify({}), function(data){
        SetupRealEstates(data);
    });
    $(".services-specific-list").fadeIn(150)
    $(".services-p").html("REAL ESTATE")
    $(".services-p").css("font-size","1.8vw")
});

$(document).on('click', '#taxi-button', function(e){
    $.post('http://lcrp-phone/GetCurrentTaxi', JSON.stringify({}), function(data){
        SetupTaxis(data);
    });
    $(".services-specific-list").fadeIn(150)
    $(".services-p").html("TAXIS")
});

$(document).on('click', '#lawyer-button', function(e){
    $.post('http://lcrp-phone/GetCurrentLawyers', JSON.stringify({}), function(data){
        SetupLawyers(data);
    });
    $(".services-specific-list").fadeIn(150)
    $(".services-p").html("LAWYERS")
});

$(document).on('click', '.services-p', function(e){
    $(".services-specific-list").fadeOut(150)
    $(".services-p").html("SERVICES")
    $(".services-p").css("font-size","2vw")
});

function toHex(str) {
    var result = '';
    for (var i=0; i<str.length; i++) {
      result += str.charCodeAt(i).toString(16);
    }
    return result;
}


SetupRealEstates = function(data) {
    $(".services-specific-list").html("");

    if (data.length > 0) {
        $.each(data, function(i, realestate){
            var element = '<div class="real-estate-li" style="background-color: rgba(11, 65, 146, 0.9);" id="realestateid-'+i+'"> <div class="services-specific-code">' + 'RE' + toHex(realestate.name).substring(0,12) + '</div><div class="services-specific-fullname">' + realestate.name + '</div> <div class="realestate-list-call"><i class="fas fa-phone"></i></div> </div>'
            //var element = '<div class="realestate-list" id="realestateid-'+i+'"> <div class="realestate-list-firstletter">' + (realestate.name).charAt(0).toUpperCase() + '</div> <div class="realestate-list-fullname">' + realestate.name + '</div> <div class="realestate-list-call"><i class="fas fa-phone"></i></div> </div>'
            $(".services-specific-list").append(element);
            $("#realestateid-"+i).data('realestateData', realestate);
        });
    } else {
        var element = '<div class="realestate-list"><div class="no-specifics">There are no realestate available.</div></div>'
        $(".services-specific-list").append(element);
    }
}

SetupTaxis = function(data) {
    $(".services-specific-list").html("");
    if (data.length > 0) {
        $.each(data, function(i, lawyer){
            var element = '<div class="real-estate-li" style="background-color: rgba(228, 225, 55, 0.9);" id="taxiid-'+i+'"> <div class="services-specific-code">' + 'RE' + toHex(lawyer.name).substring(0,12) + '</div><div class="services-specific-fullname">' + lawyer.name + '</div> <div class="taxi-list-call"><i class="fas fa-phone"></i></div> </div>'
            //var element = '<div class="lawyer-list" id="lawyerid-'+i+'"> <div class="lawyer-list-firstletter">' + (lawyer.name).charAt(0).toUpperCase() + '</div> <div class="lawyer-list-fullname">' + lawyer.name + '</div> <div class="lawyer-list-call"><i class="fas fa-phone"></i></div> </div>'
            $(".services-specific-list").append(element);
            $("#taxiid-"+i).data('TaxiData', lawyer);
        });
    } else {
        var element = '<div class="taxi-li"><div class="no-specifics">There are no taxi available.</div></div>'
        $(".services-specific-list").append(element);
    }
}

SetupLawyers = function(data) {
    $(".services-specific-list").html("");
    if (data.length > 0) {
        $.each(data, function(i, lawyer){
            var element = '<div class="real-estate-li" style="background-color: rgba(134, 6, 6, 0.9);" id="lawyerid-'+i+'"> <div class="services-specific-code">' + 'RE' + toHex(lawyer.name).substring(0,12) + '</div><div class="services-specific-fullname">' + lawyer.name + '</div> <div class="lawyer-list-call"><i class="fas fa-phone"></i></div> </div>'
            //var element = '<div class="lawyer-list" id="lawyerid-'+i+'"> <div class="lawyer-list-firstletter">' + (lawyer.name).charAt(0).toUpperCase() + '</div> <div class="lawyer-list-fullname">' + lawyer.name + '</div> <div class="lawyer-list-call"><i class="fas fa-phone"></i></div> </div>'
            $(".services-specific-list").append(element);
            $("#lawyerid-"+i).data('LawyerData', lawyer);
        });
    } else {
        var element = '<div class="lawyer-li"><div class="no-specifics">There are no lawyers available.</div></div>'
        $(".services-specific-list").append(element);
    }
}
