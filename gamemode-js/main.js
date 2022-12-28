'use strict';

var sampNodeLib = require('samp-node-lib');
var socket_ioClient = require('socket.io-client');

const socket = socket_ioClient.io("http://localhost:3000");
sampNodeLib.OnPlayerConnect(({ playerid: id }) => {
  const username = sampNodeLib.GetPlayerName(id, 20);
  sampNodeLib.SendClientMessageToAll(
    "rgba(207,240,183,1)",
    `[JOIN] ${username} (id: ${id}) has joined the server. Welcome!`
  );
  socket.emit("SERVER_JOIN", `${username} (id: ${id}) has joined the server`);
});
socket.on("connect", () => {
  console.log("[SOCKET CONNECTION]", socket.connected);
});
socket.on("RECEIVE_WEB_MESSAGE", (msg) => {
  sampNodeLib.SendClientMessageToAll("rgba(207,240,183,1)", `${msg}`);
});
//# sourceMappingURL=main.js.map
