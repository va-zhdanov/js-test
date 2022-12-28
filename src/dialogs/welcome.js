import {
   OnPlayerConnect,
   DIALOG_STYLE,
   ShowPlayerDialog,
   OnDialogResponse,
   SendClientMessage,
} from "samp-node-lib";
import { WELCOME_DIALOG, WHY_DIALOG } from "../consts/dialogs";

OnPlayerConnect(({ playerid: id }) => {
   // Show WELCOME_DIALOG
   ShowPlayerDialog(
      id,
      WELCOME_DIALOG,
      DIALOG_STYLE.MSGBOX,
      "Welcome",
      "Welcome to the shitty server",
      "Yes",
      "No"
   );
});

OnDialogResponse(({ playerid: id }, dialogid, response) => {
   if (dialogid === WELCOME_DIALOG) {
      // if NO pressed
      if (!response) {
         SendClientMessage(id, "rgb(255, 41, 41)", "Pressed no");

         // Show WHY DIALOG
         ShowPlayerDialog(
            id,
            WHY_DIALOG,
            DIALOG_STYLE.MSGBOX,
            "No?",
            "Did you press no?",
            "Yes",
            ""
         );
      }

      // if YES pressed
      if (response) {
         SendClientMessage(id, "rgb(41, 255, 65)", "Pressed yes");
      }
   }
});
