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

extension PaperTableView : UITableViewDataSource {
    internal func configure(cell: PaperCell, indexPath: IndexPath) {
        
        let mutableParagraph = NSMutableParagraphStyle()
        mutableParagraph.lineSpacing = 8
        mutableParagraph.firstLineHeadIndent = 30
        mutableParagraph.headIndent = 30
        mutableParagraph.tailIndent = -30
        
        let mutableStr = NSMutableAttributedString(attributedString: cell.label.attributedText!)
        mutableStr.addAttributes([.paragraphStyle: mutableParagraph], range: NSMakeRange(0, mutableStr.length))
        cell.label.attributedText = mutableStr
        
        let margin = Global.textMargin(by: bounds.width)
        cell.leftConstraint.constant = margin
        cell.rightConstraint.constant = margin
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PaperCell.reuseIdentifier) as! PaperCell
        configure(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
        return paperResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return paperResultsController.sections?.count ?? 0
    }
}

extension PaperTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        let cell = cellForRow(at: indexPath) as! PaperCell
        if let navVC = paperListViewController?.navigationController as? PaperNavigationViewController {
            navVC.transition.paperCell = cell
        }
        paperListViewController?.performSegue(withIdentifier: "PaperViewController", sender: cell.label.attributedText)
        
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
