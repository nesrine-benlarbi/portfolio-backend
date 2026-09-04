import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import mysql from 'mysql2/promise';

/**
 * Import ponctuel du schéma et des données de référence.
 *
 * Cette fonction n'est exécutée que si la variable d'environnement
 * SEED_ON_BOOT vaut exactement "true". Elle sert à initialiser une base
 * distante à laquelle on n'a pas d'accès direct — un hébergeur peut
 * bloquer le port MySQL sortant, alors que le serveur applicatif, lui,
 * l'atteint sans difficulté.
 *
 * ATTENTION : le fichier importé recrée les tables. Toute donnée
 * existante est perdue. La variable doit donc être retirée aussitôt
 * après le premier démarrage réussi.
 */
export const importerSchema = async () => {
  if (process.env.SEED_ON_BOOT !== 'true') return;

  const ici = path.dirname(fileURLToPath(import.meta.url));
  const fichier = path.join(ici, '..', 'db', 'portfolio_db.sql');

  if (!fs.existsSync(fichier)) {
    console.error('[seed] fichier introuvable :', fichier);
    return;
  }

  console.log('[seed] import demandé — connexion à la base…');

  let conn;
  try {
    conn = await mysql.createConnection({
      host: process.env.DB_HOST,
      port: process.env.DB_PORT,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
      ssl: { rejectUnauthorized: false },
      multipleStatements: true,
    });

    await conn.query(fs.readFileSync(fichier, 'utf8'));

    const [tables] = await conn.query(
      'SELECT COUNT(*) n FROM information_schema.TABLES WHERE TABLE_SCHEMA = ?',
      [process.env.DB_NAME]
    );
    const [projets] = await conn.query('SELECT COUNT(*) n FROM projects');

    console.log('[seed] import terminé : ' + tables[0].n + ' tables, ' + projets[0].n + ' projets.');
    console.log('[seed] RETIRER MAINTENANT la variable SEED_ON_BOOT pour ne pas réimporter au prochain démarrage.');
  } catch (error) {
    console.error('[seed] échec :', error.code || error.message);
  } finally {
    if (conn) await conn.end();
  }
};
