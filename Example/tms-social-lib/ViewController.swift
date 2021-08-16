//
//  ViewController.swift
//  tms-social-lib
//
//  Created by Phuong Vo on 08/13/2021.
//  Copyright (c) 2021 Phuong Vo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let twitter = TMSTwitter()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction private func didSelectLoginViaTwitter(_ sender: UIButton) {
        twitter.login { (result) in
            switch result {
            case .success(let session):
                print(session)
            case .failure(let error):
                print(error)
            }
        }
    }

}

