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
    
    // each occurance is a square on the board
    var gameState = [0,0,0,0,0,0,0,0,0]
    
    // arrays to store square and winner values
    var squareValue = [1,2,3,4,8,16,32,64,128,256]
    var winsArray = [7,56,448,73,146,292,273,84]
    
    @IBOutlet weak var xPlayer: UILabel!
    @IBOutlet weak var oPlayer: UILabel!
    @IBOutlet weak var winner: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBAction func buttonPressed(sender: AnyObject) {
    
        var image = UIImage()
        
        if gameState[sender.tag] == 0 {
            
            if activePlayer == 1 {
                image = UIImage(named: "cross.png")!
                xScore = xScore + squareValue[sender.tag]
                xPlayer.text = "\(xScore)"
                activePlayer = 2
            } else {
                image = UIImage(named: "circle.png")!
                oScore = oScore + squareValue[sender.tag]
                oPlayer.text = "\(oScore)"
                activePlayer = 1
            }
      
            gameState[sender.tag] = 1
            sender.setImage(image, forState: .Normal)
        }
        
        for (var i = 0; i < winsArray.count; i++) {
            // compare winsArray occurance bitwise to the current score
            if ((winsArray[i] & xScore) == winsArray[i]) {
                winner.text = "X wins"
            }
            if ((winsArray[i] & oScore) == winsArray[i]) {
                winner.text = "O wins"
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
