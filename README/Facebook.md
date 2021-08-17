# Login via Facebook

#### Setup
- Register your project in [Facebook Developer Page](https://developers.facebook.com/).
- Find **FacebookAppID** and **FacebookToken** in your project. You will see that in image below
![image](./README/asset/facebook-develop-app.png)
- Import configure twitter to **Info.plist** file 
```
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>fb{REPLACE_YOUR_FACEBOOK_APP_ID}</string>
			</array>
		</dict>
	</array>
	<key>FacebookAppID</key>
	<string>YOUR_FACEBOOK_APP_ID</string>
	<key>FacebookClientToken</key>
	<string>YOUR_FACEBOOK_LIENT-TOKEN</string>
	<key>FacebookDisplayName</key>
	<string>APP-NAME</string>
	<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>fbauth</string>
  		<string>fb-messenger-share-api</string>
  		<string>fbauth2</string>
  		<string>fbshareextension</string>
	</array>
```
- Setup in AppDelegate.swift
```
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        TMSFacebook.configuration(application, didFinishLaunchingWithOptions: launchOptions)
        return true
}

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    	 if TMSFacebook.application(app, openURL: url, options: options) {
            return true
        }
        return false
    }
```

#### Usuage
- You need to create an instance of TMSFacebook on controller and call login method in TMSFacebook. Then closure will response TMSFacebookResult include TMSFBProfile or Error. You need to listen to and handle your code in it:
```
    let facebookSDK = TMSFacebook()
    facebookSDK.login{ result in
            switch result {
            case let .success(profile):
                print(profile)
            case let .failure(error):
                print(error)
            }
        }
```
- Login with parameter custom
```
    let facebookSDK = TMSFacebook()
    facebookSDK.login(controller: self, permissions: ["public_profile", "email"]) { result in
            switch result {
            case let .success(profile):
                print(profile)
            case let .failure(error):
                print(error)
            }
        }
```
