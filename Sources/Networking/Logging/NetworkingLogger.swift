//
//  NetworkingLogger.swift
//  
//
//  Created by Sacha on 13/03/2020.
//

import Foundation

class NetworkingLogger {
    
    var logLevels = NetworkingLogLevel.off
    
    var logHandler: NetworkingLogFunction = { message in
        print(message)
    }
    
    func log(request: URLRequest, response: URLResponse, data: Data) {
        guard logLevels != .off else {
            return
        }
        
        if let verb = request.httpMethod,
           let url = request.url {
            var logString = "------------------------\n"
            logString.append("Request: \(verb) '\(url.absoluteString)'\n")
            if let allHTTPHeaderFields = request.allHTTPHeaderFields {
                logString.append("Headers: [\n")
                for (key, value) in allHTTPHeaderFields {
                    logString.append("    \(key) : \(value)\n")
                }
                logString.append("]\n")
            }
            if let body = request.httpBody,
               let str = String(data: body, encoding: .utf8) {
                logString.append("Request Body : \(str)\n")
            }
            logString.append("------------------------\n")
            if let response = response as? HTTPURLResponse {
                logString.append("Status: \(response.statusCode)'\n")
            }
            if  let object = try? JSONSerialization.jsonObject(with: data, options: []),
                let json = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted),
                let jsonString = String(data: json, encoding: .utf8) {
                logString.append("JSON: \(jsonString)")
            }
        }
        
    }
    
}
