(function() {
  var io, sio;
  root._CONFIG_PORT = parseInt(process.argv[2] || 8015, 10);
  sio = require("socket.io");
  io = sio.listen(root._CONFIG_PORT);
  console.log("RUNNING Socket Server on ON", root._CONFIG_PORT);
  io.sockets.on("connection", function(client) {
    client.on("subsrcibe", function(roomname, user) {
      client.broadcast.to(roomname).emit("stream_" + roomname, "" + user + " ist im Raum", "-System-");
      return client.join(roomname);
    });
    client.on("unsubsrcibe", function(roomname) {
      return client.leave(roomname);
    });
    return client.on("txt", function(roomname, txt, user) {
      return client.broadcast.to(roomname).emit("stream_" + roomname, txt, user);
    });
  });
}).call(this);
