//
//  ViewController.swift
//  DZ
//
//  Created by Pavel Shabliy on 20.02.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableViewListOfProducts: UITableView!
    
    var listOfProducts = [String]()
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableViewListOfProducts.register(UITableViewCell.self , forCellReuseIdentifier: "Cell")
        
        listOfProducts = getProductData()
    }
    
    func saveProductData(_ productName:String) {
        listOfProducts.append(productName)
        userDefaults.set(listOfProducts, forKey: "UserText")
       
    }

    func getProductData() -> [String] {
        let product = userDefaults.stringArray(forKey: "UserText") ?? [String]()
        return product
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "List",
                                      message: "Add a new product",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Return", style: .default) { action in
            
            guard let textField = alert.textFields?.first,
                  let productToSave = textField.text else {
                      return
                  }

            self.saveProductData(productToSave)
           
            self.listOfProducts = self.getProductData()

            self.tableViewListOfProducts.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)

    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfProducts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let product = self.listOfProducts[indexPath.row]
        
        let cell = tableViewListOfProducts.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = product
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           
            listOfProducts.remove(at: indexPath.row)
            tableViewListOfProducts.deleteRows(at: [indexPath], with: .automatic)
            
            UserDefaults.standard.set(listOfProducts, forKey: "UserText")
        }
    }
}


