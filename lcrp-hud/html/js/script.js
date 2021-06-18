LCRPHud = {};

LCRPHud.ToggleSeatbelt = function(data) {
  if(data.status) {
      $('#seatbelt2').css('stroke','#ffffff');
  } else {
      $('#seatbelt2').css('stroke','#ce2d2d00');
  }
};

LCRPHud.CarHud = function(data) {
  if (data.show) {
      $(".ui-logo").fadeIn();
      $(".logo-line").fadeIn();
      $(".ui-car-container").fadeIn();
      $(".mapoutline").css('display', 'block');
  } else {
      $(".ui-logo").fadeOut();
      $(".logo-line").hide();
      $("#waypointDistance").html("");
      $(".ui-car-container").fadeOut();
      $(".mapoutline").css('display', 'none');
  }
};

LCRPHud.setProgressFuel = function(percent, element) {
  var circle = document.querySelector(element);
  var radius = circle.r.baseVal.value;
  var circumference = radius * 2 * Math.PI;
  var html = $(element).parent().parent().find('span');

  circle.style.strokeDasharray = `${circumference} ${circumference}`;
  circle.style.strokeDashoffset = `${circumference}`;

  const offset = circumference - ((-percent*73)/100) / 100 * circumference;
  circle.style.strokeDashoffset = -offset;

  html.text(Math.round(percent));
};

LCRPHud.setProgressSpeed = function(value, element) {
  var circle = document.querySelector(element);
  var radius = circle.r.baseVal.value;
  var circumference = radius * 2 * Math.PI;
  var html = $(element).parent().parent().find('span');
  var percent = value*100/220;

  circle.style.strokeDasharray = `${circumference} ${circumference}`;
  circle.style.strokeDashoffset = `${circumference}`;

  const offset = circumference - ((-percent*73)/100) / 100 * circumference;
  circle.style.strokeDashoffset = -offset;

  var predkosc = Math.floor(value * 1.8)
  if (predkosc == 81 || predkosc == 131) {
    predkosc = predkosc - 1
  }

  html.text(predkosc);
}

LCRPHud.UpdateCash = function(data) {
  if(data.type == "cash") {
      $(".money-cash").css("display", "block");
      $("#cash").html(data.cash);
      if (data.minus) {
          $(".money-cash").append('<p class="moneyupdate minus">-<span id="cash-symbol">&dollar;&nbsp;</span><span><span id="minus-changeamount">' + data.amount + '</span></span></p>')
          $(".minus").css("display", "block");
          setTimeout(function() {
              $(".minus").fadeOut(750, function() {
                  $(".minus").remove();
                  $(".money-cash").fadeOut(750);
              });
          }, 3500)
      } else {
          $(".money-cash").append('<p class="moneyupdate plus">+<span id="cash-symbol">&dollar;&nbsp;</span><span><span id="plus-changeamount">' + data.amount + '</span></span></p>')
          $(".plus").css("display", "block");
          setTimeout(function() {
              $(".plus").fadeOut(750, function() {
                  $(".plus").remove();
                  $(".money-cash").fadeOut(750);
              });
          }, 3500)
      }
  }
};

$(document).ready(function() {
    document.getElementById("hunger").style.display = "";
    document.getElementById("thirst").style.display = "";
    document.getElementById("hunger-thirst").style.display = "";
    document.getElementById("hunger-option").style.display = "";
    document.getElementById("thirst-option").style.display = "";
    document.getElementById("stress").style.display = "none";
    document.getElementById("stress-show").style.display = "none";
    document.getElementById("stress-button").style.display = "none";
    document.getElementById("stress-option").style.display = "none";
    document.getElementById("stress").style.display = "";
    document.getElementById("stress-show").style.display = "";
    document.getElementById("stress-button").style.display = "";
    document.getElementById("stress-option").style.display = "";
});

// Set everything to be draggable
$(function() {
  $('#hunger').draggable({
    drag: function(event, ui){
      dragpositionHungerTop = ui.position.top;
      dragpositionHungerLeft = ui.position.left;
      localStorage.setItem("hungerTop", dragpositionHungerTop);
      localStorage.setItem("hungerLeft", dragpositionHungerLeft);
    }
  });
  $('#thirst').draggable({
    drag: function(event, ui){
      dragpositionThirstTop = ui.position.top;
      dragpositionThirstLeft = ui.position.left;
      localStorage.setItem("thirstTop", dragpositionThirstTop);
      localStorage.setItem("thirstLeft", dragpositionThirstLeft);
    }
  });
    $('#stress').draggable({
      drag: function(event, ui){
        dragpositionStressTop = ui.position.top;
        dragpositionStressLeft = ui.position.left;
        localStorage.setItem("stressTop", dragpositionStressTop);
        localStorage.setItem("stressLeft", dragpositionStressLeft);
      }
  });
  $('#health').draggable({
    drag: function(event, ui){
      dragpositionHealthTop = ui.position.top;
      dragpositionHealthLeft = ui.position.left;
      localStorage.setItem("healthTop", dragpositionHealthTop);
      localStorage.setItem("healthLeft", dragpositionHealthLeft);
    }
  });
  $("#armor").draggable({
    drag: function(event, ui){
      dragpositionArmorTop = ui.position.top;
      dragpositionArmorLeft = ui.position.left;
      localStorage.setItem("armorTop", dragpositionArmorTop);
      localStorage.setItem("armorLeft", dragpositionArmorLeft);
    }
  });
  $("#drag-browser").draggable();
});

// Switches & Cases
window.addEventListener("message", function(event) {
  switch (event.data.action) {
    case "show":
      $("#drag-browser").fadeIn();
    break;

    case "hide":
      $("#drag-browser").fadeOut();
    break;

    case "waypointDistance":
        if (event.data.show) {
          $("#waypointDistance").html((event.data.distance).toFixed(2) + "mi");
        } else {
          $("#waypointDistance").html("");
        }
    break;

    case "setColors":
      $('#hunger-circle').css('stroke', localStorage.getItem("hungerColor"));
      $('#thirst-circle').css('stroke', localStorage.getItem("thirstColor"));
      $("#stress-circle").css('stroke', localStorage.getItem("stressColor"));
      $('#health-circle').css('stroke', localStorage.getItem("healthColor"));
      $('#armor-circle').css('stroke', localStorage.getItem("armorColor"));
    break;

    case "update":
        LCRPHud.UpdateCash(event.data);
    break;

    case "showCash":
        $(".money-cash").fadeIn(150);
        $("#cash").html(event.data.cash);
        setTimeout(function() {
            $(".money-cash").fadeOut(750);
        }, 3500)
    break;

    case "car":
        LCRPHud.CarHud(event.data);
    break;

    case "seatbelt":
      if(event.data.status){
        $('#seatbelt2').css('stroke','#ffffff');
      } else {
          $('#seatbelt2').css('stroke','#ce2d2d00');
      }
    break;

    case "updateSpeed":
      LCRPHud.setProgressSpeed(event.data.speed,'.progress-speed');
    break;

    case "setPosition":
      $("#hunger").animate({ top: localStorage.getItem("hungerTop"), left: localStorage.getItem("hungerLeft") });
      $("#thirst").animate({ top: localStorage.getItem("thirstTop"), left: localStorage.getItem("thirstLeft") });
      $("#stress").animate({ top: localStorage.getItem("stressTop"), left: localStorage.getItem("stressLeft") });
      $("#health").animate({ top: localStorage.getItem("healthTop"), left: localStorage.getItem("healthLeft") });
      $("#armor").animate({ top: localStorage.getItem("armorTop"), left: localStorage.getItem("armorLeft") });
    break;

    // Send Data
    case "hud":
        progressCircle(event.data.hunger, ".hunger");
        progressCircle(event.data.thirst, ".thirst");
        progressCircle(event.data.stress, ".stress");
        progressCircle(event.data.health, ".health");
        progressCircle(event.data.armor, ".armor");
        
        $("#fuel-amount").html((event.data.fuel).toFixed(0));
        $("#speed-amount").html(event.data.speed);

        if(event.data.fuel < 15) {
            $("#fuel-amount").css("color","rgb(255, 51, 51)");
            $(".fa-gas-pump").css("color","rgb(255, 51, 51)");
        } else {
            $("#fuel-amount").css("color","white");
            $(".fa-gas-pump").css("color","white");
        }

        if (event.data.engine < 600) {
            $(".car-engine-info img").attr('src', './img/engine-red.png');
            $(".car-engine-info").fadeIn(150);
        } else if (event.data.engine < 800) {
            $(".car-engine-info img").attr('src', './img/engine.png');
            $(".car-engine-info").fadeIn(150);
        } else {
            if ($(".car-engine-info").is(":visible")) {
                $(".car-engine-info").fadeOut(150);
            }
        }
    break;

    // Hide elements
    case "healthHide":
      $("#health").fadeOut();
    break;

    case "armorHide":
      $("#armor").fadeOut();
    break;

    case "hungerHide":
      $("#hunger").fadeOut();
    break;

    case "thirstHide":
      $("#thirst").fadeOut();
    break;

    case "stressHide":
      $("#stress").fadeOut();
    break;

    case "updateGas":
      LCRPHud.setProgressFuel(event.data.value,'.progress-fuel');
      if (event.data.value < 15) {
          $('#fuel').css('stroke', '#f03232');
      } else if (event.data.value > 15) {
          $('#fuel').css('stroke', '#ffffff');
      }
    break;

    case "cinematicHide":
      $("#cinematic").fadeOut();
    break;

    // Show elements
    case "healthShow":
      $("#health").fadeIn();
    break;

    case "armorShow":
      $("#armor").fadeIn();
    break;

    case "hungerShow":
      $("#hunger").fadeIn();
    break;

    case "thirstShow":
      $("#thirst").fadeIn();
    break;
    
    case "stressShow":
      $("#stress").fadeIn();
    break;

    case "cinematicShow":
      $("#cinematic").fadeIn();
    break;

    // Pulse elements
    case "healthStart":
      document.getElementById("health").style.animation = "pulse 1.5s linear infinite";
    break;

    case "healthStop":
      document.getElementById("health").style.animation = "none";
    break;

    case "armorStart":
      document.getElementById("armor").style.animation = "pulse 1.5s linear infinite";
    break;

    case "armorStop":
      document.getElementById("armor").style.animation = "none";
    break;
  }
});

$(function () {
  $('#color-block').on('colorchange', function () {
    let color = $(this).wheelColorPicker('value')
    switch ($("#selection").val()) {
      case "health-option":
        $('#health-circle').css('stroke', color);
        localStorage.setItem("healthColor", color);
      break;

      case "armor-option":
        $('#armor-circle').css('stroke', color);
        localStorage.setItem("armorColor", color);
      break;

      case "hunger-option":
        $('#hunger-circle').css('stroke', color);
        localStorage.setItem("hungerColor", color);
      break;

      case "thirst-option":
        $('#thirst-circle').css('stroke', color);
        localStorage.setItem("thirstColor", color);
      break;

      case "stress-option":
        $('#stress-circle').css('stroke', color);
        localStorage.setItem("stressColor", color);
      break;
    };
  });
});

// Click functions
$("#hunger-switch").click(function() {$.post('https://lcrp-hud/change', JSON.stringify({action: 'hunger'}));});
$("#thirst-switch").click(function() {$.post('https://lcrp-hud/change', JSON.stringify({action: 'thirst'}));});
$("#stress-switch").click(function() {$.post('https://lcrp-hud/change', JSON.stringify({action: 'stress'}));});
$("#health-switch").click(function () { $.post('https://lcrp-hud/change', JSON.stringify({ action: 'health' })); });
$("#armor-switch").click(function () { $.post('https://lcrp-hud/change', JSON.stringify({ action: 'armor' })); });
$("#cinematic-switch").click(function () { $.post('https://lcrp-hud/change', JSON.stringify({ action: 'cinematic' })) });
$("#reset").click(function () { $("#drag-browser").animate({ top: "", left: "50%" }); });
$("#close").click(function () { $.post('https://lcrp-hud/close');});

$("#reset-position").click(function () {
  $("#hunger").animate({top: "0px", left: "0px"});
  localStorage.setItem("hungerTop", "0px");
  localStorage.setItem("hungerLeft", "0px");
  $("#thirst").animate({top: "0px", left: "0px"});
  localStorage.setItem("thirstTop", "0px");
  localStorage.setItem("thirstLeft", "0px");
  $("#stress").animate({top: "0px", left: "0px"});
  localStorage.setItem("stressTop", "0px");
  localStorage.setItem("stressLeft", "0px");
  $("#health").animate({ top: "0px", left: "0px" });
  localStorage.setItem("healthTop", "0px");
  localStorage.setItem("healthLeft", "0px");
  $("#armor").animate({ top: "0px", left: "0px" });
  localStorage.setItem("armorTop", "0px");
  localStorage.setItem("armorLeft", "0px");
});

$("#reset-color").click(function () {
  $('#hunger-circle').css('stroke', '');
  localStorage.setItem("hungerColor", '');
  $('#thirst-circle').css('stroke', '');
  localStorage.setItem("thirstColor", '');
  $('#stress-circle').css('stroke', '');
  localStorage.setItem("stressColor", '');
  $('#health-circle').css('stroke', '');
  localStorage.setItem("healthColor", '');
  $('#armor-circle').css('stroke', '');
  localStorage.setItem("armorColor", '');
});
// Color picker function
$(function () {
  $('#color-block').on('colorchange', function () {
    let color = $(this).wheelColorPicker('value');
    let alpha = $(this).wheelColorPicker('color').a;
    $('.color-preview-box').css('background-color', color);
    $('.color-preview-alpha').text(Math.round(alpha * 100) + '%');
  });
});

// Just for print values easier
function print(value) {
  console.log(value)
}

// Exit function
document.onkeyup = function (event) {
  if (event.key == 'Escape') {
    $.post('https://lcrp-hud/close');
  }
};
// Function for progress bars
function progressCircle(percent, element) {
  const circle = document.querySelector(element);
  const radius = circle.r.baseVal.value;
  const circumference = radius * 2 * Math.PI;
  const html = $(element).parent().parent().find("span");

  circle.style.strokeDasharray = `${circumference} ${circumference}`;
  circle.style.strokeDashoffset = `${circumference}`;

  const offset = circumference - ((-percent * 100) / 100 / 100) * circumference;
  circle.style.strokeDashoffset = -offset;

  html.text(Math.round(percent));
}
