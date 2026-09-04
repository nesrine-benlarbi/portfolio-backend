import 'dotenv/config';
import express from 'express';
import cors from 'cors';

import errorHandler from './middlewares/errorHandler.js';
import authRoutes from './routes/auth.routes.js';
import contactRoutes from './routes/contact.routes.js';
import projectRoutes from './routes/project.routes.js';
import referenceRoutes from './routes/reference.routes.js';

const app = express();
const PORT = process.env.PORT || 3001;


app.use(
  cors({
    origin: process.env.CORS_ORIGIN,
    methods: ["GET", "POST", "PUT", "DELETE"],
    allowedHeaders: ["Content-Type", "Authorization"],
  })
);

app.use(express.json());

// Routes API
app.use('/api/auth', authRoutes);
app.use('/api/projects', projectRoutes);
app.use('/api/contact', contactRoutes);
app.use('/api', referenceRoutes); // /api/categories et /api/technologies

// Gestionnaire d'erreurs (toujours en dernier)
app.use(errorHandler);

// Lancement du serveur
app.listen(PORT, () => {
  console.log(`Serveur démarré sur http://localhost:${PORT}`);
});