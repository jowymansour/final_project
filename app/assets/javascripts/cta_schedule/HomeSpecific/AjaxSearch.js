// This file is required to search automatically when something is typed in the Input

  //look if a key is pressed in the input and if the input is not empty
  //==> If so we take out the previous results and go for new ones (via function FindLine)
  $("#search").keyup(function (e) {

    var previous_results = new Array();
    previous_results[0] = document.getElementById("trains");
    previous_results[1] = document.getElementById("bus");

    for (i=0;i<2;i++) {
      while (previous_results[i].firstChild) {
          previous_results[i].removeChild(previous_results[i].firstChild);
      }
    }

    if ($(this).val()!=""){
      document.getElementById("favorites").style.display = 'none';
      FindLine($(this).val());
    } else {
      document.getElementById("favorites").style.display = 'block';
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
          results[i] = data[i];
          //console.log(results[i].route);
          AddResult(results[i]);
        }
      }
    });
  }

  //Function to add each result in the page
  function AddResult(result){



    //FINALLY ADD THE RESULT
    var div1 = document.createElement("div");
    var h4 = document.createElement("h4");
    var a = document.createElement("a");
    var trains = document.getElementById("trains");
    var bus = document.getElementById("bus");

    //IF TRAIN
    if (result.route_type=="1") {

      // ADD "Train" if it is the first one found
      if (!trains.firstChild){
        var h3 = document.createElement("h3");
        text_header = "Trains";
        h3.appendChild(document.createTextNode(text_header));
        trains.appendChild(h3);
      }

      text = result.route_long_name;
      a.setAttribute("href","train/" + result.route_id)
      document.getElementById("trains").appendChild(div1);

    //IF BUS
    } else if (result.route_type=="3") {

      // ADD "Bus" if it is the first one found
      if (!bus.firstChild){
        var h3 = document.createElement("h3");
        text_header = "Bus";
        h3.appendChild(document.createTextNode(text_header));
        document.getElementById("bus").appendChild(h3);
      }

      text = "Bus " + result.route_short_name + " - " + result.route_long_name;
      a.setAttribute("href","bus/" + result.route_id)
      document.getElementById("bus").appendChild(div1);
    }

    //ADD TO DOM
    div1.setAttribute("class","div_result");
    h4.appendChild(document.createTextNode(text));
    h4.setAttribute("class","text_result");
    a.setAttribute("class","simple_link")
    a.appendChild(h4)
    div1.appendChild(a);
  }
