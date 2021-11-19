//
//  RecipeTest.swift
//  CookyerTests
//
//  Created by Pablo Terradillos on 11/13/21.
//

import XCTest
@testable import Cookyer
import CoreData

class RecipeTest: XCTestCase {
    
    let recipeJSONString = """
      {
        "id":"70453d42-55bd-43aa-8fd6-174228162e21",
        "name":"Salmon with asparagus",
        "procedure":"foo",
        "Photos": [{"id":"4505afef-c0a2-41c7-be0e-61b961744e08","url":"addd8f12-6458-4751-84f2-72a664e11ff4.jpg"}],
        "Ingredients":[
            {
                "id":"fbbb95e2-41f8-4cea-88b1-425944becd8e",
                "name":"salmon",
                "RecipeIngredients": {
                    "quantity": 200,
                    "unit":"gr",
                    "RecipeId":"70453d42-55bd-43aa-8fd6-174228162e21",
                    "IngredientId":"fbbb95e2-41f8-4cea-88b1-425944becd8e"
            }
        }]
    }
"""
    
    let otherRecipeJSONString = """
      {
        "id":"70453d42-55bd-43aa-8fd6-174228162e22",
        "name":"Salmon with asparagus",
        "procedure":"foo",
        "Photos": [{"id":"4505afef-c0a2-41c7-be0e-61b961744e08","url":"addd8f12-6458-4751-84f2-72a664e11ff4.jpg"}],
        "Ingredients":[
            {
                "id":"fbbb95e2-41f8-4cea-88b1-425944becd8e",
                "name":"salmon",
                "RecipeIngredients": {
                    "quantity": 200,
                    "unit":"gr",
                    "RecipeId":"70453d42-55bd-43aa-8fd6-174228162e22",
                    "IngredientId":"fbbb95e2-41f8-4cea-88b1-425944becd8e"
            }
        }]
    }
"""
    
    let multipleRecipeJSONString = """
          [{
            "id":"70453d42-55bd-43aa-8fd6-174228162e22",
            "name":"Salmon with asparagus",
            "procedure":"foo",
            "Ingredients":[
                {
                    "id":"fbbb95e2-41f8-4cea-88b1-425944becd8f",
                    "name":"foobar",
                    "RecipeIngredients": {
                        "quantity": 200,
                        "unit":"gr",
                        "RecipeId":"70453d42-55bd-43aa-8fd6-174228162e22",
                        "IngredientId":"fbbb95e2-41f8-4cea-88b1-425944becd8f"
                }
            }]
        },
        {
            "id":"70453d42-55bd-43aa-8fd6-174228162e21",
            "name":"Salmon with cream",
            "procedure":"foo",
            "Ingredients":[
                {
                    "id":"70453d42-55bd-43aa-8fd6-174228162e21",
                    "name":"foobar",
                    "RecipeIngredients": {
                        "quantity": 200,
                        "unit":"gr",
                        "RecipeId":"70453d42-55bd-43aa-8fd6-174228162e21",
                        "IngredientId":"fbbb95e2-41f8-4cea-88b1-425944becd8f"
                }
            }]
        }]
    """
    
    let ingredientJSONString = """
       {"id":"fbbb95e2-41f8-4cea-88b1-425944becd8e","name":"salmon","createdAt":"2021-11-12T15:17:18.260Z","updatedAt":"2021-11-12T15:17:18.260Z"}
"""
    
    let photoJSONString = """
        {"id":"4505afef-c0a2-41c7-be0e-61b961744e08","url":"addd8f12-6458-4751-84f2-72a664e11ff4.jpg"}
"""
    
    let RecipeIngredientsJSONString = """
        {
            "quantity":200,
            "unit":"gr",
            "RecipeId":"70453d42-55bd-43aa-8fd6-174228162e21",
            "IngredientId":"fbbb95e2-41f8-4cea-88b1-425944becd8e"
        }
"""
    
    var context: NSManagedObjectContext!
    var persistentController: PersistenceController!
    var decoder: JSONDecoder!

    override func setUpWithError() throws {
        persistentController = PersistenceController.preview
        context = persistentController.container.viewContext
        decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = context

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testIngredientDecoder() throws {
        let ingredient = try decoder.decode(Ingredient.self, from: ingredientJSONString.data(using: .utf8)!)
        assert(ingredient.id!.uuidString == "fbbb95e2-41f8-4cea-88b1-425944becd8e".uppercased())
        assert(ingredient.name == "salmon")
    }
    
    func testPhotoDecoder() throws {
        let photo = try decoder.decode(Photo.self, from: photoJSONString.data(using: .utf8)!)
        assert(photo.id?.uuidString == "4505afef-c0a2-41c7-be0e-61b961744e08".uppercased())
        assert(photo.url! == URL.init(string: "addd8f12-6458-4751-84f2-72a664e11ff4.jpg"))
    }
    
    func testRecipeIngredients() throws {
        let recipeIngredients = try decoder.decode(Recipe_Ingredients.self, from: RecipeIngredientsJSONString.data(using: .utf8)!)
        assert(recipeIngredients.quantity == 200)
        assert(recipeIngredients.unit == "gr")
        assert(recipeIngredients.recipeId!.uuidString == "70453d42-55bd-43aa-8fd6-174228162e21".uppercased())
        assert(recipeIngredients.ingredientId!.uuidString == "fbbb95e2-41f8-4cea-88b1-425944becd8e".uppercased())
    }
    
    func testRecipeDecoder() throws {
        let recipe = try decoder.decode(Recipe.self, from: recipeJSONString.data(using: .utf8)!)
        assert(recipe.nameString == "Salmon with asparagus")
        assert(recipe.id!.uuidString == "70453d42-55bd-43aa-8fd6-174228162e21".uppercased())
        assert(recipe.procedure == "foo")
        recipe.ingredientsSet.forEach { ingredient in
            assert(ingredient.quantity == 200)
            assert(ingredient.ingredientName == "salmon")
        }
        
        recipe.photosSet.forEach { photo in
            assert(photo.url! == URL.init(string: "addd8f12-6458-4751-84f2-72a664e11ff4.jpg"))
        }
    }
    
    func testMultipleRecipeDecoder() async throws {
        let recipes = try decoder.decode([Recipe].self, from: multipleRecipeJSONString.data(using: .utf8)!)
        assert(recipes.count == 2)
        
        // merge policies acts on save
        try! context.save()
        
        // I get a new context to make sure elements are not duplicated
        let newContext = persistentController.container.newBackgroundContext()
        
        try! await newContext.perform {
            let ingredientsRequest = Ingredient.fetchRequest()
            let ingredients = try newContext.fetch(ingredientsRequest)
            let salmonIngredients = ingredients.filter { ingredient in
                ingredient.id?.uuidString == "fbbb95e2-41f8-4cea-88b1-425944becd8f".uppercased()
            }
            
            assert(salmonIngredients.count == 1)
        }
    }
    
    func testSameRecipeMultipleInserts() async throws {
        // I'm using a different container so it doesn't collide with the rest of the tests.
        let newContainer =  PersistenceController(inMemory: true)
        let newContext = newContainer.container.viewContext
        let newDecoder = JSONDecoder()
        newDecoder.userInfo[CodingUserInfoKey.managedObjectContext] = newContext
        
        let _ = try newDecoder.decode(Recipe.self, from: recipeJSONString.data(using: .utf8)!)
        let _ = try newDecoder.decode(Recipe.self, from: otherRecipeJSONString.data(using: .utf8)!)
        
        try! newContext.save()
        
        try! await newContext.perform {
            let recipesRequest = Recipe.fetchRequest()
            let recipes = try newContext.fetch(recipesRequest)
            
            assert(recipes.count == 1)
            
            let recipeIngredientsRequest = Recipe_Ingredients.fetchRequest()
            let recipeIngredients = try newContext.fetch(recipeIngredientsRequest)
            
            assert(recipeIngredients.count == 1)
        }
        
    }

}
