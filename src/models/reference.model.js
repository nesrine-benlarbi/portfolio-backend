import pool from '../config/db.js';

/**
 * Accès aux deux tables de référence du modèle : `categories` et
 * `technologies`. Elles alimentent les listes proposées côté front-end.
 */

export const findAllCategories = async () => {
    const [rows] = await pool.query('SELECT id, name FROM categories ORDER BY name ASC');
    return rows;
};

export const findAllTechnologies = async () => {
    const [rows] = await pool.query('SELECT id, name FROM technologies ORDER BY name ASC');
    return rows;
};
