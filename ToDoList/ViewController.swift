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
        table.register(TodoTableViewCell.self, forCellReuseIdentifier: "Identifier")
        
        return table
    }()
    
    var todos: [String] = []
//    var task: ToDo
    private var viewModels = [ToDo]()
//    var networkManager: NetworkManager = NetworkManager(with: .default)
//
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        
        setupLayout()
        setupNavigationBar()
        fetchData()
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
    
    private func fetchData() {
        NetworkManager.shared.fetchData { [weak self] result in
            switch result {
            case .success(let tasks):
                self?.viewModels = tasks.todos.compactMap {
                    ToDo (todo: $0.todo , completed: $0.completed)
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                self?.viewModels.reverse()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.reuseIdentifier, for: indexPath) as! TodoTableViewCell
        
        cell.configureCell(with: viewModels[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let todo = viewModels[sourceIndexPath.row]
        viewModels.remove(at: sourceIndexPath.row)
        viewModels.insert(todo, at: destinationIndexPath.row)
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            viewModels.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
