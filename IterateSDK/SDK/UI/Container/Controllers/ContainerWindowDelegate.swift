//
//  ContainerWindowDelegate.swift
//  Iterate
//
//  Created by Michael Singleton on 6/9/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import UIKit

final class ContainerWindowDelegate {
    private var window: PassthroughWindow?
    private var containerViewController: ContainerViewController? {
        window?.rootViewController as? ContainerViewController
    }
    var isSurveyOrPromptDisplayed: Bool?
    
    /// Show the window
    func showWindow(survey: Survey) {
        if window == nil {
            window = PassthroughWindow(survey: survey, delegate: self)
        }
        
        window?.isHidden = false
    }
    
    /// Hide the window
    func hideWindow() {
        window?.isHidden = true
        window = nil
        isSurveyOrPromptDisplayed = false
    }
    
    /// Show either the prompt (if there is one) or the survey
    func show(_ survey: Survey) {
        // Don't show another survey if we're already showing one
        if let isSurveyOrPromptDisplayed = isSurveyOrPromptDisplayed, isSurveyOrPromptDisplayed {
            return
        }
        
        isSurveyOrPromptDisplayed = true
        
        if survey.prompt != nil {
            showPrompt(survey)
        } else {
            showSurvey(survey)
        }
        
        Iterate.shared.api?.displayed(survey: survey, completion: { _, _ in })
    }
    
    func showPrompt(_ survey: Survey) {
        self.showWindow(survey: survey)
        self.containerViewController?.showPrompt()
    }
        
    func showSurvey(_ survey: Survey) {
        // Hide the prompt
        self.containerViewController?.hidePrompt()
        
        guard let surveyViewController = self.makeSurveyViewController() else {
            return
        }
        
        self.containerViewController?.isSurveyDisplayed = true
        self.containerViewController?.setNeedsStatusBarAppearanceUpdate()
        
        // Show the survey
        surveyViewController.survey = survey
        surveyViewController.delegate = self
        self.getPresentingViewController()?.present(surveyViewController, animated: true, completion: nil)
    }
    
    func dismissPrompt(survey: Survey?, userInitiated: Bool) {
        if let survey = survey, userInitiated {
            Iterate.shared.api?.dismissed(survey: survey, completion: { _, _ in })
        }
        
        containerViewController?.hidePrompt(complete: {
            self.hideWindow()
        })
    }
    
    /// Dismiss the survey, called when the user clicks the 'X' within the survey
    func dismissSurvey() {
        self.getPresentingViewController()?.dismiss(animated: true)
    }
    
    /// Called once a survey has been dismissed, this can happen if a user clicks the 'X' within a survey
    /// or drags down on the modal view
    func surveyDismissed(survey: Survey?) {
        if let survey = survey {
            Iterate.shared.api?.dismissed(survey: survey, completion: { _, _ in })
        }
        
        self.containerViewController?.isSurveyDisplayed = false
        self.hideWindow()
    }
    
    /// Get the currently visible view controller which we will use to modally present the survey and fall back to our container view controller
    func getPresentingViewController() -> UIViewController? {
        // Find the first key window that is not our own passthrough window
        var window = UIApplication.shared.windows.first { $0.isKeyWindow && $0 != self.window }
        // If we didn't find one, get the first non-key window since our window may be key (happens in iOS 14.2)
        if window == nil {
           window = UIApplication.shared.windows.first { $0 != self.window }
        }
        
        var visibleViewController = window?.rootViewController
        
        if visibleViewController == nil {
            return containerViewController
        }
        
        while visibleViewController?.presentedViewController != nil {
            switch visibleViewController?.presentedViewController {
                case let navigationController as UINavigationController:
                    visibleViewController = navigationController.visibleViewController
            case let tabBarController as UITabBarController:
                visibleViewController = tabBarController.selectedViewController
            default:
                visibleViewController = visibleViewController?.presentedViewController
            }
        }
        
        return visibleViewController
    }
    
    private func makeSurveyViewController() -> SurveyViewController? {
       return UIStoryboard(
            name: "Surveys",
            bundle: Iterate.shared.bundle
        ).instantiateViewController(withIdentifier: "SurveyModalViewController") as? SurveyViewController
    }
}
