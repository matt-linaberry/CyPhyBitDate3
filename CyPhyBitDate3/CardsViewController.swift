//
//  CardsViewController.swift
//  CyPhyBitDate
//
//  Created by Matt Linaberry on 5/5/15.
//  Copyright (c) 2015 Matt Linaberry. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController, SwipeViewDelegate {
    
    struct Card {
        let cardView: CardView
        let swipeView: SwipeView
        let user:User
    }
    
    let frontCardTopMargin: CGFloat = 0
    let backCardTopMargin: CGFloat = 10.0
    
    @IBOutlet weak var cardStackView: UIView!
    
    @IBOutlet weak var yeahButton: UIButton!
    @IBOutlet weak var nahButton: UIButton!
    var backCard: Card?
    var frontCard: Card?
    
    var users:[User]?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.titleView = UIImageView(image: UIImage(named: "nav-header"))
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav-back-button"), style: UIBarButtonItemStyle.Plain, target: self, action: "goToProfile:")
        navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        cardStackView.backgroundColor = UIColor.clearColor()
        
        nahButton.setImage(UIImage(named: "nah-button-pressed"), forState: UIControlState.Highlighted)
        yeahButton.setImage(UIImage(named: "yeah-button-pressed"), forState: UIControlState.Highlighted)
        fetchUnviewedUsers({
            returnedUsers in
            self.users = returnedUsers
            if let card = self.popCard() {  // is there a card to pop?
                self.frontCard = card  // if so, set it to the front card
                self.cardStackView.addSubview(self.frontCard!.swipeView)
            }
            
            if let card = self.popCard() {
                self.backCard = card
                self.backCard!.swipeView.frame = self.createCardFrame(self.backCardTopMargin)
                self.cardStackView.insertSubview(self.backCard!.swipeView, belowSubview: self.frontCard!.swipeView)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func yeahButtonTapped(sender: UIButton) {
        if let card = frontCard {
            card.swipeView.swipe(SwipeView.Direction.Right)
        }
    }
    @IBAction func nahButtonTapped(sender: UIButton) {
        if let card = frontCard {
            card.swipeView.swipe(SwipeView.Direction.Left)  // force a swipe left.
        }
    }
    private func createCardFrame(topMargin: CGFloat) -> CGRect {
        return CGRect(x: 0, y: topMargin, width: cardStackView.frame.width, height: cardStackView.frame.height)
    }
    
    private func createCard(user: User) -> Card {
        let cardView = CardView()
        cardView.name = user.name
        user.getPhoto({
            image in
            cardView.image = image
        })
        let swipeView = SwipeView(frame: createCardFrame(0))
        swipeView.delegate = self
        swipeView.innerView = cardView
        return Card(cardView: cardView, swipeView: swipeView, user: user)
    }
    
    private func popCard() -> Card? {
        if users != nil && users?.count > 0 {
            return createCard(users!.removeLast())
        }
        return nil
    }
    
    private func switchCards() {
        if let card = backCard {
            frontCard = card
            UIView.animateWithDuration(0.2, animations: {
                self.frontCard!.swipeView.frame = self.createCardFrame(self.frontCardTopMargin)
            })
        }
        
        if let card = self.popCard() {
            self.backCard = card
            self.backCard!.swipeView.frame = self.createCardFrame(self.backCardTopMargin)
            self.cardStackView.insertSubview(self.backCard!.swipeView, belowSubview: self.frontCard!.swipeView)
            
        }
    }
    
    func goToProfile(button: UIBarButtonItem) {
        pageController.goToPreviousVC()
    }
    
    //MARK: SwipeViewDelegate methods
    func swipedLeft() {
        println("Left!")
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
            // save this to parse
            saveSkip(frontCard.user)
            switchCards()
        }
    }
    
    func swipedRight() {
        println("Right!")
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
            saveLike(frontCard.user)
            switchCards()
        }
    }
    
    
}
