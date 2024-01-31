//
//  String+Extension.swift
//  TMDBMovies
//
//  Created by Mohamed Ramadan on 31/01/2024.
//

import Foundation

extension String {
    func getYear() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: self) else {
            return nil
        }

        formatter.dateFormat = "yyyy"
        return formatter.string(from: date)
    }
}
