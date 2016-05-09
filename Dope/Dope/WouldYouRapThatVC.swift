//
//  WouldYouRapThatVC.swift
//  Dope
//
//  Created by Aaron Rosenberger on 4/20/16.
//  Copyright © 2016 Zach Nafziger. All rights reserved.
//

import UIKit
import Koloda

class WouldYouRapThatVC: UIViewController {
    
    // MARK: - Properties & Outlets

    @IBOutlet weak var cards: KolodaView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var ratio: UILabel!
    
    var dataSource: Array<(User, UIImage)> = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cards.dataSource = self
        cards.delegate = self
        MatchingService.fetchAvailable(10) { user in
            MatchingService.getImage(user) { image in
                self.dataSource.append((user, image))
                self.cards.reloadData()
            }
        }
    }

}


// MARK: - KolodaViewDelegate

extension WouldYouRapThatVC: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        MatchingService.fetchAvailable(10) { user in
            MatchingService.getImage(user) { image in
                self.dataSource.insert((user, image), atIndex: (self.cards.currentCardIndex - 1))
                self.cards.reloadData()
            }
        }
        let position = cards.currentCardIndex
        cards.insertCardAtIndexRange(position...position, animated: true)
    }
    
    func koloda(koloda: KolodaView, didSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
        /// TODO: Check for match here.
        // If there is a match, open a new rap battle and begin broadcasting!
        MatchingService.swipeRight(self.dataSource[0].0)
        performSegueWithIdentifier("rapBattleLiveSegue", sender: self)
    }
}


// MARK: - KolodaViewDataSource
extension WouldYouRapThatVC: KolodaViewDataSource {
    
    func kolodaNumberOfCards(koloda:KolodaView) -> UInt {
        return UInt(dataSource.count)
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        return UIImageView(image: dataSource[Int(index)].1)
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        return NSBundle.mainBundle().loadNibNamed("OverlayView", owner: self, options: nil)[0] as? OverlayView
    }
}


