//
//  SurveyModalViewController.swift
//  Iterate
//
//  Created by Michael Singleton on 1/8/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import UIKit

class SurveyModalViewController: UIViewController, DisappearableUIViewController {
    var didDisappear: (() -> Void)?
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.didDisappear?()
    }
}

protocol DisappearableUIViewController: UIViewController {
    var didDisappear: (() -> Void)? { get set }
}
