//
//  FavoritesViewController.swift
//  MultiTimer
//
//  Created by edan yachdav on 1/3/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, TimerPickerDelegate {
    private var timersArray = TimerArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func timerCreated(_ timer: MTTimer) {
        
    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Create Fav Timer" {
            let navVC = segue.destination as! UINavigationController
            if let destVC = navVC.topViewController as? TimerPickerViewController {
                destVC.endActionBarButton.title = "Save"
                destVC.nameRequired = true
                destVC.timerPickerDelegate = self
            }
        }
    }
    

}
