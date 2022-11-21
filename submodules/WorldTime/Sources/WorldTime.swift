import Foundation
import UIKit
import SwiftSignalKit
import TelegramCore

public func fetchMoscowTime() -> Signal<Int32, NoError> {
    return Signal { subscriber in

        let disposable = MetaDisposable()
        disposable.set(fetchHttpResource(url: "http://worldtimeapi.org/api/timezone/Europe/Moscow").start(next: { next in
            if case let .dataPart(_, data, _, complete) = next, complete {
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let timestamp = jsonObject["unixtime"] as? Int32 {
                        subscriber.putNext(timestamp)
                        subscriber.putCompletion()
                    }
                }
            }
        }))

        return ActionDisposable {
            disposable.dispose()
        }
    }
}
