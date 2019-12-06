//
//  ViewController.swift
//  NY_Times
//
//  Created by kalyani satapathy on 06/12/19.
//  Copyright © 2019 Dalmia Best Price. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    @IBOutlet var segmentedControl: UISegmentedControl!
       var rootArray : NSMutableArray! = nil
       var imageCache = NSMutableDictionary()
       var resultDetail : Result!
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           tableView.estimatedRowHeight = 200
           tableView.rowHeight = UITableView.automaticDimension
           self.tableView.tableFooterView = UIView()
           segmentedControl.selectedSegmentIndex = 0
           fetchData()
       }
    
    @IBAction func segmentedControlButtonClickAction(_ sender: UISegmentedControl) {
       fetchData()
    }
       
    // API Calling Function
    func fetchData() {
           
        //get the segment values
        var forDays = ""
        if segmentedControl.selectedSegmentIndex == 0 {
            forDays = "1"
        } else if segmentedControl.selectedSegmentIndex == 1 {
             forDays = "7"
        } else if segmentedControl.selectedSegmentIndex == 2 {
             forDays = "30"
        }
        
        let popularArticals = "mostpopular/v2/viewed/\(forDays).json?api-key=\(apiKey)"
        //Url String for creating a request
           let urlString = baseURLString + popularArticals
           
           guard let urlRequest = URL(string: urlString)  else {
               return
           }
           
        //Add activity indicator for in table view
        let activity = UIActivityIndicatorView()
           activity.assignColor(.black)
           activity.center = self.tableView.center
           activity.startAnimating()
           self.tableView.addSubview(activity)
           
        //create a session for feth the data from NY times api
           URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
               guard let data = data else{
                   activity.stopAnimating()
                   return
               }
               
               do{
                   //Get all the data in a dictionary
                   if let jsonDic = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary{
                       //Pass dictionay to root model class
                      self.rootArray = ResponseParser.sharedInstance.apiResponse(jsonDic: jsonDic)
                       
                    //Display the Title on Home view
                       DispatchQueue.main.async {
                           self.title = "NY Times Most Popular"
                           self.tableView.reloadData()
                           activity.stopAnimating()

                       }
                       
                   }
                   
               }catch let jsonError{
                   print("Error while passing json %@",jsonError.localizedDescription)
                   DispatchQueue.main.async {
                       activity.stopAnimating()
                   }
               }
               
            }.resume()
           
       }
       

       // MARK: - Table view data source

       override func numberOfSections(in tableView: UITableView) -> Int {
           
           return 1
       }

       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return self.rootArray?.count ?? 0
       }

       
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

           if let modelResult = self.rootArray.object(at: indexPath.row) as? Result{
               
        //Display image of cell
               if let imageView = cell.viewWithTag(1001) as? UIImageView{
               
                if let casheImage = imageCache.object(forKey: modelResult.media[0].mediaMetadata[0].url!) as? UIImage{
                      imageView.image = casheImage
                   }else{
                       self.downloadImage(from: modelResult.media[0].mediaMetadata[0].url, imgViewRef: imageView)
                   }
               }
               
       //Display Title,By,Source,Date on cell
               if let titleLbl = cell.viewWithTag(1002) as? UILabel{
                   titleLbl.text = modelResult.title
               }
               if let bylineLbl = cell.viewWithTag(1003) as? UILabel{
                   bylineLbl.text = modelResult.byline
               }
               if let sourceLbl = cell.viewWithTag(1004) as? UILabel{
                   sourceLbl.text = modelResult.source
               }
               if let publishDateLbl = cell.viewWithTag(1005) as? UILabel{
                   publishDateLbl.text = modelResult.publishedDate
               }
           }
           
           
           return cell
       }
       
       
       override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return UITableView.automaticDimension
       }
       
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
          self.performSegue(withIdentifier: "detailPage", sender: self)
           
       }

       
       //Seue for next view controller
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           
           if segue.identifier == "detailPage" {
               let destination:DetailViewController = segue.destination as! DetailViewController
               let result = self.rootArray.object(at: (self.tableView.indexPathForSelectedRow?.row)!) as! Result
               destination.resultDetails = result
               destination.parentController = self
               
           }
       }

    //Download and caching the image from URL
       func downloadImage(from : String, contentMode mode : UIView.ContentMode = .scaleAspectFill, imgViewRef : UIImageView){
           
           guard let url = URL(string: from) else { return }
           URLSession.shared.dataTask(with: url) { data, response, error in
               guard
                   let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                   let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                   let data = data, error == nil,
                   let image = UIImage(data: data)
                   else { return }
               DispatchQueue.main.async() {
                   imgViewRef.image = image
                   self.imageCache.setValue(image, forKey: from)
              
            }
               }.resume()
       }
}

extension UIActivityIndicatorView {
    func assignColor(_ color: UIColor) {
        style = .whiteLarge
        self.color = color
    }
}
