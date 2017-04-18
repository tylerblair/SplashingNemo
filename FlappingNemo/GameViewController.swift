//
//  GameViewController.swift
//  SplashyFish
//
//  Created by Tyler Blair on 2017-03-10.
//  Copyright © 2017 Tyler Blair. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, GameViewControllerDelegate {
        override func viewDidLoad() {
            super.viewDidLoad()
            
            if let view = self.view as! SKView? {
                // Load the SKScene from 'GameScene.sks'
                if let scene = SKScene(fileNamed: "GameScene") {
                    // Set the scale mode to scale to fit the window
                    
                    let gameScene = scene as! GameScene
                    gameScene.gameViewControllerDelegate = self
                    
                    
                    //scene.scaleMode = .aspectFill
                    scene.scaleMode = .resizeFill
                    
                    // Present the scene
                    view.presentScene(scene)
                }
                
                view.ignoresSiblingOrder = true
                
                //testing values
                //shows FRAMES PER SECOND
                view.showsFPS = true
                //Shows NODE COUNT
                view.showsNodeCount = true
                //SHOWS PHYSICS MODELS OUTLINES
                view.showsPhysics = true
            }
        }
        func callMethod(inputProperty:String) {
            print("inputProperty is: ",inputProperty)
            if (inputProperty == "Die"){
                
            self.dismiss(animated: true, completion: {});
                
            //performSegue(withIdentifier: "return", sender: nil)
                
                
            }
            
        }
    
    
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

