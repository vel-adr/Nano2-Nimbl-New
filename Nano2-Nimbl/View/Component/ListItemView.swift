//
//  ListItemView.swift
//  Nano2-Nimbl
//
//  Created by Anselmus Pavel Adriska on 04/01/23.
//

import SwiftUI

struct ListItemView: View {
    var title: String
    var date: String
    var description: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .firstTextBaseline) {
                    Text(title)
                        .fontWeight(.semibold)
                    Text(date)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                Text(description)
                    .font(.caption)
                    .lineLimit(1)
            }
            
            Spacer()
        }
    }
}

//struct ListItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListItemView()
//    }
//}
