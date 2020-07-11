//
//  DismissedEndpoint.swift
//  Iterate
//
//  Created by Michael Singleton on 6/15/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

extension APIClient {
    func dismissed(survey: Survey, completion: @escaping (Dismissal?, Error?) -> Void) {
        post(nil, to: Paths.surveys.dismissed(surveyId: survey.id), completion: completion)
    }
}
