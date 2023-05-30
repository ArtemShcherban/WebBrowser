//
//  NetworkService.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 28.12.2022.
//

import Foundation
import RxSwift
import RxCocoa

final class IconNetworkService {
    private var relay = BehaviorRelay<UIImage?>(value: nil)
    var favoriteIconRelay: BehaviorRelay<UIImage?> {
        relay
    }
    
    static var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60.0
        configuration.timeoutIntervalForResource = 30.0
        let urlSeession = URLSession(configuration: configuration)

        return urlSeession
    }()
    let urlModel = URLModel()
    private let disposeBag = DisposeBag()
    
    func loadIconData(with url: URL, forBookmark: Bool = false) throws {
        let response = Observable.from([url])
            .map { [weak self] url -> URLRequest? in
                guard
                    let self,
                    let host = url.host,
                    let horseURL = self.urlModel.horseFavoriteIconURL(for: host) else {
                    throw NetworkServiceError.couldNotCreateURL
                }
                return URLRequest(url: horseURL)
            }
            .compactMap { $0 }
            .flatMap { urlRequest -> Observable<(response: HTTPURLResponse, data: Data)> in
                IconNetworkService.urlSession.rx.response(request: urlRequest)
            }
            .share(replay: 1)
        response
            .map { response, data in
                guard  200..<300 ~= response.statusCode else {
                    throw NetworkServiceError.httpRequestFailed
                }
                return data
            }
            .subscribe { [weak self] data in
                guard
                    let self,
                    let image = UIImage(data: data) else {
                    return
                }
                guard !forBookmark else {
                    self.relay.accept(image)
                    return
                }
                
                guard let icon = image.changeSizeTo(width: 16, height: 16) else { return }
                self.favoriteIconRelay.accept(icon)
            }
            .disposed(by: disposeBag)
    }
}
