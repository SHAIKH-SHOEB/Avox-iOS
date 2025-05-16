//
//  CacheManager.swift
//  Avox
//
//  Created by Shaikh Shoeb on 06/10/24.
//

import UIKit

class CacheManager: NSObject {
    
    static let shared = CacheManager()
    
    private override init() {}
    
    private let cache = NSCache<NSString, AnyObject>()
    
    // Store data in cache
    func setObject<T: AnyObject>(_ object: T, forKey key: String) {
        cache.setObject(object, forKey: key as NSString)
    }
    
    // Retrieve data from cache
    func getObject<T: AnyObject>(forKey key: String) -> T? {
        return cache.object(forKey: key as NSString) as? T
    }
    
    // Remove data from cache
    func removeObject(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    // Clear the entire cache
    func clearCache() {
        cache.removeAllObjects()
    }
}
