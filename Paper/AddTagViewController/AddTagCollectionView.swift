//
//  AddTagCollectionView.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 17..
//  Copyright © 2017년 Piano. All rights reserved.
//

import CoreData
import UIKit

class AddTagCollectionView: UICollectionView {
    var batchUpdateOperation: [BlockOperation] = []
    private lazy var tagResultsController: NSFetchedResultsController<Tag> = {
        let context = CoreData.sharedInstance.viewContext
        let request: NSFetchRequest<Tag> = Tag.fetchRequest()
        //TODO: Pag.papers가 nil일 경우에 에러가 안나는 지 체크하기
//        let sort1 = NSSortDescriptor(key: #keyPath(Tag.papersCount), ascending: false)
        let sort2 = NSSortDescriptor(key: #keyPath(Tag.date), ascending: true)
        request.sortDescriptors = [sort2]
        let tagResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        tagResultsController.delegate = self
        
        do {
            try tagResultsController.performFetch()
        } catch {
            print("TagCollectionView 에러, \(error.localizedDescription)")
        }
        return tagResultsController
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dataSource = self
        delegate = self
    }
    
    deinit {
        for operation in batchUpdateOperation {
            operation.cancel()
        }
        batchUpdateOperation.removeAll()
    }
}

extension AddTagCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddTagCell.reuseIdentifier, for: indexPath) as! AddTagCell
        configure(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return tagResultsController.sections?.count ?? 0
    }
    
    private func configure(cell: AddTagCell, indexPath: IndexPath) {
        let tag = tagResultsController.object(at: indexPath)
        cell.label.text = tag.name
        
        if let paperTag = CoreData.sharedInstance.paper.tags, paperTag == tag {
            cell.userSelected = true
        } else {
            cell.userSelected = false
        }
    }
}

extension AddTagCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! AddTagCell
        cell.userSelected = !cell.userSelected
        
        if cell.userSelected {
            let hashTag = tagResultsController.object(at: indexPath)
            CoreData.sharedInstance.paper.tags = hashTag
        } else {
            CoreData.sharedInstance.paper.tags = nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TagCell
        cell.userSelected = false
    }
    
}

extension AddTagCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let nameString = tagResultsController.object(at: indexPath).name
            else { return CGSize.zero }
        let nameSize = (nameString as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)])
        return CGSize(width: 16 + nameSize.width , height: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 8, 0, 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
}

extension AddTagCollectionView: NSFetchedResultsControllerDelegate {
    private func addUpdateBlock(processingBlock:@escaping ()->Void) {
        batchUpdateOperation.append(BlockOperation(block: processingBlock))
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            addUpdateBlock { [weak self] in
                self?.insertItems(at: [newIndexPath])
            }
        case .update:
            guard let indexPath = indexPath else { return }
            addUpdateBlock { [weak self] in
                self?.reloadItems(at: [indexPath])
            }
        case .move:
            guard let newIndexPath = newIndexPath, let indexPath = indexPath else { return }
            addUpdateBlock { [weak self] in
                self?.moveItem(at: indexPath, to: newIndexPath)
            }
        case .delete:
            guard let indexPath = indexPath else { return }
            addUpdateBlock { [weak self] in
                self?.deleteItems(at: [indexPath])
            }
        }
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            addUpdateBlock { [weak self] in
                self?.insertSections(IndexSet(integer: sectionIndex))
            }
        case .update:
            addUpdateBlock {
                [weak self] in
                self?.reloadSections(IndexSet(integer: sectionIndex))
            }
        case .delete:
            addUpdateBlock { [weak self] in
                self?.deleteSections(IndexSet(integer: sectionIndex))
            }
        case .move:
            ()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        performBatchUpdates({ [weak self] in
            guard let strongSelf = self else { return }
            for operation in strongSelf.batchUpdateOperation {
                operation.start()
            }
        }) { [weak self] (finished) in
            guard let strongSelf = self else { return }
            strongSelf.batchUpdateOperation.removeAll(keepingCapacity: false)
        }
    }
}

