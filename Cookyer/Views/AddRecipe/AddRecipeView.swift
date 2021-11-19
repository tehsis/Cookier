//
//  AddRecipe.swift
//  Cookyer
//
//  Created by Pablo Terradillos on 11/17/21.
//

import SwiftUI

struct AddRecipe: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject private var vm = AddRecipeViewModel()
   
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Recipe name", text: $vm.newRecipeName, prompt: Text("New recipe name"))
            
            if vm.newPhoto.cgImage == nil && vm.newPhoto.ciImage == nil {
                ZStack {
                    Image(systemName: "camera").font(.largeTitle)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .border(.black)
                }.onTapGesture(perform: vm.takePicture)
              
                   
            } else {
                Image(uiImage: vm.newPhoto)
                    .resizable()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .border(.black)
                    .onTapGesture(perform: vm.takePicture)
            }
           
                
            
            Text("Ingredients").font(.headline)
            HStack {
                TextField("Ingredient", text: $vm.newIngredient.ingredientName, prompt: Text("New Ingredient"))
                TextField("Quantity", text: $vm.quantityString, prompt: Text("Quantity")).keyboardType(.numberPad)
                TextField("Ingredient", text: $vm.newIngredient.unitString, prompt: Text("Unit"))
                Button(action: vm.addNewIngredient) { Text("Add") }
            }
            
            ForEach(vm.ingredients, id: \.self) { ingredient in
                IngredientTag(ingredient: ingredient)
            }
         
            Text("Procedure").font(.headline)
          
            TextEditor(text: $vm.newProcedure)
        }.confirmationDialog("Take a Photo", isPresented: $vm.shouldPresentSourceDialog) {
            Button {
                vm.isShowingCamera = true
            } label: {
                Text("Camera")
            }
            
            Button {
                vm.isShowingLibrary = true
            } label: {
                Text("Photo Library")
            }
        }.sheet(isPresented: $vm.isShowingCamera, onDismiss: { }) {
            ImagePicker(sourceType: .camera, selectedImage: $vm.newPhoto)
        }.sheet(isPresented: $vm.isShowingLibrary, onDismiss: { }) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $vm.newPhoto)
        }
        .padding()
        .navigationTitle("New Recipe")
        .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Add") {
                    $vm.uploadRecipe()
                }
            }
    }
}

struct AddRecipe_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddRecipe()
        }
    }
}
