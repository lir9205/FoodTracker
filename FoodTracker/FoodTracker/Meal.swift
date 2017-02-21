//
//  Meal.swift
//  FoodTracer
//
//  Created by 李芮 on 17/2/20.
//  Copyright © 2017年 7feel. All rights reserved.
//

import UIKit

class Meal: NSObject, NSCoding {
    //MARK:- Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    //Archiving Paths
    
    static let DocumentDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains:.UserDomainMask).first!
    static let ArchiveUrl = DocumentDirectory.URLByAppendingPathComponent("meals")
    
    //MARK:- Types
    
    struct PropertyType {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    //MARK:- Initialization
    
    init?(name: String, photo: UIImage?, rating: Int){
        
        guard !name.isEmpty else {
            return nil
        }
        
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.rating = rating
        
    }
    
    //MARK:- NSCoder
    //持久化数据
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyType.name)
        aCoder.encodeObject(photo, forKey: PropertyType.photo)
        aCoder.encodeObject(rating, forKey: PropertyType.rating)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObjectForKey(PropertyType.name) as? String else {
            print("Unable to decode the name for a Meal object")
            return nil
        }
        
        let photo = aDecoder.decodeObjectForKey(PropertyType.photo) as? UIImage
        let rating = aDecoder.decodeObjectForKey(PropertyType.rating) as? Int
        
        self.init(name: name, photo: photo, rating: rating!)
    }
    
    
    
}