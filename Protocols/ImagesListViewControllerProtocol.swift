//
//  ImagesListViewControllerProtocol.swift
//  imageFeed
//
//  Created by Кирилл Дробин on 22.09.2024.
//

import Foundation

protocol ImageListViewControllerProtocol: AnyObject {
    var presenter: ImageListPresenterProtocol? { get set }

}
