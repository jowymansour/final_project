//This prevent the script from being launched in another page then the ones it is made for
//$(".cta_schedule.new_search, .cta_schedule .bus_schedule, .cta_schedule .train_schedule").ready(function (){

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

  function add_remove_Favorite(stopid, favorite, type_transport, routeId){
    //RETRIEVE DATA
    $.ajax({
            url: "/../add_favorite",
            cache: false,
            data: {station_id : stopid,
                   type_transp: type_transport,
                   route_id: routeId,
                   url: window.location.href
                  },
            success: function(data){
                console.log(data["message"]);
                if (data["type"] == "reload") {
                  location.reload();
                }
                if (data["error"] == 1) {
                  var notification = new NotificationFx({
                    message : '<span class="icon icon-settings"></span><p>You can not add this route as favorite. You need to <a href="/login">Log In</a> or <a href="/signup">Sign Up</a> first.</p>',
                    layout : 'attached',
                    effect : 'bouncyflip',
                    type : 'notice', // notice, warning or error
                  });

                  // show the notification
                  notification.show();

                } else {
                  toggleClass(favorite, "added_favorite");
                }
            }
          });

  }
//});
