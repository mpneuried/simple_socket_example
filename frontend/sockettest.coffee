

jQuery ( $ )->
	# define socket
	window.socket = io.connect( "http://localhost:8015" )

# ==== IO relevant functions
	
	# callback method on incomming messages
	_onMsg = ( roomname, txt, user )->
		html = "
<li class=\"alert-message\">
	<p><strong>#{user}:</strong> #{txt}</p>
</li>
		"
		$( "#out_#{ roomname }" ).append( html )
		return

	# function to subscribe to a room
	fnRoomSub = ( roomname, user )->
		socket.emit( "subsrcibe", roomname, user )
		socket.on "stream_#{roomname}", _.bind( _onMsg, @, roomname )
		return
	
	# function to send a message to a room
	fnRoomSend = ( roomname, txt, user )->
		_onMsg( roomname, txt, user )
		socket.emit( "txt", roomname, txt, user )
		return
	


# ===== jQuery Functions

	# listen to the events of each room
	$( ".sub_room" ).on "click", ( event )->
		subscribeRoom( $( event.target ).data( "roomname" ) )
	
	$( ".send_room" ).on "click", ( event )->
		sendRoom( $( event.target ).data( "roomname" ) )
	
	$( ".send_room" ).on "keyup", ( event )->
		if event.keycode is 13
			sendRoom( $( event.target ).data( "roomname" ) )
			false
		else
			true
	
	# generic methods to run IO functions
	subscribeRoom = ( roomname )->
		$( "#box_#{ roomname }" ).show()
		fnRoomSub( roomname, $( "#user_#{ roomname }" ).val() )

	sendRoom = ( roomname )->
		fnRoomSend( $( "#send_#{ roomname }" ).data( "roomname" ), $( "#text_#{ roomname }" ).val(), $( "#user_#{ roomname }" ).val() )
