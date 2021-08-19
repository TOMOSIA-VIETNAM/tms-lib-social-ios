//
//  TMSGoogle.swift
//  tms-social-lib_Example
//
//  Created by Tuan Anh iOS on 17/08/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import GoogleSignIn

public struct TMSGGProfile {
    public var userID: String?
    public var name: String?
    public var email: String?
    public var hasImage: Bool = false
    public var avatar: URL?
    public var token: String?
}

public enum TMSGoogleResult {
    case success(TMSGGProfile)
    case failure(Error?)
}

public class TMSGoogle {
    
    /// This method should be called from your `UIApplicationDelegate`'s `application:openURL:options:`
    /// method.
    /// - Parameter url: The URL that was passed to the app.
    /// - Returns: if `GIDSignIn` handled this URL.
    public class func application(open url: URL) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }

    /// Starts an interactive sign-in flow using the provided configuration and a login hint.
    ///
    /// The callback will be called at the end of this process.  Any saved sign-in state will be
    /// replaced by the result of this flow.  Note that this method should not be called when the app is
    /// starting up, (e.g in `application:didFinishLaunchingWithOptions:`); instead use the
    /// `restorePreviousSignInWithCallback:` method to restore a previous sign-in.
    /// - Parameters:
    ///   - viewcontroller: The view controller used to present `SFSafariViewContoller` on
    ///     iOS 9 and 10.
    ///   - clientID: The client ID of the app from the Google Cloud Console.
    ///   - completion: The `TMSGoogleResult` block that is called on completion.  This block will be
    ///     called asynchronously on the main queue.
    public func login(viewcontroller: UIViewController, clientID: String, completion: @escaping (TMSGoogleResult) -> Void) {
        let signInCongig = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: signInCongig, presenting: viewcontroller) { result, error in
            if let result = result, let profile = result.profile {
                print(result)
                completion(.success(TMSGGProfile(userID: result.userID,
                                                 name: profile.name,
                                                 email: profile.email,
                                                 hasImage: profile.hasImage,
                                                 avatar: profile.imageURL(withDimension: 200),
                                                 token: result.authentication.accessToken)))
            } else {
                completion(.failure(error))
            }
        }
    }

    /// SignOut gooogle
    public func logOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}
