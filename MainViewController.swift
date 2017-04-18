//
//  MainViewController.swift
//  FlappingNemo
//
//  Created by Tyler Blair on 2017-03-31.
//  Copyright © 2017 Tyler Blair. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBAction func exit(_ sender: UIButton) {
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
       

        // Do any additional setup after loading the view.
    }
   
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
