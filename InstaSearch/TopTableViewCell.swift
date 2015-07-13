//
//  TopTableViewCell.swift
//  InstaSearch
//
//  Created by 鈴木治 on 2015/07/13.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit

class TopTableViewCell: UITableViewCell,UIWebViewDelegate {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var wigetWebView: UIWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        
    }

}
