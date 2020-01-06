//
//  InterfaceController.swift
//  Voice Notes WatchKit Extension
//
//  Created by muhammad Awais on 1/4/20.
//  Copyright © 2020 muhammad Awais. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var Table: WKInterfaceTable!
    var notes = [String]()
    var savePath = InterfaceController.getDocumentsDirectory().appendingPathComponent("notes").path
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        notes = NSKeyedUnarchiver.unarchiveObject(withFile: savePath) as? [String] ?? [String]()
        
        // Configure interface objects here.
        Table.setNumberOfRows(notes.count, withRowType: "Row")
        
        for rowIndex in 0 ..< notes.count {
            set(row: rowIndex, to: notes[rowIndex])
        }
    }
    
    func set(row rowIndex: Int, to text: String)
    {
        guard let row = Table.rowController(at: rowIndex) as? NoteSelectRow else { return }
        row.textLabel.setText(text)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func addNewNote() {
//        take user input 
        presentTextInputController(withSuggestions: nil, allowedInputMode: .plain) { [unowned self]
            result in
            
            guard let result = result?.first as? String else { return }
            
            self.Table.insertRows(at: IndexSet(integer: self.notes.count), withRowType: "Row")
            
            self.set(row: self.notes.count, to: result)
            
            self.notes.append(result)
            
            NSKeyedArchiver.archiveRootObject(self.notes, toFile: self.savePath)
        }
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        return ["index" : String(rowIndex + 1), "note" : notes[rowIndex]]
    }
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
}
