//
//  CoreData.swift
//  Paper
//
//  Created by changi kim on 2017. 9. 26..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit
import CoreData

class CoreData: NSPersistentContainer {
    
    static let sharedInstance: CoreData = {
        return createContainer()
    }()
    
    weak var textView: PianoTextView?
    internal var paper: Paper!
    internal lazy var privateMOC: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        moc.parent = self.viewContext
        return moc
    }()
    private var cache: [NSAttributedString : Paper] = [:]
    internal func paperFullContent() -> NSAttributedString {
        for (key, value) in self.cache {
            if value == paper {
                return key
            }
        }
        return NSKeyedUnarchiver.unarchiveObject(with: paper.fullContent!) as! NSAttributedString
    }
    
    internal var paperFont: UIFont {
        get {
            return Global.transformToFont(name: paper.font!)
        }
    }
    
    internal var paperColor: UIColor {
        return Global.transFormToColor(name: paper.color!)
    }
    
    lazy var preference: Preference = {
        do {
            let request: NSFetchRequest<Preference> = Preference.fetchRequest()
            let preference = try viewContext.fetch(request).first!
            return preference
        } catch {
            print("Preference 초기화 하는 도중 에러")
        }
        let preference = Preference(context: viewContext)
        saveViewContext()
        return preference
    }()
}

//MARK: Save
extension CoreData {
    static private func createContainer() -> CoreData{
        let container = CoreData(name: "PaperModel")
        container.loadPersistentStores(completionHandler: { (description, error) in
            if let error = error {
                print("Error creating persistent stores: \(error.localizedDescription)")
                fatalError()
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }
    
    private func deleteImage(){
        
    }
    
    internal func asyncSave(attrString: NSAttributedString, to paper: Paper){
        
        //1. 캐시에 임시로 저장
        let attrText = attrString.copy() as! NSAttributedString
        //TODO: 여기까지 제작완료
        
//        thumbNailAttrText
        cache[attrText] = paper
        
        privateMOC.perform { [weak self] in
            do {
                let data = NSKeyedArchiver.archivedData(withRootObject: attrText)
                self?.paper.fullContent = data
                
                //3. 저장
                try self?.privateMOC.save()
                
                //4. 메인뷰컨텍스트에도 저장하고 캐시 지우기
                self?.viewContext.performAndWait {
                    //저장완료 레이블로 변경시키고,
                    self?.saveViewContext()
                    self?.cache[attrString] = nil
                    print("비동기 저장 완료")
                }
            } catch {
                print("Failure to save context error: \(error)")
            }
        }
    }
    
    internal func syncSaveAllNote(){
        //TODO: 프라이빗 큐에서 정상 저장되는 지 체크해보기, unowned self가 되는지 체크
        guard let attrText = textView?.attributedText.copy() as? NSAttributedString else { return }
        cache[attrText] = paper
        privateMOC.performAndWait { [unowned self] in
            for (attrString, paper) in self.cache {
                
               let thumbnailAttrstring =  attrText.thumbnailAttrString()
                
                paper.thumbnailContent
                    = thumbnailAttrstring != nil
                ? NSKeyedArchiver.archivedData(withRootObject: thumbnailAttrstring!)
                : nil
                
                let data = NSKeyedArchiver.archivedData(withRootObject: attrString)
                paper.fullContent = data
            }
            saveViewContext()
            cache.removeAll()
            
        }
    }
    
    //외부 큐에서는 이 메서드 사용(?)
    internal func saveViewContext() {
        do {
            try viewContext.save()
        } catch {
            print("에러발생!!! \(error.localizedDescription)")
        }
    }
    
    //메인 큐에서는 이 메서드 사용
    internal func saveIfNeeded(){
        guard viewContext.hasChanges else { return }
        saveViewContext()
    }
}

//MARK: AppDelegate
extension CoreData {
    internal func deletePapersIfPassOneMonth(){
        let request: NSFetchRequest<Paper> = Paper.fetchRequest()
        request.predicate = NSPredicate(format: "inTrash == true AND date < %@", NSDate(timeIntervalSinceNow: -3600 * 24 * 30))
        let batchDelete = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
        batchDelete.affectedStores = CoreData.sharedInstance.viewContext.persistentStoreCoordinator?.persistentStores
        batchDelete.resultType = .resultTypeCount
        do {
            let _ = try CoreData.sharedInstance.viewContext.execute(batchDelete) as! NSBatchDeleteResult
        } catch {
            print("could not delete \(error.localizedDescription)")
        }
    }
    
    //카테고리 없다면 생성하기
//    internal func createCategoryIfNeeded(){
//        do {
//            let categoryRequest: NSFetchRequest<Category> = Category.fetchRequest()
//            let count = try viewContext.count(for: categoryRequest)
//            if count == 0 {
//                let category = Category(context: viewContext)
//                category.name = "Piano Note"
//
//                saveViewContext()
//            }
//
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
    
    //세팅 없다면 생성하기
    internal func createPreferenceIfNeeded(){
        do {
            let request: NSFetchRequest<Preference> = Preference.fetchRequest()
            let count = try viewContext.count(for: request)
            if count == 0 {
                let preference = Preference(context: viewContext)
                preference.showMirroring = false
                saveViewContext()
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
