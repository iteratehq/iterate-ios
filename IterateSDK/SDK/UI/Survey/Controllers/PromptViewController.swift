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
    @IBOutlet weak var closeButton: UIButton!
    
    var delegate: ContainerWindowDelegate?
    var survey: Survey? {
        didSet {
            preparePrompt()
        }
    }
    
    override func viewDidLoad() {
        preparePrompt()
        prepareStyle()
        
        // Allow the container view to be dynamically sized by the parent
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        prepareStyle()
    }
    
    private func prepareStyle() {
        guard let promptButton = promptButton else {
            return
        }
        
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = UIColor(hex: Colors.LightBlack.rawValue)
            self.closeButton.backgroundColor = UIColor(hex: Colors.LightBlack.rawValue)
            if let darkColor = survey?.colorDarkHex ?? survey?.colorHex {
                promptButton.backgroundColor = UIColor(hex: darkColor)
            }
        } else {
            view.backgroundColor = UIColor.white
            if let color = survey?.colorHex {
                promptButton.backgroundColor = UIColor(hex: color)
            }
        }
    }

    private func preparePrompt() {
        guard let promptLabel = promptLabel,
            let promptButton = promptButton else {
                return
        }
        
        promptLabel.text = survey?.prompt?.message
        promptButton.setTitle(survey?.prompt?.buttonText, for: .normal)
        if let surveyTextFontName = Iterate.shared.surveyTextFontName {
            let uiFont = UIFont(name: surveyTextFontName, size: 16.0)
            promptLabel.font = uiFont
        }
        
        if let titleLabel = promptButton.titleLabel, let buttonFontName = Iterate.shared.buttonFontName {
            let uiFont = UIFont(name: buttonFontName, size: 16.0)
            titleLabel.font = uiFont
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
