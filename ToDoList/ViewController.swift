//
//  ViewController.swift
//  ToDoList
//
//  Created by Luis Guette on 2/16/20.
//  Copyright © 2020 Luis Guette. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var importantCheckbox: NSButton!
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var deleteButton: NSButton!
    
    var toDoItems : [ToDoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getToDoItems()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func getToDoItems() {
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
           
            do {
                toDoItems = try context.fetch(ToDoItem.fetchRequest())
            } catch {}
            
            tableView.reloadData()
        }
    }

    @IBAction func addClicked(_ sender: Any) {
        
        if textField.stringValue != "" {
            if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                
                let toDoItem = ToDoItem(context: context)
                
                toDoItem.name = textField.stringValue
                
                if importantCheckbox.state.rawValue == 0 {
                    toDoItem.important = false
                } else {
                    toDoItem.important = true
                }

                (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)

                textField.stringValue = ""
                importantCheckbox.state = NSControl.StateValue(0)
                
                getToDoItems()
            }
        }
        
    }
    
    @IBAction func deleteClicked(_ sender: Any) {
        
        let toDoItem = toDoItems[tableView.selectedRow]
        
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        
            context.delete(toDoItem)
            (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
            getToDoItems()
            
            deleteButton.isHidden = true
        
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let importantColumnId = NSUserInterfaceItemIdentifier(rawValue: "importantColumn")
        let toDoItemsColumnId = NSUserInterfaceItemIdentifier(rawValue: "toDoItemsColumn")
        let importantCellId = NSUserInterfaceItemIdentifier(rawValue: "importantCell")
        let toDoItemCellId = NSUserInterfaceItemIdentifier(rawValue: "toDoItemCell")
        
        let toDoItem = toDoItems[row]
        
        if tableColumn?.identifier == importantColumnId {
            if let importantCell = tableView.makeView(withIdentifier: importantCellId, owner: self) as? NSTableCellView {
                
                if toDoItem.important {
                    importantCell.textField?.stringValue = "❗️"
                } else {
                    importantCell.textField?.stringValue = ""
                }
                
                return importantCell
            }
        }
        
        if tableColumn?.identifier == toDoItemsColumnId {
            if let toDoItemcell = tableView.makeView(withIdentifier: toDoItemCellId, owner: self) as? NSTableCellView {
                
                toDoItemcell.textField?.stringValue = toDoItem.name!
                
                return toDoItemcell
            }
        }
                
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        deleteButton.isHidden = false
    }
}

