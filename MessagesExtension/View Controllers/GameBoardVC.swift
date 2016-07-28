//
//  GameBoardVC.swift
//  TicTacToeSample
//
//  Created by Prianka Liz Kariat on 7/15/16.
//  Copyright © 2016 Prianka Liz Kariat. All rights reserved.
//

import UIKit
import Foundation
import Messages


protocol GameBoardVCDelegate {
    func selecteWithGameStateVM(gameStateVM: GameStateVM, image: UIImage)
}

class GameBoardVC: UIViewController {
    
    var delegate: GameBoardVCDelegate?
    var gameStateVM: GameStateVM!
    
    private var moveMade = false
    
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if gameStateVM.decideWinner() == 0 {
            
            gameOverLabel.text = "Game On"
            collectionView.alpha = 1.0
        }
        else
        {
            gameOverLabel.text = "Game Over"
            collectionView.alpha = 0.3
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        collectionView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
        
    }
    
}

extension GameBoardVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print(gameStateVM.queryItems)
        return gameStateVM.rowCount * gameStateVM.rowCount
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GAME_CELL", for: indexPath) as! GameCell
        cell.backgroundColor = indexPath.item! % 2 == 0 ? UIColor.black() : UIColor.gray()
        
        cell.gamelabel.text = gameLabelTextForIndex(index: indexPath.item!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let playedValue = gameStateVM.queryItems[indexPath.item!].value, intValue = Int(playedValue) where intValue == 0 && moveMade == false && gameStateVM.decideWinner() == 0 else {
            return
        }
        
        gameStateVM.placeItemAtRow(row: indexPath.item! / gameStateVM.rowCount, column: indexPath.item! % gameStateVM.rowCount, player: gameStateVM.player)
        collectionView.reloadData()
        moveMade = true
        
        let image = collectionView.takeSnapshot()
        delegate?.selecteWithGameStateVM(gameStateVM: gameStateVM, image: image)
    }
    
    private func gameLabelTextForIndex(index: Int) -> String {
        
        var text = ""
        
        switch  Int(gameStateVM.queryItems[index].value!)! {
        case 1:
            text = "x"
        case -1:
            text = "0"
            
        default:
            break
        }
        return text
    }
    
    
}
