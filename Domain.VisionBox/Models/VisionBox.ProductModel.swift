//
//  ProductName.swift
//  Domain.VisionBox
//
//  Created by Ricardo Santos on 05/07/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import Domain

public extension VisionBox {
    // Put on domain
    struct ProductModel {
        public let name: String
        public let specification: String
        public let inventory: String
        public let price: String
        public let backgroundImage: String
        public let productImage: String
        public let category: VisionBox.Category
        public let `description`: String

        public var priceForCountry: String {
            return "\(price) €"
        }

        public static var  _mockData: [ProductModel] = []
        public static var mockData: [ProductModel] {
            if !_mockData.isEmpty {
                return _mockData
            }
            let numberOfRecords = VisionBox.Category.allCases.capacity * 10
            (0...numberOfRecords).forEach { (some) in
                let category = Int.random(in: VisionBox.Category.cat1.rawValue ... VisionBox.Category.cat9.rawValue)
                let product = ProductModel(name: "Product \(some)",
                    specification: "\(Int.random(in: 100 ... 300))",
                    inventory: "\(Int.random(in: 100 ... 500))",
                    price: "\(Int.random(in: 10 ... 20))",
                    backgroundImage: "back.1",
                    productImage: "product.\(Int.random(in: 1 ... 3))",
                    category: VisionBox.Category(rawValue: category)!,
                    description: "This is cool description for product \(some)")
                _mockData.append(product)
            }
            return _mockData
        }
    }
}
