//
//  NetworkingService.swift
//  
//
//  Created by Sacha on 13/03/2020.
//

import Foundation
import Combine

public protocol NetworkingService {
    var network: NetworkingClient { get }
    var tokenSubject: AnyPublisher<String?, Error>? { get set }
}

// Sugar, just forward calls to underlying network client

public extension NetworkingService {
    
    func addToken() -> AnyPublisher<Void, Error> {
        Deferred<AnyPublisher<Void, Error>>(createPublisher: {
            guard let token = tokenSubject else {
                return Just(Void()).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            return token.first()
                .handleEvents(receiveOutput: { [network] token in
                    network.headers["Authorization"] = token
                })
                .map { _ in Void() }
                .eraseToAnyPublisher()
        })
        .eraseToAnyPublisher()
    }
    
    // Data
    
    func get(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        addToken()
            .flatMap { [network] _ in
                network.get(route, params: params)
            }
            .eraseToAnyPublisher()
    }
    
    func post(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        addToken()
            .flatMap { [network] _ in
                network.post(route, params: params)
            }
            .eraseToAnyPublisher()
    }
    
    func put(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        addToken()
            .flatMap { [network] _ in
                network.put(route, params: params)
            }
            .eraseToAnyPublisher()
    }
    
    func patch(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        addToken()
            .flatMap { [network] _ in
                network.patch(route, params: params)
            }
            .eraseToAnyPublisher()
    }
    
    func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        addToken()
            .flatMap { [network] _ in
                network.delete(route, params: params)
            }
            .eraseToAnyPublisher()
    }
    
    // Void
    
    func get(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        addToken()
            .flatMap { [network] _ in
                network.get(route, params: params)
            }
            .eraseToAnyPublisher()
    }
    
    func post(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        addToken()
            .flatMap { [network] _ in
                network.post(route, params: params)
            }
            .eraseToAnyPublisher()
    }
    
    func put(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        addToken()
            .flatMap { [network] _ in
                network.put(route, params: params)
            }
            .eraseToAnyPublisher()
    }
    
    func patch(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        addToken()
            .flatMap { [network] _ in
                network.patch(route, params: params)
            }
            .eraseToAnyPublisher()
    }
    
    func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        addToken()
            .flatMap { [network] _ in
                network.delete(route, params: params)
            }
            .eraseToAnyPublisher()
    }
    
    // JSON
    
    func get(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        addToken()
            .flatMap { [network] _ in
                network.get(route, params: params)
            }
            .eraseToAnyPublisher()
    }
    
    func post(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        addToken()
            .flatMap { [network] _ in
                network.post(route, params: params)
            }
            .eraseToAnyPublisher()
    }
    
    func put(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        addToken()
            .flatMap { [network] _ in
                network.put(route, params: params)
            }
            .eraseToAnyPublisher()
    }
    
    func patch(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        addToken()
            .flatMap { [network] _ in
                network.patch(route, params: params)
            }
            .eraseToAnyPublisher()
    }
    
    func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        addToken()
            .flatMap { [network] _ in
                network.delete(route, params: params)
            }
            .eraseToAnyPublisher()
    }
    
    // NetworkingJSONDecodable
    
    func get<T: NetworkingJSONDecodable>(_ route: String,
                                         params: Params = Params(),
                                         keypath: String? = nil) -> AnyPublisher<T, Error> {
        get(route, params: params)
            .tryMap { json -> T in try NetworkingParser().toModel(json, keypath: keypath) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func post<T: NetworkingJSONDecodable>(_ route: String,
                                          params: Params = Params(),
                                          keypath: String? = nil) -> AnyPublisher<T, Error> {
        addToken()
            .flatMap { [network] _ in
                network.post(route, params: params, keypath: keypath)
            }
            .eraseToAnyPublisher()
    }
    
    func put<T: NetworkingJSONDecodable>(_ route: String,
                                         params: Params = Params(),
                                         keypath: String? = nil) -> AnyPublisher<T, Error> {
        addToken()
            .flatMap { [network] _ in
                network.put(route, params: params, keypath: keypath)
            }
            .eraseToAnyPublisher()
    }
    
    func patch<T: NetworkingJSONDecodable>(_ route: String,
                                           params: Params = Params(),
                                           keypath: String? = nil) -> AnyPublisher<T, Error> {
        addToken()
            .flatMap { [network] _ in
                network.patch(route, params: params, keypath: keypath)
            }
            .eraseToAnyPublisher()
    }
    
    func delete<T: NetworkingJSONDecodable>(_ route: String,
                                            params: Params = Params(),
                                            keypath: String? = nil) -> AnyPublisher<T, Error> {
        addToken()
            .flatMap { [network] _ in
                network.delete(route, params: params, keypath: keypath)
            }
            .eraseToAnyPublisher()
    }
    
    // Array version
    func get<T: NetworkingJSONDecodable>(_ route: String,
                                         params: Params = Params(),
                                         keypath: String? = nil) -> AnyPublisher<[T], Error> {
        addToken()
            .flatMap { [network] _ in
                network.get(route, params: params, keypath: keypath)
            }
            .eraseToAnyPublisher()
    }
}
