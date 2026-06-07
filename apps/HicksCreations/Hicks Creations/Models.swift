//
//  Models.swift
//  Hicks Creations
//
//  Created by Mark Hicks on 1/3/26.
//

import Foundation

struct StoreCollection: Identifiable {
    let id: String
    let title: String
    let handle: String
}

struct Product: Identifiable {
    let id: String
    let title: String
    let price: String
    let imageURL: URL?
}


