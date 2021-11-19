//
//  IngredientTag.swift
//  Cookyer
//
//  Created by Pablo Terradillos on 11/18/21.
//

import SwiftUI

struct IngredientTag: View {
    let ingredient: RecipeIngredients
    
    private let tagColor = Color(red: 209.0 / 255, green: 209.0 / 255, blue: 209.0 / 255, opacity: 0.5)

    
    var body: some View {
        HStack {
            Text("\(ingredient.quantity) \(ingredient.unitString)")
                .font(.body)
                .padding(5)
            Text(ingredient.ingredientName).fontWeight(.bold).padding(.trailing)
        }
        .background(tagColor)
        .cornerRadius(10.0)
    }
}

//struct IngredientTag_Previews: PreviewProvider {
//    static var previews: some View {
//        IngredientTag()
//    }
//}
