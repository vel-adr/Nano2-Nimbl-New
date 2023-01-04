//
//  LogBookView.swift
//  Nano2-Nimbl
//
//  Created by Anselmus Pavel Adriska on 04/01/23.
//

import SwiftUI

struct LogBookView: View {
    @EnvironmentObject var logBookVM: LogBookViewModel
    
    var body: some View {
        Form {
            Section {
                DatePicker("tes123", selection: $logBookVM.selectedDate, displayedComponents: .date)
                    .onChange(of: logBookVM.selectedDate, perform: { _ in
                        print(logBookVM.selectedDate)
                        logBookVM.setLogBookForSelectedDate()
                    })
                    .datePickerStyle(.graphical)
                    .labelsHidden()
            }
            Section {
                TextEditor(text: $logBookVM.selectedLogBook.description)
                    .frame(height: 200)
                    .onChange(of: logBookVM.selectedLogBook.description) { _ in
                        logBookVM.update()
                        print("LogBook Updated")
                    }
            } header: {
                Text("Activity")
            }
        }
    }
}

struct LogBookView_Previews: PreviewProvider {
    static var previews: some View {
        LogBookView()
    }
}
