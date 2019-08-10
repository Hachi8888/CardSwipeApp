//
//  ViewController.swift
//  CardSwipeApp
//
//  Created by VERTEX22 on 2019/08/10.
//  Copyright © 2019 N-project. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // ユーザーカード
    @IBOutlet weak var person1: UIView!
    @IBOutlet weak var person2: UIView!
    @IBOutlet weak var person3: UIView!
    @IBOutlet weak var person4: UIView!
    @IBOutlet weak var person5: UIView!
    
    
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var baseCard: UIView!
    
    // カードの中心を座標をとって決める
    var centerOfCard: CGPoint!
    // ユーザーカードの配列
    var personList: [UIView] = []
    // 選択されたカードの数を数える変数
    var selectedCardCount: Int = 0
    // 各自の名前の配列
    let nameList: [String] = ["津田梅子","ジョージワシントン","ガリレオガリレイ","ジョン万次郎","板垣退助"]
    
    // 「いいね」された名前の配列
    var likedName: [String] = []
    
    
    // viewのレイアウトが完成されたあとの状態
    override func viewDidLayoutSubviews() {
        // ベースカードの中心を代入
     centerOfCard = baseCard.center
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // personListにperson1から5を追加
        // pesonListの配列の初期値に入れておいてもOK!
        personList.append(person1)
        personList.append(person2)
        personList.append(person3)
        personList.append(person4)
        personList.append(person5)
    }
    
    
    // 遷移前の準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
      if segue.identifier == "ToLikedList" {
        let vc = segue.destination as! LikedListTableViewController
        
        vc.likedName = likedName
        
        }
        
    }
    
    
    // ベースカードの位置と角度を戻す
    func resetCard(){
      baseCard.center = centerOfCard
      baseCard.transform = .identity
        
    }
    

    @IBAction func swipeCard(_ sender: UIPanGestureRecognizer) {
        
        // sender.viewでPanGestureRecognizerでスワイプ動作を検知する対象のview（ここではベースカード）を取得可能。それを定数に代入。
        let card = sender.view!
        
        
        
        // スワイプでどのくらい動いたか(in: view は 大元のviewからの距離)
        let point = sender.translation(in: view)
        
        // ①取得できた距離をcard.centerに加算
        card.center = CGPoint(x: card.center.x + point.x, y:  card.center.y + point.y)
        
        // ①ユーザーカードも同じ動きをする
        personList[selectedCardCount].center = CGPoint(x: card.center.x + point.x, y:card.center.y + point.y)
        
        
        // 元々の位置と移動先との差
        let xfromCenter = card.center.x - view.center.x
        
        // ②角度を付ける
        card.transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)
        
        // ②ユーザーカードも同じ動きをする
         personList[selectedCardCount].transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)
        
        
        // likeImageを表示させる
        
        if xfromCenter > 0 {
            // Goodを格納して、表示
            likeImage.image = #imageLiteral(resourceName: "いいね")
            likeImage.isHidden = false
            
        } else if xfromCenter < 0 {
            // Badを表示
            likeImage.image = #imageLiteral(resourceName: "よくないね")
            likeImage.isHidden = false
            
        }
        
        
        
        // もとに戻る処理
        if sender.state == UIGestureRecognizer.State.ended{
            
            if card.center.x < 50 {
                
            // 左へ飛ばす場合
                // クロージャによるアニメーションの追加
                UIView.animate(withDuration: 0.5, animations: {
                    
                    // x座標を-500する
                    self.personList[self.selectedCardCount].center = CGPoint(x: self.personList[self.selectedCardCount].center.x - 500 ,y: self.personList[self.selectedCardCount].center.y)
                    
                    // ベースカードの位置と角度を戻す関数
                    self.resetCard()
                    
                    // likeImageの表示を消す
                    self.likeImage.isHidden = true
                    
                    
                })
                
                // 選択されたカードの数を進める
                selectedCardCount += 1
                
                // 最後のカードをスワイプしたとき
                if selectedCardCount >= personList.count {
                    performSegue(withIdentifier: "ToLikedList", sender: self)
                }
                
                
            } else if card.center.x > view.frame.width - 50 {
                
             // 右へ飛ばす場合
                // クロージャによるアニメーションの追加
                UIView.animate(withDuration: 0.5, animations: {
                    
                // x座標を+500する
                    self.personList[self.selectedCardCount].center = CGPoint(x: self.personList[self.selectedCardCount].center.x + 500 ,y: self.personList[self.selectedCardCount].center.y)
                    
                })
                    
                // ベースカードの位置と角度を戻す関数
                  self.resetCard()
                
                // likeImageの表示を消す
                   self.likeImage.isHidden = true
                    
                // いいねされたリストに追加
                likedName.append(nameList[selectedCardCount])
                
                
                // 選択されたカードの数を進める
                selectedCardCount += 1
                
                // 最後のカードをスワイプしたときの処理(上記でカードの数を+1にすることで、Appが落ちずに済む)
                if selectedCardCount >= personList.count {
                    performSegue(withIdentifier: "ToLikedList", sender: self)
                }
                
            } else {
                
            // クロージャによるアニメーションの追加
                UIView.animate(withDuration: 0.5, animations: {
                    // ベースカードの位置と角度を戻す関数
                    self.resetCard()
                    
                    // likeImageの表示を消す
                    self.likeImage.isHidden = true
                    
                    // ユーザーカードを元の位置に戻す
                    self.personList[self.selectedCardCount].center = self.centerOfCard
                    // ユーザーカードを元の角度に戻す
                    self.personList[self.selectedCardCount].transform = .identity
                    
                
                })
                
                
            }
            
            
            
            
        }
    }
    
}

