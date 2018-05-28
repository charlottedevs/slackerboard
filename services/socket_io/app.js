var express = require('express');
var app = express();
var axios = require('axios')
var server = require('http').createServer(app);
var redis = require('redis').createClient('6379', 'redis');
var io = require('socket.io')(server);
var slackerboard = require('./slackers');


let apiEndpoint = 'http://rails_server:5000/slackers';
const slackerboard_change = 'slackerboard_change';

redis.subscribe(slackerboard_change)

redis.on('message', function(channel, message){
  var info = JSON.parse(message);
  io.sockets.emit(channel, info);
  console.log(channel, '->', info);
});

io.on('connection', function(socket) {
  console.log('socket connected...');

  socket.on('join', function(data) {
    const { channel } = data;
    console.log('client joined: ', channel)

    if (channel === 'this_week_slackerboard_updates') {
      apiEndpoint = `${apiEndpoint}?thisweek=true`;
    }

    // change: `this_week_slackerboard_updates`
    // to: `this_week_slackerboard_update`
    const eventType = channel.slice(0, -1);

    axios(apiEndpoint)
      .then(res => {
        socket.emit(eventType, res.data);
      })
      .catch(error => console.log(error))
  });

  socket.on('disconnect', function() {
    console.log('socket disconnected')
    socket.disconnect();
  });
});

app.get('/', function (req, res) {
  res.send("meep")
})

server.listen(4200);
