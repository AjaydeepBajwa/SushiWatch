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
    @IBAction func btnMoreTime() {
    }
    var timeRemaining = 25
    
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
            }
            else {
                self.lblTimeRemaining.setHidden(false)
                self.lblTimeRemaining.setText("\(messageBody) Seconds Remaining")
                
                //Hide time remaining label after 2 seconds of recieving message
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.lblTimeRemaining.setHidden(true)
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
