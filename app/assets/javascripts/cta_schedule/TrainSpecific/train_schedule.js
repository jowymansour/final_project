
 function ShowSchedule(MapId, RouteId){

    //RETRIEVE DATA
    div_to_show = document.getElementById(MapId);

    //WE SEARCH ONLY IF OPEN
    if (div_to_show.getAttribute("class","panel panel-default hidden_div")){

      // we go fetch the data
      AjaxFetch(MapId, RouteId);
    }
    toggleClass(div_to_show,"hidden_div");
  }

  //FUNCTION TO DELETE CONTENT OF THE DIV BEFORE RETRIEVING DATA
  function deleteContent(MapId) {
    var divtoclear = new Array() ;

    divtoclear[0] = document.getElementById("destination_5_" + MapId);
    divtoclear[1] = document.getElementById("destination_1_" + MapId);
    divtoclear[2] = document.getElementById("header_" + MapId);

    for (i=0;i<3;i++){
      while (divtoclear[i].firstChild) {
        divtoclear[i].removeChild(divtoclear[i].firstChild);
      }
    }
  }

  //FUNCTION TO RETRIEVE THE DATA
  function AjaxFetch(MapId, RouteId) {

    //we first delete what is currently in the div
    deleteContent(MapId);

    $.ajax({
      url: "/../train/retrieve_data",
      cache: false,
      data: {mapid : MapId},
      success: function(data){
        var list_of_results = data["ctatt"]["eta"];
        ConstructTable(list_of_results, MapId, RouteId);
      }
    });
  }


  //FUNCTION TO CONSTRUCT PREDICTION
      function ConstructTable(list_of_results, MapId, route_id){
        var train = new Array();
        var h6 = new Array ();
        var span = new Array();
        direction_1 = 0;
        direction_5 = 0;
        station_name = 0;
        div_header = document.getElementById("header_" + MapId);
        destination_5_div = document.getElementById("destination_5_" + MapId);
        destination_1_div = document.getElementById("destination_1_" + MapId);

        for (i=0; i<list_of_results.length; i++) {
          train[i] = list_of_results[i];
          if (train[i]["rt"] == route_id) {
            //Add station name if not already there
            if (station_name == 0) {
              var h4_station = document.createElement("h4");
              h4_station.appendChild(document.createTextNode(train[i]["staNm"]));
              div_header.insertBefore(h4_station, div_header.firstChild);
              station_name = 1;
            }


            // add direction name if not already there !
            if (direction_1 == 0 && train[i]["trDr"] == "1") {
              var h5_1 = document.createElement("h5");
              h5_1.appendChild(document.createTextNode(train[i]["stpDe"]));
              destination_1_div.appendChild(h5_1);
              direction_1 = 1;
            } else if (direction_5 == 0 && train[i]["trDr"] == "5") {
              var h5_5 = document.createElement("h5");
              h5_5.appendChild(document.createTextNode(train[i]["stpDe"]));
              destination_5_div.appendChild(h5_5);
              direction_5 = 1;
            }

            //Then compute the result
            var pattern = /(\d{4})(\d{2})(\d{2})/;
            arrival_time = train[i]["arrT"].replace(" ","T").replace(pattern,'$1-$2-$3');
            departure_time = train[i]["prdt"].replace(" ","T").replace(pattern,'$1-$2-$3');

            number_of_seconds = new Date(arrival_time) - new Date(departure_time);
            number_of_minutes = number_of_seconds / (60*1000);

            train_nb = "train #" + train[i]["rn"] + " - ";
            time_to_train = number_of_minutes + " minutes";
            h6[i] = document.createElement("h6");
            span[i] = document.createElement("span");

            h6[i].appendChild(document.createTextNode(train_nb));
            h6[i].setAttribute("class","train_results");

            span[i].appendChild(document.createTextNode(time_to_train));
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
              div_header.appendChild(h5);
            }

            //Then add the result to the DOM
            if (train[i]["trDr"] == "1") {
              destination_1_div.appendChild(h6[i]);
            } else if (train[i]["trDr"] == "5"){
              destination_5_div.appendChild(h6[i]);
            }
          }
        }
      }
