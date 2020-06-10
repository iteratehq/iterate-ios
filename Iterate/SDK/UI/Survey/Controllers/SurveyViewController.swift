//
//  SurveyModalViewController.swift
//  Iterate
//
//  Created by Michael Singleton on 1/8/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import UIKit
import WebKit

class SurveyViewController: UIViewController {
    var survey: Survey?
    
    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let survey = survey {
            let host = Iterate.shared.apiHost ?? DefaultAPIHost
            let myRequest = URLRequest(url: URL(string:"\(host)/\(survey.companyId)/\(survey.id)/mobile")!)
            webview.load(myRequest)
        }
    }
}
