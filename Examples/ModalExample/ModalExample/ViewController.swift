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
        
        prepareStyle()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        prepareStyle()
    }
    
    private func prepareStyle() {
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = UIColor.black
        } else {
            view.backgroundColor = UIColor.white
        }
    }

    @IBAction func showSurvey(_ sender: Any) {
        Iterate.shared.sendEvent(name: Event.ShowSurveyButtonTapped.rawValue)
    }
    
    @IBAction func login(_ sender: Any) {
        Iterate.shared.identify(userProperties: [
            "first_name": UserPropertyValue("Test"),
            "last_name": UserPropertyValue("User"),
            "account_id": UserPropertyValue(123),
            "date_joined": UserPropertyValue(Calendar.current.date(from: DateComponents(year: 2023, month: 5, day: 12))!
),
        ])
        Iterate.shared.identify(responseProperties: [
            "exampleString": ResponsePropertyValue("string & value"),
            "exampleNumber": ResponsePropertyValue(123),
            "exampleBoolean": ResponsePropertyValue(true),
            "exampleDate": ResponsePropertyValue(Calendar.current.date(from: DateComponents(year: 2023, month: 5, day: 13))!)
        ])
    }
    
    @IBAction func logout(_ sender: Any) {
        Iterate.shared.reset()
    }
}

