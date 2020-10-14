import Foundation
import Combine

public struct NetworkingClient {

    /**
        Instead of using the same keypath for every call eg: "collection",
        this enables to use a default keypath for parsing collections.
        This is overidden by the per-request keypath if present.
     
     */
    public var defaultCollectionParsingKeyPath: String?
    let baseURL: String
    public var headers = [String: String]()
    public var parameterEncoding = ParameterEncoding.urlEncoded

    /**
        Prints network calls to the console.
        Values Available are .None, Calls and CallsAndResponses.
        Default is None
    */
    public var logLevels: NetworkingLogLevel {
        get { return logger.logLevels }
        set { logger.logLevels = newValue }
    }
    
    public var logHandler: NetworkingLogFunction {
        get { return logger.logHandler }
        set { logger.logHandler = newValue }
    }

    var logger = NetworkingLogger()

    public init(baseURL: String) {
        self.baseURL = baseURL
    }
    
}

public typealias NetworkingLogFunction = (_ message: String) -> Void
