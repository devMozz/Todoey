//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by MilyMozz on 18/09/2018.
//  Copyright © 2018 mozzDev. All rights reserved.
//

import UIKit
import SwipeCellKit

//Super Class(상속 개념)
class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        //위임 -> 다른 메소드에서 사용
        cell.delegate = self
        
        return cell
    }
    
    
    //Mark: - Swipe Cell Delegate Methods
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion

            self.updateModel(at: indexPath)

        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    
    //MARK: - Update Model
    //Out - at, In - indexPath
    func updateModel(at indexPath: IndexPath) {
        
        print("Item deleted Super Class")
    }
    
}
