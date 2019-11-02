//
//  ScoresViewController.swift
//  SushiTower
//
//  Created by AJAY BAJWA on 2019-11-02.
//  Copyright © 2019 Parrot. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ScoresViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let scoreBoard:ScoreBoard!
        
        scoreBoard = scoreList[indexPath.row]
        cell.lblName.text = scoreBoard.name
        cell.lblScore.text = scoreBoard.score
        
        return cell
    }
    
    
    //Declare Firebase Databse reference
    var ref: DatabaseReference!
    var scoreData = [String]()
    
    var scoreList = [ScoreBoard]()
    var databaseHandle:DatabaseHandle!
    
    @IBOutlet weak var tblScoreBoard: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // initilize firebase referenee
        ref = Database.database().reference()
        
        //retreive data from database
       // self.databaseHandle = ref.child("ScoreCard").observe(.childAdded) { (snapshot) in
        self.databaseHandle = ref.child("ScoreBoard").observe(.value) { (snapshot) in
            // when a new value is added under Players
            if snapshot.childrenCount > 0{
                self.scoreList.removeAll()
                for scores in snapshot.children.allObjects as! [DataSnapshot] {
                    let scoreObject = scores.value as! [String: AnyObject]
                    let playerName = scoreObject["playerName"]
                    let playerScore = scoreObject["score"]
                    
                    let score = ScoreBoard(name: playerName as! String, score: playerScore as! String)
                    self.scoreList.append(score)
                    
                }
                
                self.tblScoreBoard.reloadData()
            }
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
