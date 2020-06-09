//
//  ContainerViewController.swift
//  Iterate
//
//  Created by Michael Singleton on 1/3/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    var delegate: ContainerWindowDelegate?
    var promptViewController: PromptViewController?
    var survey: Survey?
    
    @IBOutlet weak var promptView: UIView!
    
    override func viewDidLoad() {
        // Get the prompt child container controller
        if let viewController = children.first as? PromptViewController {
            promptViewController = viewController
            promptViewController?.delegate = delegate
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        promptViewController?.survey = survey
    }
    
    func showPrompt(_ survey: Survey) {
        promptView.isHidden = false
    }
    
    func showSurvey(_ survey: Survey) {
        promptView.isHidden = true
        performSegue(withIdentifier: "showSurvey", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSurvey" {
            let surveyViewController = segue.destination as! SurveyViewController
            surveyViewController.presentationController?.delegate = self
            surveyViewController.survey = survey
        }
    }
}

extension ContainerViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.hideWindow()
    }
}
