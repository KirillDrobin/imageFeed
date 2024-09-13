//
//  UrlsResult.swift
//  imageFeed
//
//  Created by Кирилл Дробин on 02.09.2024.
//

import Foundation
import UIKit

struct PhotoResult: Codable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
}

struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct ChangeLike: Codable {
    let photo: LikeResult
}

struct LikeResult: Codable {
    let likedByUser: Bool
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: String
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
}
