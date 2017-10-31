//
//  PaperListTableView.swift
//  Paper-mac
//
//  Created by changi kim on 2017. 10. 25..
//  Copyright © 2017년 Piano. All rights reserved.
//

import Cocoa

class PaperTableView: NSTableView {
    private var paperResultsController: NSFetchedResultsController<Paper>!
    weak var paperListViewController: PaperListViewController?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup(){
        dataSource = self
        delegate = self
        setupPaperResultsController(selectedTags: [])
    }
    
    private func setupPaperResultsController(selectedTags: [Tag]){
        let context = CoreData.sharedInstance.viewContext
        let request: NSFetchRequest<Paper> = Paper.fetchRequest()
        let predicate: NSPredicate
        if selectedTags.count > 0 {
            predicate = NSPredicate(format: "tags IN %@ AND inTrash == false", selectedTags)
        } else {
            predicate = NSPredicate(format: "inTrash == false")
        }
        let order = NSSortDescriptor(key: #keyPath(Paper.modifiedDate), ascending: false)
        request.predicate = predicate
        request.sortDescriptors = [order]
        paperResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        paperResultsController.delegate = self
        
        do {
            try paperResultsController.performFetch()
        } catch {
            print("setupPaperResultsController 에러, \(error.localizedDescription)")
        }
    }
}

extension PaperTableView: Filterable {
    func filter(before: [Tag], after: [Tag]) {
        //TODO
        //1. 선택할 때: 데이터 소스 세팅하고 직전 데이터에서 해당 선택 태그가 포함되어 있지 않은 indexPath를 계산하여 한방에 지우기
        //2. 선택 취소할 때: 데이터 소스 세팅하고, 미래 데이터에서 선택 취소되는 태그를 포함하고 있지 않은 indexPath를 계산하여 한방에 더하기
    }
}

extension PaperTableView: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 5
        return paperResultsController?.sections?[0].numberOfObjects ?? 0
    }
}

extension PaperTableView: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let result = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue:PaperCell.reuseIdentifier), owner: self) as? PaperCell else { return nil }
        let indexPath = IndexPath(item: row, section: 0)
        configure(cell: result, indexPath: indexPath)
        return result
    }
    
    internal func configure(cell: NSTableCellView, indexPath: IndexPath) {
        return
        let paper = paperResultsController.object(at: indexPath)
        if let thumbnailData = paper.thumbnailContent {
            let attrString = NSKeyedUnarchiver.unarchiveObject(with: thumbnailData) as! NSAttributedString
            cell.textField?.attributedStringValue = attrString
        } else if let fullData = paper.fullContent {
            let attrString = NSKeyedUnarchiver.unarchiveObject(with: fullData) as! NSAttributedString
            cell.textField?.attributedStringValue = attrString
        }
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        print("change")
    }
    
}


extension PaperTableView: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else { return }
            removeRows(at: [indexPath.item], withAnimation: .slideLeft)
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            insertRows(at: [newIndexPath.item], withAnimation: .slideLeft)
        case .update:
            guard let indexPath = indexPath else { return }
            if let rowView = rowView(atRow: indexPath.item, makeIfNecessary: true), let cellView = rowView.view(atColumn: 0) as? NSTableCellView  {
                print("이게 시방 맞는 코드여?")
                configure(cell: cellView, indexPath: indexPath)
                
            }
//            if let cell = cellForRow(at: indexPath) as? PaperCell {
//                configure(cell: cell, indexPath: indexPath)
//                cell.setNeedsLayout()
//            }
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            moveRow(at: indexPath.item, to: newIndexPath.item)
        }
        
    }
    
    //    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    //        let indexSet = IndexSet(integer: sectionIndex)
    //        switch type {
    //        case .insert:
    //            tableView.insertSections(indexSet, with: .automatic)
    //        case .delete:
    //            tableView.deleteSections(indexSet, with: .automatic)
    //        default:
    //            break
    //        }
    //    }
    //
    //    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
    //        return sectionName != "0" ? "Pin Memos" : "Memos"
    //    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        endUpdates()
    }
}
