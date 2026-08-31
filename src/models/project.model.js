import pool from '../config/db.js';

/**
 * Récupère tous les projets de la base de données
 * triés du plus récent au plus ancien (Uniquement ceux non supprimés)
 */
export const findAll = async () => {
    // OPTIMISATION : On demande directement à MySQL de filtrer les projets actifs
    const [rows] = await pool.query('SELECT * FROM projects WHERE deleted_at IS NULL ORDER BY created_at DESC');
    return rows;
};

export const findById = async (id) => {
    // OPTIMISATION : On s'assure qu'on ne puisse pas récupérer un projet archivé par son ID
    const [rows] = await pool.query('SELECT * FROM projects WHERE id = ? AND deleted_at IS NULL', [id]);
    return rows[0] || null;
};

export const create = async (data, userId) => {
    const { title, description, tech_stack, github_url, demo_url, image_url } = data;

    // user_id provient du token JWT (administrateur connecté), jamais du corps de la requête
    const [result] = await pool.query(
        'INSERT INTO projects (user_id, title, description, tech_stack, github_url, demo_url, image_url) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [userId, title, description, tech_stack, github_url, demo_url, image_url]
    );

    return await findById(result.insertId);
};

export const update = async (id, data) => {
  const { title, description, tech_stack, github_url, demo_url, image_url } = data;
  
  await pool.query(
    'UPDATE projects SET title=?, description=?, tech_stack=?, github_url=?, demo_url=?, image_url=? WHERE id=? AND deleted_at IS NULL',
    [title, description, tech_stack, github_url, demo_url, image_url, id]
  );

  return await findById(id);
};

/**
 * MODIFIÉ : Réalise un Soft Delete (Suppression douce)
 * Met à jour la colonne deleted_at avec la date actuelle au lieu de détruire la ligne
 */
export const remove = async (id) => {
  // On utilise NOW() de MySQL, c'est ultra rapide et performant
  const [result] = await pool.query('UPDATE projects SET deleted_at = NOW() WHERE id = ?', [id]);
  
  // Retourne true si le projet a bien été trouvé et mis à jour
  return result.affectedRows > 0;
};