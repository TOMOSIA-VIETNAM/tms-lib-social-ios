//  TMSLine.swift
//  tms-social-lib

import Foundation
import LineSDK

public struct TMSLineAccount: Codable {
    public var accessToken: String?
    public var userID: String?
    public var displayName: String?
    public var pictureURL: URL?
    public var statusMesssage: String?

    /// The large profile image URL of the current authorized user. `nil` if the user has not set a profile
    /// image.
    public var pictureURLLarge: URL? {
        return pictureURL?.appendingPathComponent("/large")
    }

    /// The small profile image URL of the current authorized user. `nil` if the user has not set a profile
    /// image.
    public var pictureURLSmall: URL? {
        return pictureURL?.appendingPathComponent("/small")
    }
}

public enum TMSLineResult<T: Codable> {
    case success(T)
    case failure(Error)
}

public class TMSLine {
    /// Initialize TMSLine
    public init() {
    }

    /// Setup ChannelID and UniversalLink for LineSDK
    /// - Parameters:
    ///   - channelID: The channel ID for your app.
    ///   - universalLinkURL: The universal link used to navigate back to your app from LINE.
    /// - Warning:
    ///   - Call method before other method. Recomnent you add it in AppDelegate
    public class func setup(channelID: String, universalLink: URL? = nil) {
        LoginManager.shared.setup(channelID: channelID, universalLinkURL: universalLink)
    }

    /// Call method login via LINE Platform.
    ///
    /// If user has been authorized LINE before then it will get user profile not need to  login again.
    /// - Parameters:
    ///   - permissions: The set of permissions requested by your app. The default value is
    ///                  `[.profile]`.
    ///   - viewController: The the view controller that presents the login view controller. If `nil`, the topmost
    ///                     view controller in the current view controller hierarchy will be used.
    ///   - parameters: The parameters used during the login process. For more information,
    ///                 see `LoginManager.Parameters`.
    ///   - completion: The completion closure to be invoked when the login action is finished.
    public func login(permissions: Set<LoginPermission> = [.profile], in controller: UIViewController? = nil, parameters: LoginManager.Parameters = .init(), completion: @escaping (TMSLineResult<TMSLineAccount>) -> Void) {
        if LoginManager.shared.isAuthorized {
            getProfile(completion: completion)
        } else {
            LoginManager.shared.login(permissions: permissions,
                                      in: controller,
                                      parameters: parameters) { result in
                switch result {
                case let .success(profile):
                    completion(.success(TMSLineAccount(accessToken: profile.accessToken.value,
                                                       userID: profile.userProfile?.userID,
                                                       displayName: profile.userProfile?.displayName,
                                                       pictureURL: profile.userProfile?.pictureURL,
                                                       statusMesssage: profile.userProfile?.statusMessage)))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }

    /// Call method logout via Line Platform with current user.
    /// - Parameter completion: The completion closure to be invoked when the logout action is finished.
    public func logout(completion: ((TMSLineResult<Bool>) -> Void)?) {
        LoginManager.shared.logout { result in
            switch result {
            case .success:
                completion?(.success(true))
            case let .failure(error):
                completion?(.failure(error))
            }
        }
    }

    /// Get user profile with the current user.
    ///
    /// If you are not log in then it will return an error.
    /// - Parameters:x
    ///   - queue: The callback queue that is used for `completion`. The default value is
    ///            `.currentMainOrAsync`. For more information, see `CallbackQueue`.
    ///   - completion: The completion closure to be invoked when the user's profile is returned.
    /// - Warning:
    ///   - Permission [.profile] is required.
    public func getProfile(callbackQueue queue: CallbackQueue = .currentMainOrAsync, completion: @escaping (TMSLineResult<TMSLineAccount>) -> Void) {
        guard LoginManager.shared.isAuthorized else {
            return execute(queue: queue) {
                completion(.failure(
                    LineSDKError.authorizeFailed(
                        reason: .lineClientError(code: "999",
                                                 message: "You are not log in"))))
            }
        }
        API.getProfile(callbackQueue: queue) { result in
            switch result {
            case let .success(profile):
                completion(.success(TMSLineAccount(accessToken: AccessTokenStore.shared.current?.value,
                                                   userID: profile.userID,
                                                   displayName: profile.displayName,
                                                   pictureURL: profile.pictureURL,
                                                   statusMesssage: profile.statusMessage)))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    /// Asks this `LoginManager` object to handle a URL callback from either LINE or the web login flow.
    /// - Parameters:
    ///   - app: The singleton app object.
    ///   - url: The URL resource to open. This resource should be the one passed from the iOS system through the
    ///          related method of the `UIApplicationDelegate` protocol.
    ///   - options: A dictionary of the URL handling options passed from the related method of the
    ///              `UIApplicationDelegate` protocol.
    /// - Returns: `true` if `url` has been successfully handled; `false` otherwise.
    /// - Note: This method has the same method signature as in the methods of the `UIApplicationDelegate`
    ///         protocol. Pass all arguments to this method without any modification.
    public class func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return LoginManager.shared.application(app, open: url, options: options)
    }

    private func execute(queue: CallbackQueue, _ block: @escaping () -> Void) {
        switch queue {
        case .asyncMain:
            DispatchQueue.main.async { block() }
        case .currentMainOrAsync:
            DispatchQueue.main.async { block() }
        case .untouch:
            block()
        case let .dispatch(queue):
            queue.async { block() }
        case let .operation(queue):
            queue.addOperation { block() }
        }
    }
}
