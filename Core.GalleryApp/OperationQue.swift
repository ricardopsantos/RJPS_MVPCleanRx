//
//  Created by Ricardo Santos on 27/08/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

public class OperationQueueManager {
    private init() {
        if operationQueue == nil {
            operationQueue = OperationQueue()
            operationQueue!.maxConcurrentOperationCount = 2
        }
    }
    private var operationQueue: OperationQueue?
    public static var shared = OperationQueueManager()

    func add(_ operation: Operation) {
        guard let operationQueue = operationQueue else {
            return
        }
        print("Adding operation \(operationQueue.operations.count): \(operation)")
        operationQueue.addOperations([operation], waitUntilFinished: false)
    }
}
