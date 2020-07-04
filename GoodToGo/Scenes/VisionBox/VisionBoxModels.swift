//
//  VisionBoxModels.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 04/07/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

// Put on domain
struct ProductModel {
    let name: String
    let specification: String
    let inventory: String
    let price: String
    let backgroundImage: String
    let productImage: String

    static var mockData: [ProductModel] {
       let products = [
            ProductModel(name: "1 Thor", specification: "Boston", inventory: "astronomy", price: "astronomy", backgroundImage: "back1", productImage: "honey"),
            ProductModel(name: "1 Thor", specification: "Boston", inventory: "astronomy", price: "astronomy", backgroundImage: "back1", productImage: "honey"),
            ProductModel(name: "1 Thor", specification: "Boston", inventory: "astronomy", price: "astronomy", backgroundImage: "back1", productImage: "honey"),
            ProductModel(name: "1 Thor", specification: "Boston", inventory: "astronomy", price: "astronomy", backgroundImage: "back1", productImage: "honey"),
            ProductModel(name: "1 Thor", specification: "Boston", inventory: "astronomy", price: "astronomy", backgroundImage: "back1", productImage: "honey"),
            ProductModel(name: "1 Thor", specification: "Boston", inventory: "astronomy", price: "astronomy", backgroundImage: "back1", productImage: "honey"),
            ProductModel(name: "1 Thor", specification: "Boston", inventory: "astronomy", price: "astronomy", backgroundImage: "back1", productImage: "honey")
        ]
        return products
    }
}
