//
//  Recipe_Ingredientes+Extensions.swift
//  Cookyer
//
//  Created by Pablo Terradillos on 11/4/21.
//

import CoreData

extension Recipe_Ingredients {
    convenience init(context: NSManagedObjectContext, recipe: Recipe, ingredient: Ingredient, quantity: Int16, unit: String) {
        self.init(context: context)
        self.belongsToRecipe = recipe
        self.usesIngredient = ingredient
        self.quantity = quantity
        self.unit = unit
    }
}
