//
//  RhymeService.swift
//  Dope
//
//  Created by Aaron Rosenberger on 5/7/16.
//  Copyright © 2016 Zach Nafziger. All rights reserved.
//

import Foundation

/// A service for providing battlers with rhyming words.
class RhymeService {
    
    // MARK: - Properties
    
    static let rhymeApiUrl = "http://rhymebrain.com/talk?function=getRhymes&word="
    static let sharedInstance = RhymeService()
    static var usedIndexes:[Int]!
    static var currentIndex = 0
    static var currentRhyme = 0
    
    /// The list of rhymes to be prompted with
    static var rhymes:[Rhyme]!
    
    /// A list of words to find rhymes for
    static var words:[String]!
    
    
    // MARK: - Lifecycle
    
    init() {
        getWordsFromFile()
    }
    
    
    // MARK: - Service Methods
    
    /**
     Populates a set of words to rhyme.
     - parameter numberOfWords: The number of words to load rhymes for.
    */
    static func populate(numberOfWords: Int) {
        rhymes = []
        for _ in 0..<numberOfWords {
            let w = getWord()
            let tempRhyme:Rhyme = Rhyme(word: w, rhymingWords: []);
            //pull rhymes in background
            {tempRhyme.rhymingWords = self.getRhymes(w)}~>{self.rhymes.append(tempRhyme)};
            
        }
    }
    
    /**
     Gets the next word in the list of populated words.
     - returns: A `String` for the next word
    */
    static func getWord()->String{
        currentIndex += 1
        return words[currentIndex-1 % words.count]
    }
    
    /**
     Given a word, gets words that rhyme with that word.
     - parameter word: The word to get rhymes for
     - returns: A shuffled list of words that rhyme with the provided word
    */
    static func getRhymes(word:String)->[String]{
        var tempRhymes:[String] = []
        let url = NSURL(string: "\(rhymeApiUrl)\(word)")
        if let data = NSData(contentsOfURL: url!) {
            do {
                let parsedData =  try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! [AnyObject]
                for w in parsedData{
                    tempRhymes.append("\(w["word"]!!)")
                }
                tempRhymes.shuffle()
            } catch{
                print("whoops, couldn't parse rhymes")
            }
        }
        
        return tempRhymes
    }
    
    /**
     Gets the next rhyme in the list of rhymes.
     - returns: A `Rhyme` object that is the next rhyme
    */
    static func nextRhyme()->Rhyme{
        let rhyme = rhymes[currentRhyme]
        currentRhyme += 1
        return rhyme
    }
    
    /// Gets a list of words to rhyme from a text file.
    private func getWordsFromFile() {
        if let path = NSBundle.mainBundle().pathForResource("words", ofType: "txt"){
            do{
                let data = try String(contentsOfFile:path, encoding: NSUTF8StringEncoding)
                RhymeService.words = data.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
                RhymeService.words.shuffle()
            } catch{
                print("whoops, couldn't read words file")
            }
        }
    }
    
}

//shuffle extension from https://gist.github.com/ijoshsmith/5e3c7d8c2099a3fe8dc3
extension Array
{
    /** Randomizes the order of an array's elements. */
    mutating func shuffle()
    {
        for _ in 0..<10
        {
            sortInPlace { (_,_) in arc4random() < arc4random() }
        }
    }
}