//
//  TopViewController.swift
//  InstaSearch
//
//  Created by Osamu Suzuki on 2015/05/18.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {

//    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.initLabel()
        
//        label?.text = "teststs"
        
//        NSLog("%@",label);
        self.navigationItem.title = "インスタ芸能人！"
        self.navigationController?.navigationBar.translucent = Const.NAVI_BAR_TRANSLUCENT
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        
//    }
//    
//    required init(coder aDecoder: NSCoder){
//        super.init(coder: aDecoder)
//    }
    
//    func initLabel(){
//        
//        let helloLabel: UILabel = UILabel(frame: CGRectMake(60, 100, 200, 30))
//        
//        helloLabel.text = "Hello World!"
//        helloLabel.textAlignment = NSTextAlignment.Center
//        helloLabel.textColor = UIColor.whiteColor()
//        helloLabel.backgroundColor = UIColor.orangeColor()
//        
//        self.view.addSubview(helloLabel)
//        
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
