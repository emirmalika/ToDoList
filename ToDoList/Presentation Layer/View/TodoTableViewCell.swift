//
//  TodoListTableViewCell.swift
//  ToDoList
//
//  Created by Malik Em on 04.09.2024.
//

import UIKit

final class TodoTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "Identifier"
    static let shared = TodoTableViewCell()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var statusImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with viewModel: ToDo) {
        titleLabel.text = viewModel.todo
        if viewModel.completed == true {
            statusImage.image = UIImage(named: "check")
        } else {
            statusImage.image = UIImage(named: "uncheck")
        }
        dateLabel.text = setupDate()
    }
    
    func setupDate() -> String {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long
        let date = formatter.string(from: today)

        return date
    }
    
    private func setupLayout() {
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, dateLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        
        contentView.addSubview(stackView)
        contentView.addSubview(statusImage)
    
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: statusImage.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            statusImage.heightAnchor.constraint(equalToConstant: 30),
            statusImage.widthAnchor.constraint(equalToConstant: 30),
            statusImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            statusImage.leadingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 10),
            statusImage.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            statusImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
