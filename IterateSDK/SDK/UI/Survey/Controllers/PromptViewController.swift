//
//  PromptViewController.swift
//  Iterate
//
//  Created by Michael Singleton on 6/8/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import UIKit

final class PromptViewController: UIViewController {
    @IBOutlet weak private var promptLabel: UILabel?
    @IBOutlet weak private var promptButton: UIButton?
    
    var delegate: ContainerWindowDelegate?
    var survey: Survey? {
        didSet {
            preparePrompt()
        }
    }
    
    override func viewDidLoad() {
        preparePrompt()
        
        // Override interface style until the full survey interface properly supports dark mode
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        // Allow the container view to be dynamically sized by the parent
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func preparePrompt() {
        guard let promptLabel = promptLabel,
            let promptButton = promptButton else {
                return
        }
        
        promptLabel.text = survey?.prompt?.message
        promptButton.setTitle(survey?.prompt?.buttonText, for: .normal)
        if let color = survey?.colorHex {
            promptButton.backgroundColor = UIColor(hex: color)
        }
    }
    
    @IBAction func showSurvey(_ sender: Any) {
        guard let survey = survey else {
            assertionFailure("Survey not set")
            return
        }
        
        delegate?.showSurvey(survey)
    }
    @IBAction func close(_ sender: Any) {
        delegate?.dismissPrompt(survey: survey, userInitiated: true)
    }
}
