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
    func filter(tag: Tag?)
}

class TagCollectionView: UICollectionView {
    
    weak var table: Filterable?
    internal var selectedTag: Tag? {
        didSet {
            table?.filter(tag: selectedTag)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        dataSource = self
        delegate = self
    }
    
    private lazy var tagResultsController: NSFetchedResultsController<Tag> = {
        let context = CoreData.sharedInstance.viewContext
        let request: NSFetchRequest<Tag> = Tag.fetchRequest()
        request.predicate = NSPredicate(format: "papers.@count != 0")
        //TODO: Pag.papers가 nil일 경우에 에러가 안나는 지 체크하기
//        let sort1 = NSSortDescriptor(key: #keyPath(Tag.papersCount), ascending: false)
        let sort2 = NSSortDescriptor(key: #keyPath(Tag.date), ascending: false)
        request.sortDescriptors = [sort2]
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
        let tag = tagResultsController.object(at: indexPath)
        cell.label.text = tag.name
        
        if let selectedTag = selectedTag, selectedTag == tag {
            cell.userSelected = true
        } else {
            cell.userSelected = false
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = tagResultsController.sections?[section].numberOfObjects ?? 0
        isHidden = count != 0 ? false : true
        return count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = tagResultsController.sections?.count ?? 0
        isHidden = count != 0 ? false : true
        return count
    }
}

extension TagCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TagCell
        cell.userSelected = !cell.userSelected
        
        if cell.userSelected {
            let hashTag = tagResultsController.object(at: indexPath)
            selectedTag = hashTag
        } else {
            selectedTag = nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TagCell
        cell.userSelected = false
    }
}

extension TagCollectionView: UICollectionViewDelegateFlowLayout {
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


extension TagCollectionView: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        reloadData()
    }
}
