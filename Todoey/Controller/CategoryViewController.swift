//
//  CategoryViewController.swift
//  Todoey
//
//  Created by MilyMozz on 11/09/2018.
//  Copyright © 2018 mozzDev. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.rowHeight = 80.0
        
        tableView.separatorStyle = .none
        
    }
    
    
    
    //MARK: - Datasource Methods == Android - onCreateViewHolder
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Nil Coalescing Operator
        //만약에 널이 온다면? 1이라도 보내
        return categories?.count ?? 1
    }
    
    
    //각 행에 텍스트 뿌려주기
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet!"
        
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].colour ?? "1D9BF6")
        
        return cell
        
    }
    
    
    //MARK: - Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //행을 선택하면 다음 VC로 이동
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        //didSet ->
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
        
    }
    
    
    
    //MARK: - Data Manipulation Methods
    func save(category: Category) {
        do{
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    //MARK: - Load Categories List
    func loadCategories() {
        
        //        let request : NSFetchRequest<Category> = Category.fetchRequest()
        //
        //        do{
        //            categories = try context.fetch(request)
        //        } catch {
        //            print("Error loading categories \(error)")
        //        }
        
        
        //단 한 줄.... 난 지금까지 무얼하고 있었던 것인가!!!!!!
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    //MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        
        super.updateModel(at: indexPath)
        
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category \(error)")
            }
            
        }
    }
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            //이제 스트링이다!
            newCategory.colour = UIColor.randomFlat.hexValue()
            
            //self.categories.append(newCategory)
            
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

