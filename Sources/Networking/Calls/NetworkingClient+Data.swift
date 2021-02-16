//
//  NetworkingClient+Data.swift
//  
//
//  Created by Sacha on 13/03/2020.
//

import Foundation
import Combine

public extension NetworkingClient {
    
    func get(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        token
            .first()
            .handleEvents(receiveOutput: { token in
                self.headers["Authorization"] = token
            })
            .setFailureType(to: Error.self)
            .flatMap { _ in
                self.request(.get, route, params: params).publisher()
            }
            .eraseToAnyPublisher()
    }
    
    func post(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        token
            .first()
            .handleEvents(receiveOutput: { token in
                self.headers["Authorization"] = token
            })
            .setFailureType(to: Error.self)
            .flatMap { _ in
                self.request(.post, route, params: params).publisher()
            }
            .eraseToAnyPublisher()
    }
    
    func put(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        token
            .first()
            .handleEvents(receiveOutput: { token in
                self.headers["Authorization"] = token
            })
            .setFailureType(to: Error.self)
            .flatMap { _ in
                self.request(.put, route, params: params).publisher()
            }
            .eraseToAnyPublisher()
    }
    
    func patch(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        token
            .first()
            .handleEvents(receiveOutput: { token in
                self.headers["Authorization"] = token
            })
            .setFailureType(to: Error.self)
            .flatMap { _ in
                self.request(.patch, route, params: params).publisher()
            }
            .eraseToAnyPublisher()
    }
    
    func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        token
            .first()
            .handleEvents(receiveOutput: { token in
                self.headers["Authorization"] = token
            })
            .setFailureType(to: Error.self)
            .flatMap { _ in
                self.request(.delete, route, params: params).publisher()
            }
            .eraseToAnyPublisher()
    }
}
