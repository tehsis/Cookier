//
//  Recipe_Ingredientes+Extensions.swift
//  Cookyer
//
//  Created by Pablo Terradillos on 11/4/21.
//

import CoreData

protocol RecipeIngredients {
    var unitString: String { get }
    var ingredientName: String { get }
    var quantity: Int16 { get }
}
            
class Recipe_Ingredients: NSManagedObject, Decodable, RecipeIngredients {
    // MARK: CoreData Helpers
    var unitString: String {
        unit ?? ""
    }
    
    
    var ingredientName: String {
        usesIngredient?.nameString ?? ""
    }
    
    enum codingKeys: CodingKey {
        case quantity, unit, RecipeId, IngredientId
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManageObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: codingKeys.self)
        self.quantity = try container.decode(Int16.self, forKey: .quantity)
        self.unit = try container.decode(String.self, forKey: .unit)
        self.recipeId = try container.decode(UUID.self, forKey: .RecipeId)
        self.ingredientId = try container.decode(UUID.self, forKey: .IngredientId)
        
    }
    
    convenience init(context: NSManagedObjectContext, recipe: Recipe, ingredient: Ingredient, quantity: Int16, unit: String, recipeID: UUID, ingredientID: UUID) {
        self.init(context: context)
        self.belongsToRecipe = recipe
        self.usesIngredient = ingredient
        self.quantity = quantity
        self.unit = unit
        self.recipeId = recipeID
        self.ingredientId = ingredientID
    }
}
