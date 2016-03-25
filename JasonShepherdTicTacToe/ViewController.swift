//
//  ViewController.swift
//  JasonShepherdTicTacToe
//
//  Created by Jason Shepherd on 3/22/16.
//  Copyright © 2016 Salt Lake Community College. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // 1 = player X : 2 = player O
    var activePlayer = 1 // Tracks current player
    
    // player scores
    var xScore = 0
    var oScore = 0
    
    // player total wins and total wins needed
    var xWins = 0
    var oWins = 0
    
    // vars to track rounds and game over state
    var round = 1
    var neededWins = 2
    var gameOver = false
    var tieGame = false
    
    // each occurance is a square on the board
    var gameState = [0,0,0,0,0,0,0,0,0]
    var gameStateSum = 0 // sum to check for tie game
    
    // arrays to store square and winner values
    var squareValue = [1,2,4,8,16,32,64,128,256]
    var winsArray = [7,56,448,73,146,292,273,84]

    // define a timer and counter var, playing var to halt anim
    var timer = NSTimer()
    var animTimer = NSTimer()
    var counter = 5
    var animCounter = 1
    var playing = false
    
    // positions to store for animation
    var xPos = 0
    var yPos = 0
    
    //var redImage: UIImage!
    var redImageArray: [UIImage] = []
    
    @IBOutlet weak var oHealthImage: UIImageView!
    @IBOutlet weak var xHealthImage: UIImageView!
    @IBOutlet weak var xTurn: UILabel!
    @IBOutlet weak var oTurn: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var xPlayer: UILabel!
    @IBOutlet weak var oPlayer: UILabel!
    @IBOutlet weak var winner: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    //@IBOutlet var buttons: Array<UIButton>
    
    @IBAction func buttonPressed(sender: AnyObject) {
    
        var image = UIImage()

        xPos = Int(sender.frame.origin.x)
        yPos = Int(sender.frame.origin.y)
        
        // resets animation frame counter
        startAnimation()
        playing = true // used to start animation
        
        if gameState[sender.tag] == 0 {
            
            if activePlayer == 1 {
                xTurn.text = "..."
                oTurn.text = "Go O"
                image = UIImage(named: "cross.png")!
                xScore = xScore + squareValue[sender.tag]
                
                activePlayer = 2
 
            } else {
                
                xTurn.text = "Go X"
                oTurn.text = "..."
                
                image = UIImage(named: "circle.png")!
                oScore = oScore + squareValue[sender.tag]
                
                activePlayer = 1
            }
            
            // reset counter and game state along with image
            counter = 5
            gameState[sender.tag] = 1
            sender.setImage(image, forState: .Normal)

            // get the sum of gameState array for tie game check
            gameStateSum = gameState.reduce(0,combine: +)
            print(gameStateSum)
            
            // if the sum of the gameState array reaches 9, then tie game
            if gameStateSum == 9 {
                winner.text = "No winner for round \(round)"
                round += 1
                // update the current round
                roundLabel.text = "Round \(round)"
                resetBoard() // clear for next round
            }
            
        }
        
        // check for win
        for (var i = 0; i < winsArray.count; i++) {
            
            // compare winsArray occurance bitwise to the current score
            if ((winsArray[i] & xScore) == winsArray[i]) {
                xWins += 1
                winner.text = "X Takes Round \(round)"
                oHealthImage.image = UIImage(named: "halfhealth.png")
                round += 1
                // update the current round
                roundLabel.text = "Round \(round)"
                xPlayer.text = "\(xWins) wins"
                
                if xWins == 2 {
                    oHealthImage.image = UIImage(named: "nohealth.png")
                    gameOver = true
                }
                
                resetBoard() // clear for next round
            }
            if ((winsArray[i] & oScore) == winsArray[i]) {
                oWins += 1
                winner.text = "O Takes Round \(round)"
                xHealthImage.image = UIImage(named: "halfhealth.png")
                round += 1
                // update the current round
                roundLabel.text = "Round \(round)"
                oPlayer.text = "\(oWins) wins"
                
                if oWins == 2 {
                    xHealthImage.image = UIImage(named: "nohealth.png")
                    gameOver = true
                }
                
                resetBoard() // clear for next round
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set initial label values
        xTurn.text = "Go X"
        roundLabel.text = "Round \(round)"
        
        // set images arrays
        for i in 1...6 {
            redImageArray.append(UIImage(named: "red0\(i).png")!)
        }
        
        // create the game timer
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        
        // create the animation timer
        //animTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateAnimation"), userInfo: nil, repeats: true)
        
        // check for game over
        if !gameOver {
            if xWins == neededWins {
                winner.text = "X is supreme winner"
                gameOver = true
            }
            if oWins == neededWins {
                winner.text = "O is supreme winner"
                gameOver = true
            }
        }
    }

    // clear the gameboard for next round
    func resetBoard() {
        
        // reset the gameState
        gameState = [0,0,0,0,0,0,0,0,0]
        
        // reset scores
        xScore = 0
        oScore = 0
        
        // loop through view and clear images from buttons
        for view in self.view.subviews as [UIView] {
            if let btn = view as? UIButton {
                btn.setImage(nil, forState: .Normal)
            }
        }
    }
   
    // update
    func update() {
        // update counter label and number
        counterLabel.text = String(counter)
        counter -= 1
    }
    
    // update
    /*func updateAnimation() {
        
        if activePlayer == 2 && playing {
            
        //    redImage = UIImage(named: "red0\(animCounter)")!
       //     let imageView = UIImageView()
            
        //    imageView.frame = CGRect(x: xPos, y: yPos, width: 100, height: 100)
        //    view.addSubview(imageView)
        }
        
        if animCounter == 6 {
            playing = false
            animCounter = 1
        }
        
        animCounter += 1

       
    }*/
    
    func startAnimation() {
        
        let imageView = UIImageView()

        imageView.animationImages = redImageArray
        imageView.animationDuration = 0.1
        imageView.animationRepeatCount = 1
        imageView.startAnimating()
        
        imageView.frame = CGRect(x: xPos, y: yPos, width: 100, height: 100)
        view.addSubview(imageView)


    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let position :CGPoint = touch.locationInView(view)
            print(position.x)
            print(position.y)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
