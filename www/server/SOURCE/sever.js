// Generated by CoffeeScript 1.4.0
/*class Serveur
  constructor: () ->

  init: ->
*/

var app, express, indice, io, server;

express = require('express');

app = express();

server = require('http').createServer(app);

io = require('socket.io').listen(server);

indice = 0;

server.listen(3000);

io.set('log level', 1);

io.set('transports', ['websocket', 'flashsocket', 'htmlfile', 'xhr-polling', 'jsonp-polling']);

io.sockets.on('connection', function(socket) {
  var brodcastSlide;
  socket.on('admin', function(data) {
    return console.log('admin connected');
  });
  socket.on('reset', function(data) {
    console.log('admin asks for reseting');
    return socket.broadcast.emit('sreset', data);
  });
  socket.on('user', function(data) {
    socket.name = data.name;
    return console.log('user connected');
  });
  socket.on('next', function(data) {
    return brodcastSlide('snext', data);
  });
  return brodcastSlide = function(message, data) {
    socket.emit(message, data);
    return socket.broadcast.emit(message, data);
  };
});

console.log('Serveur lancé');
