//
//  ContainerProvider.swift
//  Iterate
//
//  Created by Michael Singleton on 1/6/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import UIKit

/// Manage the UI of the containing window. This include responsibilityies like showing and hiding the window
/// as well as 
class ContainerWindowProvider {
    
    /// The containing window where all Iterate UI will be displayed. It's contained in a separate window to avoid
    /// conflicting with any UI in the underlying app and to ensure it can be displayed anywhere in the app at anytime
    var window: ContainerWindow?
    
    /// Present the view controller as a modal
    /// - Parameters:
    ///   - viewController: view controller to present
    ///   - animated: animate the display
    ///   - completion: callback after the animation has completed
    func present(_ viewController: DisappearableUIViewController, animated: Bool, completion: (() -> Void)?) {
        DispatchQueue.main.async {
            // When the presented view controller disappears, hide the container window
            viewController.didDisappear = self.hide
            
            self.show()
            self.window?.rootViewController?.present(viewController, animated: animated, completion: completion)
        }
    }
    
    
    /// Configure ensures the window and root view controller are initialized. We can't do this in init() since the window
    /// must be created later in the lifecycle
    func configure() {
        if window == nil {
            window = ContainerWindow()
            window?.rootViewController = UIStoryboard(
                name: "Surveys",
                bundle: Bundle(identifier: "com.iteratehq.Iterate")
            ).instantiateViewController(withIdentifier: "ContainerViewController")
        }
    }
    
    /// Show the window
    func show() {
        self.configure()
        self.window?.isHidden = false
    }
    
    /// Hide the window
    func hide() {
        self.window?.isHidden = true
    }
    
}
