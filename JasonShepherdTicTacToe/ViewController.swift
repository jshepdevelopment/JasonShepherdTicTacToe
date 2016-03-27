//
//  ViewController.swift
//  JasonShepherdTicTacToe
//
//  Created by Jason Shepherd on 3/22/16.
//  Copyright © 2016 Salt Lake Community College. All rights reserved.
//

import UIKit
import AVFoundation

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
    var tieGame = false
    var reset = false
    
    // each occurance is a square on the board
    var gameState = [0,0,0,0,0,0,0,0,0]
    var gameStateSum = 0 // sum to check for tie game
    
    // arrays to store square and winner values
    var squareValue = [1,2,4,8,16,32,64,128,256]
    var winsArray = [7,56,448,73,146,292,273,84]

    // define a timer and counter var
    var timer = NSTimer()
    var animTimer = NSTimer()
    var counter = 5
    
    // positions to store for animation
    var xPos = 0
    var yPos = 0
    
    //var redImage: UIImage!
    var redImageArray: [UIImage] = []
    var yellowImageArray: [UIImage] = []
    var redWizardImageArray: [UIImage] = []
    var yellowWizardImageArray: [UIImage] = []
    var bombImageArray: [UIImage] = []
    
    //load sounds
    var yellowSound: NSURL!
    var redSound: NSURL!
    var winSound: NSURL!
    var music: NSURL!

    var audioPlayer = AVAudioPlayer()
    var musicPlayer = AVAudioPlayer()
    
    @IBOutlet weak var redWizardImage: UIImageView!
    @IBOutlet weak var yellowWizardImage: UIImageView!
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

        // set button positions to display animations
        xPos = Int(sender.frame.origin.x)
        yPos = Int(sender.frame.origin.y)
        
        if gameState[sender.tag] == 0 {
            
            if activePlayer == 1 {
                // update UI for x player
                xTurn.text = ""
                oTurn.text = "Your turn!"
                image = UIImage(named: "cross.png")!
                xScore = xScore + squareValue[sender.tag]
                startRedAnimation() // play the red animation and sound for player 1
                activePlayer = 2 // change active player
 
            } else {
                // update UI
                xTurn.text = "Your turn!"
                oTurn.text = ""
                image = UIImage(named: "circle.png")!
                oScore = oScore + squareValue[sender.tag]
                startYellowAnimation() // play the yellow animation and sound for player
                activePlayer = 1 // change active player
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
                reset = true//resetBoard() // clear for next round
            }
            
        }
        
        // check for win
        for (var i = 0; i < winsArray.count; i++) {
            
            // compare winsArray occurance bitwise to the current score
            if ((winsArray[i] & xScore) == winsArray[i]) {
                xWins += 1
                winner.text = "X Takes Round \(round)"
                round += 1
                // update the current round
                roundLabel.text = "Round \(round)"
                xPlayer.text = "Score \(xWins)"
                
                // bomb red wizard animation
                yellowWizardImage.animationImages = bombImageArray
                yellowWizardImage.animationDuration = 0.5
                yellowWizardImage.animationRepeatCount = 1
                yellowWizardImage.startAnimating()
                
                // play the audio or catch an error
                do {
                    try audioPlayer = AVAudioPlayer(contentsOfURL: winSound)
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                } catch {
                    print("error playing sound")
                }
                reset = true//resetBoard() // clear for next round
            }
            if ((winsArray[i] & oScore) == winsArray[i]) {
                oWins += 1
                winner.text = "O Takes Round \(round)"
                round += 1
                // update the current round
                roundLabel.text = "Round \(round)"
                oPlayer.text = "Score \(oWins)"
                
                // bomb red wizard animation
                redWizardImage.animationImages = bombImageArray
                redWizardImage.animationDuration = 0.5
                redWizardImage.animationRepeatCount = 1
                redWizardImage.startAnimating()
                
                // play the audio or catch an error
                do {
                    try audioPlayer = AVAudioPlayer(contentsOfURL: winSound)
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                } catch {
                    print("error playing sound")
                }
                reset = true//resetBoard() // clear for next round
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set initial label values
        xTurn.text = "Your turn!"
        roundLabel.text = "Round \(round)"
        
        // set animation images arrays
        for i in 1...6 {
            redImageArray.append(UIImage(named: "red0\(i).png")!)
        }
        for i in 1...4 {
            redWizardImageArray.append(UIImage(named: "redwizard0\(i).png")!)
        }
        
        // set animation images arrays
        for i in 1...6 {
            yellowImageArray.append(UIImage(named: "yellow0\(i).png")!)
        }
        for i in 1...4 {
            yellowWizardImageArray.append(UIImage(named: "yellowwizard0\(i).png")!)
        }
        
        for i in 1...4 {
            bombImageArray.append(UIImage(named: "bomb0\(i).png")!)
        }
        
        // loading sounds and music
        yellowSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("redmove", ofType: "wav")!)
        redSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("yellowmove", ofType: "wav")!)
        winSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("win", ofType: "wav")!)
        music = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bgmusic", ofType: "mp3")!)
        
        // play the music or catch an error
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: music)
            musicPlayer.numberOfLoops = -1
            musicPlayer.prepareToPlay()
            musicPlayer.play()
        } catch {
            print("error playing sound")
        }
        
        // create the game timer
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    
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
        if reset {
            sleep(1)
            resetBoard()
            reset = false
        }
        if counter < 0 && activePlayer == 2 {
            winner.text = "Too slow O!"
            xTurn.text = "Your turn!"
            oTurn.text = ""
            activePlayer = 1
            counter = 5
        }
        if counter < 0  && activePlayer == 1 {
            winner.text = "Too slow X!"
            xTurn.text = ""
            oTurn.text = "Your turn!"
            activePlayer = 2
            counter = 5
        }
    }
    
    // start the red animation
    func startRedAnimation() {
        
        // prepare imageView for the animation
        let imageView = UIImageView()

        imageView.animationImages = redImageArray
        imageView.animationDuration = 0.3
        imageView.animationRepeatCount = 1
        imageView.startAnimating()
        
        redWizardImage.animationImages = redWizardImageArray
        redWizardImage.animationDuration = 0.3
        redWizardImage.animationRepeatCount = 1
        redWizardImage.startAnimating()
        
        // add the imageView according to button position
        imageView.frame = CGRect(x: xPos, y: yPos, width: 100, height: 100)
        view.addSubview(imageView)
        
        // play the audio or catch an error
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: redSound)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch {
            print("error playing sound")
        }

    }
    
    // start the yellow animation
    func startYellowAnimation() {
        
        // prepare imageView for the animation
        let imageView = UIImageView()
        
        imageView.animationImages = yellowImageArray
        imageView.animationDuration = 0.3
        imageView.animationRepeatCount = 1
        imageView.startAnimating()
        
        yellowWizardImage.animationImages = yellowWizardImageArray
        yellowWizardImage.animationDuration = 0.3
        yellowWizardImage.animationRepeatCount = 1
        yellowWizardImage.startAnimating()
        
        // add the imageView according to button position
        imageView.frame = CGRect(x: xPos, y: yPos, width: 100, height: 100)
        view.addSubview(imageView)
        
        // play the audio or catch an error
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: yellowSound)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch {
            print("error playing sound")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
