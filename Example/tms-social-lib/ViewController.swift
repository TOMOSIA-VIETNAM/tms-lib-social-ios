//
//  ViewController.swift
//  tms-social-lib
//
//  Created by Phuong Vo on 08/13/2021.
//  Copyright (c) 2021 Phuong Vo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let twitterSDK = TMSTwitter()
    let lineSDK = TMSLine()
    let googleSDK = TMSGoogle()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction private func didSelectLoginViaTwitter(_ sender: UIButton) {
        twitterSDK.login { result in
            switch result {
            case let .success(session):
                print(session)
            case let .failure(error):
                print(error)
            }
        }
    }

    @IBAction private func didSelectLoginViaLine(_ sender: UIButton) {
        lineSDK.login(in: self) { result in
            switch result {
            case let .success(account):
                print(account)
            case let .failure(error):
                print(error)
            }
        }
    }

    @IBAction private func didSelectLoginViaGoogle(_ sender: UIButton) {
        googleSDK.login(viewcontroller: self, clientID: Constant.gooogleClientID) { result in
            switch result {
            case let .success(profile):
                print(profile)
            case let .failure(error):
                print(error)
            }
        }
    }
}
