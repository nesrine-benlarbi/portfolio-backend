import * as userModel from "../models/user.model.js";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import AppError from "../errors/AppError.js";

export const loginUser = async ({ email, password }) => {
    // 1. On cherche l'utilisateur par son email
    const user = await userModel.findByEmail(email);

    // 2. Renvoie une erreur 401 si l'utilisateur n'existe pas
    if (!user) {
        throw new AppError('Identifiants invalides', 401);
    }

    // 3. Compare le mot de passe avec bcrypt.compare
    const isPasswordValid = await bcrypt.compare(password, user.password);

    // 4. Renvoie une erreur 401 si le mot de passe est incorrect
    if (!isPasswordValid) {
        throw new AppError('Identifiants invalides', 401);
    }

    // 5. Génère un JWT signé avec { id, email, role } dans le payload (durée : 24h)
    const payload = {
        id: user.id,
        email: user.email,
        role: user.role
    };

    const secret = process.env.JWT_SECRET;
    const options = { expiresIn: '24h' };
    const token = jwt.sign(payload, secret, options);

    // 6. Retourne le token
    return token;
};