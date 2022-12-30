//----------------------------------------------------------
//
//  TEST  1.0
//  A node.js gamemode for SA-MP 0.3
//
//----------------------------------------------------------

import {
  OnPlayerConnect,
  GetPlayerName,
  SendClientMessageToAll,
  OnGameModeInit,
  SetGameModeText,
  OnGameModeExit,
  ShowPlayerMarkers,
  ShowNameTags,
  SetNameTagDrawDistance,
  EnableStuntBonusForAll,
  DisableInteriorEnterExits,
  SetWeather,
  SetWorldTime,
} from "samp-node-lib";

// import { checkDbConnection } from "./db";

// import "./dialogs";

// This imports the team & class selection
import "./parts/teamSelection";

OnGameModeInit(async () => {
  // General settings
  SetGameModeText("Test");
  ShowPlayerMarkers(2);
  ShowNameTags(1);
  SetNameTagDrawDistance(40);
  EnableStuntBonusForAll(0);
  DisableInteriorEnterExits();
  SetWeather(2);
  SetWorldTime(11);

  // Check DB connection
  //  await checkDbConnection();
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
