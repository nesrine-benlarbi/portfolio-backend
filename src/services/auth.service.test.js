import { describe, it, expect, vi } from "vitest";
import { loginUser } from "../services/auth.service.js";
import * as User from"../models/user.model.js";
import bcrypt from "bcrypt";
import AppError from "../errors/AppError.js";


vi.mock("../models/user.model.js");
process.env.JWT_SECRET = "secret_test";

describe("loginUser", () => {
    it("lance une AppError 401 si l'utilisateur n'existe pas", async () => {
        
        // Arrange
        User.findByEmail.mockResolvedValue(null); 
        
        //Act
        // Le service attend un objet { email, password } : passer deux arguments
        // positionnels faisait passer le test pour la mauvaise raison.
        const error = await loginUser({
            email: "inconnu@example.com",
            password: "password123",
        }).catch(e => e);
        
        //Assert
        expect(error).toBeInstanceOf(AppError);
        expect(error.status).toBe(401);
    });   

   it("lance une AppError 401 si le mot de passe est invalide", async () => {
    // Arrange
    const hashedPassword = bcrypt.hashSync("bon_password", 10);

      User.findByEmail.mockResolvedValue({
        id: 1,
        email: "john@example.com",
        role: "user",
        password: hashedPassword
    });

    // Act
    const error = await loginUser({
        email: "john@example.com",
        password: "mauvais_password"
    }).catch((e) => e);

    // Assert
    expect(error).toBeInstanceOf(AppError);
    expect(error.status).toBe(401);
});

    it("retourne un token JWT si les credentials sont valides", async () => {
    // Arrange
    const hashedPassword = bcrypt.hashSync("password123", 10);

    User.findByEmail.mockResolvedValue({
        id: 1,
        email: "john@example.com",
        role: "user",
        password: hashedPassword
    });

    // Act
    const token = await loginUser({
        email: "john@example.com",
        password: "password123"
    });

    // Assert
    expect(typeof token).toBe("string");
    expect(token.split(".")).toHaveLength(3); // format JWT
});
});