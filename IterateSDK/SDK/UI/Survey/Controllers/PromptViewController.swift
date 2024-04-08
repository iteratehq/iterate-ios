//
//  PromptViewController.swift
//  Iterate
//
//  Created by Michael Singleton on 6/8/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import UIKit
import Markdown

final class PromptViewController: UIViewController {
    @IBOutlet weak var promptView: UITextView!
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
                promptView.textColor = UIColor.white
                // Color for links in markdown
                promptView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(hex: darkColor)]
            }
        } else {
            view.backgroundColor = UIColor.white
            if let color = survey?.colorHex {
                promptButton.backgroundColor = UIColor(hex: color)
                // Color for links in markdown
                promptView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(hex: color)]
            }
        }
    }

    private func preparePrompt() {
        guard let promptView = promptView,
            let promptButton = promptButton else {
                return
        }
        
        var markdownRenderer = MarkdownRenderer(withFontName: Iterate.shared.surveyTextFontName)
        // Logic to re-render the view, this is needed when async tasks like image downloads finish. Attributed text doesn't automatically
        // update when attachments are changed, so we just re-set the attributed text to force a re-render.
        markdownRenderer.rerender = {
            DispatchQueue.main.async {
                promptView.attributedText = markdownRenderer.attributedString(from: Document(parsing: self.survey?.prompt?.message ?? ""))
            }
        }
        promptView.attributedText = markdownRenderer.attributedString(from: Document(parsing: survey?.prompt?.message ?? ""))
        

        promptButton.setTitle(survey?.prompt?.buttonText, for: .normal)
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

// This is a small helper view that we use for the prompt view to remove
// the default insets on the standard UITextView
@IBDesignable class UITextViewFixed: UITextView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    func setup() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }
}
