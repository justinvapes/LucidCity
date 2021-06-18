var FoccusedBank = null;

ContactColors = {
    0: "#9b59b6",
    1: "#3498db",
    2: "#e67e22",
    3: "#e74c3c",
    4: "#1abc9c",
    5: "#9c88ff",
}

$(document).on('click', '.bank-app-account', function(e){
    var copyText = document.getElementById("iban-account");
    copyText.select();
    copyText.setSelectionRange(0, 99999);
    document.execCommand("copy");

    addNotification("fas fa-university", "Bank", "Bank account No. copied!", "#badc58", 1750);
});

var CurrentTab = "accounts";

$(document).on('click', '.bank-app-header-button', function(e){
    e.preventDefault();

    var PressedObject = this;
    var PressedTab = $(PressedObject).data('headertype');

    if (CurrentTab != PressedTab) {
        var PreviousObject = $(".bank-app-header").find('[data-headertype="'+CurrentTab+'"]');

        if (PressedTab == "invoices") {
            $(".bank-app-"+CurrentTab).animate({
                left: -30+"vh"
            }, 250, function(){
                $(".bank-app-"+CurrentTab).css({"display":"none"})
            });
            $(".bank-app-"+PressedTab).css({"display":"block"}).animate({
                left: 0+"vh"
            }, 250);
        } else if (PressedTab == "accounts") {
            $(".bank-app-"+CurrentTab).animate({
                left: 30+"vh"
            }, 250, function(){
                $(".bank-app-"+CurrentTab).css({"display":"none"})
            });
            $(".bank-app-"+PressedTab).css({"display":"block"}).animate({
                left: 0+"vh"
            }, 250);
        }

        $(PreviousObject).removeClass('bank-app-header-button-selected');
        $(PressedObject).addClass('bank-app-header-button-selected');
        setTimeout(function(){ CurrentTab = PressedTab; }, 300)
    }
})

DoBankOpen = function() {
    $.post('http://lcrp-phone/getPlyData', JSON.stringify({}), function(Data) {
        Data = JSON.parse(Data)
        Data.money.bank = (Data.money.bank).toFixed();
        $(".bank-app-account-number").val(Data.charinfo.account);
        $(".bank-app-account-balance").html("&dollar; "+Data.money.bank);
        $(".bank-app-account-balance").data('balance', Data.money.bank);

        $(".bank-app-loaded").css({"display":"none", "padding-left":"30vh"});
        $(".bank-app-accounts").css({"left":"30vh"});
        $(".Bank-logo").css({"left": "0vh"});
        $("#Bank-text").css({"opacity":"0.0", "left":"9vh"});

        $(".bank-app-loaded").css({"display":"block"}).animate({"padding-left":"0"}, 300);
        $(".bank-app-accounts").animate({left:0+"vh"}, 300);
        $(".bank-app-loading").animate({
            left: -30+"vh"
        },300, function(){
            $(".bank-app-loading").css({"display":"none"});
        });
    }); 
}

$(document).on('click', '.bank-app-account-actions', function(e){
    $(".bank-app-transfer").fadeIn(150)
});

$(document).on('click', '#cancel-transfer', function(e){
    e.preventDefault();

    $(".bank-app-transfer").fadeOut(150)
});

$(document).on('click', '#accept-transfer', function(e){
    e.preventDefault();

    var iban = $("#bank-transfer-iban").val();
    var amount = $("#bank-transfer-amount").val();
    var amountData = $(".bank-app-account-balance").data('balance');

    if (iban != "" && amount != "") {
        if (amountData >= amount) {
            $.post('http://lcrp-phone/TransferMoney', JSON.stringify({
                iban: iban,
                amount: amount
            }), function(data){
                if (data.CanTransfer) {
                    $("#bank-transfer-iban").val("");
                    $("#bank-transfer-amount").val("");
                    data.NewAmount = (data.NewAmount).toFixed();
                    $(".bank-app-account-balance").html("&dollar; "+data.NewAmount);
                    $(".bank-app-account-balance").data('balance', data.NewAmount);
                    addNotification("fas fa-university", "Bank", "&dollar; "+amount+",- transferred!", "#badc58", 1500);
                } else {
                   addNotification("fas fa-university", "Bank", "You do not have enough balance!", "#badc58", 1500);
                }
            })
            $(".bank-app-transfer").fadeOut(150)
        } else {
            addNotification("fas fa-university", "Bank", "You do not have enough balance!", "#badc58", 1500);
        }
    } else {
        addNotification("fas fa-university", "Bank", "fill out all fields!", "#badc58", 1750);
    }
});

GetInvoiceLabel = function(type) {
    retval = null;
    if (type == "request") {
        retval = "Payment request";
    }

    return retval
}

$(document).on('click', '.pay-invoice', function(event){
    event.preventDefault();

    var InvoiceId = $(this).parent().parent().attr('id');
    var InvoiceData = $("#"+InvoiceId).data('invoicedata');
    var BankBalance = $(".bank-app-account-balance").data('balance');

    if (BankBalance >= InvoiceData.amount) {
        $.post('http://lcrp-phone/PayInvoice', JSON.stringify({
            sender: InvoiceData.sender,
            amount: InvoiceData.amount,
            invoiceId: InvoiceData.invoiceid,
        }), function(CanPay){
            if (CanPay) {
                $("#"+InvoiceId).animate({
                    left: 30+"vh",
                }, 300, function(){
                    setTimeout(function(){
                        $("#"+InvoiceId).remove();
                    }, 100);
                });
                addNotification("fas fa-university", "Bank", "&dollar;"+InvoiceData.amount+" paid!", "#badc58", 1500);
                var amountData = $(".bank-app-account-balance").data('balance');
                var NewAmount = (amountData - InvoiceData.amount).toFixed();
                $("#bank-transfer-amount").val(NewAmount);
                $(".bank-app-account-balance").data('balance', NewAmount);
            } else {
                addNotification("fas fa-university", "Bank", "You do not have enough balance!", "#badc58", 1500);
            }
        });
    } else {
       addNotification("fas fa-university", "Bank", "You do not have enough balance!", "#badc58", 1500);
    }
});

$(document).on('click', '.decline-invoice', function(event){
    event.preventDefault();
    var InvoiceId = $(this).parent().parent().attr('id');
    var InvoiceData = $("#"+InvoiceId).data('invoicedata');

    $.post('http://lcrp-phone/DeclineInvoice', JSON.stringify({
        sender: InvoiceData.sender,
        amount: InvoiceData.amount,
        invoiceId: InvoiceData.invoiceid,
    }));
    $("#"+InvoiceId).animate({
        left: 30+"vh",
    }, 300, function(){
        setTimeout(function(){
            $("#"+InvoiceId).remove();
        }, 100);
    });
   addNotification("fas fa-university", "Bank", "&dollar;"+InvoiceData.amount+" paid!", "#badc58", 1500);
});

function LoadBankInvoices(invoices) {
    if (invoices !== null) {
        $(".bank-app-invoices-list").html("");

        $.each(invoices, function(i, invoice){
            var Elem = '<div class="bank-app-invoice" id="invoiceid-'+i+'"> <div class="bank-app-invoice-title">'+GetInvoiceLabel(invoice.type)+' <span style="font-size: 1vh; color: gray;">(Afzender: '+invoice.name+')</span></div> <div class="bank-app-invoice-amount">&dollar; '+invoice.amount+',-</div> <div class="bank-app-invoice-buttons"> <i class="fas fa-check-circle pay-invoice"></i> <i class="fas fa-times-circle decline-invoice"></i> </div> </div>';

            $(".bank-app-invoices-list").append(Elem);
            $("#invoiceid-"+i).data('invoicedata', invoice);
        });
    }
}

function LoadContactsWithNumber(myContacts) {
    var ContactsObject = $(".bank-app-my-contacts-list");
    $(ContactsObject).html("");
    var TotalContacts = 0;

    $("#bank-app-my-contact-search").on("keyup", function() {
        var value = $(this).val().toLowerCase();
        $(".bank-app-my-contacts-list .bank-app-my-contact").filter(function() {
          $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
        });
    });

    if (myContacts !== null) {
        $.each(myContacts, function(i, contact){
            var RandomNumber = Math.floor(Math.random() * 6);
            var ContactColor = ContactColors[RandomNumber];
            var ContactElement = '<div class="bank-app-my-contact" data-bankcontactid="'+i+'"> <div class="bank-app-my-contact-firstletter">'+((contact.name).charAt(0)).toUpperCase()+'</div> <div class="bank-app-my-contact-name">'+contact.name+'</div> </div>'
            TotalContacts = TotalContacts + 1
            $(ContactsObject).append(ContactElement);
            $("[data-bankcontactid='"+i+"']").data('contactData', contact);
        });
    }
};

$(document).on('click', '.bank-app-my-contacts-list-back', function(e){
    e.preventDefault();
    $(".bank-app-my-contacts").fadeOut(150)
});

$(document).on('click', '.bank-transfer-mycontacts-icon', function(e){
    e.preventDefault();

    $(".bank-app-my-contacts").fadeIn(150)
});

$(document).on('click', '.bank-app-my-contact', function(e){
    e.preventDefault();
    var PressedContactData = $(this).data('contactData');

    if (PressedContactData.iban !== "" && PressedContactData.iban !== undefined && PressedContactData.iban !== null) {
        $("#bank-transfer-iban").val(PressedContactData.iban);
    } else {
        addNotification("fas fa-university", "Bank", "There is no IBAN tied to this contact!", "#badc58", 2500);
    }
    $(".bank-app-my-contacts").fadeOut(150)
});