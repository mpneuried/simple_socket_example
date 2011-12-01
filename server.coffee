# get port by arg
root._CONFIG_PORT = parseInt( process.argv[2] or 8015 , 10 )

# get socket.io
sio = require("socket.io")
io = sio.listen( root._CONFIG_PORT )
console.log "RUNNING Socket Server on ON", root._CONFIG_PORT

# listen for new clients
io.sockets.on "connection", (client) ->

	# listen to a room subscription
	client.on "subsrcibe", ( roomname, user )->
		client.broadcast.to( roomname ).emit( "stream_#{roomname}", "#{ user } ist im Raum", "-System-" );
		client.join( roomname )
	
	# listen to a room unsubscription
	client.on "unsubsrcibe", ( roomname )->
		client.leave( roomname )
	
	# listen to new messages
	client.on "txt", ( roomname, txt, user )->
		# broadcast the message to the given room
		client.broadcast.to( roomname ).emit( "stream_#{roomname}", txt, user );
