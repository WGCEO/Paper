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
    var shouldReloadCollectionView = false
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
        delegate = self
        dataSource = self
        register(UINib(nibName: "TagPickerCell", bundle: nil),
                 forCellWithReuseIdentifier: "TagPickerCell")
        register(UINib(nibName: "AddTagReusableView", bundle: nil),
                 forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                 withReuseIdentifier: "AddTagReusableView")
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
        
        if let paperTag = CoreData.sharedInstance.paper.tags, paperTag == tag {
            cell.userSelected = true
        } else {
            cell.userSelected = false
        }
    }
}

extension TagPickerCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TagPickerCell
        cell.userSelected = !cell.userSelected
        
        if cell.userSelected {
            let hashTag = tagResultsController.object(at: indexPath)
            CoreData.sharedInstance.paper.tags = hashTag
        } else {
            CoreData.sharedInstance.paper.tags = nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TagPickerCell
        cell.userSelected = false
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
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        reloadData()
    }
}

