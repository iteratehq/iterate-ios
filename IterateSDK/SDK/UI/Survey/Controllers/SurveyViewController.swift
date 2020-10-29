//
//  SurveyModalViewController.swift
//  Iterate
//
//  Created by Michael Singleton on 1/8/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import UIKit
import WebKit

final class SurveyViewController: UIViewController {
    @objc dynamic private var webView: WKWebView!
    @IBOutlet weak private var loadingView: UIView!
    @IBOutlet weak private var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLoadingLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    
    var delegate: ContainerWindowDelegate?
    var observation: NSKeyValueObservation?
    var survey: Survey? {
        willSet(newSurvey) {
            guard survey == nil else {
                assertionFailure("Survey shouldn't be set more than once")
                return
            }
        }
    }
    
    private let MessageHandlerName = "iterateMessageHandler"
    
    override func viewDidLoad() {
        super.loadView()
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController.add(self, name: MessageHandlerName)

        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        // Show the survey once the webview has loaded
        observation = observe(\.webView.isLoading, options: [.old, .new]) { object, change in
            if let isLoading = change.newValue, !isLoading {
                let animator = UIViewPropertyAnimator(duration: 0.3, curve: .linear) {
                    self.loadingView.alpha = 0
                }
                animator.startAnimation()
            }
        }
        
        loadingView.frame = view.frame
        if #available(iOS 13.0, *) {
            loadingIndicator.style = .medium
        } else {
            loadingIndicator.style = .gray
        } 
        view.bringSubviewToFront(loadingView)
        view.bringSubviewToFront(errorLoadingLabel)
        view.bringSubviewToFront(closeButton)
        
        
        if let survey = survey {
            let host = Iterate.shared.apiHost ?? Iterate.DefaultAPIHost
            
            var params: [String] = []
            
            // Include the user's auth token as a query param. The web view
            // will use this token to authorize API calls
            if let authToken = Iterate.shared.userApiKey {
                params.append("auth_token=\(authToken)")
            }
            
            // Include response properties. These are in the format of response_[type]_[name]=[value]
            // e.g. response_number_userId=123
            if let responseProperties = Iterate.shared.responseProperties {
                params.append(contentsOf: responseProperties.map {
                    let value = "\($0.value.value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    return "response\($0.value.typeString())_\($0.key)=\(value)" })
            }
            
            let url = "\(host)/\(survey.companyId)/\(survey.id)/mobile?\(params.joined(separator: "&"))"
            let myRequest = URLRequest(url: URL(string: url)!)
            webView.load(myRequest)
        }
    }
    
    @IBAction func closeSurvey(_ sender: Any) {
        delegate?.dismissSurvey()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.surveyDismissed(survey: survey)
    }
}

private enum MessageType: String {
    case close = "close"
}

extension SurveyViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == MessageHandlerName {
            guard let body = message.body as? [String: AnyObject],
                let messageType = MessageType(rawValue:body["type"] as? String ?? "") else {
                return
            }
            
            switch messageType {
            case .close:
                delegate?.dismissSurvey()
            }
        }
    }
}

extension SurveyViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            loadingView.isHidden = true
            errorLoadingLabel.isHidden = false
            closeButton.isHidden = false
    }
}
