//
//  ViewController.swift
//  SlientPushDemo
//
//  Created by 김건우 on 9/15/25.
//

import UIKit

class ViewController: UIViewController {

    private var games: [String] = []
    
    @IBOutlet weak var gameTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            forName: .newGameArrived,
            object: nil,
            queue: .main
        ) { notification in
            let name = notification.userInfo?["gameName"] as! String
            self.games.append(name)
            self.gameTableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return games.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var config = cell.defaultContentConfiguration()
        config.text = games[indexPath.row]
        cell.contentConfiguration = config
        return cell
    }
}

