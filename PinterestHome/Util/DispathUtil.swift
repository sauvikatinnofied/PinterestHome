//
//  DispathUtil.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 27/01/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import Foundation

/// Class to handle all Utility (Common and Quite Often) tasks associated qith DispathQueues
class DispatchUtil {
    
    
    /// Dispatches a closure on a queue (default main) asynchronously after certain time
    ///
    /// - Parameters:
    ///   - seconds: How many seconds to be delayed before the block is executed
    ///   - queue: The queue on which block will be executed *(Default one is Global Main Queue)*
    ///   - block: The closure to be executed
    class func dispathAfter(seconds: Double,
                            queue: DispatchQueue = DispatchQueue.main,
                            block:@escaping () -> Void ) {
        
        queue.asyncAfter(deadline: .now() + seconds, execute: block)
    }
}
