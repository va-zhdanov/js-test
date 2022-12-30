import {
  GetPlayerKeys,
  GetPlayerState,
  GetTickCount,
  IsPlayerConnected,
  KEY,
  OnGameModeInit,
  OnPlayerConnect,
  OnPlayerDeath,
  OnPlayerRequestClass,
  OnPlayerSpawn,
  OnPlayerUpdate,
  PlayerPlaySound,
  PLAYER_STATE,
  SetPlayerCameraLookAt,
  SetPlayerCameraPos,
  SetPlayerInterior,
  TogglePlayerSpectating,
} from "samp-node-lib";
import { getClasses } from "./classes";

global.PlayerCitySelection = [];
global.PlayerHasCitySelected = [];
global.LastCitySelectionTick = [];

const CITY_LOS_SANTOS = 0;
const CITY_SAN_FIERRO = 1;
const CITY_LAS_VENTURAS = 2;

OnGameModeInit(() => {
  // Get all classes
  getClasses();
});

OnPlayerConnect(({ playerid: id }) => {
  // Team selection init vars
  // class selection init vars
  global.PlayerCitySelection[id] = -1;
  global.PlayerHasCitySelected[id] = 0;
  global.LastCitySelectionTick[id] = GetTickCount();

  console.log(
    global.PlayerCitySelection[id],
    global.PlayerHasCitySelected[id],
    global.LastCitySelectionTick[id]
  );
});

OnPlayerSpawn(({ playerid: id }) => {});

OnPlayerDeath(({ playerid: id }, killerid, reason) => {});

const SetupCharSelection = (id) => {};

const SetupSelectedCity = (id) => {
  if (global.PlayerCitySelection[id] === -1) {
    global.PlayerCitySelection[id] = CITY_LOS_SANTOS;
  }

  if (global.PlayerCitySelection[id] === CITY_LOS_SANTOS) {
    SetPlayerInterior(id, 0);
    SetPlayerCameraPos(id, 1630.6136, -2286.0298, 110.0);
    SetPlayerCameraLookAt(id, 1887.6034, -1682.1442, 47.6167);
  }

  if (global.PlayerCitySelection[id] === CITY_SAN_FIERRO) {
    SetPlayerInterior(id, 0);
    SetPlayerCameraPos(id, -1300.8754, 68.0546, 129.4823);
    SetPlayerCameraLookAt(id, -1817.9412, 769.3878, 132.6589);
  }

  if (global.PlayerCitySelection[id] === CITY_LAS_VENTURAS) {
    SetPlayerInterior(id, 0);
    SetPlayerCameraPos(id, 1310.6155, 1675.9182, 110.739);
    SetPlayerCameraLookAt(id, 2285.2944, 1919.3756, 68.2275);
  }
};

const SwitchToNextCity = (id) => {
  global.PlayerCitySelection[id]++;

  if (global.PlayerCitySelection[id] > CITY_LAS_VENTURAS) {
    global.PlayerCitySelection[id] = CITY_LOS_SANTOS;
  }

  PlayerPlaySound(id, 1052, 0.0, 0.0, 0.0);
  global.LastCitySelectionTick[id] = GetTickCount();
  SetupSelectedCity(id);
};

const SwitchToPreviousCity = (id) => {
  global.PlayerCitySelection[id]--;

  if (global.PlayerCitySelection[id] < CITY_LOS_SANTOS) {
    global.PlayerCitySelection[id] = CITY_LAS_VENTURAS;
  }

  PlayerPlaySound(id, 1053, 0.0, 0.0, 0.0);
  global.LastCitySelectionTick[id] = GetTickCount();
  SetupSelectedCity(id);
};

const HandleCitySelection = (id) => {
  const pKeys = GetPlayerKeys(id);

  if (global.PlayerCitySelection[id] === -1) {
    SwitchToNextCity(id);
    return;
  }

  // only allow new selection every ~500 ms
  if (GetTickCount() - global.LastCitySelectionTick[id] < 500) return;

  if (pKeys[0] === KEY.FIRE || pKeys[0] === KEY.SECONDARY_ATTACK) {
    global.PlayerHasCitySelected[id] = 1;
    TogglePlayerSpectating(id, 0);
    return;
  }

  if (pKeys[2] === KEY.RIGHT) {
    SwitchToNextCity(id);
  }

  if (pKeys[2] === KEY.LEFT) {
    SwitchToPreviousCity(id);
  }
};

OnPlayerUpdate(({ playerid: id }) => {
  if (!IsPlayerConnected(id)) {
    return;
  }

  if (
    !global.PlayerHasCitySelected[id] &&
    GetPlayerState(id) == PLAYER_STATE.SPECTATING
  ) {
    HandleCitySelection(id);
    return;
  }
});

OnPlayerRequestClass(({ playerid: id }, classid) => {
  if (GetPlayerState(id) != PLAYER_STATE.SPECTATING) {
    TogglePlayerSpectating(id, 1);
    global.PlayerCitySelection[id] = -1;
  }
});
