//
//  PaperListViewController.swift
//  Paper
//
//  Created by changi kim on 2017. 9. 26..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit
import CoreData

class PaperListViewController: DefaultViewController {
    
    @IBOutlet weak var tableView: PaperTableView!
    @IBOutlet weak var collectionView: TagCollectionView!
    @IBOutlet weak var trashButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //TODO: paper가 nil이 아니고, length = 0이면 지우기
        if let paper = CoreData.sharedInstance.paper,
            let data = paper.fullContent,
            let attrString = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSAttributedString,
            attrString.length == 0 {
            CoreData.sharedInstance.viewContext.delete(paper)
        }
    }
    
    @IBAction func tapTrash(_ sender: UIButton) {
        //TODO: 휴지통 화면 띄우기
    }
    @IBAction func tapSearch(_ sender: UIBarButtonItem) {
        //TODO: 아래 코드 여기다가 하지말고 paper.isTrash = true될 때 하기
        trashButton.isHidden = false
        AnimatorFactory.jiggle(view: trashButton)
    }
    
    @IBAction func tapCreatePaperButton(_ sender: UIButton) {
        //1. 페이퍼 생성
        let formManager = FormManager.sharedInstance
        let paragraphStyle = formManager.defaultParagraphStyle
        let defaultFontStr = "small"
        let defaultColorStr = "red"
        let attrString = NSAttributedString(string: "", attributes: [
            .font : formManager.transformToFont(name: defaultFontStr),
            .paragraphStyle : paragraphStyle,
            .foregroundColor : formManager.textColor])
        let data = NSKeyedArchiver.archivedData(withRootObject: attrString)
        let newPaper = Paper(context: CoreData.sharedInstance.viewContext)
        newPaper.fullContent = data
        newPaper.thumbnailContent = data
        newPaper.color = defaultColorStr
        newPaper.creationDate = Date()
        newPaper.modifiedDate = Date()
        //2. 현재 선택되어 있는 카테고리 append
        let selectedTags = NSSet(array: collectionView.selectedTags)
        newPaper.addToTags(selectedTags)
        newPaper.font = defaultFontStr
        
        if let navVC = navigationController as? PaperNavigationViewController {
            navVC.transition.createPaperButton = sender
        }
        
        //3. 코어데이터 페이퍼에 세팅
        CoreData.sharedInstance.paper = newPaper
        
        Global.userFeedback()
        
        //4. 이동
         performSegue(withIdentifier: "PaperViewController", sender: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let des = segue.destination as? PaperViewController,
            let shouldAppearKeyboard = sender as? Bool {
            des.shouldAppearKeyboard = shouldAppearKeyboard
        }
    }
}

extension PaperListViewController {
    
    fileprivate func setup() {
        collectionView.table = tableView
        tableView.paperListViewController = self
    }
    
    fileprivate func changeTitle(to: String) {
        self.title = to
    }
}

