//
//  DoNowViewController.swift
//  Todoey
//
//  Created by Lionel Yu on 11/10/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit

class DoNowViewController: UITableViewController {

    var itemArray = [Item]()
    
    
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if itemArray.count == 0 {
            let newItem = Item()
            newItem.title = "Placeholder"
            itemArray.append(newItem)
        }
        
        
        
//        print(dataFilePath)

        
        loadItems()
        // Do any additional setup after loading the view.
    }

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoNowItemCell", for: indexPath)
        
        
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.lineBreakMode = .byWordWrapping;
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        itemArray.remove(at: indexPath.row)
        
        if itemArray.count == 0 {
            let newItem = Item()
            newItem.title = "Placeholder"
            itemArray.append(newItem)
        } else {
            saveItems()
        }
        
        
//        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonSmashed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            

            
            
            self.saveItems()
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            
            
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }

    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("error encoding item array")
        }
        
        self.tableView.reloadData()
    }
    
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("error decoding")
            }
        }
        
        if itemArray.count == 0 {
            let newItem = Item()
            newItem.title = "Placeholder"
            itemArray.append(newItem)
        } else {
            saveItems()
        }
    }



}
