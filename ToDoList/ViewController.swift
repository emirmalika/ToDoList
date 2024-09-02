//
//  ViewController.swift
//  ToDoList
//
//  Created by Malik Em on 29.08.2024.
//

import UIKit
import CoreData

final class ViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        
        let table = UITableView()
        
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.register(TodoTableViewCell.self, forCellReuseIdentifier: "Identifier")
        
        return table
    }()
    
    lazy var dataManager = CoreDataManager.shared
    lazy var context = dataManager.persistentContainer.viewContext
//    let newTodo = ToDo(context: dataManager.viewContext)
    private var viewModels = [ToDo]()
    private var new = [ToDo]()
    private var items = [Tasks]()
    private var date: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        navigationItem.title = "Задачи"
        setupLayout()
        addAction()
        fetchData()
        saveLoadedData()
        editAction()
  
     
//        saveLoadedData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let context = dataManager.persistentContainer.viewContext
        let fetchRequest = ToDo.fetchRequest() as NSFetchRequest<ToDo>
        do {
            viewModels = try context.fetch(fetchRequest)
        } catch let error {
            print ("Не удалось загрузить данные из-за ошибки: \(error).")
        }
        tableView.reloadData()
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
            
            self.saveData(todo: alertController.textFields![0].text ?? "", completed: true, date: TodoTableViewCell.shared.setupDate())
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: addAction, menu: nil)
    }
    
    func addItem(todo: String, completed: Bool) {
        let newItem = ToDo(context: dataManager.viewContext)
        
        viewModels.append(newItem)

        tableView.reloadData()
    }
//
    func saveData(todo: String, completed: Bool, date: String) {
        
        let newTodo = ToDo(context: dataManager.viewContext)
        newTodo.todo = todo
        newTodo.completed = completed
        newTodo.date = date
        newTodo.todoID = UUID().uuidString
        
        do {
            try dataManager.viewContext.save()
        } catch let error {
            print ("Не удалось сохранить из-за ошибки \(error).")
        }
    }
    
    func saveLoadedData() {
        
        for i in items {
           
            addItem(todo: i.todo, completed: i.completed)
            saveData(todo: i.todo, completed: i.completed, date: date)
            
        }
        
    
    }
    
    private func fetchData() {
        NetworkManager.shared.fetchData { [weak self] result in
            switch result {
            case .success(let tasks):
        
            self?.items = tasks.todos.compactMap {
                Tasks(todo: $0.todo, completed: $0.completed)
            }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            self?.items.reverse()
        
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
 
   
        date = cell.setupDate()

        return cell
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        
        let todo = viewModels[sourceIndexPath.row]
        viewModels.remove(at: sourceIndexPath.row)
        viewModels.insert(todo, at: destinationIndexPath.row)
        
        let context = dataManager.persistentContainer.viewContext
        do {
            try context.save()
        } catch let error {
            print ("Не удалось сохранить из-за ошибки \(error).")
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if viewModels.count > indexPath.row {
                let todo = viewModels[indexPath.row]
                
                let context = dataManager.persistentContainer.viewContext
                context.delete(todo)
                viewModels.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                do {
                    try context.save()
                } catch let error {
                    print ("Не удалось сохранить из-за ошибки \(error).")
                }
            }
        }
    }
}
