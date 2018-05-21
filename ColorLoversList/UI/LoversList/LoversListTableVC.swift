//
//  LoversListTableVC.swift
//  ColorLoversList
//
//  Created by Grzesiek on 09/01/2018.
//  Copyright © 2018 Grzesiek. All rights reserved.
//

import UIKit

class LoversListTableVC: UITableViewController {
    
    @IBOutlet weak var pictureTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    static let PicturesSequeIdentifier = "Pictures"
    static let TableCellReusableName = "TableCell"

    let viewModel = LoversListTableVM()

    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        fetchEntries()
    }
    
    func fetchEntries() {

        viewModel.fetchEntries(handler: { response in
            self.refreshControl?.endRefreshing()
            switch response {
            case .success(_):
                self.tableView.reloadData()
            case .error(let error):
                self.showAlert(withTitle: "Error", message: error.errorDescription)
                print ("Error: \(error)")
            }
        })
    }
    
    // MARK: - Actions
    
    @IBAction func refreshControlAction(_ sender: UIRefreshControl) {

        viewModel.clearData()
        fetchEntries()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.lovers.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if viewModel.shouldFetchNextExtries(index: indexPath.row) {
            fetchEntries()
        }
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: LoversListTableVC.TableCellReusableName, for: indexPath)
        cell.textLabel?.text = viewModel.loverName(index: indexPath.row)
        cell.detailTextLabel?.text = viewModel.loverDetails(index: indexPath.row)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destinationVC = segue.destination as? PicturesListTableVC,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell),
            segue.identifier == LoversListTableVC.PicturesSequeIdentifier else { return }

        destinationVC.lover = viewModel.lovers[indexPath.row]
        destinationVC.pictureType = PictureType(rawValue: pictureTypeSegmentedControl.selectedSegmentIndex)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {

        let typeIndex = pictureTypeSegmentedControl.selectedSegmentIndex
        guard let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell),
            identifier == LoversListTableVC.PicturesSequeIdentifier,
            let pictureType = PictureType(rawValue: typeIndex) else { return false }
        let lover = viewModel.lovers[indexPath.row]
        return viewModel.numberOfPictures(lover: lover, pictureType: pictureType) > 0 ? true : false
    }
    
}
