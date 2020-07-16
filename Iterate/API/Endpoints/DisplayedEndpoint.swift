//
//  DisplayedEndpoint.swift
//  Iterate
//
//  Created by Michael Singleton on 6/15/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

extension APIClient {
    func displayed(survey: Survey, completion: @escaping (Displayed?, Error?) -> Void) {
        post(nil, to: Paths.surveys.displayed(surveyId: survey.id), completion: completion)
    }
}
