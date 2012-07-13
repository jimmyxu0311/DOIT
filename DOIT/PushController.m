//
//  PushController.m
//  手机DOIT
//
//  Created by AppDev on 12-3-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PushController.h"
#import "CommentListView.h"
#import "DOITUtil.h"
#import "InformationDetailService.h"
#import "SQLite3_Manager.h"
#import "UserInfo.h"
#import "LoginView.h"
#import "CommentListView.h"
#import "ShareView.h"
#import "MobileInfo.h"

@implementation PushController
@synthesize artID;
@synthesize genTipButton;
@synthesize sendButton;
@synthesize collectionButton;
@synthesize webView;
@synthesize toastLabel;
@synthesize genTipContentText;
@synthesize backImage;


-(IBAction)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//跟贴列表
-(IBAction)genTipClick:(id)sender{
    [self.genTipContentText resignFirstResponder];
    if (informationDetail != nil) {
        if (commentSize == 0) {
            self.toastLabel.text = @"暂无跟贴";
            [self performSelector:@selector(show) withObject:nil afterDelay:0];
            [self performSelector:@selector(hidden) withObject:nil afterDelay:0.5];
        }else{
            CommentListView* commentListView = [[CommentListView alloc] initWithNibName:@"CommentListView" bundle:nil];
            commentListView.siteid = informationDetail.siteID;
            commentListView.articleid = artID;
            commentListView.userip = _userip;
            [self.navigationController pushViewController:commentListView animated:YES];
            [commentListView release];
        }
    }
}


//回帖
-(IBAction)sendClick:(id)sender{
    [self.genTipContentText resignFirstResponder];
    NSString* sendContent = [[self.genTipContentText text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([sendContent length] > 0) {
        //self.sendButton.hidden = NO;
        if ([UserInfo sharedInstance].username != nil) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            NSString* sendRequest = [NSString stringWithFormat:@"%@article.post.comment.do?username=%@&siteid=%@&articleid=%@&content=%@&phoneip=%@",[DOITUtil getUrlBase],[UserInfo sharedInstance].username,informationDetail.siteID,artID,sendContent,_userip];
            NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[sendRequest stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            NSURLConnection* theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            if (theConnection) {
                _data = [[NSMutableData data] retain];
            }
        }else{
            LoginView* loginView = [[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
            [self.navigationController pushViewController:loginView animated:YES];
        }
    }else{
        self.toastLabel.text = @"回帖内容不能为空";
        [self performSelector:@selector(show) withObject:nil afterDelay:0];
        [self performSelector:@selector(hidden) withObject:nil afterDelay:0.5];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //请求数据出错处理
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [connection release];
    [_data release];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    //获取请求数据的处理
    [_data appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //请求完成的处理
    NSString* jsonData = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    self.toastLabel.text = jsonData;
    [self performSelector:@selector(show) withObject:nil afterDelay:0];
    [self performSelector:@selector(hidden) withObject:nil afterDelay:0.5];
    [jsonData release];
    [self.genTipContentText setText:nil];
    [connection release];
    [_data release];
    commentSize++;
    NSString* commentSizeStr = [NSString stringWithFormat:@"%i跟贴",commentSize];
    [self.genTipButton setTitle:commentSizeStr forState:UIControlStateNormal];
}



//分享
-(IBAction)shareClick:(id)sender{
    UIActionSheet* shareSheet = [[UIActionSheet alloc] initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"新浪微博" otherButtonTitles:@"腾讯微博"/*,@"人人网"*/,@"短信",@"邮箱", nil];
    [shareSheet showInView:self.view];
    [shareSheet release];
}

//收藏
-(IBAction)collectionClick:(id)sender{
    if (informationDetail != nil) {
        //收藏
        SQLite3_Manager* sqlite = [[SQLite3_Manager alloc] init];
        int success = [sqlite insertInformation:artID title:informationDetail.title summary:informationDetail.summary siteid:informationDetail.siteID];
        if (success == 22) {
            self.toastLabel.text = @"收藏成功";
            [self performSelector:@selector(show) withObject:nil afterDelay:0];
            [self performSelector:@selector(hidden) withObject:nil afterDelay:0.5];
        }else if(success == 44){
            int deleteSuccess = [sqlite deleteInformation:artID];
            if (deleteSuccess == 22) {
                self.toastLabel.text = @"取消收藏成功";
                [self performSelector:@selector(show) withObject:nil afterDelay:0];
                [self performSelector:@selector(hidden) withObject:nil afterDelay:0.5];
            }else{
                self.toastLabel.text = @"此贴已经收藏";
                [self performSelector:@selector(show) withObject:nil afterDelay:0];
                [self performSelector:@selector(hidden) withObject:nil afterDelay:0.5];
            }
        }else{
            self.toastLabel.text = @"收藏失败";
            [self performSelector:@selector(show) withObject:nil afterDelay:0];
            [self performSelector:@selector(hidden) withObject:nil afterDelay:0.5];
        }
        if ([sqlite selectInformation:artID] == 22) {
            [self.collectionButton setBackgroundImage:[UIImage imageNamed:@"collect_cancel.png"] forState:UIControlStateNormal];
        }else{
            [self.collectionButton setBackgroundImage:[UIImage imageNamed:@"collect_button.png"] forState:UIControlStateNormal];
        }
        
        [sqlite release];
        
    }
}


-(void)hidden{
    [UIView animateWithDuration:2.0 delay:0 options:0 animations:^{
        toastLabel.alpha = 0;
    } completion:^(BOOL finished){
        toastLabel.alpha = 0;
    }];
}

-(void)show{
    [UIView animateWithDuration:2.0 delay:0 options:0 animations:^{
        toastLabel.alpha = 1;
    } completion:^(BOOL finished){
        toastLabel.alpha = 1;
    }];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result)
    {
        case MessageComposeResultCancelled:
            //LOG_EXPR(@"Result: SMS sending canceled");
            break;
        case MessageComposeResultSent:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发送成功" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
            break;
        case MessageComposeResultFailed:
        {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发送失败" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
        }
            break;
        default:
            //LOG_EXPR(@"Result: SMS not sent");
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)displaySMSComposerSheet:(NSString*)sendContent{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    picker.body = [[NSString alloc] initWithString:sendContent];
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

-(void)displayComposerSheet:(NSString*)sendContent
{ 
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init]; 
    picker.title=@"新邮件";
    picker.mailComposeDelegate = self;  
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init]; 
    [dateFormatter setDateFormat:@"yyyy/MM/dd"]; 
    NSDate *date=[[NSDate alloc] init]; 
    NSString *content1=[[NSString alloc] 
                        initWithFormat:@"App:1.0.iOS:%@ Date:%@ content:%@", 
                        [[UIDevice currentDevice] systemVersion],[dateFormatter stringFromDate:date],sendContent]; 
    [date release]; 
    [dateFormatter release]; 
    [picker setMessageBody:content1 isHTML:YES]; 
    [content1 release]; 
    [self presentModalViewController:picker animated:YES]; 
    [picker release]; 
} 
-(void)launchMailAppOnDevice 
{ 
    NSString *recipients = @""; 
    //    NSString *body = @"&body=It is raining in sunny California!"; 
    NSString *body = [NSString stringWithFormat:@"&body=%@",share_Content];
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body]; 
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; 
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]]; 
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *shareContenStr = [NSString stringWithFormat:@"我在手机DOIT发现了信息:《%@》,与你分享%@",informationDetail.title,informationDetail.url];
    share_Content = shareContenStr;
    if (buttonIndex < 2) {
        ShareView* shareView = [[ShareView alloc] initWithNibName:@"ShareView" bundle:nil];
        
        shareView.shareContentStr = shareContenStr;
        switch (buttonIndex) {
            case 0:
                shareView.shareType = 0;
                break;
            case 1:
                shareView.shareType = 1;
                break;
        }
        [self.navigationController pushViewController:shareView animated:YES];
        [shareView release];
    }else{
        if (buttonIndex == 2) {
            //短信分享
            Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
            if (messageClass != nil) {
                if ([messageClass canSendText]) {
                    [self displaySMSComposerSheet:shareContenStr];
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备没有短信功能" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                }
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"iOS版本过低,iOS4.0以上才支持程序内发送短信" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            
        }else if(buttonIndex == 3){
            //邮箱分享
            Class mailClass = (NSClassFromString(@"MFMailComposeViewController")); 
            if (mailClass != nil) 
            { 
                // We must always check whether the current device is configured for sending emails 
                if ([mailClass canSendMail]) 
                { 
                    [self displayComposerSheet:shareContenStr]; 
                } 
                else 
                { 
                    [self launchMailAppOnDevice]; 
                } 
            } 
            else 
            { 
                [self launchMailAppOnDevice]; 
            } 
            
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{    
    //    message.hidden = NO; 
    // Notifies users about errors associated with the interface 
    switch (result) 
    { 
        case MFMailComposeResultCancelled: 
            //message.text = @"Result: canceled"; 
            break; 
        case MFMailComposeResultSaved: 
            //message.text = @"Result: saved"; 
            break; 
        case MFMailComposeResultSent: 
            //message.text = @"Result: sent"; 
            break; 
        case MFMailComposeResultFailed: 
            //message.text = @"Result: failed"; 
            break; 
        default: 
            //    message.text = @"Result: not sent"; 
            break; 
    } 
    [self dismissModalViewControllerAnimated:YES]; 
}


#pragma mark - View lifecycle

-(void)fetchInformationDetail:(NSString*)urlString{
    NSURL* url = [NSURL URLWithString:urlString];
    informationDetail = [[InformationDetailService getArticleContentArray:url] retain];
    @try {
        commentSize = [informationDetail.commentNum intValue];
    }
    @catch (NSException *exception) {
        //commentSize = [informationDetail.commentNum intValue];
    }
    
    NSString* commentSizeStr = [NSString stringWithFormat:@"%@跟贴",informationDetail.commentNum];
    
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"shownews" ofType:@"html"];
    @try {
        [content insertString:informationDetail.content atIndex:0];
    }
    @catch (NSException *exception) {
        NSLog(@"json解析错误");
    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
    [self.webView reload];
    
    [self.genTipButton setTitle:commentSizeStr forState:UIControlStateNormal];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (informationDetail == nil) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSString* urlString = [NSString stringWithFormat:@"%@article.show.list.do?actionType=content&id=%@&requestNum=%d",[DOITUtil getUrlBase],artID,pageSize];
        [NSThread detachNewThreadSelector:@selector(fetchInformationDetail:) toTarget:self withObject:urlString];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    content = [[NSMutableString alloc] init];
    pageSize = 1;
    _userip = [MobileInfo shareInstance].userIPAddress;
    
    self.sendButton.hidden = YES;
    fieldY = self.genTipContentText.frame.origin.y;
    imgY = self.backImage.frame.origin.y;
    
    SQLite3_Manager* sqlite = [[SQLite3_Manager alloc] init];
    if ([sqlite selectInformation:artID] == 22) {
        [self.collectionButton setBackgroundImage:[UIImage imageNamed:@"collect_cancel.png"] forState:UIControlStateNormal];
    }
    [sqlite release];
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //[content insertString:informationDetail.content atIndex:0];
    if ([request.mainDocumentURL.relativePath isEqualToString:@"/click/true"]) {
        pageSize++;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSString* urlString = [NSString stringWithFormat:@"%@article.show.list.do?actionType=content&id=%@&requestNum=%d",[DOITUtil getUrlBase],artID,pageSize];
        NSURL* url = [NSURL URLWithString:urlString];
        informationDetail = [[InformationDetailService getArticleContentArray:url] retain];
        [content insertString:informationDetail.content atIndex:[content length]];
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('article_body').innerHTML='%@'",content]];
        
        int isHasNextPage = -1;
        
        @try {
            isHasNextPage = [informationDetail.pageSize intValue];
        }
        @catch (NSException *exception) {
            isHasNextPage = 1;
        }
        
        if (isHasNextPage > pageSize) {
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithString:@"document.getElementById('moreButton').style.display='block'"]];
        }else{
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithString:@"document.getElementById('moreButton').style.display='none'"]];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        return true;
    }
    return true;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('article_body').innerHTML='%@'",content]];
    
    int isHasNextPage = -1;
    
    @try {
        isHasNextPage = [informationDetail.pageSize intValue];
    }
    @catch (NSException *exception) {
        isHasNextPage = 1;
    }
    
    if (isHasNextPage > pageSize) {
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithString:@"document.getElementById('moreButton').style.display='block'"]];
    }else{
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithString:@"document.getElementById('moreButton').style.display='none'"]];
    }
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.sendButton.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil]; 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil]; 
}


- (void) keyboardWasShown:(NSNotification *) notif{ 
    NSDictionary *info = [notif userInfo]; 
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey]; 
    CGSize keyboardSize = [value CGRectValue].size; 
    [self.genTipContentText setFrame:CGRectMake(self.genTipContentText.frame.origin.x, fieldY - keyboardSize.height, self.genTipContentText.frame.size.width, self.genTipContentText.frame.size.height)];
    [self.sendButton setFrame:CGRectMake(self.sendButton.frame.origin.x, fieldY - keyboardSize.height, self.sendButton.frame.size.width, self.sendButton.frame.size.height)];
    [self.backImage setFrame:CGRectMake(self.backImage.frame.origin.x, imgY - keyboardSize.height, self.backImage.frame.size.width, self.backImage.frame.size.height)];
    
    
    keyboardWasShown = YES; 
} 

- (void) keyboardWasHidden:(NSNotification *) notif{ 
    [self.genTipContentText setFrame:CGRectMake(self.genTipContentText.frame.origin.x, fieldY, self.genTipContentText.frame.size.width, self.genTipContentText.frame.size.height)];
    [self.sendButton setFrame:CGRectMake(self.sendButton.frame.origin.x, fieldY, self.sendButton.frame.size.width, self.sendButton.frame.size.height)];
    [self.backImage setFrame:CGRectMake(self.backImage.frame.origin.x, imgY, self.backImage.frame.size.width, self.backImage.frame.size.height)];
    
    keyboardWasShown = NO; 
    NSString* sendContent = [[self.genTipContentText text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([sendContent length] > 0) {
        self.sendButton.hidden = NO;
    }else{
        self.sendButton.hidden = YES;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _userip = nil;
    content = nil;
    self.artID = nil;
}


-(void) dealloc{
    [self.artID release];
    
    [self.genTipContentText release];
    [self.genTipButton release];
    [self.sendButton release];
    [self.collectionButton release];
    [self.toastLabel release];
    [self.webView release];
    [self.backImage release];
    [super dealloc];
}

@end
