'use strict';

var sampNodeLib = require('samp-node-lib');

const getClasses = () => {
  sampNodeLib.AddPlayerClass(
    299,
    1759.0189,
    -1898.126,
    13.5622,
    266.4503,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1
  );
  sampNodeLib.AddPlayerClass(
    300,
    1759.0189,
    -1898.126,
    13.5622,
    266.4503,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1
  );
};

global.PlayerCitySelection = [];
global.PlayerHasCitySelected = [];
global.LastCitySelectionTick = [];
const CITY_LOS_SANTOS = 0;
const CITY_SAN_FIERRO = 1;
const CITY_LAS_VENTURAS = 2;
sampNodeLib.OnGameModeInit(() => {
  getClasses();
});
sampNodeLib.OnPlayerConnect(({ playerid: id }) => {
  global.PlayerCitySelection[id] = -1;
  global.PlayerHasCitySelected[id] = 0;
  global.LastCitySelectionTick[id] = sampNodeLib.GetTickCount();
  console.log(
    global.PlayerCitySelection[id],
    global.PlayerHasCitySelected[id],
    global.LastCitySelectionTick[id]
  );
});
sampNodeLib.OnPlayerSpawn(({ playerid: id }) => {
});
sampNodeLib.OnPlayerDeath(({ playerid: id }, killerid, reason) => {
});
const SetupSelectedCity = (id) => {
  if (global.PlayerCitySelection[id] === -1) {
    global.PlayerCitySelection[id] = CITY_LOS_SANTOS;
  }
  if (global.PlayerCitySelection[id] === CITY_LOS_SANTOS) {
    sampNodeLib.SetPlayerInterior(id, 0);
    sampNodeLib.SetPlayerCameraPos(id, 1630.6136, -2286.0298, 110);
    sampNodeLib.SetPlayerCameraLookAt(id, 1887.6034, -1682.1442, 47.6167);
  }
  if (global.PlayerCitySelection[id] === CITY_SAN_FIERRO) {
    sampNodeLib.SetPlayerInterior(id, 0);
    sampNodeLib.SetPlayerCameraPos(id, -1300.8754, 68.0546, 129.4823);
    sampNodeLib.SetPlayerCameraLookAt(id, -1817.9412, 769.3878, 132.6589);
  }
  if (global.PlayerCitySelection[id] === CITY_LAS_VENTURAS) {
    sampNodeLib.SetPlayerInterior(id, 0);
    sampNodeLib.SetPlayerCameraPos(id, 1310.6155, 1675.9182, 110.739);
    sampNodeLib.SetPlayerCameraLookAt(id, 2285.2944, 1919.3756, 68.2275);
  }
};
const SwitchToNextCity = (id) => {
  global.PlayerCitySelection[id]++;
  if (global.PlayerCitySelection[id] > CITY_LAS_VENTURAS) {
    global.PlayerCitySelection[id] = CITY_LOS_SANTOS;
  }
  sampNodeLib.PlayerPlaySound(id, 1052, 0, 0, 0);
  global.LastCitySelectionTick[id] = sampNodeLib.GetTickCount();
  SetupSelectedCity(id);
};
const SwitchToPreviousCity = (id) => {
  global.PlayerCitySelection[id]--;
  if (global.PlayerCitySelection[id] < CITY_LOS_SANTOS) {
    global.PlayerCitySelection[id] = CITY_LAS_VENTURAS;
  }
  sampNodeLib.PlayerPlaySound(id, 1053, 0, 0, 0);
  global.LastCitySelectionTick[id] = sampNodeLib.GetTickCount();
  SetupSelectedCity(id);
};
const HandleCitySelection = (id) => {
  const pKeys = sampNodeLib.GetPlayerKeys(id);
  if (global.PlayerCitySelection[id] === -1) {
    SwitchToNextCity(id);
    return;
  }
  if (sampNodeLib.GetTickCount() - global.LastCitySelectionTick[id] < 500)
    return;
  if (pKeys[0] === sampNodeLib.KEY.FIRE || pKeys[0] === sampNodeLib.KEY.SECONDARY_ATTACK) {
    global.PlayerHasCitySelected[id] = 1;
    sampNodeLib.TogglePlayerSpectating(id, 0);
    return;
  }
  if (pKeys[2] === sampNodeLib.KEY.RIGHT) {
    SwitchToNextCity(id);
  }
  if (pKeys[2] === sampNodeLib.KEY.LEFT) {
    SwitchToPreviousCity(id);
  }
};
sampNodeLib.OnPlayerUpdate(({ playerid: id }) => {
  if (!sampNodeLib.IsPlayerConnected(id)) {
    return;
  }
  if (!global.PlayerHasCitySelected[id] && sampNodeLib.GetPlayerState(id) == sampNodeLib.PLAYER_STATE.SPECTATING) {
    HandleCitySelection(id);
    return;
  }
});
sampNodeLib.OnPlayerRequestClass(({ playerid: id }, classid) => {
  if (sampNodeLib.GetPlayerState(id) != sampNodeLib.PLAYER_STATE.SPECTATING) {
    sampNodeLib.TogglePlayerSpectating(id, 1);
    global.PlayerCitySelection[id] = -1;
  }
});

sampNodeLib.OnGameModeInit(async () => {
  sampNodeLib.SetGameModeText("Test");
  sampNodeLib.ShowPlayerMarkers(2);
  sampNodeLib.ShowNameTags(1);
  sampNodeLib.SetNameTagDrawDistance(40);
  sampNodeLib.EnableStuntBonusForAll(0);
  sampNodeLib.DisableInteriorEnterExits();
  sampNodeLib.SetWeather(2);
  sampNodeLib.SetWorldTime(11);
});
sampNodeLib.OnGameModeExit(async () => {
});
sampNodeLib.OnPlayerConnect(({ playerid: id }) => {
  const username = sampNodeLib.GetPlayerName(id, 20);
  sampNodeLib.SendClientMessageToAll(
    "rgba(207,240,183,1)",
    `[JOIN] ${username} (id: ${id}) has joined the server. Welcome!`
  );
});
//# sourceMappingURL=main.js.map
