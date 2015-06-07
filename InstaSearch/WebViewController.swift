//
//  WebViewController.swift
//  InstaSearch
//
//  Created by 鈴木治 on 2015/06/07.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit

enum JOWebBrowserMode {
    case Navigation
    case Modal
    case TabBar
}

class WebViewController: UIViewController {

    @IBOutlet var webView : UIWebView!
    @IBOutlet var toolBar : UIToolbar!
    
    var mode :JOWebBrowserMode?;
    var showURLStringOnActionSheetTitle :Bool?
    var showPageTitleOnTitleBar : Bool?
    var showReloadButton : Bool = false
    var showActionButton : Bool = false
    var barStyle : UIBarStyle?
    var barTintColor : UIColor?
    var modalDismissButtonTitl : String?;
//    var domainWhiteList : Array<?>;
    var currentURL : String?;
    
    // Layout
    var navigationBarModal :UINavigationBar?; // Only used in modal mode
    
    // Toolbar items
    var activityIndicator : UIActivityIndicatorView?;
    var buttonGoBack : UIBarButtonItem?;
    var buttonGoForward : UIBarButtonItem?;
    
    var forcedTitleBarText : String?;
    var originalBarStyle : UIBarStyle?;
    
    
    var urlStr : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.translucent = Const.NAVI_BAR_TRANSLUCENT
        
        initToolBar()
        
        if let url = urlStr{
            let req : NSURLRequest = NSURLRequest(URL: NSURL(string: url)!)
            self.webView.loadRequest(req)   
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func initToolBar(){
//        if (_mode == JOWebBrowserModeNavigation) {
//            self.navigationController.navigationBar.barStyle = _barStyle;
//        }
        
        //osuzuki
        //        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, viewSize.height+(49-kToolBarHeight), viewSize.width, kToolBarHeight)];
        //
        
        self.toolBar.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleTopMargin
        if let style =  self.barStyle {self.toolBar.barStyle = style}
        self.toolBar.tintColor = UIColor.blackColor()
        self.toolBar.translucent = false//osuzuki 透明さ
        
        let backButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 34, 34);
        backButton.setImage(UIImage(named: "barbtn_back"), forState: UIControlState.Normal)
        backButton.addTarget(self, action: "backButtonTouchUp:", forControlEvents: UIControlEvents.TouchUpInside)
        self.buttonGoBack = UIBarButtonItem(customView: backButton)
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        fixedSpace.width = 30;
        
        let forwardButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        forwardButton.frame = CGRectMake(0, 0, 34, 34);
        forwardButton.setImage(UIImage(named: "barbtn_forward"), forState: UIControlState.Normal)
        forwardButton.addTarget(self, action: "forwardButtonTouchUp:", forControlEvents: UIControlEvents.TouchUpInside)
        self.buttonGoForward = UIBarButtonItem(customView: forwardButton)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        let reloadButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        reloadButton.frame = CGRectMake(0, 0, 34, 34);
        reloadButton.setImage(UIImage(named: "barbtn_reload"), forState: UIControlState.Normal)
        reloadButton.addTarget(self, action: "reloadButtonTouchUp:", forControlEvents: UIControlEvents.TouchUpInside)
        let buttonReload = UIBarButtonItem(customView: reloadButton)
        
        let fixedSpace2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        fixedSpace2.width = 20;
        
        let actionButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
//        actionButton.s
        actionButton.frame = CGRectMake(0, 0, 34, 34);
        actionButton.setImage(UIImage(named: "barbtn_action"), forState: UIControlState.Normal)
        actionButton.addTarget(self, action: "buttonActionTouchUp:", forControlEvents: UIControlEvents.TouchUpInside)
        let buttonAction = UIBarButtonItem(customView: actionButton)
        
        
        // Activity indicator is a bit special
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        self.activityIndicator?.frame = CGRectMake(11, 7, 20, 20);
        let containerView = UIView(frame: CGRectMake(0, 0, 43, 33));
        containerView.addSubview(self.activityIndicator!)
        let buttonContainer = UIBarButtonItem(customView: containerView)
        
        // Add butons to an array
        let toolBarButtons = NSMutableArray()
        toolBarButtons.addObject(self.buttonGoBack!)
        toolBarButtons.addObject(fixedSpace)
        toolBarButtons.addObject(self.buttonGoForward!)
        toolBarButtons.addObject(flexibleSpace)
        toolBarButtons.addObject(buttonContainer)
        if (self.showReloadButton) {
            toolBarButtons.addObject(buttonReload)
        }
        if (self.showActionButton) {
            toolBarButtons.addObject(fixedSpace2);
            toolBarButtons.addObject(buttonAction);
        }
        
        // Set buttons to tool bar
        self.toolBar.setItems(toolBarButtons as [AnyObject], animated: true)
        
        // Tint toolBar
        if let color = self.barTintColor {self.toolBar.tintColor = color};
    }

    
    func toggleBackForwardButtons(){
        self.buttonGoBack?.enabled = self.webView.canGoBack
        self.buttonGoForward?.enabled = self.webView.canGoForward
    }
    
    
    //Mark:  - Actions
    
    func backButtonTouchUp(sender : AnyObject){
        self.webView.goBack()
    
        self.toggleBackForwardButtons();
    }
    
    func forwardButtonTouchUp(sender : AnyObject){
        self.webView.goForward();
        
        self.toggleBackForwardButtons();
    }
    
    func reloadButtonTouchUp(sender : AnyObject){
        self.webView.reload();
    
        self.toggleBackForwardButtons();
    }
    
    func buttonActionTouchUp(sender : AnyObject){
        self.showActionSheet()
    }
    
    func pushedRecommendButton(sender : AnyObject){
//        self.wallAd();
    }
    
    func wallAd(){
//    [AMoAdSDK showAppliPromotionWall:self
//    orientation:UIInterfaceOrientationPortrait
//    wallDrawSetting:APSDK_Ad_Key_WallDrawSetting_hiddenStatusBar
//    appKey:AD_APPLIPROMOTION_ID
//    onWallCloseBlock:nil];
    }
    
    //Mark : - Action Sheet
    
    func showActionSheet(){
        let urlString : String = "";
//        if (self.showURLStringOnActionSheetTitle) {
//        url = _webView.request. URL];
//        urlString = [url absoluteString];
//        }
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
//        actionSheet.title = urlString;
//        actionSheet.delegate = self;
//        [actionSheet addButtonWithTitle:NSLocalizedString(@"Open in Safari", @"")];
//        //
//        
//        //    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"googlechrome://"]]) {
//        //        [actionSheet addButtonWithTitle:@"Chromeでひらく"];
//        //        //NSLocalizedString(@"Open in Chrome", nil)
//        //    }
//        
//        [actionSheet addButtonWithTitle:NSLocalizedString(@"Share via LINE", @"")];
//        [actionSheet addButtonWithTitle:NSLocalizedString(@"Share via Twitter", @"")];
//        [actionSheet addButtonWithTitle:NSLocalizedString(@"Share via Facebook", @"")];
//        
//        actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", @"")];
//        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
//        
//        if (_mode == JOWebBrowserModeTabBar) {
//        [actionSheet showFromTabBar:self.tabBarController.tabBar];
//        }
//        //else if (_mode == JOWebBrowserModeNavigation && [self.navigationController respondsToSelector:@selector(tabBarController)]) {
//        else if (_mode == JOWebBrowserModeNavigation && self.navigationController.tabBarController != nil) {
//        [actionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
//        }
//        else {
//        [actionSheet showInView:self.view];
//        }
    
    }
}
