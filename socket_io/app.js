var express = require('express');
var app = express();
var axios = require('axios')
var server = require('http').createServer(app);
var redis = require('redis').createClient('6379', 'redis');
var io = require('socket.io')(server);
var slackerboard = require('./slackers');


const all_time_updates = 'all_time_slackerboard_update';
const weekly_updates = 'this_week_slackerboard_update';

redis.subscribe(all_time_updates);
redis.subscribe(weekly_updates);

redis.on('message', function(channel, message){
  var info = JSON.parse(message);
  io.sockets.emit(channel, info);
});

io.on('connection', function(socket) {
  socket.on('join', function(data) {
    const channel = data.channel || 'noop';

    if (channel === 'noop') { return; }

    let apiEndpoint = 'http://api:5000/slackers';

    if (channel === 'this_week_slackerboard_updates') {
      apiEndpoint = `${apiEndpoint}?thisweek`;
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
    socket.disconnect();
  });
});

app.get('/', function (req, res) {
  res.send("meep")
})

server.listen(4200);
