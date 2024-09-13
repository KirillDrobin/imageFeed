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
    private var lastLoadedPage = 1
    
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
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["Photo": photos])
                
                for i in data {
                    photos.append(Photo(id: i.id,
                                        size: (CGSize(width: i.width, height: i.height)),
                                        createdAt: dateFormatter(date: i.createdAt),
                                        welcomeDescription: i.description,
                                        thumbImageURL: i.urls.thumb,
                                        largeImageURL: i.urls.full,
                                        isLiked: i.likedByUser
                                       )
                    )
                    print("Photos count: \(photos.count)")
                    print("LastLoadedPage: \(String(describing: lastLoadedPage))")
                }

                handler(.success(data))
                lastLoadedPage += 1

            case .failure(let error):
                print("Photo responce error")
                handler(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Bool, Error>) -> Void) {
        let oAuth2TokenStorage = OAuth2TokenStorage.shared
        guard let token = oAuth2TokenStorage.token
        else {
            preconditionFailure("Token for photo error")
        }
        
        guard let baseURL = Constants.defaultBaseURL
        else {
            preconditionFailure("Unable to construct baseURL for like responce")
        }
        guard let url = URL(
            string: "/photos/\(photoId)/like",
            relativeTo: baseURL
        ) else {
            preconditionFailure("Unable to construct url")
        }
        
        var request = URLRequest(url: url)
        
        if isLike == true {
            request.httpMethod = "POST"}
        else {
            request.httpMethod = "DELETE"
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("changeLike URL Request: \(request)")
             
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ChangeLike, Error>) in
            guard let self else { preconditionFailure("") }
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(id: photo.id,
                                             size: photo.size,
                                             createdAt: photo.createdAt,
                                             welcomeDescription: photo.welcomeDescription,
                                             thumbImageURL: photo.thumbImageURL,
                                             largeImageURL: photo.largeImageURL,
                                             isLiked: !photo.isLiked)
                        self.photos[index] = newPhoto
                    }
                    print("Change like success")
                }
            case .failure(_):
                print("Change like error")
            }
        }
        task.resume()
        return
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

private func dateFormatter(date: String) -> String {
    let dateFormatter = ISO8601DateFormatter()
    guard let date = dateFormatter.date(from: date)
    else {return ""}
    let dateFormatter2 = DateFormatter()
    dateFormatter2.dateStyle = .long
    dateFormatter2.timeStyle = .none
    dateFormatter2.locale = Locale(identifier: "ru_RU")
    let convertDate = dateFormatter2.string(from: date)
    return convertDate
}
