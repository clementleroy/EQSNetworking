//
//  NetworkingClient+NetworkingJSONDecodable.swift
//  
//
//  Created by Sacha on 13/03/2020.
//

import Foundation
import Combine

public protocol NetworkingJSONDecodable {
    /// The method you declare your JSON mapping in.
    static func decode(_ json: Any) throws -> Self
}

public extension NetworkingClient {

    func get<T: NetworkingJSONDecodable>(_ route: String,
                                         params: Params = Params(),
                                         keypath: String? = nil) -> AnyPublisher<T, Error> {
        return get(route, params: params)
            .tryMap { json -> T in try NetworkingParser().toModel(json, keypath: keypath) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    // Array version
    func get<T: NetworkingJSONDecodable>(_ route: String,
                                         params: Params = Params(),
                                         keypath: String? = nil) -> AnyPublisher<[T], Error> {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        return get(route, params: params)
            .map { json -> [T] in  NetworkingParser().toModels(json, keypath: keypath) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func post<T: NetworkingJSONDecodable>(_ route: String,
                                          params: Params = Params(),
                                          keypath: String? = nil) -> AnyPublisher<T, Error> {
        return post(route, params: params)
            .tryMap { json -> T in try NetworkingParser().toModel(json, keypath: keypath) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func put<T: NetworkingJSONDecodable>(_ route: String,
                                         params: Params = Params(),
                                         keypath: String? = nil) -> AnyPublisher<T, Error> {
        return put(route, params: params)
            .tryMap { json -> T in try NetworkingParser().toModel(json, keypath: keypath) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func patch<T: NetworkingJSONDecodable>(_ route: String,
                                           params: Params = Params(),
                                           keypath: String? = nil) -> AnyPublisher<T, Error> {
        return patch(route, params: params)
            .tryMap { json -> T in try NetworkingParser().toModel(json, keypath: keypath) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func delete<T: NetworkingJSONDecodable>(_ route: String,
                                            params: Params = Params(),
                                            keypath: String? = nil) -> AnyPublisher<T, Error> {
        return delete(route, params: params)
            .tryMap { json -> T in try NetworkingParser().toModel(json, keypath: keypath) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

// Provide default implementation for Decodable models.
public extension NetworkingJSONDecodable where Self: Decodable {

    static func decode(_ json: Any) throws -> Self {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        let model = try decoder.decode(Self.self, from: data)
        return model
    }
}
