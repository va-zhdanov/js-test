import {
  OnPlayerConnect,
  GetPlayerName,
  SendClientMessageToAll,
} from "samp-node-lib";

// testing websocket
import { io } from "socket.io-client";
const socket = io("http://localhost:3000");

OnPlayerConnect(({ playerid: id }) => {
  const username = GetPlayerName(id, 20);

  SendClientMessageToAll(
    "rgba(207,240,183,1)",
    `[JOIN] ${username} (id: ${id}) has joined the server. Welcome!`
  );

  socket.emit("SERVER_JOIN", `${username} (id: ${id}) has joined the server`);
});

socket.on("connect", () => {
  console.log("[SOCKET CONNECTION]", socket.connected);
});

socket.on("RECEIVE_WEB_MESSAGE", (msg) => {
  SendClientMessageToAll("rgba(207,240,183,1)", `${msg}`);
});
