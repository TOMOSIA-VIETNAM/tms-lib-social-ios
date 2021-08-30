//
//  FacebookSocical.swift
//  tms-social-lib_Example
//
//  Created by Tuan Anh iOS on 16/08/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import FacebookCore
import FacebookLogin
import Foundation

public struct TMSFBProfile {
    public var userID: String?
    public var name: String?
    public var firstName: String?
    public var midName: String?
    public var lastName: String?
    public var linkURL: URL?
    public var refreshDate: Date?
    public var token: String?

    /// Get string URL avatar facebook
    /// - Parameters:
    ///   - size: CGSize want to get
    /// - Returns: string URL
    public func avatarURL(size: CGSize) -> URL? {
        guard let userID = userID else {
            return nil
        }
        let width = Int(size.width)
        let height = Int(size.height)
        return URL(string: "https://graph.facebook.com/\(userID)/picture?height=\(height)&type=normal&width=\(width)")
    }
}

public enum TMSFacebookResult {
    case success(TMSFBProfile)
    case failure(Error?)
}

public class TMSFacebook {
    let loginManager = LoginManager()

    /// Initialize TMSFacebook
    public init() {
    }

    /// Start login default
    /// - Parameter completion:  handler the callback success or failure
    public func login(completion: @escaping (TMSFacebookResult) -> Void) {
        loginManager.logIn(permissions: ["public_profile", "email"], from: nil) { result, error in
            if let result = result, !result.isCancelled {
                Profile.loadCurrentProfile { FBSDKProfile, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    let profile = TMSFBProfile(userID: FBSDKProfile?.userID,
                                               name: FBSDKProfile?.name,
                                               firstName: FBSDKProfile?.middleName,
                                               midName: FBSDKProfile?.middleName,
                                               lastName: FBSDKProfile?.lastName,
                                               linkURL: FBSDKProfile?.linkURL,
                                               refreshDate: FBSDKProfile?.refreshDate,
                                               token: AccessToken.current?.tokenString)
                    completion(.success(profile))
                }
            } else {
                completion(.failure(error))
            }
        }
    }

    /// Start login facebook parameters
    /// - Parameters:
    ///   - controller: fromViewController the view controller to present from. If nil, the topmost view controller will beautomatically determined as best as possible.
    ///   - permissions: the optional array of permissions. Note this is converted to NSSet and is only an NSArray for the convenience of literal syntax.
    ///   - completion: handler the callback success or failure
    public func login(controller: UIViewController? = nil, permissions: [String] = ["public_profile", "email"], completion: @escaping (TMSFacebookResult) -> Void) {
        loginManager.logIn(permissions: permissions, from: controller) { result, error in
            if let result = result, !result.isCancelled {
                Profile.loadCurrentProfile { FBSDKProfile, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    let profile = TMSFBProfile(userID: FBSDKProfile?.userID,
                                               name: FBSDKProfile?.name,
                                               firstName: FBSDKProfile?.middleName,
                                               midName: FBSDKProfile?.middleName,
                                               lastName: FBSDKProfile?.lastName,
                                               linkURL: FBSDKProfile?.linkURL,
                                               refreshDate: FBSDKProfile?.refreshDate,
                                               token: AccessToken.current?.tokenString)
                    completion(.success(profile))
                }
            } else {
                completion(.failure(error))
            }
        }
    }

    /// Logout facebook
    public func logout() {
        loginManager.logOut()
    }

    /// Call this method from the [UIApplicationDelegate application:didFinishLaunchingWithOptions:] method of the AppDelegate for your app. It should be invoked for the proper use of the Facebook SDK. As part of SDK initialization basic auto logging of app events will occur, this can be controlled via 'FacebookAutoLogAppEventsEnabled' key in the project info plist file.
    /// - Parameters:
    ///   - application: The application as passed to [UIApplicationDelegate application:didFinishLaunchingWithOptions:].
    ///   - launchOptions: The launchOptions as passed to [UIApplicationDelegate application:didFinishLaunchingWithOptions:].
    public class func configuration(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    /// Call this method from the [UIApplicationDelegate application:openURL:sourceApplication:annotation:] method of the AppDelegate for your app. It should be invoked for the proper processing of responses during interaction with the native Facebook app or Safari as part of SSO authorization flow or Facebook dialogs
    /// - Parameters:
    ///   - application: The application as passed to [UIApplicationDelegate application:openURL:sourceApplication:annotation:].
    ///   - url: The URL as passed to [UIApplicationDelegate application:openURL:sourceApplication:annotation:].
    ///   - options: The options as passed to [UIApplicationDelegate application:openURL:].
    /// - Returns:YES if the url was intended for the Facebook SDK, NO if not.

    public class func application(_ application: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool {
        ApplicationDelegate.shared.application(application, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        return true
    }

    /// Call this method from the [UIApplicationDelegate application:openURL:sourceApplication:annotation:] method of the AppDelegate for your app. It should be invoked for the proper processing of responses during interaction with the native Facebook app or Safari as part of SSO authorization flow or Facebook dialogs.
    /// - Parameters:
    ///   - scene: UIScene
    ///   - urlContexts: UIOpenURLContext
    @available(iOS 13.0, *)
    public class func scene(_ scene: UIScene, openURLContexts urlContexts: Set<UIOpenURLContext>) {
        guard let url = urlContexts.first?.url else {
            return
        }
        ApplicationDelegate.shared.application(UIApplication.shared, open: url, sourceApplication: nil, annotation: [UIApplication.OpenURLOptionsKey.annotation])
    }
}
