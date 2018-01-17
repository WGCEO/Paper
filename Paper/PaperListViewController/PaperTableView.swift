//
//  PaperTableView.swift
//  Paper
//
//  Created by changi kim on 2017. 9. 27..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit
import CoreData

class PaperTableView: UITableView {
    
    private var paperResultsController: NSFetchedResultsController<Paper>!
    weak var paperListViewController: PaperListViewController?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup(){
        delegate = self
        dataSource = self
        prefetchDataSource = self
        setupPaperResultsController(selectedTag: nil)
    }
    
    private func setupPaperResultsController(selectedTag: Tag?){
        let context = CoreData.sharedInstance.viewContext
        let request: NSFetchRequest<Paper> = Paper.fetchRequest()
        request.fetchBatchSize = 10
        
        let predicate: NSPredicate
        if let selectedTag = selectedTag {
            predicate = NSPredicate(format: "tags = %@ AND inTrash == false", selectedTag)
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
    func filter(tag: Tag?) {
        setupPaperResultsController(selectedTag: tag)
        reloadData()
        //TODO: 테이블 뷰 리로드해야함
    }
}

extension PaperTableView : UITableViewDataSource {
    internal func configure(cell: PaperCell, indexPath: IndexPath) {
        let paper = paperResultsController.object(at: indexPath)
        if let thumbnailData = paper.thumbnailContent {
            let attrString = NSKeyedUnarchiver.unarchiveObject(with: thumbnailData) as! NSAttributedString
            cell.label.attributedText = attrString
        } else if let fullData = paper.fullContent {
            let attrString = NSKeyedUnarchiver.unarchiveObject(with: fullData) as! NSAttributedString
            cell.label.attributedText = attrString
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PaperCell.reuseIdentifier) as! PaperCell
        configure(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paperResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return paperResultsController.sections?.count ?? 0
    }
}

extension PaperTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Global.userFeedback()
        
        let cell = cellForRow(at: indexPath) as! PaperCell
        if let navVC = paperListViewController?.navigationController as? PaperNavigationViewController {
            navVC.transition.paperCell = cell
        }
        
        let paper = paperResultsController.object(at: indexPath)
        CoreData.sharedInstance.paper = paper
        paperListViewController?.performSegue(withIdentifier: "PaperViewController", sender: nil)
        
    }
    
}

extension PaperTableView: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        //
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        //
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
            deleteRows(at: [indexPath], with: .left)
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            insertRows(at: [newIndexPath], with: .left)
        case .update:
            guard let indexPath = indexPath else { return }
            if let cell = cellForRow(at: indexPath) as? PaperCell {
                configure(cell: cell, indexPath: indexPath)
                cell.setNeedsLayout()
            }
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            moveRow(at: indexPath, to: newIndexPath)
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
