import db from "../config/db.js";

export const findByEmail = async (email) => {
    const sql = "select * from users where email = ?";
    const [rows] = await db.query(sql, [email]);
    return rows[0] ?? null;
};

