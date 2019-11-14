//
//  Throttle.swift
//  BookSearchLibrary
//
//  Created by K Y on 11/14/19.
//  Copyright © 2019 Consultant. All rights reserved.
//

import Foundation

struct Throttle {
    var timer: Timer?
    let work: (Timer)->Void     // any function to do that work
    let interval: TimeInterval  // amount of time needed to before work is performed
    
    init(timeInterval: TimeInterval, _ work: @escaping ()->Void) {
        self.work = { _ in work() }
        self.interval = timeInterval
    }
    
    mutating func start() {
        timer = Timer.scheduledTimer(withTimeInterval: interval,
                                     repeats: false,
                                     block: work)
    }
    
    func cancel() {
        timer?.invalidate()
    }
    
    
}
