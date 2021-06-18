Settings = {};
Background = "backgroundimage";
OpenedTab = null;
Backgrounds = {
    'backgroundimage': {
        label: "Default"
    }
};

var PressedBackground = null;
var PressedBackgroundObject = null;
var OldBackground = null;
var IsChecked = null;

$(document).on('click', '.settings-app-tab', function(e){
    e.preventDefault();
    var PressedTab = $(this).data("settingstab");

    if (PressedTab == "background") {
        $(".settings-"+PressedTab+"-tab").fadeIn(150);
        OpenedTab = PressedTab;
    } else if (PressedTab == "profilepicture") {
        $(".settings-"+PressedTab+"-tab").fadeIn(150);
        OpenedTab = PressedTab;
    } else if (PressedTab == "numberrecognition") {
        var checkBoxes = $(".numberrec-box");
        AnonymousCallGlobal = !checkBoxes.prop("checked");
        checkBoxes.prop("checked", AnonymousCallGlobal);

        if (!AnonymousCallGlobal) {
            $("#numberrecognition > p").html('Off');
        } else {
            $("#numberrecognition > p").html('On');
        }
    }
});

$(document).on('click', '#accept-background', function(e){
    e.preventDefault();
    var hasCustomBackground = IsBackgroundCustom();

    if (hasCustomBackground === false) {
        addNotification("fas fa-paint-brush", "Settings",Backgrounds[Background].label+" set!")
        $(".settings-"+OpenedTab+"-tab").fadeOut(150);
        $(".phone-background").css({"background-image":"url('/html/img/backgrounds/"+Background+".png')"})
    } else {
        addNotification("fas fa-paint-brush", "Settings", "Own background set!")
        $(".settings-"+OpenedTab+"-tab").fadeOut(150);
        $(".phone-background").css({"background-image":"url('"+Background+"')"});
    }

    $.post('http://lcrp-phone/SetBackground', JSON.stringify({
        background: Background,
    }))
});

LoadMetaData = function(MetaData) {
    if (MetaData.background !== null && MetaData.background !== undefined) {
        Background = MetaData.background;
    } else {
      Background = "backgroundimage";
    }

    var hasCustomBackground =IsBackgroundCustom();

    if (!hasCustomBackground) {
        $(".phone-background").css({"background-image":"url('/html/img/backgrounds/"+Background+".png')"})
    } else {
        $(".phone-background").css({"background-image":"url('"+Background+"')"});
    }

    if (MetaData.profilepicture == "default") {
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="./img/default.png">');
    } else {
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="'+MetaData.profilepicture+'">');
    }
}

$(document).on('click', '#cancel-background', function(e){
    e.preventDefault();
    $(".settings-"+OpenedTab+"-tab").fadeOut(150);
});

IsBackgroundCustom = function() {
    var retval = true;
    $.each(Backgrounds, function(i, background){
        if (Background == i) {
            retval = false;
        }
    });
    return retval
}

$(document).on('click', '.background-option', function(e){
    e.preventDefault();
    PressedBackground = $(this).data('background');
    PressedBackgroundObject = this;
    OldBackground = $(this).parent().find('.background-option-current');
    IsChecked = $(this).find('.background-option-current');

    if (IsChecked.length === 0) {
        if (PressedBackground != "custom-background") {
           Background = PressedBackground;
            $(OldBackground).fadeOut(50, function(){
                $(OldBackground).remove();
            });
            $(PressedBackgroundObject).append('<div class="background-option-current"><i class="fas fa-check-circle"></i></div>');
        } else {
            $(".background-custom").fadeIn(150);
        }
    }
});

$(document).on('click', '#accept-custom-background', function(e){
    e.preventDefault();

    Background = $(".custom-background-input").val();
    $(OldBackground).fadeOut(50, function(){
        $(OldBackground).remove();
    });
    $(PressedBackgroundObject).append('<div class="background-option-current"><i class="fas fa-check-circle"></i></div>');
    $(".background-custom").fadeOut(150);
});

$(document).on('click', '#cancel-custom-background', function(e){
    e.preventDefault();
    $(".background-custom").fadeOut(150);
});

// Profile Picture

var PressedProfilePicture = null;
var PressedProfilePictureObject = null;
var OldProfilePicture = null;
var ProfilePictureIsChecked = null;

$(document).on('click', '#accept-profilepicture', function(e){
    e.preventDefault();
    var ProfilePicture = profilepicture;
    if (ProfilePicture === "default") {
        addNotification("fas fa-paint-brush", "Instellingen", "Standaard profielfoto is ingesteld!")
        $(".settings-"+OpenedTab+"-tab").fadeOut(150);
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="./img/default.png">');
    } else {
        addNotification("fas fa-paint-brush", "Instellingen", "Eigen profielfoto ingesteld!")
        $(".settings-"+OpenedTab+"-tab").fadeOut(150);
        console.log(ProfilePicture)
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="'+ProfilePicture+'">');
    }
    $.post('http://lcrp-phone/UpdateProfilePicture', JSON.stringify({
        profilepicture: ProfilePicture,
    }));
});

$(document).on('click', '#accept-custom-profilepicture', function(e){
    e.preventDefault();
    profilepicture = $(".custom-profilepicture-input").val();
    $(OldProfilePicture).fadeOut(50, function(){
        $(OldProfilePicture).remove();
    });
    $(PressedProfilePictureObject).append('<div class="profilepicture-option-current"><i class="fas fa-check-circle"></i></div>');
    $(".profilepicture-custom").fadeOut(150);
});

$(document).on('click', '.profilepicture-option', function(e){
    e.preventDefault();
    PressedProfilePicture = $(this).data('profilepicture');
    PressedProfilePictureObject = this;
    OldProfilePicture = $(this).parent().find('.profilepicture-option-current');
    ProfilePictureIsChecked = $(this).find('.profilepicture-option-current');
    if (ProfilePictureIsChecked.length === 0) {
        if (PressedProfilePicture != "custom-profilepicture") {
            profilepicture = PressedProfilePicture
            $(OldProfilePicture).fadeOut(50, function(){
                $(OldProfilePicture).remove();
            });
            $(PressedProfilePictureObject).append('<div class="profilepicture-option-current"><i class="fas fa-check-circle"></i></div>');
        } else {
            $(".profilepicture-custom").fadeIn(150);
        }
    }
});

$(document).on('click', '#cancel-profilepicture', function(e){
    e.preventDefault();
    $(".settings-"+OpenedTab+"-tab").fadeOut(150);
});


$(document).on('click', '#cancel-custom-profilepicture', function(e){
    e.preventDefault();
    $(".settings-"+OpenedTab+"-tab").fadeOut(150);
});