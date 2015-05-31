//
//  FollowerRankingViewController.swift
//  InstaSearch
//
//  Created by Osamu Suzuki on 2015/05/18.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit

class FollowerRankingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "follower"
        
        
        SVProgressHUD.show()
        self.requestToGetRanking()
        
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
    
    func requestToGetRanking(){
        
        let manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        manager.requestSerializer.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.152 Safari/537.36", forHTTPHeaderField: "User-Agent")
        manager.responseSerializer = AFHTTPResponseSerializer()
        let url = "http://www.talentinsta.com/follower/99/"
        manager.GET(url,
            parameters: nil,
            timeoutInterval: 10,
            success: { (operation : AFHTTPRequestOperation!, responsobject: AnyObject!) -> Void in
                
                SVProgressHUD.dismiss()
                
                //ref:http://blog.f60k.com/objective-c%E3%81%A8swift%E3%81%AE%E7%B5%84%E3%81%BF%E5%90%88%E3%82%8F%E3%81%9B%E6%96%B9%E3%81%AE%E3%81%BE%E3%81%A8%E3%82%81/
                println("success")
                
                let html : NSString? = NSString(data: responsobject as! NSData, encoding: NSJapaneseEUCStringEncoding)
//                println("responsobject:\(responsobject)")
//                println("operation:\(operation)")
                println("html:\(html)")
                
                var followerRankings = NSMutableArray()
                var error : NSError? = nil
                var parser : HTMLParser? = HTMLParser(html: html as! String , error:&error)//parse error
                let bodyNode :HTMLNode? = parser?.body
                
                let trNodes : Array<HTMLNode>? = bodyNode?.findChildTags("tr")
                var k = 0
                var trStartIndex  =  0
                
                //オプショナルのオブジェクト郡をfor-inでつかうときはアンラップしてからつかう
                //ref:http://stackoverflow.com/questions/26852656/loop-through-anyobject-results-in-does-not-have-a-member-named-generator
                if let trNodesUnwrap = trNodes{
                    for trNode in trNodesUnwrap{
                        let tdNodes : Array<HTMLNode>? = trNode.findChildTags("td")
                        if let tdNodesUnwap = tdNodes{
                            for tdNode in tdNodesUnwap{
                                let contents : String = tdNode.contents
                                if(contents == "フォロワー数"){
                                    trStartIndex = k+1
                                }
                            }
                        }
                        k++
                    }
                }
                
                //アンラップについて
                //ref:http://qiita.com/cotrpepe/items/518c4476ca957a42f5f1
                
                for var i:Int=0; i<50; ++i{
                    if let trNodesUnwap = trNodes{
                        let node0 : HTMLNode? = trNodesUnwap[trStartIndex+i]
                        let tdNodes : Array<HTMLNode>? = node0?.findChildTags("td")
                        
                        if let tdNodesUnwap = tdNodes {
                            let rankingNumNode : HTMLNode? = tdNodesUnwap[0]
                            let nameNode : HTMLNode? = tdNodesUnwap[1].findChildTag("a")?.findChildTag("b")
                            let junreNode : HTMLNode? = tdNodesUnwap[2]
                            let followerNumNode : HTMLNode? = tdNodesUnwap[tdNodes!.count-1]
                            
                            println("\(rankingNumNode!.contents) \(nameNode!.contents) \(junreNode!.contents) \(followerNumNode!.contents)")
                            
                            let ranking : Int! = rankingNumNode!.contents.toInt()
                            let followerRanking = FollwerRanking(rankingNo: ranking, name: nameNode!.contents, junre: junreNode!.contents, follower: followerNumNode!.contents)
                            
                            followerRankings.addObject(followerRanking)
                        }
                    }
                }
                
                /*
                NSArray *trNodes = [bodyNode findChildTags:@"tr"];
                int k = 0;
                int trStartIndex = 0;
                for (HTMLNode *node in trNodes) {
                    NSArray *tdNodes = [node findChildTags:@"td"];
                    for (HTMLNode *nod in tdNodes) {
                        if([[nod contents] isEqualToString:@"フォロワー数"]){
                            trStartIndex = k+1;
                        }
                    }
                    k++;
                }
                
                for (NSInteger i=0; i<50; i++) {
                    HTMLNode *node0 = trNodes[trStartIndex+i];
                    NSArray *tdNodes = [node0 findChildTags:@"td"];
                    
                    HTMLNode *rankingNumNode = tdNodes[0];
                    HTMLNode *nameNode = [[tdNodes[1] findChildTag:@"a"] findChildTag:@"b"];
                    HTMLNode *junreNode = tdNodes[2];
                    HTMLNode *followerNumNode = tdNodes[tdNodes.count-1];
                    NSString *followerNum = [followerNumNode contents];
                    NSLog(@"%@ %@ %@ %@",[rankingNumNode contents],[nameNode contents],[junreNode contents],followerNum);
                }
                */

                
                
                
                /*
                NSMutableArray *articleUrls = [[NSMutableArray alloc] init];
                NSMutableArray *imgUrls = [[NSMutableArray alloc] init];
                NSMutableArray *sources = [[NSMutableArray alloc] init];
                NSMutableArray *dates = [[NSMutableArray alloc] init];
                NSArray *nodes = [bodyNode findChildrenOfClass:@"pickup_list pb20p"];
                for (HTMLNode *node in nodes) {
                    NSArray *aNodes = [node findChildTags:@"a"];
                    HTMLNode *aNode = (HTMLNode*)aNodes[0];
                    NSString *articleUrl = [aNode getAttributeNamed:@"href"];
                    
                    NSArray *grayNodes = [node findChildrenOfClass:@"yjSt f_gray01"];
                    HTMLNode *grayNode = (HTMLNode*)grayNodes[0];
                    
                    NSArray *imgNodes = [node findChildTags:@"img"];
                    HTMLNode *imgNode = (HTMLNode*)imgNodes[0];
                    
                    NSArray *titleNodes = [node findChildrenOfClass:@"lh14 pb5p"];
                    HTMLNode *titleNode = [titleNodes count]>0 ? (HTMLNode*)titleNodes[0] : nil;
                    
                    NSMutableString *style = [[imgNode getAttributeNamed:@"style"] mutableCopy];
                    //background:url(http://amd.c.yimg.jp/im_siggk5Vfp06zvuo6YuR7V9weoA---x67-y100-q90/amd/20150313-00000313-ism-000-0-thumb.jpg) no-repeat; width:67; height:100;
                    NSString *text1 = [style stringByReplacingOccurrencesOfString:@"background:url(" withString:@""];
                    NSArray *texts = [text1 componentsSeparatedByString:@")"];
                    NSString *imgUrl = texts[0];
                    
                    NSString *grayText = [grayNode contents];
                    NSArray *grays = [grayText componentsSeparatedByString:@"-"];
                    NSString *source = [grays[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    NSString *dateStr = [grays[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    
                    NSString *title = [titleNode.children[0] contents];
                    
                    [articleUrls addObject:articleUrl];
                    [imgUrls addObject:imgUrl];
                    [sources addObject:source];
                    [dates addObject:dateStr];
                    
                    PLArticle *article = [[PLArticle alloc]init];
                    article.url = articleUrl;
                    article.imageURL = imgUrl;
                    article.sourceName = source;
                    article.dateStr = dateStr;
                    article.title = title;
                    
                    DEBUGLOG(@"articleUrl:%@",articleUrl);
                    DEBUGLOG(@"imgUrl:%@",imgUrl);
                    DEBUGLOG(@"src:%@ dat:%@",source,dateStr);
                    DEBUGLOG(@"title:%@",title);
                    
                    [articles addObject:article];
                }
                */



                
        
            },
            failure: {( operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                SVProgressHUD.dismiss()
                println("error \(error)")
                println("error \(error.localizedDescription)")
        })
        
    }

}
