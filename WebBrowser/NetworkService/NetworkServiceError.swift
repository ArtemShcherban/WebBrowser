//
//  NetworkServiceError.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 28.12.2022.
//

import Foundation

enum NetworkServiceError: String, Error {
    case couldnotCreateURL = "Error: Couldn't create bookmark icon URL"
    case httpRequestFailed = "Error: Http Request failed, please try again"
    case unresolvedError = "Error: Unresolved error"
}
