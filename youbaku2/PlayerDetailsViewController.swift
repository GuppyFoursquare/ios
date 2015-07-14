//
//  PlayerDetailsViewController.swift
//  Ratings
//
//  Created by Caroline Begbie on 15/04/2015.
//  Copyright (c) 2015 Caroline Begbie. All rights reserved.
//

import UIKit

class PlayerDetailsViewController: UITableViewController {
  
  
  var game:String = "Chess"
  
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var detailLabel: UILabel!
  
  required init(coder aDecoder: NSCoder) {
    println("init PlayerDetailsViewController")
    super.init(coder: aDecoder)
  }
  
  deinit {
    println("deinit PlayerDetailsViewController")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    detailLabel.text = game
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.section == 0 {
      nameTextField.becomeFirstResponder()
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    /*
    if segue.identifier == "SavePlayerDetail" {
      player = Player(name: nameTextField.text, game:game, rating: 1)
    }
    if segue.identifier == "PickGame" {
      if let gamePickerViewController = segue.destinationViewController as? GamePickerViewController {
        gamePickerViewController.selectedGame = game
      }
    }
*/  }
  
  @IBAction func selectedGame(segue:UIStoryboardSegue) {
    /*
    if let gamePickerViewController = segue.sourceViewController as? GamePickerViewController,
      selectedGame = gamePickerViewController.selectedGame {
        detailLabel.text = selectedGame
        game = selectedGame
    }
*/
  }

}
