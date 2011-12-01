(function() {
  jQuery(function($) {
    var fnRoomSend, fnRoomSub, sendRoom, subscribeRoom, _onMsg;
    window.socket = io.connect("http://localhost:8015");
    _onMsg = function(roomname, txt, user) {
      var html;
      html = "<li class=\"alert-message\">	<p><strong>" + user + ":</strong> " + txt + "</p></li>		";
      $("#out_" + roomname).append(html);
    };
    fnRoomSub = function(roomname, user) {
      socket.emit("subsrcibe", roomname, user);
      socket.on("stream_" + roomname, _.bind(_onMsg, this, roomname));
    };
    fnRoomSend = function(roomname, txt, user) {
      _onMsg(roomname, txt, user);
      socket.emit("txt", roomname, txt, user);
    };
    $(".sub_room").on("click", function(event) {
      return subscribeRoom($(event.target).data("roomname"));
    });
    $(".send_room").on("click", function(event) {
      return sendRoom($(event.target).data("roomname"));
    });
    $(".send_room").on("keyup", function(event) {
      if (event.keycode === 13) {
        sendRoom($(event.target).data("roomname"));
        return false;
      } else {
        return true;
      }
    });
    subscribeRoom = function(roomname) {
      $("#box_" + roomname).show();
      return fnRoomSub(roomname, $("#user_" + roomname).val());
    };
    return sendRoom = function(roomname) {
      return fnRoomSend($("#send_" + roomname).data("roomname"), $("#text_" + roomname).val(), $("#user_" + roomname).val());
    };
  });
}).call(this);
