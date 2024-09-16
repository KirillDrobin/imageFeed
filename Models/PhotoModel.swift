//
//  Untitled 2.swift
//  imageFeed
//
//  Created by Кирилл Дробин on 15.09.2024.
//
import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
}
