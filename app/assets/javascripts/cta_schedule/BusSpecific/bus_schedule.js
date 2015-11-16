
  //FUNCTION TO TOGGLE CLASS WITHOUT USING JQUERY
  function toggleClass(element, className){
    if (!element || !className){
        return;
    }
    var classString = element.className, nameIndex = classString.indexOf(className);
    if (nameIndex == -1) {
        classString += ' ' + className;
    }
    else {
        classString = classString.substr(0, nameIndex) + classString.substr(nameIndex+className.length);
    }
    element.className = classString;
  }

  //FUNCTION TO RETRIEVE BUS DATA
  function ShowSchedule(stpid, route){

    //RETRIEVE DATA
    div_to_show = document.getElementById(stpid);

    //WE SEARCH ONLY IF OPEN
    if (div_to_show.getAttribute("class","panel panel-default hidden_div")){

      // we go fetch the data
      AjaxFetch(stpid, route);
    }
    toggleClass(div_to_show,"hidden_div");
  }


  //FUNCTION TO DELETE CONTENT OF THE DIV BEFORE RETRIEVING DATA
  function deleteContent(stpid) {
    var divtoclear = new Array() ;

    divtoclear[0] = document.getElementById("destination_" + stpid);
    divtoclear[1] = document.getElementById("header_" + stpid);

    for (i=0;i<divtoclear.length;i++){
      while (divtoclear[i].firstChild) {
        divtoclear[i].removeChild(divtoclear[i].firstChild);
      }
    }
  }

  //FUNCTION TO RETRIEVE THE DATA
  function AjaxFetch(stpid, route) {
    div_header = document.getElementById("header_" + stpid);
    destination_div = document.getElementById("destination_" + stpid);

    //we first delete what is currently in the div
    deleteContent(stpid);

    //Then we delete the first letter of stopid which was just to avoid mistake
    stopid = stpid.toString().substring(1);

    $.ajax({
      url: "/../bus/retrieve_data",
      cache: false,
      data: {stpid : stopid, rt : route},
      success: function(data){
        var list_of_results = data["bustime_response"]["prd"];
        var bus = new Array();
        var h6 = new Array ();
        var span = new Array();


        //IF NO SERVICE SCHEDULED
        if (!list_of_results){
              text = data["bustime_response"]["error"]["msg"] + " for that stop"
              h6 = document.createElement("h6");
              h6.appendChild(document.createTextNode(text));
              destination_div.appendChild(h6);

        } else if (!list_of_results[0]) {
          //IF there is only one element, there is an error because list_of_Results is not a hash
          // We make the same computation as down but for just one element.
              bus = list_of_results;
              var pattern = /(\d{4})(\d{2})(\d{2})/;
              arrival_time = bus["prdtm"].replace(" ","T").replace(pattern,'$1-$2-$3');
              departure_time = bus["tmstmp"].replace(" ","T").replace(pattern,'$1-$2-$3');

              Time_now = new Date(departure_time);
              number_of_seconds = new Date(arrival_time) - Time_now;
              number_of_minutes = number_of_seconds / (60*1000);

              bus_nb = "bus #" + bus["vid"] + " (to " + bus["des"] + ") - ";
              time_to_bus = number_of_minutes + " minutes";
              h6 = document.createElement("h6");
              span = document.createElement("span");

              h6.appendChild(document.createTextNode(bus_nb));
              h6.setAttribute("class","bus_results");

              span.appendChild(document.createTextNode(time_to_bus));
              span.setAttribute("class","time_result");

              h6.appendChild(span);

              //Then add the result to the DOM
              destination_div.appendChild(h6);

        } else {

          for (i=0; i<list_of_results.length; i++) {
            bus[i] = list_of_results[i];

              //Then compute the result
              var pattern = /(\d{4})(\d{2})(\d{2})/;
              arrival_time = bus[i]["prdtm"].replace(" ","T").replace(pattern,'$1-$2-$3');
              departure_time = bus[i]["tmstmp"].replace(" ","T").replace(pattern,'$1-$2-$3');

              number_of_seconds = new Date(arrival_time) - new Date(departure_time);
              number_of_minutes = number_of_seconds / (60*1000);

              bus_nb = "bus #" + bus[i]["vid"] + " (to " + bus[i]["des"] + ") - ";
              time_to_bus = number_of_minutes + " minutes";

              h6[i] = document.createElement("h6");
              span[i] = document.createElement("span");

              h6[i].appendChild(document.createTextNode(bus_nb));
              h6[i].setAttribute("class","bus_results");

              span[i].appendChild(document.createTextNode(time_to_bus));
              span[i].setAttribute("class","time_result");

              h6[i].appendChild(span[i]);

              // TIME now if it is the first result
              if (i == 0) {
                depart = new Date(departure_time);
                depart.setHours(depart.getHours());
                hours_UTC = depart.getUTCHours();
                minutes = depart.getMinutes();

                AM_PM = (hours_UTC >= 12) ? "PM" : "AM";
                hours = (hours_UTC > 12) ? hours_UTC-12 : hours_UTC;
                minutes = (minutes >=10) ? minutes : "0" + minutes;

                Time = "Searched at " + hours + ":" + minutes + " " + AM_PM ;

                h5 = document.createElement("h5");
                h5.appendChild(document.createTextNode(Time));
                destination_div.appendChild(h5);
              }
              //Then add the result to the DOM
              destination_div.appendChild(h6[i]);
          }
        }
      }
    });
  }

