var express = require('express');
var app = express();
var server = require('http').createServer(app);
var redis = require('redis').createClient('6379', 'redis');
var io = require('socket.io')(server);
var slackers = require('./slackers');

app.use(express.static(__dirname + '/node_modules'));
app.use(express.static(__dirname + '/public'));
app.get('/', function(req, res,next) {
  res.sendFile(__dirname + '/index.html');
});

const slackerboard_change = 'slackerboard_change';
const slackerboard_init = 'slackerboard_init';

redis.subscribe(slackerboard_change)
redis.on('message', function(channel, message){
  var info = JSON.parse(message);
  io.sockets.emit(channel, info);
  console.log('emit ->'+ channel);
});

io.on('connection', function(socket) {
  console.log('socket connected...');

  socket.on('join', function(data) {
    socket.emit(slackerboard_init, slackers);
  });

  socket.on('slackerboard_change', function(user){
    console.log('slackerboard change!', user)
  });

  socket.on('disconnect', function() {
    console.log('socket disconnected')
    socket.disconnect();
  });

});

server.listen(4200);
