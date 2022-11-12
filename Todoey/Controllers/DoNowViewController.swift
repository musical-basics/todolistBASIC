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
    var saveItemArray = [Item]()
    var numItemsShown = 1
    @IBOutlet weak var scoreLabel: UILabel!
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let saveFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ItemsSave.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if itemArray.count == 0 {
            let newItem = Item()
            newItem.title = "Placeholder"
            itemArray.append(newItem)
        }
        
        
        
        

        
        loadItems()
        scoreLabel.text = String(saveItemArray.count)
        // Do any additional setup after loading the view.
    }

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numItemsShown
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
        
        saveItemArray.append(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
        
        
        if itemArray.count == 0 {
            let newItem = Item()
            newItem.title = "Placeholder"
            itemArray.append(newItem)
        } else {
            saveItems()
        }
        
        
        
//        tableView.reloadData()
        
        let alert = UIAlertController(title: "Task Completed.", message: "", preferredStyle: .alert)
        
        present(alert, animated: true, completion: nil)
//        alert.dismiss(animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            alert.dismiss(animated: true, completion: nil)
        })
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func editTopCell(_ sender: UIBarButtonItem) {
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)
     
        var textField = UITextField()

        let alert = UIAlertController(title: "Edit Current Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Edit This Item", style: .default) { (action) in

//            let newItem = Item()
            
            let newItem = self.itemArray[0]
            newItem.title = textField.text!

            self.itemArray[0] = newItem
            self.saveItems()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = self.itemArray[0].title


            textField = alertTextField

        }

        alert.addAction(action)


        present(alert, animated: true, completion: nil)
        
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
        
        
        //MARK: SAVED ITEMS
        do{
            let data = try encoder.encode(saveItemArray)
            try data.write(to: saveFilePath!)
        } catch {
            print("error encoding item array")
        }
        
        
        scoreLabel.text = String(saveItemArray.count)
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
        
        //MARK: SAVED ITEMS
        if let data = try? Data(contentsOf: saveFilePath!) {
            let decoder = PropertyListDecoder()
            do{
                saveItemArray = try decoder.decode([Item].self, from: data)
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


    
    //MARK: SHOW 2 ITEMS
    
    @IBAction func showTwoItemsPressed(_ sender: UIBarButtonItem) {
        if numItemsShown == 1 {
            
            numItemsShown = 2
            self.tableView.reloadData()
            
        } else {
            numItemsShown = 1
            self.tableView.reloadData()
        }
            
        
    }
    
    

    
    
    
    
    
    
}
