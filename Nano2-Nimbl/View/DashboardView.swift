//
//  DashboardView.swift
//  Nano2-Nimbl
//
//  Created by Anselmus Pavel Adriska on 07/01/23.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var logBookVM: LogBookViewModel
    @EnvironmentObject var resourceVM: ResourceViewModel
    @EnvironmentObject var reflectionVM: ReflectionViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Rectangle()
                        .fill(Color("RectangleBg"))
                        .frame(maxHeight: UIScreen.main.bounds.height/4.5)
                        .cornerRadius(20)
                        .ignoresSafeArea()
                    
                    Spacer()
                }
                
                VStack(spacing: 16) {
                    Group {
                        //Date & Title
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("\(Date.now.formatted(.dateTime.day().month().year()))")
                                    .font(.headline)
                                Text("Today's Activity:")
                                    .font(.title2)
                                    .bold()
                            }
                            Spacer()
                        }
                        DailyStatusBarView()
                    }
                    .padding(.horizontal)
                    .zIndex(3)
                    
                    
                    List {
                        //Today's log book section
                        Section {
                            if logBookVM.todayLogBook.desc == "" {
                                Text("Today's log book is still empty")
                                    .foregroundColor(.secondary)
                                    .font(.footnote)
                            } else {
                                Text(logBookVM.todayLogBook.desc)
                                    .font(.footnote)
                            }
                        } header: {
                            Text("Today's Log Book")
                        }
                        .headerProminence(.increased)
                        
                        //Resource section
                        Section {
                            if resourceVM.getRecentResources().count > 0 {
                                ForEach(resourceVM.getRecentResources()) { el in
                                    NavigationLink {
                                        ResourceDetailView(mode: "Edit", selectedResource: el)
                                    } label: {
                                        ListItemView(title: el.title, date: el.updateTime.formatted(.dateTime.day().month().year()), description: el.desc)
                                    }
                                }
                            } else {
                                Text("There are no resource yet")
                                    .foregroundColor(.secondary)
                                    .font(.footnote)
                            }
                        } header: {
                            Text("Recent Resource")
                        }
                        .headerProminence(.increased)
                        
                        Section {
                            if reflectionVM.getRecentReflections().count > 0 {
                                ForEach(reflectionVM.getRecentReflections()) { el in
                                    NavigationLink {
                                        ReflectionDetailView(mode: "Edit", selectedReflection: el)
                                    } label: {
                                        ListItemView(title: el.title, date: el.updateTime.formatted(.dateTime.day().month().year()), description: el.desc)
                                    }
                                }
                            } else {
                                Text("There are no reflection yet")
                                    .foregroundColor(.secondary)
                                    .font(.footnote)
                            }
                        } header: {
                            Text("Recent Reflection")
                        }
                        .headerProminence(.increased)
                    }
                    .listStyle(.insetGrouped)
                    .padding(.top, -12)
                }
                .padding(.top)
            }
            .background(Color("BgColor"))
            .navigationBarHidden(true)
        }
        .onAppear {
            resourceVM.fetchResource()
            reflectionVM.fetchReflection()
        }
    }
}

//struct DashboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        DashboardView()
//    }
//}
