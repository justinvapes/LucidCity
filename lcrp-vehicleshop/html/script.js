var selectedCategory = $('#home');
var currentVehicleData = null;
var inWorldMap = false;
var isLoaded = false;
var images = [];

$(document).ready(function(){
    $('.container').hide();
    $('.loader').hide();
    window.addEventListener('message', function(event){
        var eventData = event.data;

        if (eventData.action == "ui") {
            if (eventData.ui) {
                $('.container').fadeIn(200);
            } else {
                $('.container').fadeOut(200);
            }
        }

        if (eventData.action == "setupVehicles") {
            isLoaded = false
            setupVehicles(eventData.vehicles)
        }
    })

    $('[data-toggle="tooltip"]').tooltip();

    $('.vehicle-category').click(function(e){
        e.preventDefault();
        var vehicleCategory = $(this).attr('id');

        $(this).addClass('selected');
        if (selectedCategory !== null && selectedCategory !== this) {
            $(selectedCategory).removeClass('selected');
        }
        if (vehicleCategory == "home") {
            resetVehicles()
            $('.vehicle-shop-home').show();
        } else {
            if ($('.vehicle-shop-home').css("display") !== "none") {
                $.post('http://lcrp-vehicleshop/GetCategoryVehicles', JSON.stringify({
                    selectedCategory: vehicleCategory
                }))
                $('.vehicle-shop-home').fadeOut(100);
            } else {
                $.post('http://lcrp-vehicleshop/GetCategoryVehicles', JSON.stringify({
                    selectedCategory: vehicleCategory
                }))
            }
        }
        selectedCategory = this;
    });

    $('.map-pin').click(function(e){
        e.preventDefault();
        var garageId = $(this).attr('id');
        $.post('http://lcrp-vehicleshop/buyVehicle', JSON.stringify({
            vehicleData: currentVehicleData,
            garage: garageId
        }))
        currentVehicleData = null;
        inWorldMap = false;
        $('.vehicle-shop').css("filter", "none")
        $('.buy-vehicle-map').fadeOut(100);
    });

    $("#close-map").click(function(e){
        e.preventDefault();
        $('.vehicle-shop').css("filter", "none")
        $('.buy-vehicle-map').fadeOut(100);
        currentVehicleData = null;
        inWorldMap = false;
    });
});

function checkForLoaded(imagesLoaded, totalImages) {
    if(imagesLoaded === totalImages) {
        var loadingDiv = document.getElementById('loadingDiv');
        loadingDiv.parentNode.removeChild(loadingDiv);
    }
}

function preload() {
    for (var i = 0; i < arguments.length; i++) {
        images[i] = new Image();
        images[i].src = preload.arguments[i];
    }
}

function setupVehicles(vehicles) {
    $('.vehicles').html("");
    $('.loader').show();

    preload(vehicles.image);

    setTimeout(() => { 
        if (isLoaded !== true) {
            $('.loader').hide();
            $.each(vehicles, function(index, vehicle){    
                var elem = ('<div class="vehicle" id='+index+'><div class="car-image" style="background-image: url('+vehicle.image+')"><span id="vehicle-name">'+vehicle.name+'</span><div class="vehicle-buy-btn" data-vehicle="'+vehicle+'"><p>Purchase</p></div> <span id="vehicle-price">$ '+vehicle.price+'</span>  </div>');
                $('.vehicles').append(elem);
                $('#'+index).data('vehicleData', vehicle);
                isLoaded = true
            })
        }
    }, 1500);
}

function resetVehicles() {
    $('.vehicles').html("");
    $('.loader').hide();
}

$(document).on('click', '.vehicle-buy-btn', function(e){
    if (!inWorldMap) {
        e.preventDefault();
        currentVehicleData = null;
    
        var vehicleId = $(this).parent().parent().attr('id');
        var vehicleData = $('#'+vehicleId).data('vehicleData');
        currentVehicleData = vehicleData
        inWorldMap = true;

        $('.vehicle-shop').css("filter", "blur(2px)")
    
        $('.buy-vehicle-map').fadeIn(100);
    }
})

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
            $.post('http://lcrp-vehicleshop/exit')
            break;
    }
});