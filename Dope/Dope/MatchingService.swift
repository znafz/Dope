//
//  MatchingService.swift
//  Dope
//
//  Created by Aaron Rosenberger on 5/7/16.
//  Copyright © 2016 Zach Nafziger. All rights reserved.
//

import Foundation
import Firebase

/// A service for matching users into rap battles.
class MatchingService: NSObject {
    
    // MARK: - Properties
    static private let MAX_QUERY = 100
    static private let baseRef = Firebase(url:"https://popping-inferno-6138.firebaseio.com")
    static private let usersRef = Firebase(url:"https://popping-inferno-6138.firebaseio.com/users")
    
    static let sharedMatchingInstance = MatchingService()
    
    /// List of users available for battle matching
    static var available: [User] = []
    
    /// List of confirmed matches ready for battle
    static private var matches: [Match] = []
    
    
    // MARK: - Service Methods
    
    /**
     Adds a user that is available for battling and sorts the list of users by lowest minutesAgoLastSeen.
     - parameter user: The `User` object to add.
     - returns: If `user` was added, returns the index of said user after the list has been sorted.
                If the `user` wasn't added, returns -1.
    */
    static func addAvailable(user: User) -> Int? {
        if !available.contains(user) {
            available.append(user)
        } else {
            return -1
        }
        // In order for accessing the last online user to remain a constant time operation,
        //   we must sort this list by lowest minutesAgoLastSeen.
        available.sortInPlace()
        return available.indexOf(user)
        // A test exists for this function in DopeTests.swift
    }
    
    /**
     If the given user is available, removes the user from the availability list.
     - parameter user: The user to remove availability for
     - throws: `MatchingError.NotInAvailableList` if `user` does not exist in `available`
     - returns: The removed `User` object
    */
    static func removeAvailable(user: User) throws -> User {
        if let index = available.indexOf(user) {
            return available.removeAtIndex(index)
        }
        throw MatchingError.NotInAvailableList
    }
    
    /**
     Adds a match to the list of matches.
     - parameter match: The `Match` to add
     - returns: If `match` was added, returns the index of said `Match`
    */
    static func addMatch(match: Match) -> Int? {
        if !matches.contains({ (a: User, b: User) -> Bool in
            if ((match.0 == a && match.1 == b) ||
                (match.1 == a && match.0 == b)) {
                return true
            } else {
                return false
            }
        }) {
            matches.append(match)
        }
        return matches.indexOf({ (a: User, b: User) -> Bool in
            if ((match.0 == a && match.1 == b) ||
                (match.1 == a && match.0 == b)) {
                return true
            } else {
                return false
            }
        })
    }
    
    /**
     Removes the matched users from the list of matches and adds them to `available`.
     - parameter match: The `Match` to remove
     - throws: `MatchingError.NotInAvailableList` if `match` does not exist in `matches`
     - returns: The removed `Match` object
    */
    static func removeMatch(match: Match) throws -> Match {
        if let index = matches.indexOf({ (a: User, b: User) -> Bool in
            if ((match.0 == a && match.1 == b) ||
                (match.1 == a && match.0 == b)) {
                return true
            } else {
                return false
            }
        }) {
            return matches.removeAtIndex(index)
        }
        throw MatchingError.NotInAvailableList
    }
    
    /**
     Matches two `User`s together and prepares them for a rap battle.
     - Parameters:
        - a: `User` to match
        - b: `User` to match
     - throws: `MatchingError.SameUser` if `a` and `b` are equal
     - returns: The new `Match` ready for battle
    */
    static func match(a: User, b: User) throws -> Match {
        guard a != b else { throw MatchingError.SameUser }
        var match: Match! = nil
        do {
            let a = try removeAvailable(a)
            let b = try removeAvailable(b)
            match = (a, b)
            addMatch(match)
        } catch {
            print(error)
        }
        return match
    }
    
    /**
     Fetches new users that are available and adds them to `MatchingService.availability`.
     - parameter qty: The number of users to search for, limited by the constant `MAX_QUERY`.
    */
    static func fetchAvailable(qty: Int) {
        let limit = qty % MAX_QUERY
        usersRef.queryOrderedByChild("online")
            .queryEqualToValue(true)
            .queryLimitedToFirst(UInt(limit))
            .observeEventType(.Value, withBlock: { snapshot in
                for child in snapshot.children {
                    let child = child as! FDataSnapshot
                    let uid = child.key
                    let dName = child.value.objectForKey("display_name") as! String
                    let image = child.value.objectForKey("image_url") as! String
                    let numBattles = child.value.objectForKey("number_of_battles") as! Int
                    let numWins = child.value.objectForKey("number_of_wins") as! Int
                    let new = User(uid: uid, imageURL: image, displayName: dName, numberOfBattles: numBattles, numberOfWins: numWins)
                    self.addAvailable(new)
                }
        })
    }
    
    /// When a Firebase user is modified, this method is triggered.
    static func startUpdating() {
        usersRef.queryOrderedByChild("online").observeEventType(.ChildChanged, withBlock: { snapshot in
            let uid = snapshot.key
            let image = snapshot.value.objectForKey("image_url") as! String
            let dName = snapshot.value.objectForKey("display_name") as! String
            let numBattles = snapshot.value.objectForKey("number_of_battles") as! Int
            let numWins = snapshot.value.objectForKey("number_of_wins") as! Int
            let updated = User(uid: uid, imageURL: image, displayName: dName, numberOfBattles: numBattles, numberOfWins: numWins)
            if let online = snapshot.value.objectForKey("online") as? Bool {
                if !online {
                    do {
                        try self.removeAvailable(updated)
                    } catch {
                        print(error)
                    }
                } else {
                    self.addAvailable(updated)
                }
            }
            
        })
    }
    
    /// Retrieves a list of the locations of all available users' images.
    static func getImageURLs() -> [String] {
        var URLs: [String] = []
        for user in available {
            if let url = user.imageURL {
                URLs.append(url)
            }
        }
        return URLs
    }
    
}
    
enum MatchingError: ErrorType {
    case SameUser
    case NotInAvailableList
}
    
extension MatchingError: CustomStringConvertible {
    var description: String {
        switch self {
        case .SameUser:
            return "A user cannot be matched with himself"
        case .NotInAvailableList:
            return "The specified item to remove does not exist."
        }
    }
}








