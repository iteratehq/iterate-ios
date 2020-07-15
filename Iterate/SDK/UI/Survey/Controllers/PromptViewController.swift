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
    
    override func loadView() {
        super.loadView()
        
        // Allow the container view to be dynamically sized by the parent 
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    override func viewWillAppear(_ animated: Bool) {
        promptLabel.text = survey?.prompt?.message
        promptButton.setTitle(survey?.prompt?.buttonText, for: .normal)
        if let color = survey?.color {
            promptButton.backgroundColor = UIColor(hex: color)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // TODO: Call API displayed here
    }

    @IBAction func showSurvey(_ sender: Any) {
        if let survey = survey {
            delegate?.showSurvey(survey)
        }
    }
    @IBAction func close(_ sender: Any) {
        delegate?.dismissPrompt(survey: survey, userInitiated: true)
    }
}
