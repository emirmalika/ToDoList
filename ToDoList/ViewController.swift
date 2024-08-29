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
        table.register(TasksTableViewCell.self, forCellReuseIdentifier: "Identifier")
        
        return table
    }()
    
    var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tasks = Array(repeating: Task(title: "Магазин", description: "купить хлеб", date: "23 августа", status: "Выполнен"), count: 30)
        
        view.addSubview(tableView)
        
        setupLayout()
        setupNavigationBar()
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupNavigationBar() {
        let editAction = UIAction { _ in
            self.tableView.isEditing.toggle()
        }
        navigationItem.title = "Задачи"
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .edit, primaryAction: editAction, menu: nil)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TasksTableViewCell.reuseIdentifier, for: indexPath) as! TasksTableViewCell
        
        let task = tasks[indexPath.row]
        cell.configureCell(with: task)

        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let task = tasks[sourceIndexPath.row]
        tasks.remove(at: sourceIndexPath.row)
        tasks.insert(task, at: destinationIndexPath.row)
        
        tableView.reloadData()
    }
    
}
