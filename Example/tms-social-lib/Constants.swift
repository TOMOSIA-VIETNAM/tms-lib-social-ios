//
//  Constants.swift
//  tms-social-lib



struct Constant {
    static let consumerKey = "eWMtwhDFyaz55XaQszTrNVIRG"
    static let consumerSecret = "TRLSIIOoVUYfZtaiXotz5QYOt4WpyDCHKoApY8mO1fz3IiWOLH"
    
    static let channelID = "1655223358"
    
    static let gooogleClientID =
        "400985660348-kh81iue2vfqpc7sl79qtprcm1bj1tbt6.apps.googleusercontent.com"
    
    static var requestTokenURL: String {
        return "https://api.twitter.com/oauth/request_token"
    }

    static var authorizeURL: String {
        return "https://api.twitter.com/oauth/authorize"
    }

    static var accessTokenURL: String {
        return "https://api.twitter.com/oauth/access_token"
    }

    static var callBackURLTwitter: String {
        return "twitterkit-\(consumerKey)://oauth-callback/twitter"
    }
}





