// Samp node
import {
   OnPlayerConnect,
   GetPlayerName,
   SendClientMessageToAll,
   OnGameModeInit,
   SetGameModeText,
   OnGameModeExit,
} from "samp-node-lib";

// Database
import { checkDbConnection } from "./db";

// Global Variables
SetP;

// Dialogs
import "./dialogs";

OnGameModeInit(async () => {
   // Gamemode Name
   SetGameModeText("Test");

   // Check DB connection
   await checkDbConnection();
});

OnGameModeExit(async () => {});

OnPlayerConnect(({ playerid: id }) => {
   const username = GetPlayerName(id, 20);

   // Send join message to all
   SendClientMessageToAll(
      "rgba(207,240,183,1)",
      `[JOIN] ${username} (id: ${id}) has joined the server. Welcome!`
   );
});
