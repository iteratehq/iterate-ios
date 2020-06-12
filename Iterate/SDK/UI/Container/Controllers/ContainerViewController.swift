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
    @IBOutlet weak var promptViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var promptViewTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        // Get the prompt child container controller
        if let viewController = children.first as? PromptViewController {
            promptViewController = viewController
            promptViewController?.delegate = delegate
        }
        
        promptViewBottomConstraint.isActive = false
        promptViewTopConstraint.isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        promptViewController?.survey = survey
    }
    
    func showPrompt(_ survey: Survey) {
        promptView.isHidden = false
        view.layoutIfNeeded()
        
        let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1) {
            self.promptViewBottomConstraint.isActive = true
            self.promptViewTopConstraint.isActive = false
            
            self.view.layoutIfNeeded()
        }
        
        animator.startAnimation()
    }
    
    func showSurvey(_ survey: Survey) {
        promptView.isHidden = true
        performSegue(withIdentifier: "showSurvey", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSurvey" {
            let surveyViewController = segue.destination as! SurveyViewController
            surveyViewController.presentationController?.delegate = self
            surveyViewController.delegate = delegate
            surveyViewController.survey = survey
        }
    }
}

extension ContainerViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.dismiss(userInitiated: true)
    }
}
