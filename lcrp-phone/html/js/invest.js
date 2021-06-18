var assets;
var dps = [];
var current_asset;

$(document).on('click', '.phone-btc-container', function(e){
    e.preventDefault();
    $(".invest-app").show();
    $(".invest-main").show();
    $(".invest-asset").hide();
    var d = new Date()
    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    $(".header-date").html(d.getDate() + " " + months[d.getMonth()])
    $.post('http://lcrp-phone/getCoinsValues', JSON.stringify({}), function(stonks){
        assets = stonks;
        $(".invest-assets-ul").empty();
        var i;
        var j;
        for(j=0; j < assets.length; j++) {
            percentage = (assets[j].value * 100) / assets[j].initial
            if (percentage > 100) {
                percentage = percentage - 100
            } else {
                percentage = (100 - percentage) * (- 1)
            }
            percentage = percentage.toFixed(2);
            if(percentage > 0) {
                if(assets[j].name.length > 23) {
                    $(".invest-assets-ul").append('<div class="asset" id ="' + j + '"><p class="asset-abv">' + assets[j].abv + '</p><p class="asset-name">' + assets[j].name.substring(0,21) + '..</p><p class="asset-value">' + assets[j].value.toFixed(5) + '$</p><p class="asset-percentage" style="background-color: rgba(144, 255, 32, 0.63);">+' + (Math.round(Math.abs(percentage) * 100) / 100).toFixed(2) + '%</p></div>');
                } else {
                    $(".invest-assets-ul").append('<div class="asset" id ="' + j + '"><p class="asset-abv">' + assets[j].abv + '</p><p class="asset-name">' + assets[j].name + '</p><p class="asset-value">' + assets[j].value.toFixed(5) + '$</p><p class="asset-percentage" style="background-color: rgba(144, 255, 32, 0.63);">+' + (Math.round(Math.abs(percentage) * 100) / 100).toFixed(2) + '%</p></div>');
                }
            } else {
                if(assets[j].name.length > 23) {
                    $(".invest-assets-ul").append('<div class="asset" id ="' + j + '"><p class="asset-abv">' + assets[j].abv + '</p><p class="asset-name">' + assets[j].name.substring(0,21) + '..</p><p class="asset-value">' + assets[j].value.toFixed(5) + '$</p><p class="asset-percentage" style="background-color: rgba(247, 42, 35, 0.63);">-' + (Math.round(Math.abs(percentage) * 100) / 100).toFixed(2) + '%</p></div>');
                } else {
                    $(".invest-assets-ul").append('<div class="asset" id ="' + j + '"><p class="asset-abv">' + assets[j].abv + '</p><p class="asset-name">' + assets[j].name + '</p><p class="asset-value">' + assets[j].value.toFixed(5) + '$</p><p class="asset-percentage" style="background-color: rgba(247, 42, 35, 0.63);">-' + (Math.round(Math.abs(percentage) * 100) / 100).toFixed(2) + '%</p></div>');
                }
            }
        }
    });
});

$(document).on('click', '.asset', function(e){
    e.preventDefault();
    current_asset = assets[parseInt($(this).attr("id"))];
    $(".invest-main").hide();
    $(".invest-asset").show();
    $(".chart-abv").html(current_asset.abv);
    $(".chart-name").html(current_asset.name);
    var i;
    var j;
    $(".highway-lane").empty();
    for(i=0; i < 2; i++) {
        for(j=0; j < assets.length; j++) {
            percentage = (assets[j].value * 100) / assets[j].initial
            if (percentage > 100) {
                percentage = percentage - 100
            } else {
                percentage = 100 - percentage
            }

            percentage = percentage.toFixed(2);
            if(percentage > 0) {
                $(".highway-lane").append('<div class="highway-car"><p class="abv">' + assets[j].abv + '</p><p class="value">' + assets[j].value.toFixed(2) + '</p><p class="percentage" style="background-color: rgba(144, 255, 32, 0.63);">+' + (Math.round(Math.abs(percentage) * 100) / 100).toFixed(2) + '%</p></div>');
            } else {
                $(".highway-lane").append('<div class="highway-car"><p class="abv">' + assets[j].abv + '</p><p class="value">' + assets[j].value.toFixed(2) + '</p><p class="percentage" style="background-color: rgba(247, 42, 35, 0.63);">-' + (Math.round(Math.abs(percentage) * 100) / 100).toFixed(2) + '%</p></div>');
            }
        }
    }

    $.post('http://lcrp-phone/getAssetValues', JSON.stringify({name: current_asset.abv}), function(values){
        var info = values;
        parseDataPoints(info)
        var chart = new CanvasJS.Chart("chartContainer", {
            animationEnabled: true,
            theme: "light2",
            backgroundColor:'rgba(156, 156, 156, 0.2)',
            title:{
                text: ""
            },
            axisY:{
                gridColor: "rgba(156,156,156,0.35)",
                labelFormatter: function(){
                    return " ";
                }
            },
            axisX:{
                labelFormatter: function(){
                    return " ";
                }
            },
            data: [{        
                type: "area",
                markerType: "none",
                fillOpacity: .1,
                color: 'rgba(144, 255, 32, 0.63)',
                indexLabelFontSize: 16,
                dataPoints: dps
            }]
        });
        chart.render();
        $(".chart-info-value").html("Value: " + current_asset.value.toFixed(5));
        $(".chart-info-max").html("Max: " + Math.max.apply(null,info).toFixed(5));
        $(".chart-info-min").html("Min: " + Math.min.apply(null,info).toFixed(5));
        $(".chart-info-vol").html("VOL: " + Math.sqrt(Math.max.apply(null,info)).toFixed(5));
        $(".chart-info-fib").html("FIB: " + Math.sin(Math.max.apply(null,info)).toFixed(5));
        $(".chart-info-nls").html("NLS: " + Math.tan(Math.max.apply(null,info)).toFixed(5));
        dps = [];
    });
    getPlayerValues()
});

$(document).on('click', '.buy-asset', function(e){
    e.preventDefault();
    $.post('http://lcrp-phone/buyAsset', JSON.stringify({name: current_asset.abv, value: parseInt($("#asset-amount").val())}), function(bought) {
        if(bought) {
            getPlayerValues();
        } else {
            addNotification("fas fa-university", "Assets", "Couldn't execute your request!", "rgba(247, 42, 35, 0.63)", 1500);
        }
    });
});

$(document).on('click', '.sell-asset', function(e){
    e.preventDefault();
    $.post('http://lcrp-phone/sellAsset', JSON.stringify({name: current_asset.abv, value: parseInt($("#asset-amount").val())}), function(sold) {
        if(sold) {
            getPlayerValues();
        } else {
            addNotification("fas fa-university", "Assets", "Couldn't execute your request!", "rgba(247, 42, 35, 0.63)", 1500);
        }
    });
});

$(document).on('click', '.phone-invest-container', function(e){
    e.preventDefault();
    $(".invest-app").hide();
});

$(document).on('click', '.phone-asset-back', function(e){
    e.preventDefault();
    $(".invest-asset").hide();
    $(".invest-main").show();
});

function parseDataPoints( info) {
    //var info = [12,3,9,20,4,5,24,27];
    for (var i = 0; i < info.length; i++)
      dps.push({
        y: info[i]
    });
};

function getPlayerValues() {
    $.post('http://lcrp-phone/getPlayerValues', JSON.stringify({name: current_asset.abv}), function(info) {
        $(".asset-person-wallet").html(info.wallet.toFixed(2) + "$");
        $(".asset-person-amount").html(info.amount.toFixed(5));
        $(".asset-person-dollars").html(info.dollars.toFixed(2) + "$");
    });
}

$(document).on('click', '.phone-btc-container', function(e){
    e.preventDefault();
    $(".invest-app").show();
});

$(document).on('click', '.phone-inv-container', function(e){
    e.preventDefault();
    $(".invest-app").hide();
});




/*
$(document).on('click', '.invest-app-buy', function(e){
    e.preventDefault();
    amt = parseInt($("#inv-amount").val());
    if(amt === 0) {
        scPhone.Notifications.Add("fas fa-exclamation-circle", "LC Markets", "Zero is not a valid amount!");
    } else {
        $.post('http://lcrp-phone/buyStonks', JSON.stringify({ amount: parseFloat(amt), }), function(stonks){
            if (stonks) {
                scPhone.Notifications.Add("fas fa-check", "LC Markets", "You bought Lucid Coin!");
                re =" ";
                ldc = parseFloat($(".LDC").text().split(re)[0]);
                dolar = parseFloat($(".dollars").text().split(re)[0]);
                amnt = parseFloat($("#inv-amount").val());
                ldc = ldc + amnt;
                dolar = dolar + (amnt/parseFloat(globalLDC));
                $(".LDC").html("" + ldc.toFixed(2) + " $");
                $(".dollars").html("" + dolar.toFixed(8) + " LDC");
            } else {
                scPhone.Notifications.Add("fas fa-exclamation-circle", "LC Markets", "You don't have enough money!");
            }
        });   
    }
});

$(document).on('click', '.invest-app-sell', function(e){
    e.preventDefault();
    amt = parseInt($("#inv-amount").val());
    if(amt === 0) {
        scPhone.Notifications.Add("fas fa-exclamation-circle", "LC Markets", "Zero is not a valid amount!");
    } else {
        $.post('http://lcrp-phone/sellStonks', JSON.stringify({ amount: parseFloat(amt), }), function(stonks){
            if (stonks) {
                scPhone.Notifications.Add("fas fa-check", "LC Markets", "You sold Lucid Coin!");
                re =" ";
                ldc = parseFloat($(".LDC").text().split(re)[0]);
                dolar = parseFloat($(".dollars").text().split(re)[0]);
                amnt = parseFloat($("#inv-amount").val());
                ldc = ldc - amnt;
                dolar = dolar - (amnt/parseFloat(globalLDC));
                $(".LDC").html("" + ldc.toFixed(2) + " $");
                $(".dollars").html("" + dolar.toFixed(8) + " LDC");
            } else {
                scPhone.Notifications.Add("fas fa-exclamation-circle", "LC Markets", "You don't have enough coin!");
            }
        });
    }
}); */
