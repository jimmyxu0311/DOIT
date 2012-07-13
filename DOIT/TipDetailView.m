//
//  TipDetailView.m
//  DOIT
//
//  Created by AppDev on 11-12-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TipDetailView.h"
#import "DOITUtil.h"
#import "TipDetailService.h"
#import "ReplayView.h"
#import "SQLite3_Manager.h"
#import "ShareView.h"

@implementation TipDetailView
@synthesize webView;
@synthesize pageSizeLabel;
@synthesize toastLabel;
@synthesize tid = _tid;
@synthesize bkid = _bkid;
@synthesize tipTitle = _tipTitle;
@synthesize userip = _userip;
@synthesize titleText;
@synthesize titleLabel;
@synthesize leftbtn;
@synthesize rightbtn;

static int pageIndex = 1;
static int pageSize = 10;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
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

//返回
-(IBAction)backClick:(id)sender{
    pageIndex = 1;
    [self.navigationController popViewControllerAnimated:YES];
    //[self dealloc];
}

//回帖
-(IBAction)replayClick:(id)sender{
    if (tipDetail) {
        ReplayView* replayView = [[ReplayView alloc] initWithNibName:@"ReplayView" bundle:nil];
        replayView.tid = self.tid;
        replayView.fid = self.bkid;
        replayView.userip = _userip;
        [self.navigationController pushViewController:replayView animated:YES];
        [replayView release];
    }
}

//上一页
-(IBAction)leftClick:(id)sender{
    
    if (pageIndex > 1) {
        [leftbtn setImage:[UIImage imageNamed:@"club_button_left.png"] forState:UIControlStateNormal];
        [rightbtn setImage:[UIImage imageNamed:@"club_button_right.png"] forState:UIControlStateNormal];
        pageIndex--;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSString* urlString = [NSString stringWithFormat:@"%@bbs.topic.detail.ios.do?tid=%@&page=%d&requestNum=%d",[DOITUtil getUrlBase],_tid,pageIndex,pageSize];
        [NSThread detachNewThreadSelector:@selector(loadTipContent:) toTarget:self withObject:urlString];
        if (pageIndex==1) {
            [leftbtn setImage:[UIImage imageNamed:@"club_button_un_left.png"] forState:UIControlStateNormal];
        }
    }
    else{
        [leftbtn setImage:[UIImage imageNamed:@"club_button_un_left.png"] forState:UIControlStateNormal];
    }
}

//下一页
-(IBAction)rightClick:(id)sender{
    if (tipDetail) {
        if (pageIndex < [tipDetail.pageSize intValue]) {
            [rightbtn setImage:[UIImage imageNamed:@"club_button_right.png"] forState:UIControlStateNormal];
            [leftbtn setImage:[UIImage imageNamed:@"club_button_left.png"] forState:UIControlStateNormal];
            pageIndex++;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            NSString* urlString = [NSString stringWithFormat:@"%@bbs.topic.detail.ios.do?tid=%@&page=%d&requestNum=%d",[DOITUtil getUrlBase],_tid,pageIndex,pageSize];
            [NSThread detachNewThreadSelector:@selector(loadTipContent:) toTarget:self withObject:urlString];
            if (pageIndex==[tipDetail.pageSize intValue]) {
                [rightbtn setImage:[UIImage imageNamed:@"club_button_un_right.png"] forState:UIControlStateNormal];
            }
        }
    }
    else{
        [rightbtn setImage:[UIImage imageNamed:@"club_button_un_right.png"] forState:UIControlStateNormal];
    }

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.webView setScalesPageToFit:YES];
    self.titleLabel.text = self.titleText;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (tipDetail == nil) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSString* urlString = [NSString stringWithFormat:@"%@bbs.topic.detail.ios.do?tid=%@&page=%d&requestNum=%d",[DOITUtil getUrlBase],_tid,pageIndex,pageSize];
        [NSThread detachNewThreadSelector:@selector(loadTipContent:) toTarget:self withObject:urlString];
    }
}

-(void)loadTipContent:(NSString*)urlStr{
    NSURL* url = [NSURL URLWithString:urlStr];
    tipDetail = [[TipDetailService getTipDetail:url] retain];
    
    [self.webView loadHTMLString:tipDetail.threadMessage baseURL:nil];
    
    NSString* pageSizeString = [NSString stringWithFormat:@"%d/%@",pageIndex,tipDetail.pageSize];
    
    int size = 0;
    @try {
        size = [tipDetail.pageSize intValue];
    }
    @catch (NSException *exception) {
        size = -1;
    }
    @finally {
        if (size > 0) {
            [self.pageSizeLabel performSelectorOnMainThread:@selector(setText:) withObject:pageSizeString waitUntilDone:YES];
        }
    }
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //获取网页的url
    NSString* url = request.URL.relativeString;
    if ([url isEqualToString:@"about:blank"]) {
        return YES;
    }else{
        if ([url hasSuffix:@"type=0"]) {
            //回复
            NSRange range;
            range = [url rangeOfString:@"?"];
            if (range.location != NSNotFound) {
                int start = range.location + 1;
                range = [url rangeOfString:@"&"];
                int end = range.location;
                NSString* pidString = [url substringWithRange:NSMakeRange(start, (end - start))];
                
                range = [pidString rangeOfString:@"="];
                if (range.location != NSNotFound) {
                    NSString* pid = [pidString substringFromIndex:(range.location+1)];
                    ReplayView* replayView = [[ReplayView alloc] initWithNibName:@"ReplayView" bundle:nil];
                    replayView.tid = self.tid;
                    replayView.fid = self.bkid;
                    replayView.pid = pid;
                    replayView.userip = _userip;
                    [self.navigationController pushViewController:replayView animated:YES];
                    [replayView release];
                }
            }
            
        }if ([url hasSuffix:@"type=1"]) {
            //分享
            UIActionSheet* shareSheet = [[UIActionSheet alloc] initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"新浪微博" otherButtonTitles:@"腾讯微博"/*,@"人人网"*/,@"短信",@"邮箱", nil];
            [shareSheet showInView:self.view];
            [shareSheet release];
        }if ([url hasSuffix:@"type=2"]) {
            //收藏
            SQLite3_Manager* sqlite = [[SQLite3_Manager alloc] init];
            int success = [sqlite insertTip:_tid title:_tipTitle fid:_bkid];
            if (success == 22) {
                //NSLog(@"insert success");
                self.toastLabel.text = @"收藏成功";
                [self performSelector:@selector(show) withObject:nil afterDelay:0];
                [self performSelector:@selector(hidden) withObject:nil afterDelay:1.0];
            }else if(success == 44){
                //NSLog(@"此贴已经收藏");
                self.toastLabel.text = @"此贴已经收藏";
                [self performSelector:@selector(show) withObject:nil afterDelay:0];
                [self performSelector:@selector(hidden) withObject:nil afterDelay:1.0];
            }else{
                self.toastLabel.text = @"收藏失败";
                [self performSelector:@selector(show) withObject:nil afterDelay:0];
                [self performSelector:@selector(hidden) withObject:nil afterDelay:1.0];
            }
            [sqlite release];
        }
        
        return NO;
    }
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
    NSString *body = [NSString stringWithFormat:@"&body=%@",share_content];
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body]; 
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; 
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]]; 
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString* url = [NSString stringWithFormat:@"http://bbs.doit.com.cn/thread-%@-1-1.html",_tid];
    NSString *shareContenStr = [NSString stringWithFormat:@"我在手机DOIT发现了信息:《%@》,与你分享%@",_tipTitle,url];
    share_content = shareContenStr;
    ShareView* shareView = [[ShareView alloc] initWithNibName:@"ShareView" bundle:nil];
    shareView.shareContentStr = shareContenStr;
    if (buttonIndex < 2) {
        switch (buttonIndex) {
            case 0:
                shareView.shareType = 0;
                break;
            case 1:
                shareView.shareType = 1;
            break;       
//            case 2:
//                shareView.shareType = 2;
//                break;
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

- (void)viewDidUnload{
    [super viewDidUnload];
    self.titleText = nil;
}


-(void)dealloc{
    [self.titleLabel release];
    [tipDetail release];
    [self.userip release];
    [self.tipTitle release];
    [self.tid release];
    [self.bkid release];
    [toastLabel release];
    [pageSizeLabel release];
    [webView release];
    [super dealloc];
}

@end
