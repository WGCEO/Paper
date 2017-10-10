//
//  PianoTextView_CoreData.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 7..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit
import  CoreData

extension PianoTextView {
    /*
    internal func updateTextView(){
        self.textColor = Global.textColor
        self.font = Global.transformToFont(name: paper.font)
        
        for (key, value) in CoreData.sharedInstance.cache {
            if value == paper {
                self.attributedText = key
                return
            }
        }
        
        let attrString = NSKeyedUnarchiver.unarchiveObject(with: self.paper.fullContent) as! NSAttributedString
        self.attributedText = attrString
    }
    
    internal func createNewNote(category: Category){
        let paragraphStyle = Global.defaultParagraphStyle
        
        //기존 노트가 없을 때에는 이전 노트에서 참조할 수 없으므로 폰트, 컬러를 새롭게 만들어줘야함
        let prevFontStr: String
        let prevColorStr: String
        
        if let note = self.note {
            prevFontStr = note.font
            prevColorStr = note.color
        } else {
            prevFontStr = "system17"
            prevColorStr = "red"
        }
        
        let attrString = NSAttributedString(string: "", attributes: [
            .font : Global.transformToFont(name: prevFontStr),
            .paragraphStyle : paragraphStyle,
            .foregroundColor : Global.textColor])
        let data = NSKeyedArchiver.archivedData(withRootObject: attrString)
        let newNote = Note(context: CoreData.sharedInstance.viewContext)
        newNote.content = data
        newNote.color = prevColorStr
        newNote.category = category
        newNote.font = prevFontStr
        self.note = newNote
        self.font = Global.transformToFont(name: prevFontStr)
        self.textColor = Global.textColor
    }
    
    internal func deleteNoteIfNeeded(note: Note){
        let attrString = NSKeyedUnarchiver.unarchiveObject(with: paper.fullContent) as! NSAttributedString
        if attrString.length == 0 {
            CoreData.sharedInstance.viewContext.delete(note)
            CoreData.sharedInstance.saveIfNeeded()
        }
    }
 
     */
}
