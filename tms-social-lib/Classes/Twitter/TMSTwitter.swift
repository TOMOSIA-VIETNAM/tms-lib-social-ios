//  TMSTwitter.swift
//  tms-social-lib

import Foundation
import TwitterCore
import TwitterKit

public struct TMSConfiguration {
    public let consumerKey: String
    public let consumerSecret: String
    public var accessGroup: String?
}

public struct TMSTwitterSession {
    public var authToken: String
    public var authTokenSecret: String
    public var userName: String
    public var userID: String
}

public enum TMSTwitterResult {
    case success(TMSTwitterSession)
    case failure(Error)
}

public class TMSTwitter {
    /// Initialize TMSTwitter
    public init() {
    }

    /// Start Twitter with a consumer key, secret, and keychain access group in TMSConfiguration
    /// - Parameter configuration: Contains consumerKey, consumerSecret and accessGroup on Twitter App Page
    class func configuration(_ configuration: TMSConfiguration) {
        TWTRTwitter.sharedInstance().start(withConsumerKey: configuration.consumerKey,
                                           consumerSecret: configuration.consumerSecret,
                                           accessGroup: configuration.accessGroup)
    }

    /// Triggers user authentication with Twitter.
    /// This method will present UI to allow the user to log in if there are no saved Twitter login credentials.
    /// This method is equivalent to calling login:completion with TMSTwitterResult response when finish
    /// - Parameters:
    ///     - completion: The completion block will be called after authentication is successful or if there is an error.
    /// - Warning:
    ///     - This method requires that you have set up your `consumerKey` and `consumerSecret` in TMSConfiguration.
    public func login(completion: @escaping (TMSTwitterResult) -> Void) {
        TWTRTwitter.sharedInstance().logIn { session, error in
            if let session = session?.mapTMSSession() {
                completion(.success(session))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }

    /// Triggers user authentication with Twitter. Allows the developer to specify the presenting view controller.
    /// This method will present UI to allow the user to log in if there are no saved Twitter login credentials.
    /// - Parameters:
    ///   - controller: The view controller that will be used to present the authentication view.
    ///   - completion: The completion block will be called after authentication is successful or if there is an error.
    /// - Warning:
    ///     - This method requires that you have set up your `consumerKey` and `consumerSecret` in TMSConfiguration.
    public func login(with controller: UIViewController, completion: @escaping (TMSTwitterResult) -> Void) {
        TWTRTwitter.sharedInstance().logIn(with: controller) { session, error in
            if let session = session?.mapTMSSession() {
                completion(.success(session))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }

    /// Finish the `SFSafariViewController` authentication loop. This method should
    /// be called from application:openURL:options inside the application delegate.
    ///
    /// This method will verify an authentication token sent by the Twitter API to
    /// finish the web-based authentication flow.
    /// - Parameters:
    ///   - application: The `UIApplication` instance received as a parameter
    ///   - url: The `URL` instance received as a parameter
    ///   - options: The options dictionary received as a parameter.
    /// - Returns: Boolean specifying whether this URL was handled by Twitter Kit or not
    public class func application(_ application: UIApplication, open url: URL, options: [AnyHashable: Any] = [:]) -> Bool {
        return TWTRTwitter.sharedInstance().application(application, open: url, options: options)
    }

    /// Finish the `SFSafariViewController` authentication loop. This method should
    /// be called from scene:openURLContexts inside the scene delegate.
    ///
    /// This method will verify an authentication token sent by the Twitter API to
    /// finish the web-based authentication flow.
    /// - Parameters:
    ///   - scene: The scene that UIKit asks to open the URL.
    ///   - urlContexts: One or more UIOpenURLContext objects. Each object contains one URL to open and any additional information needed to open that URL.
    @available(iOS 13.0, *)
    public class func scene(_ scene: UIScene, openURLContexts urlContexts: Set<UIOpenURLContext>) {
        TWTRTwitter.sharedInstance().scene(scene, openURLContexts: urlContexts)
    }
}

extension TWTRSession {
    public func mapTMSSession() -> TMSTwitterSession {
        return TMSTwitterSession(authToken: authToken,
                                 authTokenSecret: authTokenSecret,
                                 userName: userName,
                                 userID: userID)
    }
}
