var express = require('express');
var app = express();
var axios = require('axios')
var server = require('http').createServer(app);
var redis = require('redis').createClient('6379', 'redis');
var io = require('socket.io')(server);
var slackerboard = require('./slackers');


const apiEndpoint = 'http://rails_server:5000/slackers';
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
    axios(apiEndpoint)
      .then(res => {
        socket.emit(slackerboard_change, res.data);
      })
      .catch(error => console.log(error))
  });

  socket.on('disconnect', function() {
    console.log('socket disconnected')
    socket.disconnect();
  });
});

server.listen(4200);
