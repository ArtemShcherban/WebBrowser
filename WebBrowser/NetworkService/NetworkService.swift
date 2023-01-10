//
//  NetworkService.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 28.12.2022.
//

import Foundation

final class NetworkService {
    static var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60.0
        configuration.timeoutIntervalForResource = 30.0
        let urlSeession = URLSession(configuration: configuration)
        
        return urlSeession
    }()
    let urlModel = URLModel()
    
    func loadIconData(
        for domain: String,
        complition: @escaping ((Result<Data, NetworkServiceError>) -> Void)
    ) {
        guard let url = urlModel.horeseFavoriteIconURL(for: domain) else {
            complition(.failure(NetworkServiceError.couldnotCreateURL))
            return
        }        
        Task {
            do {
                let (data, urlResponse) = try await NetworkService.urlSession.data(for: URLRequest(url: url))
                guard
                    let httpURLResponse = urlResponse as? HTTPURLResponse,
                    (200..<300).contains(httpURLResponse.statusCode) else {
                    complition(.failure(NetworkServiceError.httpRequestFailed))
                    return
                }
                complition(.success(data))
            } catch {
                complition(.failure(NetworkServiceError.unresolvedError))
            }
        }
    }
}
