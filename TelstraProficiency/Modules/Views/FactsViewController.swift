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
        static let pullToRefresh = "Pull to refresh."
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
        
        configureRefresh()
        configureTableView()
        getFacts()
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
        
        if let url = row.url {
            tableView.beginUpdates()
            let cellToken = viewModel?.loadImage(from: url, completion: { image in
                cell.factsImage = image
            })
            cell.onReuse = {
                if let token = cellToken {
                    self.viewModel?.cancelLoad(token: token)
                }
            }
            tableView.endUpdates()  
        }
        cell.configure(row)
        return cell
    }
}

//MARK: - FactsViewModelDelegate Methods

extension FactsViewController: FactsViewModelDelegate {
    func didUpdate(_ viewModel: FactsViewModel, error: Error?) {
        navigationItem.title = viewModel.factsTitle()
        refreshControl?.endRefreshing()
        
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
    
    func configureRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: Constants.pullToRefresh)
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(FactsTableViewCell.self, forCellReuseIdentifier: Constants.resuseIdentifier)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        getFacts()
    }
    
    func getFacts() {
        if let viewModel = viewModel {
            viewModel.getFacts()
        }
    }
}

