import pool from '../config/db.js';

/**
 * Requête de lecture commune à findAll et findById.
 *
 * Trois jointures :
 *  - `categories` pour récupérer le libellé de la catégorie (association 1─N) ;
 *  - `project_technologies` puis `technologies` pour l'association N─N.
 *
 * GROUP_CONCAT rassemble les technologies d'un projet en une seule chaîne,
 * ce qui évite de renvoyer une ligne par technologie. Le séparateur `||`
 * est utilisé plutôt que la virgule, car un nom de technologie pourrait
 * lui-même en contenir une.
 */
const SELECT_PROJECT = `
  SELECT p.id, p.user_id, p.category_id, p.title, p.description,
         p.github_url, p.demo_url, p.image_url,
         p.created_at, p.updated_at, p.deleted_at,
         c.name AS category,
         GROUP_CONCAT(t.name ORDER BY t.name SEPARATOR '||') AS technologies
  FROM projects p
  LEFT JOIN categories c            ON c.id = p.category_id
  LEFT JOIN project_technologies pt ON pt.project_id = p.id
  LEFT JOIN technologies t          ON t.id = pt.technology_id
`;

/**
 * Transforme la chaîne renvoyée par GROUP_CONCAT en véritable tableau,
 * pour que le front-end n'ait plus à découper quoi que ce soit.
 */
const hydrate = (row) => ({
    ...row,
    technologies: row.technologies ? row.technologies.split('||') : [],
});

/**
 * Récupère tous les projets non archivés, du plus récent au plus ancien.
 */
export const findAll = async () => {
    const [rows] = await pool.query(
        `${SELECT_PROJECT}
         WHERE p.deleted_at IS NULL
         GROUP BY p.id, c.name
         ORDER BY p.created_at DESC`
    );
    return rows.map(hydrate);
};

/**
 * Récupère un projet actif par son identifiant.
 */
export const findById = async (id) => {
    const [rows] = await pool.query(
        `${SELECT_PROJECT}
         WHERE p.id = ? AND p.deleted_at IS NULL
         GROUP BY p.id, c.name`,
        [id]
    );
    return rows.length ? hydrate(rows[0]) : null;
};

/**
 * Retrouve une catégorie par son nom, et la crée si elle n'existe pas encore.
 *
 * Même principe que pour les technologies : l'administratrice saisit un
 * libellé, et la base se charge du reste. `INSERT IGNORE` s'appuie sur la
 * contrainte d'unicité de `categories.name` pour ne jamais créer de doublon.
 * C'est ce qui permet de gérer tout le contenu du portfolio depuis
 * l'interface, sans jamais écrire de SQL.
 *
 * @returns {number|null} l'identifiant de la catégorie, ou null si aucune
 */
const resolveCategory = async (conn, name) => {
    if (!name) return null;

    await conn.query('INSERT IGNORE INTO categories (name) VALUES (?)', [name]);
    const [rows] = await conn.query('SELECT id FROM categories WHERE name = ?', [name]);

    return rows.length ? rows[0].id : null;
};

/**
 * Met à jour les technologies liées à un projet.
 *
 * On efface d'abord les liaisons existantes, puis on recrée l'ensemble :
 * c'est plus simple et plus sûr que de calculer les différences, et le
 * volume concerné est de quelques lignes.
 *
 * Les technologies inconnues sont créées à la volée : `INSERT IGNORE`
 * s'appuie sur la contrainte d'unicité de `technologies.name` pour ne
 * jamais créer de doublon.
 *
 * @param {object} conn  connexion de la transaction en cours
 */
const syncTechnologies = async (conn, projectId, names) => {
    await conn.query('DELETE FROM project_technologies WHERE project_id = ?', [projectId]);

    if (!names || names.length === 0) return;

    for (const name of names) {
        await conn.query('INSERT IGNORE INTO technologies (name) VALUES (?)', [name]);
    }

    await conn.query(
        `INSERT INTO project_technologies (project_id, technology_id)
         SELECT ?, id FROM technologies WHERE name IN (?)`,
        [projectId, names]
    );
};

/**
 * Crée un projet et ses liaisons dans une transaction.
 *
 * La transaction garantit qu'un projet ne peut pas être enregistré sans
 * ses technologies : si l'écriture de la liaison échoue, l'insertion du
 * projet est annulée elle aussi.
 */
export const create = async (data, userId) => {
    const { category, title, description, github_url, demo_url, image_url, technologies } = data;

    const conn = await pool.getConnection();
    try {
        await conn.beginTransaction();

        const categoryId = await resolveCategory(conn, category);

        // user_id provient du token JWT (administrateur connecté), jamais du corps de la requête
        const [result] = await conn.query(
            `INSERT INTO projects (user_id, category_id, title, description, github_url, demo_url, image_url)
             VALUES (?, ?, ?, ?, ?, ?, ?)`,
            [userId, categoryId, title, description ?? null,
             github_url ?? null, demo_url ?? null, image_url ?? null]
        );

        await syncTechnologies(conn, result.insertId, technologies);
        await conn.commit();

        return await findById(result.insertId);
    } catch (error) {
        await conn.rollback();
        throw error;
    } finally {
        conn.release();
    }
};

/**
 * Met à jour un projet existant et ses liaisons, dans une transaction.
 */
export const update = async (id, data) => {
    const { category, title, description, github_url, demo_url, image_url, technologies } = data;

    const conn = await pool.getConnection();
    try {
        await conn.beginTransaction();

        const categoryId = await resolveCategory(conn, category);

        await conn.query(
            `UPDATE projects
             SET category_id = ?, title = ?, description = ?,
                 github_url = ?, demo_url = ?, image_url = ?
             WHERE id = ? AND deleted_at IS NULL`,
            [categoryId, title, description ?? null,
             github_url ?? null, demo_url ?? null, image_url ?? null, id]
        );

        await syncTechnologies(conn, id, technologies);
        await conn.commit();

        return await findById(id);
    } catch (error) {
        await conn.rollback();
        throw error;
    } finally {
        conn.release();
    }
};

/**
 * Réalise un Soft Delete (Suppression douce)
 * Met à jour la colonne deleted_at avec la date actuelle au lieu de détruire la ligne.
 * Les liaisons `project_technologies` sont conservées : le projet étant
 * seulement archivé, il doit pouvoir être restauré tel quel.
 */
export const remove = async (id) => {
    const [result] = await pool.query('UPDATE projects SET deleted_at = NOW() WHERE id = ?', [id]);
    return result.affectedRows > 0;
};
