//
//  DetailViewController.swift
//  NY_Times
//
//  Created by kalyani satapathy on 06/12/19.
//  Copyright © 2019 Dalmia Best Price. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {

    var resultDetails : Result!
    var parentController : ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
         let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
         
         if let imageView = cell.viewWithTag(1001) as? UIImageView{
            
            if let casheImage = parentController.imageCache.object(forKey: resultDetails.media[0].mediaMetadata[0].url!) as? UIImage{
                 imageView.image = casheImage
             }else{
                 parentController.downloadImage(from: resultDetails.media[0].mediaMetadata[2].url, imgViewRef: imageView)
             }
         }
         
          if let titleLbl = cell.viewWithTag(1002) as? UILabel{
                     titleLbl.text = resultDetails.title
        }
      
      return cell
    }
}

