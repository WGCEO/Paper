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
        register(UINib(nibName: "TagPickerCell", bundle: nil),
                 forCellWithReuseIdentifier: "TagPickerCell")
        register(UINib(nibName: "AddTagReusableView", bundle: nil),
                 forCellWithReuseIdentifier: "AddTagReusableView")
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return tagResultsController.sections?.count ?? 0
    }
    
    private func configure(cell: TagPickerCell, indexPath: IndexPath) {
        let tag = tagResultsController.object(at: indexPath)
        cell.label.text = tag.name
    }
}

extension TagPickerCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TagPickerCell
        cell.isSelected = !cell.isSelected
        //TODO: 페이퍼에 태그 추가하고 빼는 작업
    }
}

extension TagPickerCollectionView: NSFetchedResultsControllerDelegate {
    
}

