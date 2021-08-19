# Login via Google

#### Setup
- Register your project in [Google Developer Page](https://developers.google.com/).
- Generate file Credentials.plist or GoogleService-Info.plist. Please pay attention **CLIENT_ID** and **REVERSED_CLIENT_ID** in your file plist. You will see that in image below
  ![image info](/README/asset/credentials.png)
  ![image info](/README/asset/googleservice-info.png)
  
- Import configure Google to **Info.plist** file 
```
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>REVERSED_CLIENT_ID</string>
			</array>
		</dict>
	</array>
```
- Setup in AppDelegate.swift
```
  
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    	if TMSGoogle.application(open: url) {
            return true
        }
        return false 
    }
```

#### Usuage
- You need to create an instance of TMSGoogle on controller and call login method in TMSGoogle. Then closure will response TMSGoogleResult include TMSGGProfile or Error. You need to listen to and handle your code in it:
```
    let googleSDK = TMSGoogle()
    googleSDK.login(viewcontroller: self, clientID: CLIENT_ID) { result in
            switch result {
            case let .success(profile):
                print(profile)
            case let .failure(error):
                print(error)
            }
        }
```
- Get account profile when user is logged in 
