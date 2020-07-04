//
//  VisionBoxModels.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 04/07/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

public struct VisionBox {

}

extension VisionBox {
    // Put on domain
    public struct ProductModel {
        let name: String
        let specification: String
        let inventory: String
        let price: String
        let backgroundImage: String
        let productImage: String
        let category: VisionBox.Category

        var priceForCountry: String {
            return "\(price) €"
        }

        static var mockData: [ProductModel] {
            var products: [ProductModel] = []
            let numberOfRecords = VisionBox.Category.allCases.capacity * 5
            (0...numberOfRecords).forEach { (some) in
                let category = Int.random(in: VisionBox.Category.cat1.rawValue ... VisionBox.Category.cat9.rawValue)
                let product = ProductModel(name: "Product \(some)",
                    specification: "\(Int.random(in: 100 ... 300))",
                    inventory: "\(Int.random(in: 100 ... 500))",
                    price: "\(Int.random(in: 10 ... 20))",
                    backgroundImage: "back.\(Int.random(in: 1 ... 2))",
                    productImage: "product.\(Int.random(in: 1 ... 3))",
                    category: VisionBox.Category(rawValue: category)!)
                products.append(product)
            }
            return products
        }
    }
}

extension VisionBox {
    public enum Category: Int, CaseIterable {
        case cat1 = 10000
        case cat2
        case cat3
        case cat4
        case cat5
        case cat6
        case cat7
        case cat8
        case cat9

        var tag: Int {
            return self.rawValue
        }

        var toString: String {
            switch self {
            case .cat1: return "Cat1"
            case .cat2: return "Cat2"
            case .cat3: return "Cat3"
            case .cat4: return "Cat4"
            case .cat5: return "Cat5"
            case .cat6: return "Cat6"
            case .cat7: return "Cat7"
            case .cat8: return "Cat8"
            case .cat9: return "Cat9"
            }
        }

        var imageName: String {
            switch self {
            case .cat1: return "trash.fill"
            case .cat2: return "trash.fill"
            case .cat3: return "trash.fill"
            case .cat4: return "trash.fill"
            case .cat5: return "trash.fill"
            case .cat6: return "trash.fill"
            case .cat7: return "trash.fill"
            case .cat8: return "trash.fill"
            case .cat9: return "trash.fill"
            }
        }
    }
}
