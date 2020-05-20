//
//  ViewController.swift
//  ModalExample
//
//  Created by Michael Singleton on 1/2/20.
//  Copyright © 2020 Iterate. All rights reserved.
//

import UIKit
import Iterate

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func showSurvey(_ sender: Any) {
        Iterate.shared.sendEvent(name: Event.ShowSurveyButtonClicked.rawValue)
    }
}

