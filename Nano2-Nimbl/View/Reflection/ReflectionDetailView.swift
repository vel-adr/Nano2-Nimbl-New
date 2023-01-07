//
//  ReflectionDetailView.swift
//  Nano2-Nimbl
//
//  Created by Anselmus Pavel Adriska on 07/01/23.
//

import SwiftUI

struct ReflectionDetailView: View {
    var mode: String
    var selectedReflection: Reflection
    @FocusState var titleTextFieldIsFocused: Bool
    @EnvironmentObject var reflectVM: ReflectionViewModel
    
    var body: some View {
        Form {
            TextField("Title", text: $reflectVM.selectedReflection.title)
                .focused($titleTextFieldIsFocused)
            
            TextEditor(text: $reflectVM.selectedReflection.desc)
                .frame(height: UIScreen.main.bounds.height * 0.6)
        }
        .navigationTitle((mode == "Edit") ? "Edit Reflection" : "New Reflection")
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture {
            titleTextFieldIsFocused = false
        }
        .onAppear {
            reflectVM.setSelectedReflection(as: selectedReflection)
        }
        .onChange(of: reflectVM.selectedReflection.title) { _ in
            reflectVM.updateReflection()
        }
        .onChange(of: reflectVM.selectedReflection.desc) { _ in
            reflectVM.updateReflection()
        }
    }
}

//struct ReflectionDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReflectionDetailView()
//    }
//}
