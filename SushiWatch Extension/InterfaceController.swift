//
//  InterfaceController.swift
//  SushiWatch Extension
//
//  Created by AJAY BAJWA on 2019-11-01.
//  Copyright © 2019 Parrot. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
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
    }
    
    @IBAction func btnRightClick() {
    }
}
