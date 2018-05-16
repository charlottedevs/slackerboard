var express = require('express');
var app = express();
var server = require('http').createServer(app);
var redis = require('redis').createClient('6379', 'redis');
var io = require('socket.io')(server);

app.use(express.static(__dirname + '/node_modules'));
app.get('/', function(req, res,next) {
  res.sendFile(__dirname + '/index.html');
});

const slackerboard_change = 'slackerboard_change'

redis.subscribe(slackerboard_change)
redis.on('message', function(channel, message){
  var info = JSON.parse(message);
  io.sockets.emit(channel, info);
  console.log('emit '+ channel);
});

io.on('connection', function(client) {
  console.log('Client connected...');

  client.on('join', function(data) {
    console.log(data);
    client.emit('messages', 'Hello from server');
  });

  client.on('slackerboard_change', function(user){
    console.log('slackerboard change!', user)
  });

  client.on('disconnect', function() {
    console.log('Client disconnected')
    client.disconnect();
  });

});

server.listen(4200);
