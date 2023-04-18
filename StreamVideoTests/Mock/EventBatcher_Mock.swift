//
// Copyright © 2023 Stream.io Inc. All rights reserved.
//

import Foundation
@testable import StreamVideo
import protocol StreamVideo.Timer

final class EventBatcher_Mock: EventBatcher {
    var currentBatch: [Event] = []

    let handler: (_ batch: [Event], _ completion: @escaping () -> Void) -> Void

    init(
        period: TimeInterval = 0,
        timerType: Timer.Type = DefaultTimer.self,
        handler: @escaping (_ batch: [Event], _ completion: @escaping () -> Void) -> Void
    ) {
        self.handler = handler
    }

    lazy var mock_append = MockFunc.mock(for: append)

    func append(_ event: Event) {
        mock_append.call(with: (event))

        handler([event]) {}
    }

    lazy var mock_processImmediately = MockFunc.mock(for: processImmediately)

    func processImmediately(completion: @escaping () -> Void) {
        mock_processImmediately.call(with: (completion))
    }
}
