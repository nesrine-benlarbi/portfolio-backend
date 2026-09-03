import * as referenceModel from '../models/reference.model.js';

/**
 * Listes de référence consultées par le formulaire d'administration
 * et par les filtres du site. Lecture seule et publiques : elles ne
 * contiennent aucune donnée sensible.
 */

export const getCategories = async (req, res, next) => {
    try {
        res.json(await referenceModel.findAllCategories());
    } catch (error) {
        next(error);
    }
};

export const getTechnologies = async (req, res, next) => {
    try {
        res.json(await referenceModel.findAllTechnologies());
    } catch (error) {
        next(error);
    }
};
