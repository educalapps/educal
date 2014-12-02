//
//  LoginViewController.swift
//  educal
//
//  Created by Jurriaan Lindhout on 01-12-14.
//  Copyright (c) 2014 Jurriaan Lindhout. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        var barbutton = UIBarButtonItem()
        barbutton.title = ""
        navigationItem.setLeftBarButtonItem(barbutton, animated: false)
        navigationItem.hidesBackButton = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginBtnPressed(sender: UIButton) {
        println("logged in succesfully")
    }
}
