//
//  IceLevel.swift
//  DrinkApp
//
//  Created by Peter Pan on 2023/6/2.
//

import Foundation
//CaseIterable 可將enum做成array
//搭配allCases使用
enum IceLevel: String, CaseIterable {
    case noIce = "去冰"
    case littleIce = "微冰"
}
