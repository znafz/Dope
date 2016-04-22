//
//  WouldYouRapThatVC.swift
//  Dope
//
//  Created by Aaron Rosenberger on 4/20/16.
//  Copyright © 2016 Zach Nafziger. All rights reserved.
//

import UIKit
import Koloda

private var numberOfCards = 5

class WouldYouRapThatVC: UIViewController {

    @IBOutlet weak var cards: KolodaView!
    
    private var dataSource: Array<UIImage> = {
        var array: Array<UIImage> = []
        for index in 0..<numberOfCards {
            array.append(UIImage(named: "Foodini.png")!)
        }
        
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cards.dataSource = self
        cards.delegate = self
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: IBActions
    @IBAction func leftButtonTapped() {
        cards.swipe(SwipeResultDirection.Left)
    }
    
    @IBAction func rightButtonTapped() {
        cards.swipe(SwipeResultDirection.Right)
    }
    
    @IBAction func undoButtonTapped() {
        cards.revertAction()
    }

}

//MARK: KolodaViewDelegate
extension WouldYouRapThatVC: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        dataSource.insert(UIImage(named: "Foodini.png")!, atIndex: cards.currentCardIndex - 1)
        let position = cards.currentCardIndex
        cards.insertCardAtIndexRange(position...position, animated: true)
    }
    
    func koloda(koloda: KolodaView, didSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
        // TODO: Check for match here.
        // If there is a match, open a new rap battle and begin broadcasting!
        performSegueWithIdentifier("rapBattleLiveSegue", sender: self)
    }
}

//MARK: KolodaViewDataSource
extension WouldYouRapThatVC: KolodaViewDataSource {
    
    func kolodaNumberOfCards(koloda:KolodaView) -> UInt {
        return UInt(dataSource.count)
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        return UIImageView(image: dataSource[Int(index)])
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        return NSBundle.mainBundle().loadNibNamed("OverlayView", owner: self, options: nil)[0] as? OverlayView
    }
}
