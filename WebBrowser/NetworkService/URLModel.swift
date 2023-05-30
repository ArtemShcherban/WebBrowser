//
//  URLModel.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 10.01.2023.
//

import Foundation

final class URLModel {
    func googleFavoriteIconURL(for domain: String) -> URL? {
        var components = URLComponents()
        components.scheme = URLConstants.GoogleFavoriteIcon.scheme
        components.host = URLConstants.GoogleFavoriteIcon.host
        components.path = URLConstants.GoogleFavoriteIcon.path
        let queryItemQuery = URLQueryItem(name: URLConstants.GoogleFavoriteIcon.query, value: domain)
        let queryItemSize = URLQueryItem(
            name: URLConstants.GoogleFavoriteIcon.iconSize, value: URLConstants.GoogleFavoriteIcon.sixtyFour)
        components.queryItems = [queryItemQuery, queryItemSize]
        let url = components.url
        return url
    }
    
    func horseFavoriteIconURL(for domain: String) -> URL? {
        var components = URLComponents()
        components.scheme = URLConstants.IconHorseFavoriteIcon.scheme
        components.host = URLConstants.IconHorseFavoriteIcon.host
        components.path = URLConstants.IconHorseFavoriteIcon.path
        let url = components.url?.appendingPathComponent(domain)
        return url
    }
}
