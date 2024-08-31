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

    private var viewModels = [ToDo]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        navigationItem.title = "Задачи"
        
        setupLayout()
        fetchData()
        editAction()
        addAction()
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    
    func editAction() {
        
        let editAction = UIAction { _ in
            self.tableView.isEditing.toggle()
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .edit, primaryAction: editAction, menu: nil)
    }
    
    func addAction() {
        
        let addAction = UIAction { _ in
            let alertController = UIAlertController(title: "Добавить новую задачу", message: nil, preferredStyle: .alert)
            alertController.addTextField { (textField) in
                textField.placeholder = "Название задачи"
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Статус"
            }
            
            let alertAction1 = UIAlertAction(title: "Закрыть", style: .default) { (alert) in
                
            }
            let alertAction2 = UIAlertAction(title: "Создать", style: .cancel) { (alert) in
                let newItem = alertController.textFields![0].text
//                let isCompleted = alertController.textFields![1].text
                
                if newItem != "" {
                    self.addItem(todo: newItem!, completed: true)
                }
            }
            
            alertController.addAction(alertAction1)
            alertController.addAction(alertAction2)
            
            self.present(alertController, animated: true)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: addAction, menu: nil)
    }
    
    func addItem(todo: String, completed: Bool) {
        let newItem = ToDo(todo: todo, completed: completed)
        viewModels.append(newItem)
        
        tableView.reloadData()
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
