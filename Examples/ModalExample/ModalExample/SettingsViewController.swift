//
//  SettingViewController.swift
//  ModalExample
//
//  Created by Michael Singleton on 2/28/20.
//  Copyright © 2020 Iterate. All rights reserved.
//

import UIKit
import IterateSDK

let ApiKeyKey = "com.iteratehq.apikey"
let EnvironmentKey = "com.iteratehq.environment"

enum Environment: Int {
    case Production = 0
    case Development = 1
}

enum EnvironmentUrl: String {
    case Development = "http://localhost:8080"
    case Production = "https://iteratehq.com"
}

class SettingsViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var apiKeyTextField: UITextField!
    @IBOutlet weak var environmentSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiKeyTextField.text = UserDefaults.standard.string(forKey: ApiKeyKey)
        environmentSegmentedControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: EnvironmentKey)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func onApiKeyEditingChanged(_ sender: UITextField) {
        UserDefaults.standard.set(apiKeyTextField.text, forKey: ApiKeyKey)
        
        let apiHost = Environment(rawValue: UserDefaults.standard.integer(forKey: EnvironmentKey)) == Environment.Development ? EnvironmentUrl.Development : EnvironmentUrl.Production
        Iterate.shared.configure(apiKey: apiKeyTextField.text ?? "", apiHost: apiHost.rawValue)
    }
    
    @IBAction func onEnvironmentChanged(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(environmentSegmentedControl.selectedSegmentIndex, forKey: EnvironmentKey)
        
        let apiHost = Environment(rawValue: environmentSegmentedControl.selectedSegmentIndex) == Environment.Development ? EnvironmentUrl.Development : EnvironmentUrl.Production
        Iterate.shared.configure(apiKey: apiKeyTextField.text ?? "", apiHost: apiHost.rawValue)
    }
    
    @IBAction func done(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

