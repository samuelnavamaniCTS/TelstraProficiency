//
//  FactsViewController.swift
//  TelstraProficiency
//
//  Created by Navamani, Samuel on 5/12/20.
//

import UIKit

class FactsViewController: UITableViewController {
    
    //MARK: - Enums
    
    enum Constants {
        static let resuseIdentifier = "FactsCellID"
        static let connectionError = "Connection Error"
        static let primary = "Ok"
    }
    
    //MARK: - Properties
    
    var viewModel: FactsViewModel? {
        didSet {
            viewModel?.delegate = self
        }
    }

    //MARK: - LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let viewModel = viewModel {
            viewModel.getFacts()
        }
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100 //UITableView.automaticDimension
        tableView.register(FactsTableViewCell.self, forCellReuseIdentifier: Constants.resuseIdentifier)
    }
}

//MARK: - UITableViewDataSource Methods

extension FactsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRowsInSection() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.resuseIdentifier) as? FactsTableViewCell, let row = viewModel?.cellForRowAt(indexPath: indexPath) else {
            return UITableViewCell()
        }
        
        cell.configure(row)
        return cell
    }
}

extension FactsViewController {
    
//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        UITableView.automaticDimension
//    }
//
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        UITableView.automaticDimension
//    }
}

//MARK: - FactsViewModelDelegate Methods

extension FactsViewController: FactsViewModelDelegate {
    func didUpdate(_ viewModel: FactsViewModel, error: Error?) {
        navigationItem.title = viewModel.factsTitle()

        if let error = error {
            showAlert(error.localizedDescription)
        } else {
            tableView.reloadData()
        }
    }
}

//MARK: - Private Methods

private extension FactsViewController {
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: Constants.connectionError, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.primary, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

