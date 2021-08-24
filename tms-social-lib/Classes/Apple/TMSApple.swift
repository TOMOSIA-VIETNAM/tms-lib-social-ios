//
//  TMSApple.swift
//  tms-social-lib_Example
//
//  Created by Tuan Anh iOS on 19/08/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import AuthenticationServices

public struct TMSAppleProfile {
    public var userID: String?
    public var fullName: PersonNameComponents?
    public var email: String?
    public var identityToken: String?
}

@available(iOS 13.0, *)
public enum TMSAppleResult {
    case success(TMSAppleProfile)
    case failure(ASAuthorizationError?)
}

@available(iOS 13.0, *)
public class TMSApple: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    weak var viewController: UIViewController!
    private var handlerCompletion: ((TMSAppleResult) -> Void)?

    init(handlerCompletion: @escaping (TMSAppleResult) -> Void) {
        self.handlerCompletion = handlerCompletion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func login(controller: UIViewController) {
        viewController = controller
        viewController.present(self, animated: true, completion: nil)
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        guard let error = error as? ASAuthorizationError else {
            handlerCompletion?(.failure(nil))
            dismiss(animated: true, completion: nil)
            return
        }
        handlerCompletion?(.failure(error))
        dismiss(animated: true, completion: nil)
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let appleIDToken = appleIDCredential.identityToken {
            let token = String(data: appleIDToken, encoding: .utf8) ?? nil
            let profile = TMSAppleProfile(userID: appleIDCredential.user,
                                          fullName: appleIDCredential.fullName,
                                          email: appleIDCredential.email,
                                          identityToken: token)
            handlerCompletion?(.success(profile))
            dismiss(animated: true, completion: nil)
        } else {
            handlerCompletion?(.failure(nil))
            dismiss(animated: true, completion: nil)
        }
    }
}
