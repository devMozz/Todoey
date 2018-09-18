//
//  ViewController.swift
//  Todoey
//
//  Created by MilyMozz on 07/09/2018.
//  Copyright © 2018 mozzDev. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import SwipeCellKit

class TodoListViewController: SwipeTableViewController {
    
    //    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogoron"]
    var itemArray : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
            
            tableView.rowHeight = 80.0
        }
    }
    
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    let defaults = UserDefaults.standard
    
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    //cellForRowAt - 테이블뷰에 텍스트 뿌리기
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        //        let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemCell")
        
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = itemArray?[indexPath.row].title
            
            //        if item.done == true {
            //            cell.accessoryType = .checkmark
            //        } else {
            //            cell.accessoryType = .none
            //        }
            
            //Ternary operator
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Item Added"
        }
        
        print("cellForRowAtIndexPath Called")
        
        return cell
    }
    
    
    //MARK: - Tableview Delegate Methods
    
    //didSelectRowAt - 어떤 행을 선택하고, 그것을 사용함
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row] {
            do{
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
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
        
        //        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todaey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on UIAlert
            //            print("Add item pressed")
            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                    
                }
            }
            
            self.tableView.reloadData()
            
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
    
    //    func saveItems() {
    //
    //        do{
    //            try realm.write {
    //                realm.add(itemArray)
    //            }
    //        } catch {
    //            print("Error saving category \(error)")
    //        }
    //
    //        self.tableView.reloadData()
    //    }
    
    //외부 with 내부 request 매개 변수
    //Item.fetchRequest() -> 기본 볼륨을 가질 수 있다(Default)
    //    func loadItems(with reqeust: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
    func loadItems() {
        //        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //단 한 줄? 밑에 보면 뜨억!
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        
        //        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        //
        //        if let additionalPredicate = predicate {
        //            reqeust.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        //        } else {
        //            reqeust.predicate = categoryPredicate
        //        }
        //
        //        do {
        //            itemArray = try context.fetch(reqeust)
        //        } catch {
        //            print("Error fetching data from context \(error)")
        //        }
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = itemArray?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting Item \(error)")
            }
        }
    }
    
}


//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
        //        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //
        //        //검색한다
        //        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //
        //        //정렬한다
        //        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        //
        //        loadItems(with: request, predicate: predicate)
        
        //        do {
        //            itemArray = try context.fetch(request)
        //        } catch {
        //            print("Error fetching data from context \(error)")
        //        }
        
        //        tableView.reloadData()
        
    }
    
    //MARK: - 검색 후 취소 버튼을 누르면 모든 리스트를 다시 불러온다.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
    
    
}
