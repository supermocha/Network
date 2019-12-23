//
//  ViewController.swift
//  Network2
//
//  Created by Cheryl Chen on 2019/12/16.
//  Copyright © 2019 Cheryl Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let router = Router<UserInfoRequest, UserInfoResponse>()
        let urlInput = UserInfo.URLInput(id: "000")
        router.get(with: urlInput) { (output: UserInfo.Output?) in
            guard let output = output else { return }
            print(output.name)
        }
    }
}
