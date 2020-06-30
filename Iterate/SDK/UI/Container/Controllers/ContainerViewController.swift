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
    var isSurveyDisplayed: Bool?
    
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
        
        promptViewBottomConstraint.constant > 25 ? hidePrompt() : showPrompt()
    }
    
    func showPrompt(complete: (() -> Void)? = nil) {
        promptView.isHidden = false
        self.promptViewBottomConstraint.constant = promptViewController?.view.frame.height ?? 300
        self.promptViewBottomConstraint.isActive = true
        self.promptViewTopConstraint.isActive = false
        view.layoutIfNeeded()
        
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
}
