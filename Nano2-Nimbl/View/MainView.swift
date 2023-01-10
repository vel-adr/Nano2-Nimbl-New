//
//  MainView.swift
//  Nano2-Nimbl
//
//  Created by Anselmus Pavel Adriska on 09/01/23.
//

import SwiftUI

struct MainView: View {
    @State var selection = 0
    @StateObject var logBookVM: LogBookViewModel = LogBookViewModel()
    @StateObject var resourceVM: ResourceViewModel = ResourceViewModel()
    @StateObject var reflectionVM: ReflectionViewModel = ReflectionViewModel()
    
    var body: some View {
        TabView(selection: $selection) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
                .tag(0)
            
            LogBookView()
                .tabItem {
                    Label("Log Book", systemImage: "calendar")
                }
                .tag(1)
            
            ResourceView()
                .tabItem {
                    Label("My Resource", systemImage: "link")
                }
                .tag(2)
            
            ReflectionView()
                .tabItem {
                    Label("My Reflection", systemImage: "heart.text.square.fill")
                }
                .tag(3)
        }
        .environmentObject(logBookVM)
        .environmentObject(resourceVM)
        .environmentObject(reflectionVM)
    }
}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
