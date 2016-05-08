//
//  Rhyme.swift
//  Dope
//
//  Created by Zach Nafziger on 5/1/16.
//  Copyright © 2016 Zach Nafziger. All rights reserved.
//

import Foundation

class Rhyme: NSObject {
    var word:String!
    var rhymingWords:[String]!
    init(word:String, rhymingWords:[String]){
        self.word = word
        self.rhymingWords = rhymingWords
    }
}