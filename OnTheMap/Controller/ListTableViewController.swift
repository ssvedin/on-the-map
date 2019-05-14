//
//  ListTableViewController.swift
//  OnTheMap
//
//  Created by Sabrina on 3/24/19.
//  Copyright © 2019 Sabrina Svedin. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    // MARK: Outlets and Properties
    
    @IBOutlet weak var studentTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var students = [StudentInformation]()
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        myIndicator.isHidden = true
        myIndicator.hidesWhenStopped = true
        showActivityIndicator()
        getStudentsList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        showActivityIndicator()
        getStudentsList()
    }
    
    // MARK: Refresh list
    
    @IBAction func refreshList(_ sender: UIBarButtonItem) {
        // self.activityIndicator.startAnimating()
        showActivityIndicator()
        getStudentsList()
    }
    
    // MARK: Get list of students
    
    func getStudentsList() {
        UdacityClient.getStudentsLocation() {students, error in
            self.students = students ?? []
            DispatchQueue.main.async {
                self.hideActivityIndicator()
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: Activity Indicator
    
    var myIndicator: UIActivityIndicatorView {
        let myIndicator:UIActivityIndicatorView = UIActivityIndicatorView (style: UIActivityIndicatorView.Style.gray)
        self.view.addSubview(myIndicator)
        myIndicator.bringSubviewToFront(self.view)
        myIndicator.center = self.view.center
        return myIndicator
    }
    
    func showActivityIndicator() {
        myIndicator.isHidden = false
        myIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        myIndicator.stopAnimating()
    }

    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell", for: indexPath)
        let student = students[indexPath.row]
        cell.textLabel?.text = "\(student.firstName)" + " " + "\(student.lastName)"
        cell.detailTextLabel?.text = "\(student.mediaURL ?? "")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[indexPath.row]
        UIApplication.shared.open(URL(string: student.mediaURL ?? "")!, options: [:], completionHandler: nil)
    }
    
}
