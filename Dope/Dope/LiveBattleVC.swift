//
//  LiveBattleVC.swift
//  Dope
//
//  Created by Aaron Rosenberger on 4/21/16.
//  Copyright © 2016 Zach Nafziger. All rights reserved.
//

import UIKit
import R5Streaming

class LiveBattleVC: UIViewController {
    
    @IBOutlet weak var streamView: UIView!
    @IBOutlet weak var word:UIBarButtonItem!
    @IBOutlet weak var rhymingWord:UIBarButtonItem!
    @IBOutlet weak var handicapBar:UIToolbar!
    var currentWord = 0
    var rhyme:Rhyme!
    @IBAction func handicap(){
        if(handicapBar.hidden){
            switchWords()
            handicapBar.hidden = false
        } else{
            handicapBar.hidden = true
        }
        
    }
    
    @IBAction func switchWords(){
        rhyme = RhymeService.nextRhyme()
        word.title = rhyme.word
        rhymingWord.title = rhyme.rhymingWords[0]
        currentWord = 0
    }
    
    @IBAction func changeWord(sender: UIBarButtonItem){
        currentWord += 1
        sender.title = rhyme.rhymingWords[currentWord % rhyme.rhymingWords.count]
    }
    
    @IBAction func quit(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        RhymeService.populate(100)
        handicapBar.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

}
