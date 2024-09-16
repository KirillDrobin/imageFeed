//
//  UrlsResult.swift
//  imageFeed
//
//  Created by Кирилл Дробин on 02.09.2024.
//
import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
}
