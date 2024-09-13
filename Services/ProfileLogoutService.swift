//
//  ProfileLogoutService.swift
//  imageFeed
//
//  Created by Кирилл Дробин on 12.09.2024.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let imagesListService = ImagesListService.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    
    static let shared = ProfileLogoutService()
    
    private init() {}
    
    func logout() {
        cleanCookies()
        cleanProfile()
    }
    
    private func cleanCookies() {
        // Очищаем все куки из хранилища
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    private func cleanProfile() {
        oAuth2TokenStorage.token = " "
    }
}
