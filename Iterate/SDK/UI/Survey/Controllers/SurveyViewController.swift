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
    var webView: WKWebView!
    
    var delegate: ContainerWindowDelegate?
    var survey: Survey?
    
    let MessageHandlerName = "iterateMessageHandler"
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController.add(self, name: MessageHandlerName)
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let survey = survey {
            let host = Iterate.shared.apiHost ?? DefaultAPIHost
            let myRequest = URLRequest(url: URL(string:"\(host)/\(survey.companyId)/\(survey.id)/mobile")!)
            webView.load(myRequest)
        }
    }
}

enum MessageType: String {
    case Close = "close"
}

extension SurveyViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == MessageHandlerName {
            guard let body = message.body as? [String: AnyObject],
                let messageType = MessageType(rawValue:body["type"] as? String ?? ""),
                let data = body["data"] as? [String: AnyObject] else {
                return
            }
            
            switch messageType {
            case .Close:
                let userInitiated = data["userInitiated"] as? Bool ?? false
                delegate?.dismiss(userInitiated: userInitiated)
            }
        }
    }
}
