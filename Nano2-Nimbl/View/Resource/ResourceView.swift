//
//  ResourceView.swift
//  Nano2-Nimbl
//
//  Created by Anselmus Pavel Adriska on 04/01/23.
//

import SwiftUI

struct ResourceView: View {
    @StateObject var resourceVM: ResourceViewModel = ResourceViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                if resourceVM.resources.count > 0 {
                    ForEach(resourceVM.resources) { el in
                        NavigationLink {
                            ResourceDetailView(mode: "Edit", selectedResource: Resource(id: el.id ?? UUID(), title: el.title ?? "", desc: el.desc ?? "", updateTime: el.updateTime ?? Date()))
                                .environmentObject(resourceVM)
                        } label: {
                            ListItemView(title: el.title ?? "" , date: el.updateTime?.formatted(.dateTime.day().month().year()) ?? Date().formatted(.dateTime.day().month().year()), description: el.desc ?? "")
                        }
                    }
                    .onDelete(perform: resourceVM.delete)
                } else {
                    Text("There are no resource yet")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("My Resource")
            .toolbar {
                NavigationLink {
                    ResourceDetailView(mode: "Add", selectedResource: Resource(title: "", desc: "", updateTime: Date()))
                        .environmentObject(resourceVM)
                } label: {
                    Text("Add")
                }
            }
        }
        .onAppear {
            resourceVM.fetchResource()
        }
    }
}

//struct ResourceView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResourceView(resourceVM: <#ResourceViewModel#>)
//    }
//}
