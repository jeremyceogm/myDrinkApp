//
//  struct.swift
//  myDrinkApp
//
//  Created by Jeremy on 2023/6/2.
//

import Foundation

//https://raw.githubusercontent.com/PeterPanSwift/JSON_API/main/Milksha.json

struct Menu:Codable{
    let category:String
    let drinks:[Drink]
}

struct Drink:Codable{
    let name:String
    let info:DrinkInfo
}

struct DrinkInfo:Codable{
    let m:Int
    let l:Int?
    
    //打enum co會跳出來 //打co也有 //要有:Codable
    //僅讀json時改字用
    enum CodingKeys:String, CodingKey {
        case m = "M"
        case l = "L"
    }
    
}


//註冊/登入共用
//https://favqs.com/api

struct LoginRegisterBody:Codable{
   let user:UserBody
}
struct UserBody:Codable{
    let login:String
    var email:String?
    let password:String
}

//註冊/登入成功時回傳 //登入接收回傳值有少沒關係？ //可以少不能多 因共用故捨棄email
struct LoginRegisterResponse:Codable{
    let token:String
    let login: String
    
    enum CodingKeys:String, CodingKey {
        case token = "User-Token"
        case login
    }
}


//註冊/登入錯誤時回傳
struct ErrorRespose:Codable{
    let errorCode:Int
    let message:String
}
