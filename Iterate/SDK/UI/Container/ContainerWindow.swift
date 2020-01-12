//
//  ContainerWindow.swift
//  Iterate
//
//  Created by Michael Singleton on 1/3/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import UIKit


/// ContainerWindow class is the primary display layer for Iterate, it's a window that sits above the
/// current application window ensuring it an be displayed anywhere at anytime.
class ContainerWindow: UIWindow {
    init() {
        if #available(iOS 13.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                super.init(windowScene: scene)
            } else {
                super.init(frame: UIScreen.main.bounds)
            }
        } else {
            super.init(frame: UIScreen.main.bounds)
        }
        
        alpha = 0.8
        backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Override the hit test to ignore hits on the window itself, this way it will pass through events to underlying views
    /// - Parameters:
    ///   - point: Point of hit
    ///   - event: Event that caused the hit
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        
        return view == self ? nil : view
    }
}
