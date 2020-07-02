//
//  ViewController.swift
//  iOsNetworking
//
//  Created by Miguel Rueda on 01/07/20.
//  Copyright © 2020 Miguel Rueda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var feedGists: [Gist] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DataService.shared.fetchGists {(result) in
            DispatchQueue.main.async {
                switch result {
                    case .success(let gists):
                        self.feedGists = gists
                        self.tableView.reloadData()
                        for gist in gists {
                            print("\(gist)")
                        }
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }


    @IBAction func createNewGist(_ sender: Any) {
        DataService.shared.createNewGist{ (result) in
            DispatchQueue.main.async {
                 switch result {
                           case .success(let json):
                               self.showResultAlert(title: "Yay!", message: "New post successfully created")
                           case .failure(let error):
                               self.showResultAlert(title: "Ooops!", message: "Something went wrong!")
                           }
            }
        }
    }
    
    func showResultAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedGists.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "feedCellId", for: indexPath)
        
        let currentGist = self.feedGists[indexPath.row]
        cell.textLabel?.text = currentGist.description
        cell.detailTextLabel?.text = currentGist.id
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let currentGist = self.feedGists[indexPath.row]
        let starAction = UIContextualAction(style: .normal, title: "Star"){ (action, view, completion) in
            DataService.shared.starUnstarGist(id: "\(currentGist.id!)", star: true){(success) in
                DispatchQueue.main.async {
                      if success {
                                      self.showResultAlert(title: "Success", message: "Gist successfully starred")
                                  } else {
                                      self.showResultAlert(title: "Ooops", message: "Something went wrong")
                                  }
                }
            }
            completion(true)
        }
        
        let unstarAction = UIContextualAction(style: .normal, title: "Unstar") {(action, view, completion) in
            DataService.shared.starUnstarGist(id: "\(currentGist.id!)", star: false){(success) in
                DispatchQueue.main.async {
                      if success {
                                      self.showResultAlert(title: "Success", message: "Gist successfully unstarred")
                                  } else {
                                      self.showResultAlert(title: "Ooops", message: "Something went wrong")
                                  }
                }
            }
            completion(true)
        }
        
        starAction.backgroundColor = .blue
        unstarAction.backgroundColor = .darkGray
        
        let actionConfig = UISwipeActionsConfiguration(actions: [unstarAction, starAction])
        return actionConfig
    }
}


