//
//  ScoresViewController.swift
//  SushiTower
//
//  Created by AJAY BAJWA on 2019-11-02.
//  Copyright © 2019 Parrot. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ScoresViewController: UIViewController {
    
    //Declare Firebase Databse reference
    var ref: DatabaseReference!
    var scoreData = [String]()
    
    var databaseHandle:DatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // initilize firebase referenee
        ref = Database.database().reference()
        
        //retreive data from database
        self.databaseHandle = ref.child("ScoreCard").observe(.childAdded) { (snapshot) in
            // when a new value is added under Players
            //let post = snapshot.
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
