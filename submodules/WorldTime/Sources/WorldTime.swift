import Foundation
import UIKit
import SwiftSignalKit
import TelegramCore

fileprivate func iso8601Formatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
    return formatter
}

public func fetchMoscowTime() -> Signal<Date, NoError> {
    return Signal { subscriber in

        let disposable = MetaDisposable()
        disposable.set(fetchHttpResource(url: "http://worldtimeapi.org/api/timezone/Europe/Moscow").start(next: { next in
            if case let .dataPart(_, data, _, complete) = next, complete {
                // JSON(data: data) fails to produce parsed instance
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let datetimeString = jsonObject["datetime"] as? String,
                       let timezoneString = jsonObject["timezone"] as? String {
                        if let utcDatetime = iso8601Formatter().date(from: datetimeString),
                           let timeZone = TimeZone(identifier: timezoneString) {
                            let localDate = utcDatetime.addingTimeInterval(TimeInterval(timeZone.secondsFromGMT()))
                            subscriber.putNext(localDate)
                        }
                    }
                }
                subscriber.putCompletion()
            }
        }))

        return ActionDisposable {
            disposable.dispose()
        }
    }
}


