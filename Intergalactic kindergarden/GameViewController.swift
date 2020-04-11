//
//  GameViewController.swift
//  Intergalactic kindergarden
//
//  Created by Oksana Bolibok on 01.03.2020.
//  Copyright © 2020 Oksana Bolibok. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


class GameViewController: UIViewController {
    var scene: GameScene!
    let area = Area(columns: 4, rows: 4)
    @IBOutlet weak var connectionLabel: UILabel!
    
    let transferService = TransferService()
    
    @IBAction func connect(_ sender: UIButton) {
        transferService.joinSession(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
           let skView = view as! SKView
           skView.isMultipleTouchEnabled = false
    
           scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .resizeFill
        scene.setConnectionSctring = { [weak self] str in
            guard let self = self else { return }
            self.connectionLabel.text = str
        }
        
           
           skView.presentScene(scene)
           beginGame()
        
    }

    func beginGame() {
       shuffle()
     }

     func shuffle() {
       let setChildren = area.shuffle()
        scene.addSprites(for: setChildren)
     }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}


