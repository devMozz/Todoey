//
//  ViewController.swift
//  Todoey
//
//  Created by MilyMozz on 07/09/2018.
//  Copyright © 2018 mozzDev. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    //    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogoron"]
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    let defaults = UserDefaults.standard
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        print(dataFilePath!)
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
//        loadItems()
        
        //        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
        //            itemArray = items
        //        }
        
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //cellForRowAt - 테이블뷰에 텍스트 뿌리기
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        //        let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemCell")
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        //        if item.done == true {
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }
        
        //Ternary operator
        cell.accessoryType = item.done ? .checkmark : .none
        
        print("cellForRowAtIndexPath Called")
        
        return cell
    }
    
    
    //MARK - Tableview Delegate Methods
    
    //didSelectRowAt - 어떤 행을 선택하고, 그것을 사용함
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        //        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        
        //        if itemArray[indexPath.row].done == false {
        //            itemArray[indexPath.row].done = true
        //        } else {
        //            itemArray[indexPath.row].done = false
        //        }
        
        //Update
        //        itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
        
        //Data에 있는 데이터를 먼저 지우고 그 이후에 뷰에 있는 아이템을 지운다
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        //Toggling
        //        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todaey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on UIAlert
            //            print("Add item pressed")
            
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            //            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
        }
        
        //EditText == TextField
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
            print("Now")
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Model Manupulation Methods(Decodable, Encodable == Codable -> class Item : Codable)
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    //외부 with 내부 request 매개 변수
    //Item.fetchRequest() -> 기본 볼륨을 가질 수 있다(Default)
    func loadItems(with reqeust: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        //        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        if let additionalPredicate = predicate {
            reqeust.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            reqeust.predicate = categoryPredicate
        }
        
        
//        let compountPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
//        reqeust.predicate = compountPredicate
        
        do {
            itemArray = try context.fetch(reqeust)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
}


//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //검색한다
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //정렬한다
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        
        //        do {
        //            itemArray = try context.fetch(request)
        //        } catch {
        //            print("Error fetching data from context \(error)")
        //        }
        
        //        tableView.reloadData()
        
    }
    
    //MARK: 검색 후 취소 버튼을 누르면 모든 리스트를 다시 불러온다.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
    
    
}
