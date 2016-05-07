//
//  MatchingService.swift
//  Dope
//
//  Created by Aaron Rosenberger on 5/7/16.
//  Copyright © 2016 Zach Nafziger. All rights reserved.
//

import Foundation

/// A service for matching users into rap battles.
class MatchingService {
    
    // MARK: - Properties
    
    typealias Match = (User, User)
    static let sharedMatchingInstance = MatchingService()
    
    /// List of users available for battle matching
    static private var available: [User] = []
    
    /// List of confirmed matches ready for battle
    static private var matches: [Match] = []
    
    
    // MARK: - Service Methods
    
    /**
     Adds a user that is available for battling and sorts the list of users by lowest minutesAgoLastSeen.
     - parameter user: The `User` object to add.
     - returns: If `user` was added, returns the index of said user after the list has been sorted.
    */
    static func addAvailable(user: User) -> Int? {
        available.append(user)
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
        matches.append(match)
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








