//
//  DisplayedEndpoint.swift
//  Iterate
//
//  Created by Michael Singleton on 6/15/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

extension APIClient {
    func displayed(survey: Survey, complete: @escaping (Displayed?, Error?) -> Void) {
        post(path: Paths.Surveys.Displayed(surveyId: survey.id), data: nil, complete: complete)
    }
}
