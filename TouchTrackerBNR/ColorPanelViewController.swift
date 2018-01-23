//
//  ColorPanelViewController.swift
//  TouchTrackerBNR
//
//  Created by Anatoliy Chernyuk on 1/23/18.
//  Copyright © 2018 Anatoliy Chernyuk. All rights reserved.
//

import UIKit

class ColorPanelViewController: UIViewController {
    var preferredColor: UIColor?
    var theView: DrawView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        let tag = sender.tag
        switch tag {
        case 1:
            theView.chosenColor = UIColor.blue
        case 2:
            theView.chosenColor = UIColor.yellow
        case 3:
            theView.chosenColor = UIColor.orange
        case 4:
            theView.chosenColor = UIColor.purple
        case 5:
            theView.chosenColor = UIColor.green
        case 6:
            theView.chosenColor = UIColor.red
        case 7:
            theView.chosenColor = UIColor.cyan
        default:
            theView.chosenColor = nil
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
