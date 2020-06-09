//
//  PromptViewController.swift
//  Iterate
//
//  Created by Michael Singleton on 6/8/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import UIKit

class PromptViewController: UIViewController {
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var promptButton: UIButton!
    
    var delegate: ContainerWindowDelegate?
    var survey: Survey?

    override func viewWillAppear(_ animated: Bool) {
        promptLabel.text = survey?.prompt?.message
        promptButton.setTitle(survey?.prompt?.buttonText, for: .normal) 
    }

    @IBAction func showSurvey(_ sender: Any) {
        if let survey = survey {
            delegate?.showSurvey(survey)
        }
    }
}
