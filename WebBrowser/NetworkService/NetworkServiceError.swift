//
//  NetworkServiceError.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 28.12.2022.
//

import Foundation

enum NetworkServiceError: String, Error {
    case couldNotCreateURL = "Error: Couldn't create bookmark icon URL"
    case httpRequestFailed = "Error: Http Request failed, please try again"
    case couldNotCreateUIImage = "Error: Couldn't create favorite icon"
    case unresolvedError = "Error: Unresolved error"
}
