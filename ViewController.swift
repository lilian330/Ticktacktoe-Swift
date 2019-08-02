//
//  ViewController.swift
//  TicTacToe
//
//  Created by Lilian Wang on 2019-03-16.
//  Copyright © 2019 COMP2601. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func exitGame(_ sender: UIButton){
        print("Suspend the game");
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}

