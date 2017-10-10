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
        let paragraphStyle = Global.defaultParagraphStyle
        let defaultFontStr = "system17"
        let defaultColorStr = "red"
        let attrString = NSAttributedString(string: "", attributes: [
            .font : Global.transformToFont(name: defaultFontStr),
            .paragraphStyle : paragraphStyle,
            .foregroundColor : Global.textColor])
        let data = NSKeyedArchiver.archivedData(withRootObject: attrString)
        let newPaper = Paper(context: CoreData.sharedInstance.viewContext)
        newPaper.fullContent = data
        newPaper.color = defaultColorStr
        
        //2. 현재 선택되어 있는 카테고리 append
        let selectedTags = NSSet(array: collectionView.selectedTags)
        newPaper.addToTags(selectedTags)
        newPaper.font = defaultFontStr
        newPaper.thumbnailContent = data
        
        if let navVC = navigationController as? PaperNavigationViewController {
            navVC.transition.createPaperButton = sender
        }
        
        //3. 코어데이터 페이퍼에 세팅
        CoreData.sharedInstance.paper = newPaper
        
        Global.userFeedback()
        
        //4. 이동
         performSegue(withIdentifier: "PaperViewController", sender: sender.attributedTitle(for: .normal))
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PaperViewController" {
            let des = segue.destination as! PaperViewController
            if let attrText = sender as? NSAttributedString {
                des.thumbnailAttrText = attrText
            }
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

