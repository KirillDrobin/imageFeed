//
//  ImagesListService.swift
//  imageFeed
//
//  Created by Кирилл Дробин on 02.09.2024.
//

import Foundation

final class ImagesListService {
    private(set) var photos: [Photo] = []
    private var task: URLSessionTask?
    private var lastLoadedPage = 0
    
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceProviderDidChange")
    
    func fetchPhotosNextPage(handler: @escaping (Result<[PhotoResult], any Error>) -> Void) {
        
        if task != nil {
            task?.cancel()
        }
        
        guard let photoRequest = makePhotoRequest(page: lastLoadedPage),
              task == nil
        else {
            print("Photo request error")
            return
        }
        
        let task = URLSession.shared.objectTask(for: photoRequest) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { preconditionFailure("") }
            self.task = nil
            switch result {
            case .success(let data):
                for i in data {
                    photos.append(Photo(id: i.id,
                                        size: (CGSize(width: i.width, height: i.height)),
                                        createdAt: dateConverter(date: i.createdAt),
                                        welcomeDescription: i.description,
                                        thumbImageURL: i.urls.thumb,
                                        largeImageURL: i.urls.full,
                                        isLiked: i.likedByUser
                                       )
                    )
                    print("\(photos.count)")
                    print("\(String(describing: lastLoadedPage))")
                }
                handler(.success(data))
                lastLoadedPage += 1
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["Photo": photos])
            case .failure(let error):
                print("Photo responce error")
                handler(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}

// MARK: - makePhotoRequest private func
private func makePhotoRequest(page: Int) -> URLRequest? {
    
    let oAuth2TokenStorage = OAuth2TokenStorage.shared
    
    guard let baseURL = Constants.defaultBaseURL
    else {
        preconditionFailure("Unable to construct baseURL")
    }
    guard let url = URL(
        string: "/photos?page=\(page)",
        relativeTo: baseURL
    ) else {
        preconditionFailure("Unable to construct url")
    }
    
    guard let token = oAuth2TokenStorage.token
    else {
        preconditionFailure("Token for photo error")
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    print("Photo URL Request: \(request)")
    return request
}

private func dateConverter(date: String) -> Date? {
    let dateFormatter = DateFormatter()
    let dateConvert = dateFormatter.date (from: date)
    return dateConvert
}
