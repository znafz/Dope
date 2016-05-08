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

    @IBOutlet weak var cards: KolodaView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    private var dataSource: Array<UIImage> = setDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cards.dataSource = self
        cards.delegate = self
        MatchingService.fetchAvailable(3)
        MatchingService.addObserver(self, forKeyPath: "available", options: .New, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let newValue = change?[NSKeyValueChangeNewKey] {
            let newValue = newValue as! UIImage
            dataSource.append(newValue)
        }
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
        skipButton.imageView?.image = UIImage(named: "btn_skip_pressed")
        cards.swipe(SwipeResultDirection.Left)
    }
    
    @IBAction func rightButtonTapped() {
        likeButton.imageView?.image = UIImage(named: "btn_like_pressed")
        cards.swipe(SwipeResultDirection.Right)
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
        Stream.setStream2Name("laptop")
        Stream.setStream1Name("phone")
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

func setDataSource() -> Array<UIImage> {
    var array: Array<UIImage> = []
    let urls: [String] = MatchingService.getImageURLs()
    for url in urls {
        downloadImage(NSURL(string: url)!) { img in
            dispatch_async(dispatch_get_main_queue()) {
                array.append(img)
            }
        }
    }
    return array
}

func getDataFromUrl(url: NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
    NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
        completion(data: data, response: response, error: error)
    }.resume()
}

func downloadImage(url: NSURL, completion: UIImage -> Void) {
    print("Download Started")
    print("lastPathComponent: " + (url.lastPathComponent ?? ""))
    getDataFromUrl(url) { (data, response, error) in
        dispatch_async(dispatch_get_main_queue()) {
            guard let data = data where error == nil else { return }
            print(response?.suggestedFilename ?? "")
            print("Download Finished")
            completion(UIImage(data: data)!)
        }
    }
}
