//
//  Rhyme.swift
//  Dope
//
//  Created by Zach Nafziger on 5/1/16.
//  Copyright © 2016 Zach Nafziger. All rights reserved.
//

import Foundation

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

class Rhyme {
    var word:String!
    var rhymingWords:[String]!
    init(word:String, rhymingWords:[String]){
        self.word = word
        self.rhymingWords = rhymingWords
    }
}

class RhymeRepo{
    let rhymeApiUrl = "http://rhymebrain.com/talk?function=getRhymes&word="
    static let sharedInstance = RhymeRepo()
    var rhymes:[Rhyme]!
    var words:[String]!
    var usedIndexes:[Int]!
    var currentIndex = 0
    var currentRhyme = 0
    func populate(numberOfRhymes:Int){
        rhymes = []
        for _ in 0..<numberOfRhymes{
            let w = getWord()
            let tempRhyme:Rhyme = Rhyme(word: w, rhymingWords: []);
            //pull rhymes in background
            {tempRhyme.rhymingWords = self.getRhymes(w)}~>{self.rhymes.append(tempRhyme)};
            
        }
    }
    func getWord()->String{
        currentIndex += 1
        return words[currentIndex-1 % words.count]
    }
    
    func getRhymes(word:String)->[String]{
        var tempRhymes:[String] = []
        let url = NSURL(string: "\(rhymeApiUrl)\(word)")
        let data = NSData(contentsOfURL: url!)
        do{
            let parsedData =  try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! [AnyObject]
            for w in parsedData{
                tempRhymes.append("\(w["word"]!!)")
            }
            tempRhymes.shuffle()
        } catch{
            print("whoops, couldn't parse rhymes")
        }
        
        return tempRhymes
    }
    
    func nextRhyme()->Rhyme{
        let rhyme = rhymes[currentRhyme]
        currentRhyme += 1
        return rhyme
    }
    init(){
        if let path = NSBundle.mainBundle().pathForResource("words", ofType: "txt"){
            do{
                let data = try String(contentsOfFile:path, encoding: NSUTF8StringEncoding)
                words = data.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
                words.shuffle()
            } catch{
                print("whoops, couldn't read words file")
            }
        }
    }
}