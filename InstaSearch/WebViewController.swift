//
//  WebViewController.swift
//  InstaSearch
//
//  Created by 鈴木治 on 2015/06/07.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit
import Social

enum JOWebBrowserMode : Int{
    case Navigation
    case Modal
    case TabBar
}
enum ActionSheetButtonIndex : Int{
    case Safari
    case Line
    case Twitter
    case Facebook
};

class WebViewController: UIViewController,UIActionSheetDelegate,UIWebViewDelegate {

    @IBOutlet var webView : UIWebView!
    @IBOutlet var toolBar : UIToolbar!
    
    @IBOutlet var toolbarConstraint : NSLayoutConstraint!
    
    var mode :JOWebBrowserMode?;
    var showURLStringOnActionSheetTitle :Bool = false
    var showPageTitleOnTitleBar : Bool = false
    var showReloadButton : Bool = false
    var showActionButton : Bool = false
    var showToolBar : Bool = true
    var showAd : Bool = true
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
    var adBannerView : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.translucent = Const.NAVI_BAR_TRANSLUCENT
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.webView.delegate = self
        
        initToolBar()
        
        if let url = urlStr{
            SVProgressHUD.show()
            let req : NSURLRequest = NSURLRequest(URL: NSURL(string: url)!)
            self.webView.loadRequest(req)   
        }
        
        showBannerAd()
    }
    
    func showBannerAd(){
        let w = Util.displaySize().width
        let h = Util.displaySize().width/CGFloat(320.0) * CGFloat(Const.AD_BANNER_HIGHT)
        let x = CGFloat(0.0)
        let y = Util.displaySize().height-h-CGFloat(Const.TAB_H+44.0+20.0+44.0)
        let adView = UIView(frame: CGRectMake(x, y, w, h))
        adView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(adView)
        self.adBannerView = adView;
        
        if self.showAd {
            ImobileSdkAds.showBySpotID(Const.AD_IMOBILE_SPOT_ID_BANNER5, view: self.adBannerView, sizeAdjust: true)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if Const.ENABLE_ANALYTICS{
            let build = GAIDictionaryBuilder.createScreenView().set(theClassName, forKey: kGAIScreenName).build() as NSDictionary
            GAI.sharedInstance().defaultTracker.send(build as [NSObject : AnyObject])
        }
        
        if self.showAd {
            ImobileSdkAds.showBySpotID(Const.AD_IMOBILE_SPOT_ID_TEXT)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        SVProgressHUD.dismiss()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        SVProgressHUD.dismiss()
        super.viewWillDisappear(animated)
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
        
        self.toolBar.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleTopMargin]
        if let style =  self.barStyle {self.toolBar.barStyle = style}
        self.toolBar.tintColor = UIColor.blackColor()
        self.toolBar.translucent = false//osuzuki 透明さ
        
        let backButton = UIButton(type: UIButtonType.Custom)
        backButton.frame = CGRectMake(0, 0, 34, 34);
        backButton.setImage(UIImage(named: "barbtn_back"), forState: UIControlState.Normal)
        backButton.addTarget(self, action: #selector(WebViewController.backButtonTouchUp(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.buttonGoBack = UIBarButtonItem(customView: backButton)
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        fixedSpace.width = 30;
        
        let forwardButton = UIButton(type: UIButtonType.Custom)
        forwardButton.frame = CGRectMake(0, 0, 34, 34);
        forwardButton.setImage(UIImage(named: "barbtn_forward"), forState: UIControlState.Normal)
        forwardButton.addTarget(self, action: #selector(WebViewController.forwardButtonTouchUp(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.buttonGoForward = UIBarButtonItem(customView: forwardButton)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        let reloadButton = UIButton(type: UIButtonType.Custom)
        reloadButton.frame = CGRectMake(0, 0, 34, 34);
        reloadButton.setImage(UIImage(named: "barbtn_reload"), forState: UIControlState.Normal)
        reloadButton.addTarget(self, action: #selector(WebViewController.reloadButtonTouchUp(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let buttonReload = UIBarButtonItem(customView: reloadButton)
        
        let fixedSpace2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        fixedSpace2.width = 20;
        
        let actionButton = UIButton(type: UIButtonType.Custom)
//        actionButton.s
        actionButton.frame = CGRectMake(0, 0, 34, 34);
        actionButton.setImage(UIImage(named: "barbtn_action"), forState: UIControlState.Normal)
        actionButton.addTarget(self, action: #selector(WebViewController.buttonActionTouchUp(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let buttonAction = UIBarButtonItem(customView: actionButton)
        
        
        // Activity indicator is a bit special
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        self.activityIndicator?.frame = CGRectMake(11, 7, 20, 20);
        let containerView = UIView(frame: CGRectMake(0, 0, 43, 33));
        containerView.addSubview(self.activityIndicator!)
        let buttonContainer = UIBarButtonItem(customView: containerView)
        
        // Add butons to an array
        var toolBarButtons = [UIBarButtonItem]()
        toolBarButtons.append(self.buttonGoBack!)
        toolBarButtons.append(fixedSpace)
        toolBarButtons.append(self.buttonGoForward!)
        toolBarButtons.append(flexibleSpace)
        toolBarButtons.append(buttonContainer)
        if (self.showReloadButton) {
            toolBarButtons.append(buttonReload)
        }
        if (self.showActionButton) {
            toolBarButtons.append(fixedSpace2);
            toolBarButtons.append(buttonAction);
        }
        
        
        if !self.showToolBar {
            self.toolBar.hidden = true
            self.toolbarConstraint.constant = -44.0
        }
        
        // Set buttons to tool bar
        self.toolBar.setItems(toolBarButtons, animated: true)
        
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
    
    
    func shareViaLine(urlStr:String?){
        if let urlString = urlStr{
            let title = self.webView.stringByEvaluatingJavaScriptFromString("document.title")!
            let appName = Const.APP_NAME
            let text = " \(title) \(urlString) by \(appName) \(Const.URL_APP_STORE_SHORT)"
            if let msgText = Util.changeUrlEncode(text){
                let urlStringLine = "line://msg/text/\(msgText)"
                if UIApplication.sharedApplication().canOpenURL(NSURL(string: urlStringLine)!){
                    UIApplication.sharedApplication().openURL(NSURL(string: urlStringLine)!)
                    if Const.ENABLE_ANALYTICS {
                        
                    }
                }else {
                    //NSLocalizedString
                    Util.showAlert(NSLocalizedString("Error", comment: ""),
                        message: NSLocalizedString("No function of LINE :(", comment: ""))
                }
            }
        }
    }
    
    func shareViaTwitter(urlString:String?){
        if let urlString = urlStr{
            if !SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
                //NSLocalizedString
                Util.showAlert(NSLocalizedString("Error", comment: ""),
                    message: NSLocalizedString("No function of Twitter :(", comment: ""))
            }
            let tweetViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            let title = self.webView.stringByEvaluatingJavaScriptFromString("document.title")!
            let appName = Const.APP_NAME
            let msgText = " \(title) \(urlString) by \(appName)"
            tweetViewController.setInitialText(msgText)
            tweetViewController.addURL(NSURL(string: Const.URL_APP_STORE_SHORT))
            
            tweetViewController.completionHandler = {(result:SLComposeViewControllerResult) -> () in
                if result == SLComposeViewControllerResult.Cancelled{
                    Log.DLog("Cancelled")
                }else{
                    Log.DLog("Done")
                    if Const.ENABLE_ANALYTICS{
                        
                    }
                    
                    //NSLocalizedString
                    Util.showAlert("", message: "シェア成功!")
                }
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            self.presentViewController(tweetViewController, animated: true, completion: nil)
        }
    }
    
    func shareViaFacebook(urlString:String?){
        if let urlString = urlStr{
            if !SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
                //NSLocalizedString
                Util.showAlert(NSLocalizedString("Error", comment: ""),
                    message: NSLocalizedString("No function of Facebook :(", comment: ""))
            }
            let tweetViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            let title = self.webView.stringByEvaluatingJavaScriptFromString("document.title")!
            let appName = Const.APP_NAME
            let msgText = " \(title) \(urlString) by \(appName)"
            tweetViewController.setInitialText(msgText)
            tweetViewController.addURL(NSURL(string: Const.URL_APP_STORE_SHORT))
            
            tweetViewController.completionHandler = {(result:SLComposeViewControllerResult) -> () in
                if result == SLComposeViewControllerResult.Cancelled{
                    Log.DLog("Cancelled")
                }else{
                    Log.DLog("Done")
                    if Const.ENABLE_ANALYTICS{
                        
                    }
                    
                    //NSLocalizedString
                    Util.showAlert("", message: "シェア成功!")
                }
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            self.presentViewController(tweetViewController, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - Action Sheet
    
    func showActionSheet(){
        var urlString : String?
        if (self.showURLStringOnActionSheetTitle) {
            let url = self.webView.request?.URL
            urlString = url?.absoluteString
        }
        let actionSheet = UIActionSheet()
        if let title = urlString{ actionSheet.title = title}
        actionSheet.delegate = self
        actionSheet.addButtonWithTitle("Safariでひらく")//NSLocalizedString
        
        actionSheet.addButtonWithTitle("LINEでシェア")//NSLocalizedString
        actionSheet.addButtonWithTitle("Twitterでシェア")
        actionSheet.addButtonWithTitle("Facebookでシェア")

        actionSheet.cancelButtonIndex = actionSheet.addButtonWithTitle("キャンセル")
        actionSheet.actionSheetStyle = UIActionSheetStyle.BlackTranslucent;

        if (self.mode == JOWebBrowserMode.TabBar) {
            actionSheet.showFromTabBar((self.tabBarController?.tabBar)!);
        }else if (self.mode == JOWebBrowserMode.Navigation && self.navigationController?.tabBarController != nil) {
            actionSheet.showFromTabBar((self.navigationController?.tabBarController?.tabBar)!);
        }else {
            actionSheet.showInView(self.view);
        }
    }
    
    // MARK: - UIActionSheetDelegate
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        if (buttonIndex == actionSheet.cancelButtonIndex){return}
        
        let theURL = self.webView.request?.URL
//        if theURL == nil || theURL.isEqual(NSURL(string: "")!) {
//            theURL = self.urlToLoad
//        }
        
        if buttonIndex == ActionSheetButtonIndex.Safari.rawValue {
            UIApplication.sharedApplication().openURL(theURL!)
        } else if buttonIndex == ActionSheetButtonIndex.Line.rawValue {
            self.shareViaLine(theURL?.absoluteString)
        } else if buttonIndex == ActionSheetButtonIndex.Twitter.rawValue {
            self.shareViaTwitter(theURL?.absoluteString)
        } else if buttonIndex == ActionSheetButtonIndex.Facebook.rawValue{
            self.shareViaFacebook(theURL?.absoluteString)
        }

    }
    
    //MARK: - UIWebViewDelegate
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        Log.DLog("")
        print(request)

        let urlStr = request.URL?.absoluteString
        if Util.includedStringInString("#opensafari", inString: urlStr!) {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        Log.DLog("")
//        SVProgressHUD.show()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        toggleBackForwardButtons()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        Log.DLog("")
        SVProgressHUD.dismiss()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        toggleBackForwardButtons()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        SVProgressHUD.showErrorWithStatus("情報取得に失敗しました\(error?.localizedDescription) \(error?.code)")
    }
}
