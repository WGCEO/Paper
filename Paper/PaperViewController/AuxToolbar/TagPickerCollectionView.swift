//
//  TagPickerCollectionView.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 10..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit
import CoreData

class TagPickerCollectionView: UICollectionView {
    
    var batchUpdateOperation: [BlockOperation] = []
    private lazy var tagResultsController: NSFetchedResultsController<Tag> = {
        let context = CoreData.sharedInstance.viewContext
        let request: NSFetchRequest<Tag> = Tag.fetchRequest()
        //TODO: Pag.papers가 nil일 경우에 에러가 안나는 지 체크하기
        let sort1 = NSSortDescriptor(key: #keyPath(Tag.papersCount), ascending: false)
        let sort2 = NSSortDescriptor(key: #keyPath(Tag.date), ascending: false)
        request.sortDescriptors = [sort1, sort2]
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
        allowsMultipleSelection = true
        delegate = self
        dataSource = self
        register(UINib(nibName: "TagPickerCell", bundle: nil),
                 forCellWithReuseIdentifier: "TagPickerCell")
        register(UINib(nibName: "AddTagReusableView", bundle: nil),
                 forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                 withReuseIdentifier: "AddTagReusableView")
    }
    
    deinit {
        for operation in batchUpdateOperation {
            operation.cancel()
        }
        batchUpdateOperation.removeAll()
    }

}

extension TagPickerCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagResultsController.sections?[section].numberOfObjects ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagPickerCell.reuseIdentifier, for: indexPath) as! TagPickerCell
        configure(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "AddTagReusableView", for: indexPath) as! AddTagReusableView
        return reusableView
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return tagResultsController.sections?.count ?? 0
    }
    
    private func configure(cell: TagPickerCell, indexPath: IndexPath) {
        let tag = tagResultsController.object(at: indexPath)
        cell.label.text = tag.name
        
        if let tags = CoreData.sharedInstance.paper.tags, tags.contains(tag) {
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }
    }
}

extension TagPickerCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TagPickerCell
        cell.isSelected = !cell.isSelected
        //TODO: 페이퍼에 태그 추가하고 빼는 작업
        let tag = tagResultsController.object(at: indexPath)
        if cell.isSelected {
            CoreData.sharedInstance.paper.tags?.adding(tag)
        } else {
            if let set = CoreData.sharedInstance.paper.tags {
                let mutableSet = NSMutableSet(set: set)
                mutableSet.remove(tag)
                CoreData.sharedInstance.paper.tags = mutableSet
            }
        }
    }
}

extension TagPickerCollectionView: UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let nameSize = ("태그 추가" as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)])
        return CGSize(width: 16 + nameSize.width, height: 32)
    }
}

extension TagPickerCollectionView: NSFetchedResultsControllerDelegate {
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
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
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

