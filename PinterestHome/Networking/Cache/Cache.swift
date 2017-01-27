//
//  Cache.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 26/01/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import Foundation




public protocol CacheItemType {
    var data: Data { get }
    var sizeInKB: Int { get }
    var storeTimeStamp: TimeInterval { get }
    var key: String { get }
    
    init?(httpResponse: HTTPResponse)
}

struct CacheItem: CacheItemType {
    var data: Data
    var key: String
    var storeTimeStamp: TimeInterval
    
    var sizeInKB: Int {
        return self.data.count / 1024
    }
    
    init(data: Data, key: String) {
        self.data = data
        self.key = key
        self.storeTimeStamp = Date().timeIntervalSince1970
    }
    
    init?(httpResponse: HTTPResponse) {
        
        guard let urlPath = httpResponse.originalRequest?.url?.absoluteString,
        let data = httpResponse.data else {
            return nil
        }
        self.init(data: data, key: urlPath)
    }
}


public protocol MemoryCache {
    var maxSizeKB: Int { get set}
    var currentSize: Int { get }
    var isFull: Bool { get }
    mutating func purge()
    subscript(key: String) -> CacheItemType? { get set }
    
}

struct OnMemoryCache: MemoryCache {
    
    public var isFull: Bool {
        return currentSize >= maxSizeKB
    }
    
    static let shared = OnMemoryCache(maxSizeInKB: Constants.Cache.MaxSizeInKB)
    public var maxSizeKB: Int
    public var currentSize: Int = 0
    private var cacheDictionary: [String : CacheItemType] = [:]
    private var allCachedItems : [CacheItemType] {
        return cacheDictionary.flatMap({$0 as? CacheItemType})
    }
    
    private init(maxSizeInKB: Int) {
        self.maxSizeKB = maxSizeInKB
    }
    
    subscript(key: String) -> CacheItemType? {
        get {
            guard let item = cacheDictionary[key] else {
                debugPrint("Cache Miss")
                return nil
            }
            debugPrint("Cache Hit")
            return item
        }
        set {
            guard let item = newValue else { return }
            // Check for overflow
            if currentSize + item.sizeInKB > maxSizeKB {
                // handle overflow 
                purgeByMinimumMemory(minMemoryToPurge: item.sizeInKB)
                
            } else {
                // Save in memory cache
                currentSize += item.sizeInKB
                cacheDictionary[item.key] = item
                debugPrint("Current Cache Size in KB = \(currentSize)")
            }
        }
    }
    
    
    mutating func purge(){
        cacheDictionary = [:]
    }
    
    // MARK: PRIVATE HELPERS
    private mutating func purgeByMinimumMemory(minMemoryToPurge: Int) {
        // 1. Sort all cached items in decending order for the stored timestamp
        let sortedItems = allCachedItems.sorted(by: { (item1, item2) -> Bool in
            return item1.storeTimeStamp < item2.storeTimeStamp
        })
        // Removing minimum items to place this new item in the array

        var memoryPurged = 0
        for item in sortedItems {
            memoryPurged += item.sizeInKB
            self.cacheDictionary[item.key] = nil
            if memoryPurged > minMemoryToPurge { break }
        }
    }

}
