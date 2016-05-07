//
//  DopeTests.swift
//  DopeTests
//
//  Created by Zach Nafziger on 4/16/16.
//  Copyright © 2016 Zach Nafziger. All rights reserved.
//

import XCTest
@testable import Dope

class DopeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Matching service
    func test_addAvailable() {
        let user1 = User(uid: "123", imageURL: "imgur.com", displayName: "user1", numberOfBattles: 0, numberOfWins: 0, minutesAgoLastSeen: 5)
        let user2 = User(uid: "123", imageURL: "imgur.com", displayName: "user1", numberOfBattles: 0, numberOfWins: 0, minutesAgoLastSeen: 10)
        let _ = MatchingService()
        XCTAssert(MatchingService.addAvailable(user2) == 0)
        XCTAssert(MatchingService.addAvailable(user1) == 0)
        
        let user3 = User(uid: "123", imageURL: "imgur.com", displayName: "user1", numberOfBattles: 0, numberOfWins: 0, minutesAgoLastSeen: 15)
        self.measureBlock {
            // Put the code you want to measure the time of here.
            MatchingService.addAvailable(user3)
        }
    }
    
}
