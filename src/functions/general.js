const crypto = require("crypto");

export const timestamp = () => {
   return Math.round(+new Date() / 1000);
};

export const uuid = () => {
   return crypto.randomUUID();
};
