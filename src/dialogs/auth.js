import {
   OnPlayerConnect,
   DIALOG_STYLE,
   ShowPlayerDialog,
   OnDialogResponse,
   SendClientMessage,
   GetPlayerName,
   Kick,
} from "samp-node-lib";
import {
   LOGIN_DIALOG,
   REGISTER_DIALOG,
   REGISTER_VALIDATION_DIALOG,
   LOGIN_VALIDATION_DIALOG,
} from "../consts/dialogs";
import { db } from "../db";
import { isEmpty, uuid, timestamp } from "../functions";

// REGISTER_DIALOG
const showRegisterDialog = (id) => {
   ShowPlayerDialog(
      id,
      REGISTER_DIALOG,
      DIALOG_STYLE.INPUT,
      "Register",
      "Welcome to our server! \n\nthis account is not registered yet. \n\nPlease provide a password to register.",
      "Register",
      "Quit"
   );
};

// LOGIN_DIALOG
const showLoginDialog = (id) => {
   ShowPlayerDialog(
      id,
      LOGIN_DIALOG,
      DIALOG_STYLE.INPUT,
      "Login",
      "Welcome back!\n\nWe miss you here!\n\nPlease login to get your stats back!",
      "Login",
      "Quit"
   );
};

// VALIDATION_DIALOG
const showRegisterValidationDialog = ({ id, title, message }) => {
   ShowPlayerDialog(
      id,
      REGISTER_VALIDATION_DIALOG,
      DIALOG_STYLE.MSGBOX,
      title,
      message,
      "Okay",
      ""
   );
};

const showLoginValidationDialog = ({ id, title, message }) => {
   ShowPlayerDialog(
      id,
      LOGIN_VALIDATION_DIALOG,
      DIALOG_STYLE.MSGBOX,
      title,
      message,
      "Okay",
      ""
   );
};

OnPlayerConnect(async ({ playerid: id }) => {
   // Check if player is registered
   // if not, show REGISTER_DIALOG
   // else show LOGIN_DIALOG

   const username = GetPlayerName(id, 20);

   const query = `SELECT * FROM players WHERE username = ?`;
   const values = [username];
   const isRegistered = await db({ query: query, values: values });

   if (isEmpty(isRegistered)) {
      // Send message that player isn't registered.
      SendClientMessage(
         id,
         "rgb(234, 85, 74)",
         `[AUTH] You don't have an account yet. Please register one now!`
      );

      // REGISTER_DIALOG
      showRegisterDialog(id);
      return;
   }

   SendClientMessage(
      id,
      "rgb(0, 150, 136)",
      `Welcome back ${username}. Please login.`
   );

   showLoginDialog(id);
});

OnDialogResponse(
   async ({ playerid: id }, dialogid, response, listitem, inputtext) => {
      if (dialogid === REGISTER_DIALOG) {
         if (!response) {
            Kick(id);
         }

         if (response) {
            // empty
            if (isEmpty(inputtext)) {
               showRegisterValidationDialog({
                  id: id,
                  title: "Error",
                  message: "Password is required",
               });
               return;
            }

            // 6 characters
            if (!isEmpty(inputtext) && inputtext.length < 6) {
               showRegisterValidationDialog({
                  id: id,
                  title: "Error",
                  message: "Password must contain at least 6 characters.",
               });
               return;
            }

            const username = GetPlayerName(id, 20);
            const query = "INSERT INTO players VALUES (?, ?, ?, ?, ?)";
            const values = [
               uuid(),
               username,
               inputtext,
               timestamp(),
               timestamp(),
            ];
            await db({ query: query, values: values });

            SendClientMessage(
               id,
               "rgb(0, 150, 136)",
               "You have successfully registered. Welcome to our community!"
            );
         }
      }

      if (dialogid === REGISTER_VALIDATION_DIALOG) {
         if (response || !response) {
            showRegisterDialog(id);
         }
      }

      if (dialogid === LOGIN_DIALOG) {
         if (!response) {
            showLoginDialog(id);
            return;
         }

         if (response) {
            // if empty password
            if (isEmpty(inputtext)) {
               showLoginValidationDialog({
                  id: id,
                  title: "Error",
                  message: "Password is a required field.",
               });
               return;
            }

            const player = await db({
               query: "SELECT * FROM players WHERE username = ?",
               values: [GetPlayerName(id, 20)],
            });

            if (player[0].password !== inputtext) {
               showLoginValidationDialog({
                  id: id,
                  title: "Error",
                  message: "Invalid password.",
               });
               return;
            }
         }
      }

      if (dialogid === LOGIN_VALIDATION_DIALOG) {
         if (response || !response) {
            showLoginDialog(id);
         }
      }
   }
);
