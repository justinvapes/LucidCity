$(document).on('click', '.realestate-list-call', function(e){
    e.preventDefault();

    var realestateData = $(this).parent().data('realestateData');
    
    var cData = {
        number: realestateData.phone,
        name: realestateData.name
    }

    $.post('http://lcrp-phone/CallContact', JSON.stringify({
        ContactData: cData,
        Anonymous: AnonymousCallGlobal,
    }), function(status){
        $.post('http://lcrp-phone/getPhoneNumber', JSON.stringify({}), function(number) {
            if (cData.number !== number) {
                if (status.IsOnline) {
                    if (status.CanCall) {
                        if (!status.InCall) {
                            if (AnonymousCallGlobal) {
                               addNotification("fas fa-phone", "Phone", "You have started an anonymous call!");
                            }
                            $(".phone-call-outgoing").css({"display":"block"});
                            $(".phone-call-incoming").css({"display":"none"});
                            $(".phone-call-ongoing").css({"display":"none"});
                            $(".phone-call-outgoing-caller").html(cData.name);
                            
                            HeaderTextColor("white", 400);
                            $(".phone-application-container").fadeOut(150)


                            setTimeout(function(){
                                $(".services-app").css({"display":"none"});
                                $(".phone-application-container").fadeIn(150)
                                $(".phone-call").css("display","block")
                            }, 450);

                            ShowCalling = true
                            CallData.name = cData.name;
                            CallData.number = cData.number;
                            closeCurrentApplication();
                            currentApplication = "phone-call";
                            $(".phone-call-app").fadeIn(150)
                        } else {
                            addNotification("fas fa-phone", "Phone", "You are already busy!");
                        }
                    } else {
                        addNotification("fas fa-phone", "Phone", "This person is in call!");
                    }
                } else {
                    addNotification("fas fa-phone", "Phone", "This person is not available!");
                }
            } else {
               addNotification("fas fa-phone", "Phone", "You cannot call your own number!");
            }
        });
    });
});