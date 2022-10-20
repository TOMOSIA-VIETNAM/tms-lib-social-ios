//  TMSTwitter.swift
//  tms-social-lib

import Foundation
import OAuthSwift

public struct TMSConfiguration {
    public let consumerKey: String
    public let consumerSecret: String
    public var accessGroup: String?
    public let requestTokenURL: String
    public let authorizeURL: String
    public let accessTokenURL: String
}

public struct TMSTwitterSession: Codable {
    let userId: String
    let screenName: String
    let oauthTokenSecret: String
    let oauthToken: String
}

public enum TMSTwitterResult {
    case success(TMSTwitterSession)
    case failure(Error)
}

public class TMSTwitter {
    private var oauthSwift: OAuth1Swift
    /// Initialize TMSTwitter
    public init(configuration: TMSConfiguration) {
        oauthSwift = OAuth1Swift(consumerKey: configuration.consumerKey,
                                 consumerSecret: configuration.consumerSecret,
                                 requestTokenUrl: configuration.requestTokenURL,
                                 authorizeUrl: configuration.authorizeURL,
                                 accessTokenUrl: configuration.accessTokenURL)
    }

    /// Triggers user authentication with Twitter.
    /// This method will present UI to allow the user to log in if there are no saved Twitter login credentials.
    /// This method is equivalent to calling login:completion with TMSTwitterResult response when finish
    /// - Parameters:
    ///     - completion: The completion block will be called after authentication is successful or if there is an error.
    /// - Warning:
    ///     - This method requires that you have set up your `consumerKey` and `consumerSecret` in TMSConfiguration.
    public func login(callBackURL: String, completion: @escaping (TMSTwitterResult) -> Void) {
        guard let callBackURL = URL(string: callBackURL) else { return }
        oauthSwift.authorize(withCallbackURL: callBackURL, completionHandler: { response in
            switch response {
            case let .success(result):
                let json = try? JSONSerialization.data(withJSONObject: result.parameters)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let json = json else { return }
                let twitterSeession = try? decoder.decode(TMSTwitterSession.self, from: json)
                completion(.success(twitterSeession!))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
    
    /// Handle callback url which contains now token information
    public class func handleURL(url: URL) {
        OAuthSwift.handle(url: url)
    }
}

