// This file is required to search automatically when something is typed in the Input

//This prevent the script from being launched in another page then the ones it is made for
$(".transportation.new_search").ready(function () {

  //look if a key is pressed in the input and if the input is not empty
  //==> If so we take out the previous results and go for new ones (via function FindLine)
  $("#search").keyup(function (e) {
    var previous_results = document.getElementById("lines_searched");
    while (previous_results.firstChild) {
        previous_results.removeChild(previous_results.firstChild);
    }
    if ($(this).val()!=""){
      FindLine($(this).val());
    }
  })

  //Ajax function to get back the data we requested
  function FindLine(text_input){
    $.ajax({
      url: "/../transportation/request",
      cache: false,
      data: {line: text_input},
      success: function(data){
        var results = new Array();
        for (i=0; i<data.length; i++) {
          results[i] = data[i]
          console.log(results[i].route);
          AddResult(results[i]);
        }
      }
    });
  }

  //Function to add the results in the page
  function AddResult(result){
    var div1 = document.createElement("div");
    var h3 = document.createElement("h3");
    text = result.route;
    h3.appendChild(document.createTextNode(text));
    h3.setAttribute("class","text_result");
    div1.appendChild(h3);
    document.getElementById("lines_searched").appendChild(div1);
  }

});
