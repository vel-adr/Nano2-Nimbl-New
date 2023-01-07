//
//  ReflectionView.swift
//  Nano2-Nimbl
//
//  Created by Anselmus Pavel Adriska on 07/01/23.
//

import SwiftUI

struct ReflectionView: View {
    @StateObject var reflectVM: ReflectionViewModel = ReflectionViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                if reflectVM.reflections.count > 0 {
                    ForEach(reflectVM.reflections) { el in
                        NavigationLink {
                            ReflectionDetailView(mode: "Edit", selectedReflection: Reflection(id: el.id ?? UUID(), title: el.title ?? "", desc: el.desc ?? "", updateTime: el.updateTime ?? Date()))
                                .environmentObject(reflectVM)
                        } label: {
                            ListItemView(title: el.title ?? "" , date: el.updateTime?.formatted(.dateTime.day().month().year()) ?? Date().formatted(.dateTime.day().month().year()), description: el.desc ?? "")
                        }
                    }
                    .onDelete(perform: reflectVM.delete)
                } else {
                    Text("There are no reflection yet")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("My Reflection")
            .toolbar {
                NavigationLink {
                    ReflectionDetailView(mode: "Add", selectedReflection: Reflection(title: "", desc: "", updateTime: Date()))
                        .environmentObject(reflectVM)
                } label: {
                    Text("Add")
                }
            }
        }
        .onAppear {
            reflectVM.fetchReflection()
        }
    }
}

//struct ReflectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReflectionView()
//    }
//}
