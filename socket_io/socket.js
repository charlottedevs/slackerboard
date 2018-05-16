// Immediately start connecting
socket = io.connect('ws://localhost:5000/cable');

typeof console !== 'undefined' &&
  console.log('Connecting Socket.io to Sails.js...');

// Attach a listener which fires when a connection is established:
socket.on('connect', function socketConnected() {

  typeof console !== 'undefined' &&
    console.log(
      'Socket is now connected and globally accessible as `socket`.\n' +
      'e.g. to send a GET request to Sails via Socket.io, try: \n' +
      '`socket.get("/foo", function (response) { console.log(response); })`'
    );

  // Attach a listener which fires every time the server publishes a message:
  socket.on('message', function newMessageFromSails ( message ) {

    typeof console !== 'undefined' &&
      console.log('New message received from Sails ::\n', message);

  });
});
