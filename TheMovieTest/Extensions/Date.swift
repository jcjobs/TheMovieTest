//
//  Date.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 10/10/22.
//

import Foundation

extension Date {
    private static let dateFormatter: DateFormatter = {
        return DateFormatter()
    }()
    
    init(dateString: String) {
        Date.dateFormatter.locale = Locale.current
        Date.dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedString = Date.dateFormatter.date(from: dateString)

        if let date = formattedString {
            self.init(timeInterval: 0, since: date)
        } else {
            self.init()
        }
    }
    
    func getFormatedDate() -> String {
        Date.dateFormatter.calendar = Calendar(identifier: .iso8601)
        Date.dateFormatter.locale = Locale.current
        Date.dateFormatter.timeZone = TimeZone.current
        Date.dateFormatter.dateFormat = "MMMM dd, yyyy"
        let dateISO = Date.dateFormatter.string(from: self)
        return dateISO
    }
}
