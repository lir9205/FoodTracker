//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by 李芮 on 17/2/20.
//  Copyright © 2017年 7feel. All rights reserved.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {
    //MARK:- Meal Class Tests
    func testMealInitializationSucceeds() {
        let zeroRatingMeal = Meal.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)
        
        let positiveRatingMeal = Meal.init(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingMeal)
        
        
    }
    
    func testMealInitializationFails() {
        let nagativeRatingMeal = Meal.init(name: "Nagative", photo: nil, rating: -1)
        XCTAssertNil(nagativeRatingMeal)
        
        let largestRatingMeal = Meal.init(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largestRatingMeal)
        
        
        let emptyStringMeal = Meal.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyStringMeal)
        
    }
    
    
    
    
}
