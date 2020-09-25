//
//  ContainerViewController.swift
//  Iterate
//
//  Created by Michael Singleton on 1/3/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import UIKit

final class ContainerViewController: UIViewController {
    var delegate: ContainerWindowDelegate?
    private var promptViewController: PromptViewController?
    var survey: Survey?
    var isSurveyDisplayed: Bool?
    
    @IBOutlet weak private var promptView: UIView!
    @IBOutlet weak private var promptViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private var promptViewTopConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        promptViewBottomConstraint.constant = 0
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let isSurveyDisplayed = isSurveyDisplayed,
            isSurveyDisplayed {
            return .lightContent
        }
        
        return .default
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
        
        if promptViewBottomConstraint.constant > 25 {
            delegate?.dismissPrompt(survey: survey, userInitiated: true)
        } else {
            let animator = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 1) {
                self.promptViewBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
            animator.startAnimation()
        }
    }
    
    func showPrompt(complete: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.promptView.isHidden = false
            self.promptViewBottomConstraint.constant = self.promptViewController?.view.frame.height ?? 300
            self.promptViewBottomConstraint.isActive = true
            self.promptViewTopConstraint.isActive = false
            self.view.layoutIfNeeded()
            
            let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1) {
                self.promptViewBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
            
            if let complete = complete {
                animator.addCompletion { (_ UIViewAnimatingPosition) in
                    complete()
                }
            }
            
            animator.startAnimation()
        }
    }
    
    func hidePrompt(complete: (() -> Void)? = nil) {
        view.layoutIfNeeded()
        let animator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1) {
            self.promptViewBottomConstraint.constant = 0
            self.promptViewBottomConstraint.isActive = false
            self.promptViewTopConstraint.isActive = true
            self.view.layoutIfNeeded()
        }
        
        animator.addCompletion { (_ UIViewAnimatingPosition) in
            self.promptView.isHidden = true
        }
        
        if let complete = complete {
            animator.addCompletion { (_ UIViewAnimatingPosition) in
                complete()
            }
        }
        
        animator.startAnimation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "promptViewControllerSegue") {
            promptViewController = segue.destination as? PromptViewController
            promptViewController?.delegate = delegate
            promptViewController?.survey = survey
        }
    }
}
