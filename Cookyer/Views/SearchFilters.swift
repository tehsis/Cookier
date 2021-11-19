//
//  SearchFilters.swift
//  Cookyer
//
//  Created by Pablo Terradillos on 11/6/21.
//

import SwiftUI

struct SearchFilters: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \Ingredient.name, ascending: false)
    ], animation: .default) private var availableIngredients: FetchedResults<Ingredient>
    
    @Binding var selectedIngredients: [Ingredient]
    @Binding var shouldOnlyUseTheseIngredients: Bool

    @State var newFilter = ""
    
    var body: some View {
        NavigationView {
            Form {
                Toggle("Use Only these ingredients", isOn: $shouldOnlyUseTheseIngredients)
                TextField("Add a new filter", text: $newFilter).padding(0.0)
                if !newFilter.isEmpty {
                    ForEach(availableIngredients.filter(filter)) { ingredient in
                        HStack {
                            Text(ingredient.nameString).onTapGesture {
                                selectedIngredients.append(ingredient)
                            }
                            Spacer()
                            Button {
                                selectedIngredients.append(ingredient)
                            } label: {
                                Image(systemName: "plus.circle.fill")
                            }
                        }
                       
                    }
                }
                
                Section("Selected Filters") {
                    if selectedIngredients.isEmpty {
                        Text("No filters selected")
                    } else {
                        ForEach(selectedIngredients, id: \.self) { selectedIngredient in
                            Text(selectedIngredient.nameString)
                        }.onDelete { selectedIngredients.remove(atOffsets: $0) }
                    }
                }
                
            }.navigationTitle("Filters")
        }
       
        
    }
    
    func filter(_ ingredient: Ingredient) -> Bool {
        return ingredient.nameString.lowercased().contains(newFilter.lowercased())
        && !selectedIngredients.contains(ingredient)
    }
}

struct SearchFilters_Previews: PreviewProvider {
    static var previews: some View {
        SearchFilters(selectedIngredients: .constant([]), shouldOnlyUseTheseIngredients: .constant(false))
    }
}
