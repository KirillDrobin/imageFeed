//
//  DateFormatter.swift
//  imageFeed
//
//  Created by Кирилл Дробин on 21.09.2024.
//

import Foundation

class ImageListDateFormatterService {
    
    lazy var dateFormatter: DateFormatter = { //
        let date = DateFormatter()
        date.dateFormat = "dd MMMM yyyy"
        date.locale = Locale(identifier: "ru_RU")
        return date
    }()
}
