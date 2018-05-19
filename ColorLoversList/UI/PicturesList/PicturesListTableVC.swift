//
//  PicturesListTableVC.swift
//  ColorLoversList
//
//  Created by Grzesiek on 09/01/2018.
//  Copyright © 2018 Grzesiek. All rights reserved.
//

import UIKit

class PicturesListTableVC: UITableViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    static let PictureSequeIdentifier = "Picture"
    static let TableCellReusableName = "TableCell"
    
    var lover: Lover?
    var pictureType: PictureType?

    lazy var imageController: ImageController = ImageController()
    let viewModel = PicturesListTableVM()
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = lover?.userName
        viewModel.numberOfPictures = LoversListTableVM().numberOfPictures(lover: lover, pictureType: pictureType)
        fetchEntries()
    }
    
    // MARK: - Actions
    
    @IBAction func refreshControlAction(_ sender: UIRefreshControl) {
        
        viewModel.clearData()
        fetchEntries()
    }
    
    func fetchEntries() {
        
        if let userName = lover?.userName, let pictureType = pictureType {

            viewModel.fetchEntries(userName: userName, pictureType: pictureType) { response in
                
                self.refreshControl?.endRefreshing()
                switch response {
                case .success(_):
                    self.tableView.reloadData()
                case .error(let error):
                    self.showAlert(withTitle: "Error", message: error.errorDescription)
                    print ("Error: \(error)")
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.pictures.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if viewModel.shouldFetchNextExtries(index: indexPath.row) {
            fetchEntries()
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PicturesListTableVC.TableCellReusableName, for: indexPath)
        cell.textLabel?.text = viewModel.pictureName(index: indexPath.row)
        cell.detailTextLabel?.text = viewModel.pictureDetails(index: indexPath.row)

        loadImage(imageUrl: viewModel.pictures[indexPath.row].imageUrl, cell: cell, indexPath: indexPath)
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destinationVC = segue.destination as? PictureVC,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell),
        segue.identifier == PicturesListTableVC.PictureSequeIdentifier else { return }
        destinationVC.picture = viewModel.pictures[indexPath.row]
    }
    
    // MARK: Helper methods
    
    func loadImage(imageUrl: String?, cell: UITableViewCell, indexPath: IndexPath) {

        guard let imageUrl = imageUrl else { return }
        if let image = imageController.imageFromCache(url: imageUrl) {
            cell.imageView?.image = image
            return
        }

        cell.imageView?.image = nil
        imageController.image(url: imageUrl, handler: { (response) in
            switch response {
            case .success(_):
                self.tableView.reloadRows(at: [indexPath], with: .none)
            default: break
            }
        })
    }
    
}

