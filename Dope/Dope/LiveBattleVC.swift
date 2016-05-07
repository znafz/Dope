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
/*
        r5ViewController = Subscribe()
        
        self.addChildViewController(r5ViewController!)
        self.view.addSubview(r5ViewController!.view)
        
        r5ViewController!.view.autoresizesSubviews = true
        r5ViewController!.view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth];*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
