//
//  NetworkingLogger.swift
//  
//
//  Created by Sacha on 13/03/2020.
//

import Foundation

class NetworkingLogger {
    
    var logLevels = NetworkingLogLevel.off
    
    var logHandler: LogFunction = { message in
        print(message)
    }
    
    func log(request: URLRequest) {
        guard logLevels != .off else {
            return
        }
        if let verb = request.httpMethod,
           let url = request.url {
            logHandler("\(verb) '\(url.absoluteString)'")
            logHeaders(request)
            logBody(request)
        }
    }
    
    func log(response: URLResponse, data: Data) {
        guard logLevels != .off else {
            return
        }
        if let response = response as? HTTPURLResponse {
            logStatusCodeAndURL(response)
        }
        if logLevels == .debug {
            if  let object = try? JSONSerialization.jsonObject(with: data, options: []),
                let json = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted),
                let jsonString = String(data: json, encoding: .utf8) {
                logHandler(jsonString)
            }
        }
    }
    
    private func logHeaders(_ urlRequest: URLRequest) {
        if let allHTTPHeaderFields = urlRequest.allHTTPHeaderFields {
            for (key, value) in allHTTPHeaderFields {
                logHandler("  \(key) : \(value)")
            }
        }
    }
    
    private func logBody(_ urlRequest: URLRequest) {
        if let body = urlRequest.httpBody,
           let str = String(data: body, encoding: .utf8) {
            logHandler("  HttpBody : \(str)")
        }
    }
    
    private func logStatusCodeAndURL(_ urlResponse: HTTPURLResponse) {
        if let url = urlResponse.url {
            logHandler("\(urlResponse.statusCode) '\(url.absoluteString)'")
        }
    }
}
