import Foundation
import UIKit
import SwiftSignalKit
import TelegramCore

fileprivate func utcFormatter() -> DateFormatter {
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
                    if let datetimeString = jsonObject["datetime"] as? String {
                        if let datetime = utcFormatter().date(from: "2000-11-15T00:04:12.085136+03:00") {
                            subscriber.putNext(datetime)
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


