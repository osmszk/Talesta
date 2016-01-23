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
    @IBOutlet weak var widgetWebView: UIWebView!
    @IBOutlet weak var cellHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
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
        self.indicator.hidden = false
        self.indicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.indicator.stopAnimating()
        self.indicator.hidden = true
        
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        self.indicator.stopAnimating()
        self.indicator.hidden = true
    }

}
