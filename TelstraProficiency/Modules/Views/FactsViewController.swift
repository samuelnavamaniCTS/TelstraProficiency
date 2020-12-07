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
        static let resuseIdentifier = "FactsViewCellID"
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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.resuseIdentifier)
    }
}

//MARK: - UITableViewDataSource Methods

extension FactsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRowsInSection() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = viewModel?.cellForRowAt(indexPath: indexPath) else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.resuseIdentifier, for: indexPath)
        cell.textLabel?.text = row.title
        return cell
    }
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

