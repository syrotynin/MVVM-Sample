//
//  SearchViewController.swift
//  MVVM-Sample
//
//  Created by Serhii Syrotynin on 6/26/17.
//  Copyright © 2017 Serhii Syrotynin. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - View Model
    
    private let viewModel = SearchViewModel()
    
    // MARK: - View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    func bindViewModel() {
        
        viewModel.searchString.bidirectionalBind(to:searchField.reactive.text)
        
        // change text color if valid (Red - valid, Gray - not)
        viewModel.validSearchText
            .map { $0 ? .black : .gray }
            .bind(to: searchField.reactive.textColor)
        
        // table view cells handling
        
        viewModel.searchResults.bind(to: tableView) { dataSource, indexPath, tableView in
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchItemTableViewCell
            let track = dataSource[indexPath.row]
            cell.label.text = track.title
            
            // load track image
            let backgroundQueue = DispatchQueue(label: "backgroundQueue",
                                                qos: .background,
                                                attributes: .concurrent,
                                                autoreleaseFrequency: .inherit,
                                                target: nil)
            cell.photo.image = nil
            backgroundQueue.async {
                if let imageData = try? Data(contentsOf: track.url) {
                    DispatchQueue.main.async() {
                        cell.photo.image = UIImage(data: imageData)
                    }
                }
            }
            
            return cell
        }
        
        viewModel.searchInProgress
            .map { !$0 }.bind(to: activityIndicator.reactive.isHidden)
        
        viewModel.searchInProgress
            .map { $0 ? CGFloat(0.5) : CGFloat(1.0) }
            .bind(to: tableView.reactive.alpha)
        
        _ = viewModel.errorMessages.observeNext {
            [unowned self] error in
            
            let alertController = UIAlertController(title: "Something went wrong :-(", message: error, preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            let actionOk = UIAlertAction(title: "OK", style: .default,
                                         handler: { action in alertController.dismiss(animated: true, completion: nil) })
            
            alertController.addAction(actionOk)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsSegue" {
            if let settingsVC = segue.destination as? SettingsViewController {
                settingsVC.viewModel = viewModel.settingsViewModel
            }
        }
    }
}
