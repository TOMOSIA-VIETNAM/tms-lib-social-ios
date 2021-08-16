# Login via Twitter

#### Setup
- Register your project in [Twitter Developer Page](https://developer.twitter.com/en/portal/dashboard).
- Generate **Consumer Key** and **Consumer Secret** in your project. You will see that in image below
![image](./README/asset/consumer key.png)
- Import configure twitter to **Info.plist** file 
```
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>twitterkit-{REPLACE_YOUR_CONSUMER_KEY}</string>
			</array>
		</dict>
	</array>
	<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>twitterauth</string>
		<string>twitter</string>
	</array>
```
- Setup **Consumer Key** and **Consumer Secret** in AppDelegate.swift
```
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        TMSTwitter.configuration(TMSConfiguration(consumerKey: {CONSUMER_KEY},
                                                  consumerSecret: {CONSUMER_SECRET}))
        return true
}

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return TMSTwitter.application(app, openURL: url, options: options)
    }
```

#### Usuage
- You need to create an instance of TMSTwitter on controller and call login method in TMSTwitter. Then closure will response TMSTwitterResult include TMSSession or Error. You need to listen to and handle your code in it:
```
    let twitter = TMSTwitter()
    twitter.login { (result) in
            switch result {
            case .success(let session):
                print(session)
            case .failure(let error):
                print(error)
            }
        }
```
