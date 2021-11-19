//
//  Persistence.swift
//  Cookyer
//.
//  Created by Pablo Terradillos on 11/3/21.
//

import CoreData


struct PersistenceController {
    static let shared = PersistenceController()
    
    static var recipes: [Recipe]?

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        recipes = [
            Recipe(context: viewContext, name: "Salmon con hongos", procedure: "Corta el salmon"),
            Recipe(context: viewContext, name: "Spaghetti Carbonara", procedure: "Ponele crema  ")
        ]
        
        let ingredients = [
            Ingredient(context: viewContext, name: "Salmon"),
            Ingredient(context: viewContext, name: "Spaghetti"),
            Ingredient(context: viewContext, name: "Guancialle"),
            Ingredient(context: viewContext, name: "Egg"),
            Ingredient(context: viewContext, name: "Parmigiano Cheese")
        ]
        
        let recipe_ingredients = [
            Recipe_Ingredients(context: viewContext, recipe: recipes![1], ingredient: ingredients[1], quantity: 100, unit: "gr", recipeID: recipes![1].id ?? UUID(), ingredientID: ingredients[1].id ?? UUID()),
            Recipe_Ingredients(context: viewContext, recipe: recipes![1], ingredient: ingredients[2], quantity: 10, unit: "gr", recipeID: recipes![1].id ?? UUID(), ingredientID: ingredients[1].id ?? UUID()),
            Recipe_Ingredients(context: viewContext, recipe: recipes![1], ingredient: ingredients[3], quantity: 100, unit: "unit", recipeID: recipes![1].id ?? UUID(), ingredientID: ingredients[1].id ?? UUID()),
            Recipe_Ingredients(context: viewContext, recipe: recipes![1], ingredient: ingredients[4], quantity: 20, unit: "gr", recipeID: recipes![1].id ?? UUID(), ingredientID: ingredients[1].id ?? UUID())
        ]
            
            recipes![1].addToHasManyIngredients(recipe_ingredients[0])
            recipes![1].addToHasManyIngredients(recipe_ingredients[1])
            recipes![1].addToHasManyIngredients(recipe_ingredients[2])
            recipes![1].addToHasManyIngredients(recipe_ingredients[3])

        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Cookyer")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
            print(storeDescription.url!)
        })
    }
}

