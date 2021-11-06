//
//  RecipeView.swift
//  Cookyer
//
//  Created by Pablo Terradillos on 11/4/21.
//

import SwiftUI

struct RecipeView: View {
    
    let recipe: Recipe
    
    var procedureAttributedString: AttributedString {
        try! AttributedString(markdown: recipe.procedureString)
    }
    
    var ingredientsStrings: [String] {
        
        let ingredientsArray: [Recipe_Ingredients] = recipe.hasManyIngredients!.allObjects as! [Recipe_Ingredients]
        
        let ingredientsString = ingredientsArray.map {
            "* \($0.usesIngredient!.name!) \($0.quantity) - \($0.unit!)"
        }
        
        return ingredientsString
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(recipe.nameString.replacingOccurrences(of: " ", with: "-"), bundle: .main)
                .resizable()
              
            Text("Ingredients")
                .font(.title)

            ForEach(ingredientsStrings, id: \.self) { ingredient in
                Text(ingredient).padding(.leading)
            }
            
            Text("Procedure")
                .font(.title)
            Text(procedureAttributedString).font(.body)
        }.navigationTitle(recipe.name!
)
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
       // RecipeView()
        Text("hi")
    }
}
