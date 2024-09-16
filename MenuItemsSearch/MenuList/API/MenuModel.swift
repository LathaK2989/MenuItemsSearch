//
//  MenuModel.swift
//  ReceipeSearch
//
//  Created by Srilatha on 2024-09-13.
//

import Foundation

struct MenuModel: Codable {
    var name: String
    var coverImgUrl: URL
    var deliveryFee: Int
    var description: String
}
