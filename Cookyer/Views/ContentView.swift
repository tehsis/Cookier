//
//  ContentView.swift
//  Cookyer
//
//  Created by Pablo Terradillos on 11/3/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \Recipe.name, ascending: false)
    ], animation: .default) private var recipes: FetchedResults<Recipe>
    
    @State var showingSearch = false
    @State var recipeIndex = 0
    @State var viewingRecipe = false
    @State var selectedFilters: [String] = []
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: RecipeView(recipe: recipes[recipeIndex]), isActive: $viewingRecipe) { EmptyView() }
                
                HStack {
                    if selectedFilters.isEmpty {
                        Text("No filter selected")
                    } else {
                        Text(selectedFilters.joined(separator: " "))
                    }
                    Image(systemName: "magnifyingglass")
                }
                .onTapGesture {
                    showingSearch = true
                }
                .sheet(isPresented: $showingSearch, onDismiss: {}) {
                    SearchFilters(selectedFilters: $selectedFilters)
                }
              
                RecipeSelector(recipe: recipes[recipeIndex], onAccept: {
                    recipeIndex = recipeIndex + 1
                    
                    if recipeIndex >= recipes.count {
                        recipeIndex = 0
                    }
                }, onRecipeSelected: {
                    self.viewingRecipe = true
                })
            }.statusBar(hidden: false)
        }
    }
}

struct RecipeSelector: View {
    let recipe: Recipe
    
    let onAccept: () -> ()
    let onRecipeSelected: () -> ()
    
    private let gradient = Gradient(colors: [Color.black.opacity(0), Color.black.opacity(0.5)])
    
    
    var body: some View {
        VStack {
            ZStack {
                Image(recipe.name!.replacingOccurrences(of: " ", with: "-"), bundle: .main)
                    .resizable(resizingMode: .stretch)
                    .cornerRadius(8)
                   
                    LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom)                    .onTapGesture(perform: onRecipeSelected)

                    VStack(alignment: .leading) {
                        Spacer()
                        Text(recipe.name!)
                            .foregroundColor(.white)
                            .font(.largeTitle)
                    }
            }
            HStack {
                Spacer()
                Image("cancel-icon", bundle: .main)
                Spacer()
                Image("accept-icon", bundle: .main).onTapGesture(perform: onAccept)
                Spacer()
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
