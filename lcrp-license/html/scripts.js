// Mouse Controls
var documentWidth = document.documentElement.clientWidth;
var documentHeight = document.documentElement.clientHeight;
var cursor = $('#cursor');
var cursorX = documentWidth / 2;
var cursorY = documentHeight / 2;

//question variables
var questionNumber = 1;
var userAnswer = [];
var goodAnswer = [];
var questionUsed = [];
var nbQuestionToAnswer = 10; // don't forget to change the progress bar max value in html
var nbAnswerNeeded = 7; // out of nbQuestionToAnswer
var nbPossibleQuestions = 13; //number of questions in database questions.js
var lastClick = 0;

function getRandomQuestion() {
  var random = Math.floor(Math.random() * nbPossibleQuestions)

  while (true) {
    if (questionUsed.indexOf(random) === -1) {
      break
    }

    random = Math.floor(Math.random() * nbPossibleQuestions)
  }

  questionUsed.push(random)

  return random
}

// Partial Functions
function closeMain() {
  $(".home").css("display", "none");
}
function openMain() {
  $(".home").css("display", "block");
}
function closeAll() {
  $(".body").css("display", "none");
}
function openQuestionnaire() {
  $(".questionnaire-container").css("display", "block");
  var randomQuestion = getRandomQuestion();
  $("#questionNumero").html("Question: " + questionNumber + " of " + nbQuestionToAnswer);
  $("#question").html(questionList[randomQuestion].question);
  $(".answerA").html(questionList[randomQuestion].propositionA);
  $(".answerB").html(questionList[randomQuestion].propositionB);
  $(".answerC").html(questionList[randomQuestion].propositionC);
  $(".answerD").html(questionList[randomQuestion].propositionD);
  $('input[name=question]').attr('checked',false);
  goodAnswer.push(questionList[randomQuestion].reponse);
  $(".questionnaire-container .progression").val(questionNumber-1);
}
function openResultGood() {
  $(".resultGood").css("display", "block");
}
function openResultBad() {
  $(".resultBad").css("display", "block");
}
function openContainer() {
  $(".question-container").css("display", "block");
  $("#cursor").css("display", "block");
}
function closeContainer() {
  $(".question-container").css("display", "none");
  $("#cursor").css("display", "none");
}

// Listen for NUI Events
window.addEventListener('message', function(event){

  var item = event.data;
  // Open & Close main gang window
  if(item.openQuestion == true) {
    openContainer();
    openMain();
  }
  if(item.openQuestion == false) {
    closeContainer();
    closeMain();
  }
  // Open sub-windows / partials
  if(item.openSection == "question") {
    closeAll();
    openQuestionnaire();
  }
});

// Handle Button Presses
$(".btnQuestion").click(function () {
	$.post('http://lcrp-license/question', JSON.stringify({}));
});

$(".btnClose").click(function () {
	$.post('http://lcrp-license/close', JSON.stringify({}));
	userAnswer = [];
	goodAnswer = [];
	questionUsed = [];
	questionNumber = 1;
});

$(".btnKick").click(function () {
	$.post('http://lcrp-license/kick', JSON.stringify({}));
	userAnswer = [];
	goodAnswer = [];
	questionUsed = [];
	questionNumber = 1;
});

$(".buttonClose").click(function(){
  $.post('http://lcrp-license/closeButton', JSON.stringify({}));
  userAnswer = [];
	goodAnswer = [];
	questionUsed = [];
  questionNumber = 1;
  
  closeAll();
  closeContainer();
  closeMain();
});

// Handle Form Submits
$("#question-form").submit(function(e) {

  e.preventDefault();

  if(questionNumber!=nbQuestionToAnswer){
    //question 1 to 9 : pushing answer in array
    closeAll();
    userAnswer.push($('input[name="question"]:checked').val());
    questionNumber++;
    openQuestionnaire();
  }
  else {
    // question 10 : comparing arrays and sending number of good answers
    userAnswer.push($('input[name="question"]:checked').val());
    var nbGoodAnswer = 0;
    for (i = 0; i < nbQuestionToAnswer; i++) {
      if (userAnswer[i] == goodAnswer[i]) {
        nbGoodAnswer++;
      }
    }
    closeAll();
    if(nbGoodAnswer >= nbAnswerNeeded) {
      openResultGood();
    }
    else{
      openResultBad();
    }
  }

  return false;

});

// THIS WILL ALLOW ONLY 1 CHECKBOX TO BE SELECTED
$("input:checkbox").on('click', function() {
  var $box = $(this);
  if ($box.is(":checked")) {
    var group = "input:checkbox[name='" + $box.attr("name") + "']";
    $(group).prop("checked", false);
    $box.prop("checked", true);
  } else {
    $box.prop("checked", false);
  }
});

// $(document).on('keydown', function() {
//   switch(event.keyCode) {
//       case 27: // ESCAPE
//           closeAll();
//           closeContainer();
//           closeMain();
//           $.post('http://lcrp-license/closeButton', JSON.stringify({}));
//           break;
//         }
// });