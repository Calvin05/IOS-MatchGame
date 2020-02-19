//
//  ViewController1.swift
//  MatchGame
//
//  Created by Cường Nguyễn on 2018-11-06.
//  Copyright © 2018 Cuong Nguyen. All rights reserved.
//

import UIKit

class ViewController1: UIViewController {

    var value:Float = 0
    @IBOutlet weak var lb1: UILabel!
    
    @IBOutlet weak var sg: UISegmentedControl!
    
    @IBAction func sgAction(_ sender: Any) {
        switch  sg.selectedSegmentIndex {
        case 0:
            value = 60000
        case 1:
            value = 40000
        case 2:
            value = 25000
        default:
            value = 40000
        }
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "sendData", sender: self)
        print(value)
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "sendData" {
            let secondVC = segue.destination as! ViewController
            secondVC.milliseconds = value
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
