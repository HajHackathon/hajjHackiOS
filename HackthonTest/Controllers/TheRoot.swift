//
//  TheRoot.swift
//  HackthonTest
//
//  Created by Qahtan on 8/1/18.
//  Copyright © 2018 QahtanLab. All rights reserved.
//

import UIKit
import Firebase
class TheRoot: UITableViewController {
    
    let cellId = "cellId"
    var hajji : Hajji?
    let hajjis = [Hajji(uid: "23323234", location: [21.615474, 39.166657], casee: 5),
                  Hajji(uid: "23323234", location: [21.613544, 39.162294], casee: 2),
                  Hajji(uid: "23323234", location: [21.620425, 39.159183], casee: 3),
                  Hajji(uid: "23323234", location: [21.621319, 39.159123], casee: 1),
                  Hajji(uid: "23323234", location: [21.621492, 39.158653], casee: 5),
                  Hajji(uid: "23323234", location: [21.619791, 39.162151], casee: 4),
                  ]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        checkIfUserSingIn()
        
    }
    func checkIfUserSingIn() {
        if Auth.auth().
    }
    func setupTableView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        hajji = Hajji(uid: "FDDFDREERTR", location: [21.615924,39.166206], casee: 1)
        
        view.backgroundColor = .gray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    @objc func handleLogout() {
        do{
            try Auth.auth().signOut()
            let nav = UINavigationController(rootViewController: LogInViewController())
            nav.isNavigationBarHidden = true
            self.present(nav, animated: true, completion: nil)
        } catch let singOutErr {
            print("Failed to sing out", singOutErr)
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CustomTableViewCell
        
        cell.hajje = hajjis[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let map = MapViewController()
        map.hajji = hajjis[indexPath.row]
        print("map.hajji",map.hajji)
        navigationController?.pushViewController(map, animated: true)
        
    }
}
