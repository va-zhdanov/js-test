//----------------------------------------------------------
//
//  GRAND LARCENY  1.0
//  A freeroam gamemode for SA-MP 0.3
//
//----------------------------------------------------------

#include <a_samp>
#include <sscanf2>

// YSI LIBRARY
#define YSI_NO_CACHE_MESSAGE
#define YSI_NO_OPTIMISATION_MESSAGE
#define YSI_NO_VERSION_CHECK
#include <YSI_Visual/y_classes>
#include <YSI_Players/y_groups>
#include <YSI_Visual/y_commands>

#include "../include/gl_common.inc"
#include "../include/gl_spawns.inc"

new	Group:gNoClass,
    Group:gPolice,
    Group:gMafia,
    Group:gCluckers,
	Group:gVIP;

//CLASS SELECTION TXD
new Text:box_bg;
new Text:ls_logo;
new Text:gw_logo;
new Text:box_bg2;
new Text:box_title;
new Text:version_logo;
new Text:SEL_info;
new Text:SEL_info2;
new Text:members_list;
new Text:website_bg;
new Text:website_bg2;
new Text:website_title;
new Text:website_text;

//----------------------------------------------------------

#define COLOR_WHITE 		0xFFFFFFFF
#define COLOR_NORMAL_PLAYER 0xFFBB7777

#define TEAM_POLICE 	0
#define TEAM_MAFIA 		1
#define TEAM_CLUCKERS 	2
#define TEAM_VIP 		3

enum TPlayerData
{
	TeamSelection,
	HasTeamSelected,
	LastTeamSelectionTick
}
new PlayerInfo[MAX_PLAYERS][TPlayerData];

new Text:txtPolice;
new Text:txtMafia;
new Text:txtCluckers;
new Text:txtVIP;

//----------------------------------------------------------

main() {}

//----------------------------------------------------------

public OnPlayerConnect(playerid)
{
	Group_SetPlayer(gNoClass, playerid, true);
  	// class selection init vars
  	PlayerInfo[playerid][TeamSelection] = -1;
	PlayerInfo[playerid][HasTeamSelected] = 0;
	PlayerInfo[playerid][LastTeamSelectionTick] = GetTickCount();
 	return 1;
}

public OnPlayerSpawn(playerid)
{
	new randSpawn = 0;
	
	if(TEAM_POLICE == PlayerInfo[playerid][TeamSelection]) 
	{
 	    randSpawn = random(sizeof(gRandomSpawns_LosSantos));
 	    SetPlayerPos(playerid, gRandomSpawns_LosSantos[randSpawn][0], gRandomSpawns_LosSantos[randSpawn][1], gRandomSpawns_LosSantos[randSpawn][2]);
		SetPlayerFacingAngle(playerid,gRandomSpawns_LosSantos[randSpawn][3]);
	}
	else if(TEAM_MAFIA == PlayerInfo[playerid][TeamSelection]) 
	{
 	    randSpawn = random(sizeof(gRandomSpawns_SanFierro));
 	    SetPlayerPos(playerid, gRandomSpawns_SanFierro[randSpawn][0], gRandomSpawns_SanFierro[randSpawn][1], gRandomSpawns_SanFierro[randSpawn][2]);
		SetPlayerFacingAngle(playerid,gRandomSpawns_SanFierro[randSpawn][3]);
	}
	else if(TEAM_CLUCKERS == PlayerInfo[playerid][TeamSelection]) 
	{
 	    randSpawn = random(sizeof(gRandomSpawns_LasVenturas));
 	    SetPlayerPos(playerid, gRandomSpawns_LasVenturas[randSpawn][0], gRandomSpawns_LasVenturas[randSpawn][1],  gRandomSpawns_LasVenturas[randSpawn][2]);
		SetPlayerFacingAngle(playerid,gRandomSpawns_LasVenturas[randSpawn][3]);
	}
	else if(TEAM_VIP == PlayerInfo[playerid][TeamSelection]) 
	{
 	    randSpawn = random(sizeof(gRandomSpawns_LasVenturas));
 	    SetPlayerPos(playerid, gRandomSpawns_LasVenturas[randSpawn][0], gRandomSpawns_LasVenturas[randSpawn][1],  gRandomSpawns_LasVenturas[randSpawn][2]);
		SetPlayerFacingAngle(playerid,gRandomSpawns_LasVenturas[randSpawn][3]);
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	// If the player returns to class selection reset their city (they'll see the first city?)
	PlayerInfo[playerid][HasTeamSelected] = 0;
   	return 1;
}

// Used to init textdraws of city names
ClassSel_InitTeamNameText(Text:txtInit)
{
	TextDrawFont(txtInit, 3);
	TextDrawLetterSize(txtInit, 0.408333, 1.599998);
	TextDrawTextSize(txtInit, 400.000000, 17.000000);
	TextDrawSetOutline(txtInit, 0);
	TextDrawSetShadow(txtInit, 1);
	TextDrawAlignment(txtInit, 1);
	TextDrawBoxColor(txtInit, 50);
	TextDrawUseBox(txtInit, 0);
	TextDrawSetProportional(txtInit, 1);
	TextDrawSetSelectable(txtInit, 0);
}

ClassSel_InitTextDraws()
{
	// Init our observer helper text display
	txtPolice = TextDrawCreate(249.000000, 197.000000, "The Police");
    TextDrawColor(txtPolice, 0x0080FFFF);
	TextDrawBackgroundColor(txtPolice, 135);
	ClassSel_InitTeamNameText(txtPolice);

	txtMafia = TextDrawCreate(249.000000, 197.000000, "The Italian Mafia");
    TextDrawColor(txtMafia, 0x926757FF);
    TextDrawBackgroundColor(txtMafia, 70);
	ClassSel_InitTeamNameText(txtMafia);

	txtCluckers = TextDrawCreate(249.000000, 197.000000, "The Cluckers");
    TextDrawColor(txtCluckers, 0xF1B514FF);
    TextDrawBackgroundColor(txtCluckers, 70);
	ClassSel_InitTeamNameText(txtCluckers);
	
	txtVIP = TextDrawCreate(249.000000, 197.000000, "VIP MEMBERS");
    TextDrawColor(txtVIP, 0x7BE600FF);
    TextDrawBackgroundColor(txtVIP, 70);
	ClassSel_InitTeamNameText(txtVIP);

	//CLASS SELECTION TXD
	box_bg = TextDrawCreate(74.000000, 230.000000, "_");
	TextDrawFont(box_bg, 0);
	TextDrawLetterSize(box_bg, 0.987500, 6.100004);
	TextDrawTextSize(box_bg, 324.000000, 124.000000);
	TextDrawSetOutline(box_bg, 0);
	TextDrawSetShadow(box_bg, 0);
	TextDrawAlignment(box_bg, 2);
	TextDrawColor(box_bg, -1);
	TextDrawBackgroundColor(box_bg, -1962934017);
	TextDrawBoxColor(box_bg, 1517313023);
	TextDrawUseBox(box_bg, 1);
	TextDrawSetProportional(box_bg, 1);
	TextDrawSetSelectable(box_bg, 0);

	ls_logo = TextDrawCreate(30.000000, 174.000000, "Las Venturas");
	TextDrawFont(ls_logo, 0);
	TextDrawLetterSize(ls_logo, 0.600000, 2.299998);
	TextDrawTextSize(ls_logo, 403.500000, 19.000000);
	TextDrawSetOutline(ls_logo, 1);
	TextDrawSetShadow(ls_logo, 0);
	TextDrawAlignment(ls_logo, 1);
	TextDrawColor(ls_logo, -1);
	TextDrawBackgroundColor(ls_logo, 255);
	TextDrawBoxColor(ls_logo, 50);
	TextDrawUseBox(ls_logo, 0);
	TextDrawSetProportional(ls_logo, 1);
	TextDrawSetSelectable(ls_logo, 0);

	gw_logo = TextDrawCreate(20.000000, 195.000000, "Death Match");
	TextDrawFont(gw_logo, 3);
	TextDrawLetterSize(gw_logo, 0.600000, 2.149996);
	TextDrawTextSize(gw_logo, 400.000000, 17.000000);
	TextDrawSetOutline(gw_logo, 1);
	TextDrawSetShadow(gw_logo, 0);
	TextDrawAlignment(gw_logo, 1);
	TextDrawColor(gw_logo, 1517313023);
	TextDrawBackgroundColor(gw_logo, 255);
	TextDrawBoxColor(gw_logo, 50);
	TextDrawUseBox(gw_logo, 0);
	TextDrawSetProportional(gw_logo, 1);
	TextDrawSetSelectable(gw_logo, 0);

	box_bg2 = TextDrawCreate(74.000000, 248.000000, "_");
	TextDrawFont(box_bg2, 1);
	TextDrawLetterSize(box_bg2, 0.600000, 3.900000);
	TextDrawTextSize(box_bg2, 323.000000, 121.000000);
	TextDrawSetOutline(box_bg2, 1);
	TextDrawSetShadow(box_bg2, 0);
	TextDrawAlignment(box_bg2, 2);
	TextDrawColor(box_bg2, -1);
	TextDrawBackgroundColor(box_bg2, 255);
	TextDrawBoxColor(box_bg2, 135);
	TextDrawUseBox(box_bg2, 1);
	TextDrawSetProportional(box_bg2, 1);
	TextDrawSetSelectable(box_bg2, 0);

	box_title = TextDrawCreate(14.000000, 232.000000, "Welcome Gangsta'");
	TextDrawFont(box_title, 1);
	TextDrawLetterSize(box_title, 0.195831, 1.000000);
	TextDrawTextSize(box_title, 400.000000, 17.000000);
	TextDrawSetOutline(box_title, 0);
	TextDrawSetShadow(box_title, 0);
	TextDrawAlignment(box_title, 1);
	TextDrawColor(box_title, 255);
	TextDrawBackgroundColor(box_title, 255);
	TextDrawBoxColor(box_title, 50);
	TextDrawUseBox(box_title, 0);
	TextDrawSetProportional(box_title, 1);
	TextDrawSetSelectable(box_title, 0);

	version_logo = TextDrawCreate(119.000000, 214.000000, "v1.0");
	TextDrawFont(version_logo, 1);
	TextDrawLetterSize(version_logo, 0.191666, 0.999997);
	TextDrawTextSize(version_logo, 400.000000, 17.000000);
	TextDrawSetOutline(version_logo, 1);
	TextDrawSetShadow(version_logo, 0);
	TextDrawAlignment(version_logo, 1);
	TextDrawColor(version_logo, -1);
	TextDrawBackgroundColor(version_logo, 255);
	TextDrawBoxColor(version_logo, 50);
	TextDrawUseBox(version_logo, 0);
	TextDrawSetProportional(version_logo, 1);
	TextDrawSetSelectable(version_logo, 0);

	SEL_info = TextDrawCreate(14.000000, 250.000000, "Please use ~r~LEFT ~w~and ~r~RIGHT ~w~to switch between teams.");
	TextDrawFont(SEL_info, 1);
	TextDrawLetterSize(SEL_info, 0.174998, 0.950001);
	TextDrawTextSize(SEL_info, 132.500000, 37.000000);
	TextDrawSetOutline(SEL_info, 0);
	TextDrawSetShadow(SEL_info, 0);
	TextDrawAlignment(SEL_info, 1);
	TextDrawColor(SEL_info, -1);
	TextDrawBackgroundColor(SEL_info, 255);
	TextDrawBoxColor(SEL_info, 0);
	TextDrawUseBox(SEL_info, 1);
	TextDrawSetProportional(SEL_info, 1);
	TextDrawSetSelectable(SEL_info, 0);

	SEL_info2 = TextDrawCreate(14.000000, 271.000000, "Use ~r~SHIFT ~w~or ~r~ENTER ~w~to select team.");
	TextDrawFont(SEL_info2, 1);
	TextDrawLetterSize(SEL_info2, 0.174998, 0.950001);
	TextDrawTextSize(SEL_info2, 132.500000, 37.000000);
	TextDrawSetOutline(SEL_info2, 0);
	TextDrawSetShadow(SEL_info2, 0);
	TextDrawAlignment(SEL_info2, 1);
	TextDrawColor(SEL_info2, -1);
	TextDrawBackgroundColor(SEL_info2, 255);
	TextDrawBoxColor(SEL_info2, 0);
	TextDrawUseBox(SEL_info2, 1);
	TextDrawSetProportional(SEL_info2, 1);
	TextDrawSetSelectable(SEL_info2, 0);

	members_list = TextDrawCreate(252.000000, 213.000000, "Members: 10 Online");
	TextDrawFont(members_list, 1);
	TextDrawLetterSize(members_list, 0.212500, 1.149999);
	TextDrawTextSize(members_list, 400.000000, 17.000000);
	TextDrawSetOutline(members_list, 1);
	TextDrawSetShadow(members_list, 0);
	TextDrawAlignment(members_list, 1);
	TextDrawColor(members_list, -1);
	TextDrawBackgroundColor(members_list, 72);
	TextDrawBoxColor(members_list, 50);
	TextDrawUseBox(members_list, 0);
	TextDrawSetProportional(members_list, 1);
	TextDrawSetSelectable(members_list, 0);

	website_bg = TextDrawCreate(74.000000, 291.000000, "_");
	TextDrawFont(website_bg, 0);
	TextDrawLetterSize(website_bg, 0.987500, 5.650002);
	TextDrawTextSize(website_bg, 324.000000, 124.000000);
	TextDrawSetOutline(website_bg, 0);
	TextDrawSetShadow(website_bg, 0);
	TextDrawAlignment(website_bg, 2);
	TextDrawColor(website_bg, -1);
	TextDrawBackgroundColor(website_bg, -1962934017);
	TextDrawBoxColor(website_bg, 1517313023);
	TextDrawUseBox(website_bg, 1);
	TextDrawSetProportional(website_bg, 1);
	TextDrawSetSelectable(website_bg, 0);

	website_bg2 = TextDrawCreate(74.000000, 309.000000, "_");
	TextDrawFont(website_bg2, 1);
	TextDrawLetterSize(website_bg2, 0.600000, 3.450000);
	TextDrawTextSize(website_bg2, 323.000000, 121.000000);
	TextDrawSetOutline(website_bg2, 1);
	TextDrawSetShadow(website_bg2, 0);
	TextDrawAlignment(website_bg2, 2);
	TextDrawColor(website_bg2, -1);
	TextDrawBackgroundColor(website_bg2, 255);
	TextDrawBoxColor(website_bg2, 135);
	TextDrawUseBox(website_bg2, 1);
	TextDrawSetProportional(website_bg2, 1);
	TextDrawSetSelectable(website_bg2, 0);

	website_title = TextDrawCreate(14.000000, 293.000000, "Visit our website");
	TextDrawFont(website_title, 1);
	TextDrawLetterSize(website_title, 0.195831, 1.000000);
	TextDrawTextSize(website_title, 400.000000, 17.000000);
	TextDrawSetOutline(website_title, 0);
	TextDrawSetShadow(website_title, 0);
	TextDrawAlignment(website_title, 1);
	TextDrawColor(website_title, 255);
	TextDrawBackgroundColor(website_title, 255);
	TextDrawBoxColor(website_title, 50);
	TextDrawUseBox(website_title, 0);
	TextDrawSetProportional(website_title, 1);
	TextDrawSetSelectable(website_title, 0);

	website_text = TextDrawCreate(14.000000, 311.000000, "Visit our website at: ~g~www.lv-dm.com ~w~and access your profile.");
	TextDrawFont(website_text, 1);
	TextDrawLetterSize(website_text, 0.174998, 0.950001);
	TextDrawTextSize(website_text, 132.500000, 37.000000);
	TextDrawSetOutline(website_text, 0);
	TextDrawSetShadow(website_text, 0);
	TextDrawAlignment(website_text, 1);
	TextDrawColor(website_text, -1);
	TextDrawBackgroundColor(website_text, 255);
	TextDrawBoxColor(website_text, 0);
	TextDrawUseBox(website_text, 1);
	TextDrawSetProportional(website_text, 1);
	TextDrawSetSelectable(website_text, 0);
}


ClassSel_SetupSelectedCity(playerid)
{
	if(PlayerInfo[playerid][TeamSelection] == -1) 
	{
		PlayerInfo[playerid][TeamSelection] = TEAM_POLICE;
	}
	
	if(PlayerInfo[playerid][TeamSelection] == TEAM_POLICE) 
	{
		Group_SetPlayer(gPolice, playerid, true);
		Group_SetPlayer(gMafia, playerid, false);
		Group_SetPlayer(gCluckers, playerid, false);
		Group_SetPlayer(gVIP, playerid, false);
		
		// Set the camera to look at the Police base
		SetPlayerInterior(playerid,0);
   		SetPlayerCameraPos(playerid,2217.9705,2391.6995,45.6409);
		SetPlayerCameraLookAt(playerid,2243.9185,2451.8093,38.1762, CAMERA_MOVE);
		
		TextDrawShowForPlayer(playerid, txtPolice);
		TextDrawHideForPlayer(playerid, txtMafia);
		TextDrawHideForPlayer(playerid, txtCluckers);
		TextDrawHideForPlayer(playerid, txtVIP);
	}
	else if(PlayerInfo[playerid][TeamSelection] == TEAM_MAFIA) 
	{
		Group_SetPlayer(gPolice, playerid, false);
		Group_SetPlayer(gMafia, playerid, true);
		Group_SetPlayer(gCluckers, playerid, false);
		Group_SetPlayer(gVIP, playerid, false);
		
		// Set the camera to look at the Mafia base
		SetPlayerInterior(playerid,0);
   		SetPlayerCameraPos(playerid,1034.9702,1831.2263,39.3380);
		SetPlayerCameraLookAt(playerid,967.2339,1771.2921,33.7641, CAMERA_MOVE);
		
		TextDrawHideForPlayer(playerid, txtPolice);
		TextDrawShowForPlayer(playerid, txtMafia);
		TextDrawHideForPlayer(playerid, txtCluckers);
		TextDrawHideForPlayer(playerid, txtVIP);
	}
	else if(PlayerInfo[playerid][TeamSelection] == TEAM_CLUCKERS) 
	{
		Group_SetPlayer(gPolice, playerid, false);
		Group_SetPlayer(gMafia, playerid, false);
		Group_SetPlayer(gCluckers, playerid, true);
		Group_SetPlayer(gVIP, playerid, false);
		
		// Set the camera to look at the Cluckers base
		SetPlayerInterior(playerid,0);
   		SetPlayerCameraPos(playerid,2488.1362,1844.9017,48.1280);
		SetPlayerCameraLookAt(playerid,2563.9663,1808.1927,33.5555, CAMERA_MOVE);
		
		TextDrawHideForPlayer(playerid, txtPolice);
		TextDrawHideForPlayer(playerid, txtMafia);
		TextDrawShowForPlayer(playerid, txtCluckers);
		TextDrawHideForPlayer(playerid, txtVIP);
	}
	else if(PlayerInfo[playerid][TeamSelection] == TEAM_VIP) 
	{
		Group_SetPlayer(gPolice, playerid, false);
		Group_SetPlayer(gMafia, playerid, false);
		Group_SetPlayer(gCluckers, playerid, false);
		Group_SetPlayer(gVIP, playerid, true);
		
		// Set the camera to look at the VIP base
		SetPlayerInterior(playerid,0);
   		SetPlayerCameraPos(playerid, 2205.5598,618.8271,47.3589);
		SetPlayerCameraLookAt(playerid, 2291.9419,564.9495,29.7493, CAMERA_MOVE);
		
		TextDrawHideForPlayer(playerid, txtPolice);
		TextDrawHideForPlayer(playerid, txtMafia);
		TextDrawHideForPlayer(playerid, txtCluckers);
		TextDrawShowForPlayer(playerid, txtVIP);
	}
}

ClassSel_SwitchToNextClass(playerid)
{
    PlayerInfo[playerid][TeamSelection]++;
	if(PlayerInfo[playerid][TeamSelection] > TEAM_VIP) // TEAM_VIP is the last team in the class (team) selection
	{
	    PlayerInfo[playerid][TeamSelection] = TEAM_POLICE;
	}
	PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
	PlayerInfo[playerid][LastTeamSelectionTick] = GetTickCount();
	ClassSel_SetupSelectedCity(playerid);
}

ClassSel_SwitchToPreviousClass(playerid)
{
    PlayerInfo[playerid][TeamSelection]--;
	if(PlayerInfo[playerid][TeamSelection] < TEAM_POLICE) 
	{
	    PlayerInfo[playerid][TeamSelection] = TEAM_VIP; // TEAM_VIP is the last team in the class (team) selection
	}
	PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
	PlayerInfo[playerid][LastTeamSelectionTick] = GetTickCount();
	ClassSel_SetupSelectedCity(playerid);
}

ClassSel_HandleClassSelection(playerid)
{
	new Keys,ud,lr;
    GetPlayerKeys(playerid, Keys, ud, lr);
    
    if(PlayerInfo[playerid][TeamSelection] == -1) 
	{
		ClassSel_SwitchToNextClass(playerid);
		return;
	}
	// Only allow new selection every 250 ms
	if ((GetTickCount() - PlayerInfo[playerid][LastTeamSelectionTick]) < 250) return;
	// KEYS (ENTER OR SHIFT)
	if (Keys & KEY_JUMP || Keys & KEY_SECONDARY_ATTACK) 
	{
	    PlayerInfo[playerid][HasTeamSelected] = 1;
		
		TextDrawHideForPlayer(playerid,txtPolice);
		TextDrawHideForPlayer(playerid,txtMafia);
		TextDrawHideForPlayer(playerid,txtCluckers);
		TextDrawHideForPlayer(playerid,txtVIP);
		TextDrawHideForPlayer(playerid,box_bg);
		TextDrawHideForPlayer(playerid,ls_logo);
		TextDrawHideForPlayer(playerid,gw_logo);
		TextDrawHideForPlayer(playerid,box_bg2);
		TextDrawHideForPlayer(playerid,box_title);
		TextDrawHideForPlayer(playerid,version_logo);
		TextDrawHideForPlayer(playerid,SEL_info);
		TextDrawHideForPlayer(playerid,SEL_info2);
		TextDrawHideForPlayer(playerid,members_list);
		TextDrawHideForPlayer(playerid,website_bg);
		TextDrawHideForPlayer(playerid,website_bg2);
		TextDrawHideForPlayer(playerid,website_title);
		TextDrawHideForPlayer(playerid,website_text);
		Class_EnableSelection(playerid);
	    return;
	}
	
	if(lr > 0) {
	   ClassSel_SwitchToNextClass(playerid);
	}
	else if(lr < 0) {
	   ClassSel_SwitchToPreviousClass(playerid);
	}
}

public OnPlayerRequestClass(playerid, classid)
{
	if (PlayerInfo[playerid][HasTeamSelected]) 
	{
		SetPlayerPos(playerid, 1958.0863, 948.6185, 10.8203);
		SetPlayerFacingAngle(playerid, 180.0);
		SetPlayerCameraPos(playerid, 1958.5, 930, 15.0);
		SetPlayerCameraLookAt(playerid, 1958.4, 940, 11);
		return 1;
	} 
	else 
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING) 
		{
			Class_DisableSelection(playerid);
			PlayerInfo[playerid][TeamSelection] = -1;
			
			TextDrawShowForPlayer(playerid,box_bg);
			TextDrawShowForPlayer(playerid,ls_logo);
			TextDrawShowForPlayer(playerid,gw_logo);
			TextDrawShowForPlayer(playerid,box_bg2);
			TextDrawShowForPlayer(playerid,box_title);
			TextDrawShowForPlayer(playerid,version_logo);
			TextDrawShowForPlayer(playerid,SEL_info);
			TextDrawShowForPlayer(playerid,SEL_info2);
			TextDrawShowForPlayer(playerid,members_list);
			TextDrawShowForPlayer(playerid,website_bg);
			TextDrawShowForPlayer(playerid,website_bg2);
			TextDrawShowForPlayer(playerid,website_title);
			TextDrawShowForPlayer(playerid,website_text);
		}
	}
	return 0;
}

public OnGameModeInit()
{
	// ------------------------------------------
	SetGameModeText("Grand Larceny");
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);
	ShowNameTags(1);
	SetNameTagDrawDistance(40.0);
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	SetWeather(2);
	SetWorldTime(11);
	UsePlayerPedAnims();
	// ------------------------------------------
	
	// Initialize the class selection textdraws
	ClassSel_InitTextDraws();
	
	// Create the groups
	gNoClass = Group_Create("No class");
	gPolice = Group_Create("Police");
    gMafia = Group_Create("Mafia");
    gCluckers = Group_Create("Cluckers");
	gVIP = Group_Create("VIP");
	
	// Police skins
	Class_AddForGroup(gPolice, 0, 0.0, 0.0, 5.0, 0.0);
	Class_AddForGroup(gPolice, 105, 0.0, 0.0, 5.0, 0.0);
	Class_AddForGroup(gPolice, 106, 0.0, 0.0, 5.0, 0.0);
	Class_AddForGroup(gPolice, 107, 0.0, 0.0, 5.0, 0.0);
	
	// Mafia skins
	Class_AddForGroup(gMafia, 167, 0.0, 0.0, 5.0, 0.0);
	Class_AddForGroup(gMafia, 211, 0.0, 0.0, 5.0, 0.0);
	
	// Clucker skins
	Class_AddForGroup(gCluckers, 173, 0.0, 0.0, 5.0, 0.0);
	Class_AddForGroup(gCluckers, 174, 0.0, 0.0, 5.0, 0.0);
	Class_AddForGroup(gCluckers, 175, 0.0, 0.0, 5.0, 0.0);
	
	// VIP skins
	Class_AddForGroup(gVIP, 212, 0.0, 0.0, 5.0, 0.0);
	Class_AddForGroup(gVIP, 230, 0.0, 0.0, 5.0, 0.0);
	return 1;
}

public OnPlayerUpdate(playerid)
{
	// Changing cities by inputs
	if (!PlayerInfo[playerid][HasTeamSelected] && GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) 
	{
	    ClassSel_HandleClassSelection(playerid);
	    return 1;
	}
	return 1;
}

YCMD:changeteam(playerid, params[], help)
{
	ForceClassSelection(playerid);
    TogglePlayerSpectating(playerid, true);
    TogglePlayerSpectating(playerid, false);
	
	PlayerInfo[playerid][HasTeamSelected] = 0;
	Group_SetPlayer(gPolice, playerid, false);
	Group_SetPlayer(gMafia, playerid, false);
	Group_SetPlayer(gCluckers, playerid, false);
	Group_SetPlayer(gVIP, playerid, false);
    return 1;
}