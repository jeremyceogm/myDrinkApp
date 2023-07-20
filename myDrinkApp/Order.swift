//
//  Order.swift
//  DrinkApp
//
//  Created by Peter Pan on 2023/6/2.
//

import Foundation

//上傳資料用
struct OrderBody: Codable {
    let data: [Order]
}
//本來僅需
struct Order: Codable {
    let name: String
    let drink: String
    var size: String
    var iceLevel: String
    var sugarLevel: String
    var price: Int
}
