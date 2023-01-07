//
//  Resource.swift
//  Nano2-Nimbl
//
//  Created by Anselmus Pavel Adriska on 04/01/23.
//

import Foundation

struct Resource: Identifiable {
    var id = UUID()
    var title: String
    var desc: String
    var updateTime: Date
}
