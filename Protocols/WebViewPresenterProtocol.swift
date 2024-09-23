//
//  WebViewPresenterProtocol.swift
//  imageFeed
//
//  Created by Кирилл Дробин on 17.09.2024.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func code(from url: URL) -> String?
    func didUpdateProgressValue(_ newValue: Double)
}
