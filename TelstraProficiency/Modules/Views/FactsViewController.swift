//
//  FactsViewController.swift
//  TelstraProficiency
//
//  Created by Navamani, Samuel on 5/12/20.
//

import UIKit

class FactsViewController: UITableViewController {
    
    var viewModel: FactsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let viewModel = viewModel {
            viewModel.getFacts()
        }
    }
}

