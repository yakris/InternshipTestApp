//
//  DateFormatterHelper.swift
//  Internship
//
//  Created by Kristina Aleksiutina on 27.08.2023.
//

import Foundation

final class DateFormatterHelper {
    lazy var createdDate: DateFormatter = {
        return self.dateFormatter(with: "dd MMMM yyyy")
    }()
    
    lazy var createdDateFromBackend: DateFormatter = {
        return self.dateFormatter(with: "yyyy-MM-dd")
    }()

    func dateFormatter(with format: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = format

        return dateFormatter
    }
}

extension DateFormatter {
    func dateWithToday(_ date: Date) -> String {
        if Calendar.current.isDate(date, equalTo: Date(), toGranularity: .day) {
            return "Сегодня"
        } else if
            let tomorrowDate = (Calendar.current as NSCalendar).date(
                byAdding: .day,
                value: -1,
                to: Date(),
                options: []
            ),
            Calendar.current.isDate(date, equalTo: tomorrowDate, toGranularity: .day)
        {
            return "Вчера"
        } else {
            return string(from: date)
        }
    }
}
