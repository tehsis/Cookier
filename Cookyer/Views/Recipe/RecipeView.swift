//
//  RecipeView.swift
//  Cookyer
//
//  Created by Pablo Terradillos on 11/4/21.
//

import SwiftUI

struct RecipeView: View {
    
    let recipe: Recipe
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var vm = RecipeViewModel()
    
    let gradient = Gradient(colors: [.black.opacity(0), .white.opacity(1)])
    
    init(recipe: Recipe?) {
        if let recipe = recipe {
            self.recipe = recipe
        } else {
            self.recipe = Recipe(context: PersistenceController.preview.container.viewContext, name: "test", procedure: "test test")
        }
    }
    
    var procedureAttributedString: AttributedString {
        try! AttributedString(markdown: recipe.procedureString)
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottomTrailing) {
                if let photo = recipe.photosSet.first?.photoUrlCDN {
                    AsyncImage(url: photo) { image in
                        image.resizable().onAppear {
                            recipe.cachedImage = image
                        }
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Image("Spaghetti-Carbonara", bundle: .main)
                        .resizable()
                }
                

               
       
            }
           
            Text("Ingredients")
                .font(.headline)
                .padding()
            
            ForEach(recipe.ingredientsSet) { IngredientTag(ingredient: $0) }.padding(.leading)
            
            Text("Procedure")
                .font(.headline)
                .padding()
            Text(procedureAttributedString)
                .font(.custom("test", size: 15))
                .padding()

        }.navigationTitle(recipe.nameString).navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: vm.showActivityView) {
                    Image(systemName: "square.and.arrow.up")
                }.background(ActivityView(isPresented: $vm.showingActivityView, data: ["Recipe for: \(recipe.nameString)", "Ingredients",recipe.ingredientsString, "Procedure", recipe.procedureString, "Check this recipe on Cookier!"]))
            }
    }
}

struct RecipeView_Previews: PreviewProvider {
    
    static let moc = PersistenceController.preview.container.viewContext
    
    static var previews: some View {
        let recipe = Recipe(context: moc, name: "Test", procedure: "test test")
        let ingredients = Ingredient(context: moc, id: UUID(), name: "garlic")
        let recipeIngredient = Recipe_Ingredients(context: moc, recipe: recipe, ingredient: ingredients, quantity: 6, unit: "kg", recipeID: recipe.id!, ingredientID: ingredients.id!)
        
        recipe.addToHasManyIngredients(recipeIngredient)
        return  NavigationView {
            RecipeView(recipe: recipe)
        }
    }
}
