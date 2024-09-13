//
//  ImagesListCellDelegate.swift
//  imageFeed
//
//  Created by Кирилл Дробин on 10.09.2024.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
