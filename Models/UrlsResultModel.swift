//
//  UrlsResult.swift
//  imageFeed
//
//  Created by Кирилл Дробин on 02.09.2024.
//

import Foundation
import UIKit

struct UrlsResult: Codable {
    let id: String
    let createdAt: String
    let updatedAt: String
    let width: Int
    let height: Int
    let color: String
    let blurHash: String
    let likes: Int
    let likedByUser: Bool
    let description: String
    let user: String?
    let urls: Dictionary<String, String>
}

//struct Urls: Codable {
//    let raw: String
//    let full: String
//    let regular: String
//    let small: String
//    let thumb: String
//}
