//
//  ViewController.swift
//  STToDoListDemo
//
//  Created by song on 2021/11/23.
//

import UIKit
import SnapKit
import IQKeyboardManager

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let viewModel: STListViewModel = STListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(STListTableViewCell.self, forCellReuseIdentifier: "STListTableViewCell")

        self.viewModel.addToDoList(title: "SwiftUI Essentials", content: "Building Lists and Navigation")
        self.viewModel.addToDoList(title: "SwiftUI Essentials", content: "Creating and Combining Views")
        self.viewModel.addToDoList(title: "SwiftUI Essentials", content: "Handling User Input")

        self.viewModel.addToDoList(title: "Drawing and Animation", content: "Animating Views and Transitions")
        self.viewModel.addToDoList(title: "Drawing and Animation", content: "Drawing Paths and Shapes")

        self.viewModel.addToDoList(title: "App Design and Layout", content: "Handling User Input")
        self.viewModel.addToDoList(title: "App Design and Layout", content: "Building Lists and Navigation")
        self.viewModel.addToDoList(title: "App Design and Layout", content: "Creating and Combining Views")
        self.viewModel.addToDoList(title: "App Design and Layout", content: "Handling User Input")
    
        self.title = "List"
        navigationItem.searchController = searchController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    @objc func itemClick(sender: STCircleButton) {
        if let indexPath = sender.indexPath {
            var model = self.viewModel.cellForRowAt(section: indexPath.section, row: indexPath.row, isFiltering: false)
            if model.isDeleted, model.isSelected { return }
            model.isSelected = !model.isSelected
            self.viewModel.didSelectRowAt(section: indexPath.section, row: indexPath.row, model: model)
            self.tableView.reloadData()
        }
    }
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.returnKeyType = UIReturnKeyType.search
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "Search To Do Item"
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        return searchController
    }()
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        self.viewModel.filteredModels(searchText: searchText.lowercased())
        self.tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections(isFiltering: isFiltering())
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInSection(section: section, isFiltering: isFiltering())
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "STListTableViewCell", for: indexPath) as? STListTableViewCell {
            let model = self.viewModel.cellForRowAt(section: indexPath.section, row: indexPath.row, isFiltering: isFiltering())
            cell.update(isSelected: model.isSelected)
            cell.update(content: model.content, isDeleted: model.isDeleted)
            cell.bigCircleView.indexPath = indexPath
            cell.bigCircleView.addTarget(self, action: #selector(itemClick(sender:)), for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        headView.backgroundColor = UIColor.st_color(hexString: "#f6f6f6")

        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        headView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.centerY.equalTo(headView.snp.centerY)
        }
        titleLabel.text = self.viewModel.viewForHeaderInSection(section: section)
        return headView
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.textFiledChange(textField: textField)
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textFiledChange(textField: textField)
        return true
    }
    
    func textFiledChange(textField: UITextField) {
        if textField.text?.count ?? 0 < 1 {
            if let field: STTextField = textField as? STTextField {
                if let indexPath = field.indexPath {
                    deleteToDo(isDelete: true, indexPath: indexPath)
                }
            }
        }
    }
    
    func deleteToDo(isDelete: Bool, indexPath: IndexPath) {
        var model = self.viewModel.cellForRowAt(section: indexPath.section, row: indexPath.row, isFiltering: isFiltering())
        model.isDeleted = isDelete
        self.viewModel.didSelectRowAt(section: indexPath.section, row: indexPath.row, model: model)
        self.tableView.reloadData()
    }
}
