//
//  DailyStatusBarView.swift
//  Nano2-Nimbl
//
//  Created by Anselmus Pavel Adriska on 07/01/23.
//

import SwiftUI

struct DailyStatusBarView: View {
    @EnvironmentObject var logBookVM: LogBookViewModel
    @EnvironmentObject var resourceVM: ResourceViewModel
    @EnvironmentObject var reflectionVM: ReflectionViewModel
    
    var body: some View {
        HStack(alignment: .bottom) {
            Spacer()
            
            VStack(spacing: 8) {
                Image(systemName: (logBookVM.todayLogBook.desc != "") ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.title)
                    .foregroundColor((logBookVM.todayLogBook.desc != "") ? .green : .red)
                Text("Log Book")
                    .font(.caption2)
                    .fontWeight(.medium)
            }
            .padding()
            
            Group {
                Spacer()
                Divider()
                Spacer()
            }
            
            VStack(spacing: 8) {
                Text("\(resourceVM.getTodayResourceCount())")
                    .font(.title)
                    .bold()
                Text("Resource")
                    .font(.caption2)
                    .fontWeight(.medium)
            }
            .padding()
            
            Group {
                Spacer()
                Divider()
                Spacer()
            }
            
            VStack(spacing: 8) {
                Text("\(reflectionVM.getTodayReflectionCount())")
                    .font(.title)
                    .bold()
                Text("Reflections")
                    .font(.caption2)
                    .fontWeight(.medium)
            }
            .padding()
            
            Spacer()
        }
        .frame(height: 80)
        .background(.white)
        .cornerRadius(8)
        .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 0, y: 4)
    }
}

struct DailyStatusBarView_Previews: PreviewProvider {
    static var previews: some View {
        DailyStatusBarView()
    }
}
