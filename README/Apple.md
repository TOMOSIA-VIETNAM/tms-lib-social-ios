# Login via Apple

#### Setup
- Apps that use a third-party or social login service (such as Facebook Login, Google Sign-In, Sign in with Twitter, Sign In with LinkedIn, Login with Amazon, or WeChat Login) to set up or authenticate the user’s primary account with the app must also offer Sign in with Apple as an equivalent option.
- Deployment iOS SDK 13.0+
- Add capability Sign in with Apple 
![image info](/README/asset/signin-apple.png)

#### Usuage
- You should create default apple button according to this document https://developer.apple.com/design/human-interface-guidelines/sign-in-with-apple/overview/buttons/
```
    let signInAppleButton = ASAuthorizationAppleIDButton(type: .default, style: .black)
	let frame = CGRect(x: 0, y: 0, width: 300, height: 100)
	signInAppleButton.frame = frame
	signInAppleButton.center = view.center
    view.addSubview(signInAppleButton)
```
- You need to create an instance of TMSApple on controller and call login method in TMSApple. Then closure will response TMSAppleResult include TMSApple or Error. You need to listen to and handle your code in it:
```
    let tmsApple = TMSApple(handlerCompletion: { result in
                switch result {
                case let .success(profile):
                    print(profile)
                case let .failure(error):
                    print(error)
                }
            })
     tmsApple.login(controller: self)
```
- Get account profile when user is logged in 
