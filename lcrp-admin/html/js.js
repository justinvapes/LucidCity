var historyOpen = false;
var reports = [];
var currentID = false;

window.addEventListener("message", function (event) {
    let action = event.data.action;
    let data = event.data.data;

    if (action == 'new') {
        AddReport(data)
    } else if (action == 'history') {
        ShowHistory()
    } else if (action == 'info') {
        AddInfo(data);
    } else if (action == 'delete') {
        reports[data] = undefined;
    } else if (action == 'open') {
        if (reports[data]) {
            MoreInfo(data);
        } else {
            $.post('http://lcrp-admin/notify', JSON.stringify({
                error: "Invaild report id.",
                type: "error",
            }));
        }
    }
})

function HideHistory() {
    historyOpen = false;
    $('#reports').fadeIn(500);
    $('#history').fadeOut(500);

    $.post("http://lcrp-admin/closeNUI"); 
}

function ShowHistory() {
    $('#history').html("<div class='title' style='background-color: rgba(0, 0, 30, 0.40); padding-right: 15px;  padding-left: 15px; font-size: 18px; color: white;'>Reports History</div>");

    for (i = reports.length; i != 0; i--) {
        var $history = $(document.createElement('div'));
        var data = reports[i];

        if(data && data.report) {
            var msg = data.text.length < 40 ? data.text : data.text.slice(0, 40) + '...';

            $history.html("<div class='report'><div class='title'>Report #" + data.report + " - " + data.name + " | ID: " + data.id + "</div>\
            <p class='info'>Report: " + msg + "</h1></div>");
            $('#history').append($history);
        }
    }

    if(reports.length == 0) {
        var $history = $(document.createElement('div'));
        $history.html("<div class='report'><div class='title'>Info</div>\<p class='info'>There are no recorded reports</h1>\</div>");
        $('#history').append($history);
    }

    historyOpen = true;
    $('#reports').fadeOut(500);
    $('#history').fadeIn(500);
}

function AddInfo(msg) {
    var $error = $(document.createElement('div'));

    $error.html("<div class='report'><div class='title''>Reports</div>\
    <p class='info'>" + msg + "</h1>\
    </div></div>");

    $('#reports').append($error);

    setTimeout(() => {
        $error.fadeOut(500);
    }, 8000)
}

function AddReport(data) {
    reports[data.report] = data;
    var $report = $(document.createElement('div'));
    var msg = data.text.length < 40 ? data.text : data.text.slice(0, 40) + '...';

    var html = "<div class='report'><div class='title'>Report #" + data.report + " - " + data.name + " | ID: " + data.id +  "</div>\
    <p class='info'> Report: " + msg + "</h1> <br> "

    $report.html(html);

    $('#reports').append($report);

    setTimeout(() => {
        $report.fadeOut(500);
    }, 8000)
}

function ReplyPlayer(id, reportId) {
    $('#info').fadeOut(500);
    $.post("http://lcrp-admin/closeNUI"); 
    $.post('http://lcrp-admin/reply', JSON.stringify({
        player: id,
        reportId: reportId,
    }));
}

function GotoPlayer(id) {
    $.post('http://lcrp-admin/goto', JSON.stringify({
     player: id
    }));
}

function MoreInfo(reportID) {
    $.post("http://lcrp-admin/openNUI");

    dragElement('info');
    currentID = reportID;
    var report = reports[currentID];
    $.post('http://lcrp-admin/GetInfo', JSON.stringify({
        player: report.id,
        timer: report.timer,
    }), function() {
        var html = "<div class='title2'>Report #" + currentID + "</div>\
        <div class='info-options'>\
            <button type='button' class='info-option' onclick='ReplyPlayer(" + report.id + ", " + report.report + ")'>Reply</button>\
            <button type='button' class='info-option' onclick='GotoPlayer(" + report.id + ")'>Goto</button>\
            <button type='button' class='info-option' style='color:red;' onclick='DeleteReport(" + report.report + ")'>Delete</button>\
        </div><div class='info-player'>\
            <i class='far fa-stopwatch'></i><i> <b> Time: </b>" + report.time + "</i></br>\
            <i class='fas fa-id-badge'></i><i><b> Name: </b>" + report.name + "</i></br>\
            <i class='fas fa-portrait'></i><i><b> ID: </b>" + report.id + "</id><br>\
            <i class='fas fa-file-alt'></i><i> <b> Report: </b>" + report.text + "</i></br>\
        </div></div>"
    
    
        $('#info').html(html);
        $('#info').fadeIn(500);
        
        $('#reports').fadeOut(500);
        $('#history').fadeOut(500);
    
        historyOpen = false;
    });
}

function DeleteReport(reportID) {
    $.post('http://lcrp-admin/delete', JSON.stringify({
        report: reportID
    }));

    CloseInfo();
}

function CloseInfo() {
    $('#info').fadeOut(500);
    $('#reports').fadeIn(500);
    $('#history').fadeOut(500);

    currentID = false;

    $.post("http://lcrp-admin/closeNUI");
}

function dragElement(id) {
    var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
    var elmnt = document.getElementById(id);
    elmnt.onmousedown = dragMouseDown;
  
    function dragMouseDown(e) {
      e = e || window.event;
      e.preventDefault();
      pos3 = e.clientX;
      pos4 = e.clientY;
      document.onmouseup = closeDragElement;
      document.onmousemove = elementDrag;
    }
  
    function elementDrag(e) {
      e = e || window.event;
      e.preventDefault();
      pos1 = pos3 - e.clientX;
      pos2 = pos4 - e.clientY;
      pos3 = e.clientX;
      pos4 = e.clientY;
      elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
      elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";
    }

    function closeDragElement() {
        // stop moving when mouse button is released:
        document.onmouseup = null;
        document.onmousemove = null;
      }
}

window.addEventListener("keyup", function (key) {
    if (key.which === 27) {
        if (historyOpen == true) {
            HideHistory();
        }

        if (currentID != false) {
            CloseInfo();
        }
    }
})