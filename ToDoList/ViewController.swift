//
//  ViewController.swift
//  ToDoList
//
//  Created by Malik Em on 29.08.2024.
//

import UIKit

final class ViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        
        let table = UITableView()
        
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Identifier")
        
        return table
    }()
    
    var tasks: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tasks = ["купить хлеб", "поработать", "сходить в магазин", "написать приложение"]
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Identifier", for: indexPath)
        
        var listConfiguration = cell.defaultContentConfiguration()
        listConfiguration.text = tasks[indexPath.row]
        
        cell.contentConfiguration = listConfiguration
        
        return cell
    }
    
    
}
