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
        promptViewBottomConstraint.constant = 0
        promptViewController?.survey = survey
    }
    
    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        if (promptViewBottomConstraint.constant + translation.y) > 0 {
            promptViewBottomConstraint.constant = promptViewBottomConstraint.constant + translation.y
        }
        
        gesture.setTranslation(.zero, in: view)
        
        guard gesture.state == .ended else {
            return
        }
        
        promptViewBottomConstraint.constant > 25 ? hidePrompt() : showPrompt()
    }
    
    func showPrompt() {
        promptView.isHidden = false
        self.promptViewBottomConstraint.constant = promptViewController?.view.frame.height ?? 300
        self.promptViewBottomConstraint.isActive = true
        self.promptViewTopConstraint.isActive = false
        view.layoutIfNeeded()
        
        let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1) {
            self.promptViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        
        animator.startAnimation()
    }
    
    func hidePrompt(complete: (() -> Void)? = nil) {
        view.layoutIfNeeded()
        let animator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1) {
            self.promptViewBottomConstraint.constant = 0
            self.promptViewBottomConstraint.isActive = false
            self.promptViewTopConstraint.isActive = true
            
            self.view.layoutIfNeeded()
        }
        
        if let complete = complete {
            animator.addCompletion { (_ UIViewAnimatingPosition) in
                complete()
            }
        }
        
        animator.startAnimation()
    }
    
    func showSurvey(_ survey: Survey) {
        performSegue(withIdentifier: "showSurvey", sender: self)
    }
    
    func hideSurvey(complete: (() -> Void)? = nil) {
        dismiss(animated: true, completion: complete)
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
        delegate?.dismissSurvey(userInitiated: true)
    }
}
