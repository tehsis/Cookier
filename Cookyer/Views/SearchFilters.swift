//
//  SearchFilters.swift
//  Cookyer
//
//  Created by Pablo Terradillos on 11/6/21.
//

import SwiftUI

struct SearchFilters: View {
    
    @Binding var selectedFilters: [String]
    
    @State var newFilter = ""
    
    var body: some View {
        VStack {
            TextField("Add a new filter", text: $newFilter).padding(0.0)
            Button("Add") {
                if newFilter != "" {
                    selectedFilters.append(newFilter)
                    newFilter = ""
                }
            }
            if selectedFilters.isEmpty {
                Text("No filters selected")
            } else {
                ForEach(selectedFilters, id: \.self) { filter in
                    Text(filter)
                }
            }
        }
        
    }
}

struct SearchFilters_Previews: PreviewProvider {
    static var previews: some View {
        SearchFilters(selectedFilters: .constant([]))
    }
}
