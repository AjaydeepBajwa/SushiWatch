//
//  InterfaceController.swift
//  SushiWatch Extension
//
//  Created by AJAY BAJWA on 2019-11-01.
//  Copyright © 2019 Parrot. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    @IBOutlet weak var btnMoveleft: WKInterfaceButton!
    
    @IBOutlet weak var btnMoveRight: WKInterfaceButton!
    @IBOutlet weak var lblTimeRemaining: WKInterfaceLabel!
    
    @IBOutlet weak var btnMoreTimeOutlet: WKInterfaceButton!
    
    @IBOutlet weak var lblGameState: WKInterfaceLabel!
    
    @IBOutlet weak var btnEnterNameOutlet: WKInterfaceButton!
    
    @IBOutlet weak var tapToSeeScoreOutlet: WKTapGestureRecognizer!
    
    var timeRemaining = 25
    var playerName = ""
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        if WCSession.isSupported() {
            print("Watch supports WCSession")
            WCSession.default.delegate = self
            WCSession.default.activate()
            print("Session Activated")
        }
        else {
            print("Watch does not support WCSession")
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {

        if (message.keys.contains("timeRemaining")){
            
            let messageBody = message["timeRemaining"] as! Int
            self.timeRemaining = messageBody
            print("WATCH: Got message from Phone = \(messageBody)")
            
            
            if messageBody == 0 {
                self.lblTimeRemaining.setHidden(false)
                self.lblTimeRemaining.setText("GAME OVER")
                self.btnMoveleft.setHidden(true)
                self.btnMoveRight.setHidden(true)
                self.btnEnterNameOutlet.setHidden(false)
            }
            else {
                self.lblTimeRemaining.setHidden(false)
                self.lblTimeRemaining.setText("\(messageBody) Seconds Remaining")
                
                //Hide time remaining label after 2 seconds of recieving message
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.lblTimeRemaining.setText("")
                }
            }
        }
        

        
        if message.keys.contains("moreTime"){
            //Hide time remaining label after 2 seconds of recieving message
            self.btnMoreTimeOutlet.setHidden(false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
               self.btnMoreTimeOutlet.setHidden(true)
            }
            
            
        }
        
        }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func btnMoreTime() {
        if (WCSession.default.isReachable) {
            print("Phone reachable")
            let message = ["moreTimeReply": "yes"]
            WCSession.default.sendMessage(message, replyHandler: nil)
            // output a debug message to the console
            print("sent more time request to phone")
        }
        else {
            print("WATCH: Cannot reach phone")
        }
        self.btnMoreTimeOutlet.setHidden(true)
    }
    
    @IBAction func gesturePause(_ sender: Any) {
        // Double tap to resume game
        if (WCSession.default.isReachable) {
            print("Phone reachable")
            let message = ["pause": "yes"]
            WCSession.default.sendMessage(message, replyHandler: nil)
            // output a debug message to the console
            print("sent pause request to phone")
            self.lblGameState.setText("Paused! Swipe Right to Resume")
        }
        else {
            print("WATCH: Cannot reach phone")
        }
    }
    
    
    @IBAction func gestureSwipeResume(_ sender: Any) {
        //Swipe right to resume game
        if (WCSession.default.isReachable) {
            print("Phone reachable")
            let message = ["resume": "yes"]
            WCSession.default.sendMessage(message, replyHandler: nil)
            // output a debug message to the console
            print("sent resume request to phone")
            self.lblGameState.setText("Double tap to pause Sushi Tower")
        }
        else {
            print("WATCH: Cannot reach phone")
        }
    }
    
    @IBAction func btnEnterNameClick() {
        
        let suggestedResponses = ["Jen", "Pri", "Aja"]
        
        presentTextInputController(withSuggestions: suggestedResponses, allowedInputMode: .plain ) {
            
            (results) in
            
            if (results != nil && results!.count > 0) {
                let userResponse = results?.first as? String
                // Limit the Player Name to Maximum 3 Characters
                if ((userResponse!.count) > 3){
                    let indexEndOfText = userResponse!.index(userResponse!.startIndex, offsetBy: 2)
                    //self.btnEnterNameOutlet.setTitle("\(userResponse![...indexEndOfText])")
                    print("\(self.btnEnterNameOutlet!)")
                    self.playerName = String(userResponse![...indexEndOfText])
                    self.playerName = self.playerName.uppercased()
                    self.btnEnterNameOutlet.setTitle("Name: \(self.playerName)")
                }
                else {
                    self.playerName = userResponse!
                    self.playerName = self.playerName.uppercased()
                    self.btnEnterNameOutlet.setTitle("Name: \(self.playerName)")
                }
                
                
                if (WCSession.default.isReachable) {
                    print("phone reachable")
                    let message = ["playerName": self.playerName]
                    WCSession.default.sendMessage(message, replyHandler: nil)
                    // output a debug message to the console
                    print("sent player name to phone")
                }
                else {
                    print("WATCH: Cannot reach phone")
                }
                // Disable Enter Name Button after entering name, so that user cannot send same score twice to database.
                self.btnEnterNameOutlet.setEnabled(false)
                self.tapToSeeScoreOutlet.isEnabled = true
                self.lblTimeRemaining.setText("Double Tap for Score")
            }
        }
    }
    
    @IBAction func dblTapToSeeScoreBoard(_ sender: Any) {
        if (WCSession.default.isReachable) {
            print("phone reachable")
            let message = ["seeScoreBoard": "yes"]
            WCSession.default.sendMessage(message, replyHandler: nil)
            // output a debug message to the console
            print("sent ScoreBoard request to phone")
        }
        else {
            print("WATCH: Cannot reach phone")
        }
    }
    
    @IBAction func btnLeftClick() {
        if (WCSession.default.isReachable) {
            print("phone reachable")
            let message = ["moveDirection": "left"]
            WCSession.default.sendMessage(message, replyHandler: nil)
            // output a debug message to the console
            print("sent move left to phone")
        }
        else {
            print("WATCH: Cannot reach phone")
        }
    }
    
    @IBAction func btnRightClick() {
        if (WCSession.default.isReachable) {
            print("phone reachable")
            let message = ["moveDirection": "right"]
            WCSession.default.sendMessage(message, replyHandler: nil)
            // output a debug message to the console
            print("sent move right to phone")
        }
        else {
            print("WATCH: Cannot reach phone")
        }
    }
}
