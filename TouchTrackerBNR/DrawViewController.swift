//
//  ViewController.swift
//  TouchTrackerBNR
//
//  Created by Anatoliy Chernyuk on 1/10/18.
//  Copyright © 2018 Anatoliy Chernyuk. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let view = self.view as! DrawView
        view.swipeRecognizer.addTarget(self, action: #selector(swipe))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowColorPanel" {
            let controller = segue.destination as! ColorPanelViewController
            controller.theView = self.view as! DrawView
        }
    }
    
    @objc func swipe() {
        print("swipe")
        performSegue(withIdentifier: "ShowColorPanel", sender: self.view)
    }
}

