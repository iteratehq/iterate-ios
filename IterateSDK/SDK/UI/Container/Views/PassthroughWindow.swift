//
//  PassthroughWindow.swift
//  Iterate
//
//  Created by Michael Singleton on 1/3/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import UIKit


/// PassthroughWindow class is the primary display layer for Iterate, it's a window that sits above the
/// current application window ensuring it an be displayed anywhere at anytime.
final class PassthroughWindow: UIWindow {
    init(survey: Survey, delegate: ContainerWindowDelegate) {
        let presentingWindow = PassthroughWindow.frontmostApplicationWindow()

        if #available(iOS 13.0, *) {
            let fallbackScene = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first { $0.activationState == .foregroundActive }

            if let scene = presentingWindow?.windowScene ?? fallbackScene {
                super.init(windowScene: scene)
            } else {
                super.init(frame: UIScreen.main.bounds)
            }
        } else {
            super.init(frame: UIScreen.main.bounds)
        }

        windowLevel = PassthroughWindow.promptWindowLevel(above: presentingWindow?.windowLevel)
        
        // Initialize the root view controller
        if let containerViewController = UIStoryboard(
            name: "Surveys",
            bundle: Iterate.shared.bundle
        ).instantiateViewController(withIdentifier: "ContainerViewController") as? ContainerViewController {
            containerViewController.survey = survey
            containerViewController.delegate = delegate
            self.rootViewController = containerViewController
        }
        
        isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init from coder not supported")
    }

    static func promptWindowLevel(above windowLevel: UIWindow.Level?) -> UIWindow.Level {
        let normalWindowLevel = UIWindow.Level.normal.rawValue
        let desiredWindowLevel = (windowLevel?.rawValue ?? normalWindowLevel) + 1
        let maximumPromptWindowLevel = UIWindow.Level.alert.rawValue - 1

        return UIWindow.Level(rawValue: min(desiredWindowLevel, maximumPromptWindowLevel))
    }
    
    /// Override the hit test to ignore hits on the window itself, this way it will pass through events to underlying views
    /// - Parameters:
    ///   - point: Point of hit
    ///   - event: Event that caused the hit
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let rootViewController = self.rootViewController else {
            return nil
        }
        
        if let view = rootViewController.view.hitTest(point, with: event) {
            return view
        }
        
        return nil
    }

    private static func frontmostApplicationWindow() -> UIWindow? {
        let maximumPromptWindowLevel = UIWindow.Level.alert.rawValue - 1

        return UIApplication.shared.windows
            .filter {
                !$0.isHidden &&
                    $0.rootViewController != nil &&
                    !($0 is PassthroughWindow) &&
                    $0.windowLevel.rawValue < maximumPromptWindowLevel
            }
            .max { lhs, rhs in
                if lhs.windowLevel == rhs.windowLevel {
                    return !lhs.isKeyWindow && rhs.isKeyWindow
                }

                return lhs.windowLevel.rawValue < rhs.windowLevel.rawValue
            }
    }
}
