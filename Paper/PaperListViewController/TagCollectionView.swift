//
//  TagCollectionView.swift
//  Paper
//
//  Created by changi kim on 2017. 9. 27..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit
import CoreData

protocol Filterable: class {
    func filter(before: [Tag], after: [Tag])
}

class TagCollectionView: UICollectionView {
    
    weak var table: Filterable?
    var batchUpdateOperation: [BlockOperation] = []
    private var selectedTags: [Tag] = [] {
        didSet {
            table?.filter(before: oldValue, after: selectedTags)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    deinit {
        for operation in batchUpdateOperation {
            operation.cancel()
        }
        batchUpdateOperation.removeAll()
    }
    
    private func setup() {
        dataSource = self
        delegate = self
    }
    
    private lazy var tagResultsController: NSFetchedResultsController<Tag> = {
        let context = CoreData.sharedInstance.viewContext
        let request: NSFetchRequest<Tag> = Tag.fetchRequest()
        //TODO: Pag.papers가 nil일 경우에 에러가 안나는 지 체크하기
        let sort1 = NSSortDescriptor(key: #keyPath(Tag.papersCount), ascending: false)
        let sort2 = NSSortDescriptor(key: #keyPath(Tag.date), ascending: false)
        request.sortDescriptors = [sort1, sort2]
        let tagResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        tagResultsController.delegate = self
        
        do {
            try tagResultsController.performFetch()
        } catch {
            print("TagCollectionView 에러, \(error.localizedDescription)")
        }
        return tagResultsController
    }()
}

extension TagCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseIdentifier, for: indexPath) as! TagCell
        configure(cell: cell, indexPath: indexPath)
        return cell
    }
    
    private func configure(cell: TagCell, indexPath: IndexPath){
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return tagResultsController.sections?.count ?? 0
    }
}

extension TagCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}


extension TagCollectionView: NSFetchedResultsControllerDelegate {
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
