//
//  ProfileLogoutService.swift
//  imageFeed
//
//  Created by Кирилл Дробин on 12.09.2024.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    // MARK: - Private Properties
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let splashViewController = SplashViewController.shared
    
    static let shared = ProfileLogoutService()
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Methods
    func logout() {
        oAuth2TokenStorage.token = nil
        cleanCookies()
        switchToSplashViewController()
     }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func switchToSplashViewController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        window.rootViewController = SplashViewController()
    }
}
