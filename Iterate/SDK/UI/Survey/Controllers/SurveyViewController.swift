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
    @objc dynamic var webView: WKWebView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var delegate: ContainerWindowDelegate?
    var survey: Survey?
    
    let MessageHandlerName = "iterateMessageHandler"
    
    override func loadView() {
        super.loadView()
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController.add(self, name: MessageHandlerName)

        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
        addObserver(self, forKeyPath: #keyPath(webView.isLoading), options: [.old, .new], context: nil)
        
        loadingView.frame = view.frame
        if #available(iOS 13.0, *) {
            loadingIndicator.style = .medium
        } else {
            loadingIndicator.style = .gray
        } 
        view.bringSubviewToFront(loadingView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let survey = survey {
            let host = Iterate.shared.apiHost ?? DefaultAPIHost
            
            // Include the user's auth token as a query param. The web view
            // will use this token to authorize API calls
            var authTokenParam = ""
            if let authToken = Iterate.shared.userApiKey {
                authTokenParam = "auth_token=\(authToken)"
            }
            
            let myRequest = URLRequest(url: URL(string:"\(host)/\(survey.companyId)/\(survey.id)/mobile?\(authTokenParam)")!)
            webView.load(myRequest)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.surveyDismissed(survey: survey)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(webView.isLoading) {
            if let change = change,
                let isLoading = change[.newKey] as? Bool {
                if !isLoading {
                    let animator = UIViewPropertyAnimator(duration: 1.0, dampingRatio: 1) {
                        self.loadingView.alpha = 0
                    }
                    animator.startAnimation()
                }
            }
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
                let messageType = MessageType(rawValue:body["type"] as? String ?? "") else {
                return
            }
            
            switch messageType {
            case .Close:
                delegate?.dismissSurvey()
            }
        }
    }
}
