//
//  ResourceDetailView.swift
//  Nano2-Nimbl
//
//  Created by Anselmus Pavel Adriska on 04/01/23.
//

import SwiftUI

struct ResourceDetailView: View {
    var mode: String
    var selectedResource: Resource
    @FocusState var titleTextFieldIsFocused: Bool
    @EnvironmentObject var resourceVM: ResourceViewModel
    
    var body: some View {
        Form {
            TextField("Title", text: $resourceVM.selectedResource.title)
                .focused($titleTextFieldIsFocused)
            
            TextEditor(text: $resourceVM.selectedResource.desc)
                .frame(height: UIScreen.main.bounds.height * 0.6)
        }
        .navigationTitle((mode == "Edit") ? "Edit Resource" : "New Resource")
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture {
            titleTextFieldIsFocused = false
        }
        .onAppear {
            resourceVM.setSelectedResource(as: selectedResource)
        }
        .onChange(of: resourceVM.selectedResource.title) { _ in
            resourceVM.updateResource()
        }
        .onChange(of: resourceVM.selectedResource.desc) { _ in
            resourceVM.updateResource()
        }
    }
}

//struct ResourceDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResourceDetailView()
//    }
//}
