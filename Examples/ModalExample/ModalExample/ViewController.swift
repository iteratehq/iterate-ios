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
        Iterate.shared.preview(surveyId: "5efa0121a9fffa0001c70b8d")
        Iterate.shared.sendEvent(name: Event.ShowSurveyButtonTapped.rawValue)
    }
    
    @IBAction func login(_ sender: Any) {
        Iterate.shared.identify(userProperties: [
            "first_name": UserPropertyValue("Test"),
            "last_name": UserPropertyValue("User"),
            "account_id": UserPropertyValue(123)
        ])
        Iterate.shared.identify(responseProperties: [
            "exampleString": ResponsePropertyValue("string value"),
            "exampleNumber": ResponsePropertyValue(123),
            "exampleBoolean": ResponsePropertyValue(true),
        ])
    }
    
    @IBAction func logout(_ sender: Any) {
        Iterate.shared.reset()
    }
}

