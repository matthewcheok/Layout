//
//  MenuViewController.swift
//  Layout
//
//  Created by Matthew Cheok on 2/8/16.
//  Copyright © 2016 Matthew Cheok. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
  let items: [(title: String, type: UIViewController.Type)] = [
    ("Lock Screen", LockScreenDemoController.self),
    ("Control Center", ControlCenterDemoController.self),
    ("Messages", MessagesDemoController.self)
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Demo"
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let item = items[indexPath.row]
    cell.textLabel?.text = item.title
    cell.accessoryType = .disclosureIndicator
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = items[indexPath.row]
    let controller = item.type.init()
    present(controller, animated: true, completion: nil)
  }
}
