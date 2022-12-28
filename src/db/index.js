import mysql from "serverless-mysql";

const conn = mysql({
   config: {
      host: "localhost",
      port: 3306,
      database: "node",
      user: "root",
      password: "",
   },
});

export const db = async ({ query, values }) => {
   try {
      const results = await conn.query(query, values);
      await conn.end();
      return results;
   } catch (error) {
      console.log(error);
      throw { error };
   }
};

export const checkDbConnection = async () => {
   try {
      await db({ query: "SELECT 1" });
      console.log({ success: true, message: "[DB]: Connection established." });
   } catch (error) {
      console.log({ success: false, message: "[DB]: Connection failed." });
   }
};
