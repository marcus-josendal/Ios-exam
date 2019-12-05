//
//  Time.swift
//  PG5600_5031
//
//  Created by Marcus Jøsendal on 05/12/2019.
//  Copyright © 2019 Marcus Jøsendal. All rights reserved.
//

import Foundation

class Time {
    
    func convertToTimestamp(time: Int) -> String {
        let time = (minutes: (time / 1000) % 60, seconds: ((time / 1000) % 3600) / 60)
        var seconds = String(time.seconds)
        var minutes = String(time.minutes)
        if(time.seconds < 10) {
            seconds = "0" + seconds
        }
        
        if(time.minutes < 10) {
            minutes = "0" + minutes
        }
        
        return "(\(seconds):\(minutes))"
    }
    
}
