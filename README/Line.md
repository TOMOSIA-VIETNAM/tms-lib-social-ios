# Login via LINE

#### Setup
- Create new your provider in [LINE Developer Page](https://developers.line.biz/console/).
- Register your app bundle identifier in Login Tab. Copy ChannelID value in Basic Settings tab to your project and define it
  ![image info](/README/asset/channelID.png)
- **NOTE**: The developer needs to add your email in **Roles Tab** before begin to test login via LINE. 
- Import configure LINE to **Info.plist** file 
```
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>line3rdp.$(PRODUCT_BUNDLE_IDENTIFIER)</string>
			</array>
		</dict>
	</array>
	<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>lineauth2</string>
	</array>
```
- Setup **Channel ID** in AppDelegate.swift
```
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        TMSLine.setup(channelID: {CHANNEL_ID})
        return true
}

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return TMSLine.application(app, open: url, options: options)
    }
```

#### Usuage
- You need to create an instance of TMSLine on controller and call login method in TMSLine. Then closure will response TMSLineResult include TMSLineAccount or Error. You need to listen to and handle your code in it:
```
    let lineSDK = TMSLine()
    lineSDK.login(in: self) { (result) in
        switch result {
        case .success(let account):
            // Handle your code when login is successful
        case .failure(let error):
            // Handle your code when login is failed
        }
    }
```
- Get account profile when the user was logged in. If an account wasn't log in then callback will return error.
```
    lineSDK.getProfile { (result) in
        switch result {
        case .success(let account):
            // Handle your code when login is successful
        case .failure(let error):
            // Handle your code when login is failed
        }
    }
```
