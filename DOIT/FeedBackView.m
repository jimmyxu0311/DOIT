//
//  FeedBackView.m
//  DOIT
//
//  Created by AppDev on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "FeedBackView.h"
#import "UserInfo.h"
#import "JSON.h"

#define FEEDBACK_URL @"http://m.doit.com.cn/api/more.feedback.do"

@implementation FeedBackView
@synthesize feedBackTextView;
@synthesize limitLabel;
@synthesize toastLabel;

@synthesize connection = _connection;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(IBAction)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)doneClick:(id)sender{
    [feedBackTextView resignFirstResponder];
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
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];  
    [topView setAlpha:0.8];
    [topView setBarStyle:UIBarStyleBlack];  
        
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];  
     
           
     
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneClick:)];  
     
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];  
    
    [doneButton release];  
     
    [btnSpace release];  
         
    [topView setItems:buttonsArray];  
     
    [textView setInputAccessoryView:topView]; 
    return YES;
}

//字数限制显示
- (BOOL)textChanged:(NSNotification *)notification{
    NSString* textViewContent = self.feedBackTextView.text;
    int input = 200 - textViewContent.length;
    if (input >= 0) {
        NSString *inputStr = [NSString stringWithFormat:@"%d",input];
        self.limitLabel.text = inputStr;
        self.toastLabel.alpha = 0; 
        return YES;
    }
    else{
        NSString *inputStr = [NSString stringWithFormat:@"%d",0];
        self.limitLabel.text = inputStr;
        [self.toastLabel setText:@"您已超过字数！"];
        self.toastLabel.alpha = 1;
        return NO;
    }
}


-(IBAction)sendClick:(id)sender{
    [self.feedBackTextView resignFirstResponder];
    NSString* feedContent = [self.feedBackTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([feedContent length] > 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSString* urlStr = nil;
        if ([UserInfo sharedInstance].username == nil) {
            urlStr = [NSString stringWithFormat:@"%@?username=%@&content=%@",FEEDBACK_URL,@"null",feedContent];
        }else{
            urlStr = [NSString stringWithFormat:@"%@?username=%@&content=%@",FEEDBACK_URL,[UserInfo sharedInstance].username,feedContent];
        }
        
        NSURL* url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }else{
        [self.toastLabel setText:@"反馈内容不能为空！"];
        self.toastLabel.alpha = 1;
    }
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [connection release];
    //请求数据出错处理
    self.toastLabel.text = @"网络正忙，请稍候再试";
    [self performSelector:@selector(show) withObject:nil afterDelay:0];
    [self performSelector:@selector(hidden) withObject:nil afterDelay:1.0];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1{
    //获取请求数据的处理
    [_data appendData:data1];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    //请求完成的处理
    NSString* jsonData = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    if (jsonData != nil) {
        NSDictionary* dictionary = [jsonData JSONValue];
        if (dictionary != nil) {
            NSString* statue = [dictionary objectForKey:@"state"];
            int stat = 0;
            @try {
                stat = [statue intValue];
            }
            @catch (NSException *exception) {
                self.toastLabel.text = @"提交失败";
                self.toastLabel.alpha = 1;
            }
            @finally {
                
            }
            if (stat == 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                self.toastLabel.text = @"提交失败";
                [self performSelector:@selector(show) withObject:nil afterDelay:0];
                [self performSelector:@selector(hidden) withObject:nil afterDelay:1.0];
            }
        }
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [jsonData release];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(textChanged:) 
												 name:UITextViewTextDidChangeNotification 
											   object:self.feedBackTextView];
    _data = [[NSMutableData alloc] init];
}


-(void) dealloc{
    if (nil != _data) {
        [_data release];
    }
    [self.feedBackTextView release];
    [self.limitLabel release];
    [super dealloc];
}

@end
