//
//  ContentView.swift
//  Cookyer
//
//  Created by Pablo Terradillos on 11/3/21.
//

import SwiftUI
import CoreData

struct RecipeList: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \Recipe.name, ascending: false)
    ], animation: .default) private var recipes: FetchedResults<Recipe>
    
    private var recipesArray: [Recipe] {
        recipes.map { $0 }
    }
    
    @StateObject private var vm = RecipeListViewModel()

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: AddRecipe(), isActive: $vm.addRecipeActive) { EmptyView() }
                
                Filter(selectedFilters: $vm.selectedFilters).onTapGesture(perform: vm.showSearch)
                    .sheet(isPresented: $vm.showingSearch,onDismiss: { vm.updateFilter(recipes: recipesArray) }) {
                        SearchFilters(selectedIngredients: $vm.selectedFilters,
                                      shouldOnlyUseTheseIngredients: $vm.shouldOnlyUseTheseIngredients)
                    }

                if $vm.filteredRecipes.isEmpty {
                    Spacer()
                    Text("No recipes found!")
                    Spacer()
                } else {
                    NavigationLink(destination: RecipeView(recipe: vm.currentRecipe), isActive: $vm.viewingRecipe) { EmptyView() }
                    RecipeSelector(recipe: vm.currentRecipe, onAccept: vm.moveToNextRecipe, onRecipeSelected: vm.showRecipe)
                }
        }
        .statusBar(hidden: false)
        .toolbar {
            Button(action: {
                vm.addRecipeActive = true
            }) {
                Image(systemName: "plus")
            }
        }
           
    }.onAppear(perform: { vm.updateFilter(recipes: recipesArray) } )
            
            
    }
}

struct Filter: View {
    @Binding var selectedFilters: [Ingredient]
    
    var body: some View {
        HStack {
            if selectedFilters.isEmpty {
                Text("No filter selected")
            } else {
                Text(selectedFilters.map({ $0.nameString }).joined(separator: " "))
            }
            Image(systemName: "magnifyingglass")
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
            ZStack(alignment: .leading) {
                if let photo = recipe.photosSet.first?.photoUrlCDN {
                    AsyncImage(url: photo) { image in
                        image
                            .resizable(resizingMode: .stretch)
                            .cornerRadius(8)
                            .shadow(color: .black, radius: 5, x: 5, y: 5)
                            .padding()
                        } placeholder: {
                            ProgressView()
                        }
                }
               
                   
                LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom)                    .onTapGesture(perform: onRecipeSelected).cornerRadius(8).padding()

                    VStack(alignment: .leading) {
                        Spacer()
                        Text(recipe.nameString)
                            .foregroundColor(.white)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .padding()
                    }.padding()
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
        RecipeList().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
