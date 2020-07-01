//
//  ViewController.swift
//  iOsNetworking
//
//  Created by Miguel Rueda on 01/07/20.
//  Copyright © 2020 Miguel Rueda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var responseView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DataService.shared.fetchGists {(result) in
            switch result {
            case .success(let json):
                print(json)
                do {
                    let data = try JSONSerialization.data(withJSONObject: json, options: [])
                    if let string = String(data: data, encoding: String.Encoding.utf8) {
                        self.responseView.text = string
                    }
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }


}

