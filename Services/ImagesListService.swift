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
    private var lastLoadedPage: Int?
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceProviderDidChange")
    
    func fetchPhotosNextPage(handler: @escaping (Result<UrlsResult, any Error>) -> Void) {
        
        if photos .isEmpty {
            lastLoadedPage? = 1
        } else {
            lastLoadedPage? += 1
        }
        
        guard let photoRequest = makePhotoRequest(page: lastLoadedPage ?? 1),
              task == nil
        else {
            print("Photo request error")
            return
        }
        
        let task = URLSession.shared.objectTask(for: photoRequest) { [weak self] (result: Result<UrlsResult, Error>) in
            guard let self else { preconditionFailure("") }
            self.task = nil
            switch result {
            case .success(let data):
                photos.append(Photo(id: data.id,
                                    size: (CGSize(width: data.width, height: data.height)),
                                    createdAt: dateConverter(date: data.createdAt),
                                    welcomeDescription: data.description,
                                    thumbImageURL: data.urls["thumb"] ?? "",
                                    largeImageURL: data.urls["full"] ?? "",
                                    isLiked: data.likedByUser))
                handler(.success(data))
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
    guard let baseURL = Constants.defaultBaseURL
    else {
        preconditionFailure("Unable to construct baseURL")
    }
    guard let url = URL(
        string: "/photos?per_page=10, page=\(page)",
        relativeTo: baseURL
    ) else {
        preconditionFailure("Unable to construct url")
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    print("Photo URL Request: \(request)")
    return request
}

private func dateConverter(date: String) -> Date? {
    let dateFormatter = DateFormatter()
    let dateConvert = dateFormatter.date (from: date)
    return dateConvert
}
