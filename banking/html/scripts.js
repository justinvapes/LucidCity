// Credit to Kanersps @ EssentialMode and Eraknelo @FiveM
function addGaps(nStr) {
  nStr += '';
  var x = nStr.split('.');
  var x1 = x[0];
  var x2 = x.length > 1 ? '.' + x[1] : '';
  var rgx = /(\d+)(\d{3})/;
  while (rgx.test(x1)) {
    x1 = x1.replace(rgx, '$1' + '<span style="margin-left: 3px; margin-right: 3px;"/>' + '$2');
  }
  return x1 + x2;
}
function addCommas(nStr) {
  nStr += '';
  var x = nStr.split('.');
  var x1 = x[0];
  var x2 = x.length > 1 ? '.' + x[1] : '';
  var rgx = /(\d+)(\d{3})/;
  while (rgx.test(x1)) {
    x1 = x1.replace(rgx, '$1' + ',<span style="margin-left: 0px; margin-right: 1px;"/>' + '$2');
  }
  return x1 + x2;
}

$(document).ready(function(){
  // Mouse Controls
  var documentWidth = document.documentElement.clientWidth;
  var documentHeight = document.documentElement.clientHeight;


  function triggerClick(x, y) {
      var element = $(document.elementFromPoint(x, y));
      element.focus().click();
      return true;
  }

  // Partial Functions
  function closeMain() {
    $(".home").css("display", "none");
  }
  
  function openMain() {
    $(".home").css("display", "block");
    $(".trans-ul").empty();

    $.post('http://banking/transfers', JSON.stringify({}), function(transfers) {
      if(transfers.hasTrans == true) {
        var i;
        for(i=0; i<transfers.transactions.length; i++) {
          if(transfers.transactions[i].transaction == "received") {
            $(".trans-ul").append("<div class='transaction'><div class='account-number'>ACCOUNT: LCB" + transfers.account.substring(2,16) + "</div><p class='transaction-type'>[" + transfers.transactions[i].transaction.toUpperCase() + "] #" + transfers.transactions[i].id + "     " + transfers.transactions[i].other.toUpperCase() + "</p><div class='trans-line'></div><p class='transaction-date'>Completed in " + transfers.transactions[i].date + "</p><p class='transaction-amount' style='color:#6BBF3B !important;'>+" + transfers.transactions[i].amount + " $</p></div>")
          }
          if(transfers.transactions[i].transaction == "sent") {
            $(".trans-ul").append("<div class='transaction'><div class='account-number'>ACCOUNT: LCB" + transfers.account.substring(2,16) + "</div><p class='transaction-type'>[" + transfers.transactions[i].transaction.toUpperCase() + "] #" + transfers.transactions[i].id + "     " + transfers.transactions[i].other.toUpperCase() + "</p><div class='trans-line'></div><p class='transaction-date'>Completed in " + transfers.transactions[i].date + "</p><p class='transaction-amount' style='color:#F56A4C  !important;'>-" + transfers.transactions[i].amount + " $</p></div>")
          }
          if(transfers.transactions[i].transaction == "withdraw") {
            $(".trans-ul").append("<div class='transaction'><div class='account-number'>ACCOUNT: LCB" + transfers.account.substring(2,16) + "</div><p class='transaction-type'>[" + transfers.transactions[i].transaction.toUpperCase() + "] #" + transfers.transactions[i].id + "     " + convertToHexa("Lucid").substring(0,8) + "-" + convertToHexa("Bank").substring(0,10) + "</p><div class='trans-line'></div><p class='transaction-date'>Completed in " + transfers.transactions[i].date + "</p><p class='transaction-amount' style='color:#F56A4C  !important;'>-" + transfers.transactions[i].amount + " $</p></div>")
          }
          if(transfers.transactions[i].transaction == "deposit") {
            $(".trans-ul").append("<div class='transaction'><div class='account-number'>ACCOUNT: LCB" + transfers.account.substring(2,16) + "</div><p class='transaction-type'>[" + transfers.transactions[i].transaction.toUpperCase() + "] #" + transfers.transactions[i].id + "     " + convertToHexa("Lucid").substring(0,8) + "-" + convertToHexa("City").substring(0,10) + "</p><div class='trans-line'></div><p class='transaction-date'>Completed in " + transfers.transactions[i].date + "</p><p class='transaction-amount' style='color:#6BBF3B !important;'>+" + transfers.transactions[i].amount + " $</p></div>")
          }
        }
      } else {
        $(".trans-ul").append("<p class='trans-p'>YOU HAVEN'T MADE ANY TRANSACTIONS YET!</p>");
      }
    });
  }

  const convertToHexa = (str = '') =>{
    const res = [];
    const { length: len } = str;
    for (let n = 0, l = len; n < l; n ++) {
       const hex = Number(str.charCodeAt(n)).toString(16);
       res.push(hex);
    };
    return res.join('');
 }

  function closeAll() {
    $(".body").css("display", "none");
  }
  function openBalance() {
    $(".balance-container").css("display", "block");
  }
  function openWithdraw() {
    $(".withdraw-container").css("display", "block");
  }
  function openDeposit() {
    $(".deposit-container").css("display", "block");
  }
  function openSend() {
    $(".send-container").css("display", "block");
  }
  function openTransfer() {
    $(".transfer-container").css("display", "block");
  }
  function openContainer() {
    $(".bank-container").fadeIn(400);
  }
  function closeContainer() {
    $(".bank-container").fadeOut(250);
  }

  // Listen for NUI Events
  window.addEventListener('message', function(event){
    var item = event.data;
    // Open & Close main bank window
    if(item.openBank == true) {
      $('.currentBalance').html('&dollar;'+addCommas(item.PlayerData.money.bank));
      $('.username').html(item.PlayerData.charinfo.firstname + " " + item.PlayerData.charinfo.lastname);
      openContainer();
      openMain();
    }

    if(item.updateBalance) {
      $('.currentBalance').html('&dollar;'+addCommas(item.bankAmount));
      //console.log(item.PlayerData.money.bank)
    }

    if(item.openBank == false) {
      closeContainer();
      closeMain();
    }
    // Open sub-windows / partials
    if(item.openSection == "balance") {
      closeAll();
      openBalance();
    }
    if(item.openSection == "withdraw") {
      closeAll();
      openWithdraw();
    }
    if(item.openSection == "deposit") {
      closeAll();
      openDeposit();
    }
    if(item.openSection == "send") {
      closeAll();
      openSend();
    }
  });
  // On 'Esc' call close method
  document.onkeyup = function (data) {
    if (data.which == 27 ) {
      $.post('http://banking/close', JSON.stringify({}));
    }
  };
  // Handle Button Presses
  $(".btnWithdraw").click(function(){
      $.post('http://banking/withdraw', JSON.stringify({}));
  });
  $(".btnDeposit").click(function(){
      $.post('http://banking/deposit', JSON.stringify({}));
  });
  $(".btnSend").click(function(){
    $.post('http://banking/send', JSON.stringify({}));
});
  $(".btnBalance").click(function(){
      $.post('http://banking/balance', JSON.stringify({}));
  });
  $(".btnClose").click(function(){
      $.post('http://banking/close', JSON.stringify({}));
  });

  $("#home-btn").click(function(){
      closeAll();
      openMain();
  });
  // Handle Form Submits
  $("#withdraw-form").submit(function(e) {
      e.preventDefault();
      var amount = parseInt($("#withdraw-form #amount").val());

      if (amount > 0 ) {
        $.post('http://banking/newTransfer', JSON.stringify({
        transaction: 'withdraw',
        amount: $("#withdraw-form #amount").val()
        }));
      }
      closeAll();
      openMain();

      $("#withdraw-form #amount").val('')
  });
  $("#deposit-form").submit(function(e) {
      e.preventDefault();
      var amount = parseInt($("#deposit-form #amount").val());

      if (amount > 0 ) {
        $.post('http://banking/newTransfer', JSON.stringify({
          transaction: 'deposit',
          amount: $("#deposit-form #amount").val()
        }));
      }

      closeAll();
      openMain();
      
      $("#deposit-form #amount").val('')
  });
  $("#send-form").submit(function(e) {
    e.preventDefault();
    var amount = parseInt($("#send-form #send-amount").val());
    var id = parseInt($("#send-form #sendid").val());

    if (amount >= 0 ) {
      $.post('http://banking/transferSubmit', JSON.stringify({
          amount: $("#send-form #send-amount").val(),
          toPlayer: $("#send-form #sendid").val()
      }));
    }

    closeAll();
    openMain();
    
    $("#send-form #send-amount").val('')
});
});
