//
//  HTML.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 20.01.2023.
//

import Foundation

enum HTML {
    // swiftlint:disable all
    static func webpageWith(_ error: NSError?) -> String {
        guard let error else { return String() }
        let htmlString = """
            <html>
            <head>
                    <meta http-equiv="content-type" content="text/html; charset=utf-8">
                    <meta name="format-detection" content="telephone=no">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
                    <meta name="disabled-adaptations" content="watch">
                    <style>
                        :root {
                            color-scheme: light dark;
                            --body-text-color: rgb(125, 127, 127);
                        }
            
                        @media (prefers-color-scheme: dark) {
                            :root {
                                --body-text-color: rgb(133, 133, 133);
                            }
                        }
            
                        html {
                            width: 100%;
                        }
            
                        body {
                            -webkit-text-size-adjust: none;
                            -webkit-user-select: none;
                            color: var(--body-text-color);
                            font: -apple-system-short-body;
                            height: 100%;
                            margin: 0;
                            padding: 0;
                        }
            
                        body.watch {
                            align-items: center;
                            background: black;
                            color: white;
                            display: flex;
                            font: -apple-system-body;
                            width: 100%;
                        }
            
                        p {
                            text-align: center;
                            word-wrap: break-word;
                        }
            
                        body:not(.watch) p {
                            padding: 0 50px;
                            margin: 123px auto 0 auto;
                            max-width: 832px;
                        }
            
                        body:not(.watch).preview p {
                            font-size: 5vw;
                        }
            
                        body.watch p {
                            padding: 0;
                            max-width: 100vw;
                        }
            
                        a {
                            font-weight: bold;
                            color: inherit;
                        }
            
                        
                    </style>
                    <title>Cannot Open Page</title>
                    </head>
                    <body>
                        <p>\(error.localizedDescription.description)</p>
            
            
                </body>
            </html>
            """
        return htmlString
    }
}
// swiftlint:enable all
