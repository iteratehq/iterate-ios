//
//  DismissedEndpoint.swift
//  Iterate
//
//  Created by Michael Singleton on 6/15/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

extension APIClient {
    func dismissed(survey: Survey, complete: @escaping (Dismissed?, Error?) -> Void) {
        post(path: Paths.Surveys.Dismissed(surveyId: survey.id), data: nil, complete: complete)
    }
}
