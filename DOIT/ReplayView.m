//
//  ReplayView.m
//  DOIT
//
//  Created by AppDev on 11-12-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ReplayView.h"
#import "UIImage+CustomUIImage.h"
#import "DOITUtil.h"
#import "UserInfo.h"
#import "LoginView.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

@implementation ReplayView
@synthesize textView;
@synthesize selImageView;
@synthesize toastLabel;
@synthesize tid = _tid;
@synthesize fid = _fid;
@synthesize pid = _pid;
@synthesize userip = _userip;

UIImage* dealImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //[self.toastLabel setAlpha:0];
    }
    return self;
}
//返回按钮事件处理
-(IBAction)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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

//发送按钮事件处理
-(IBAction)sendClick:(id)sender{
    [self.textView resignFirstResponder];
    
    NSString* sendContent = [[self.textView text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //NSMutableData* postData = [[NSMutableData alloc] init];
    NSString* requestURL;
    if ([sendContent length] > 0) {
        if ([UserInfo sharedInstance].username != nil) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            //针对回复者的回复
            if (_pid != NULL) {
                requestURL = [NSString stringWithFormat:@"%@bbs.topic.quote.do",[DOITUtil getUrlBase]];
                
                ASIFormDataRequest* request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:requestURL]];
                [request setPostValue:_fid forKey:@"fid"];
                [request setPostValue:_tid forKey:@"tid"];
                [request setPostValue:[UserInfo sharedInstance].username forKey:@"author"];
                [request setPostValue:sendContent forKey:@"message"];
                [request setPostValue:_userip forKey:@"useip"];
                [request setPostValue:[DOITUtil encodeBase64:dealImage] forKey:@"imageString"];
                [request setPostValue:_pid forKey:@"pid"];
                [request startSynchronous];
                NSDictionary* dic = [[request responseString] JSONValue];
                NSString* statue = [dic objectForKey:@"state"];
                int state;
                @try {
                    state = [statue intValue];
                }
                @catch (NSException *exception) {
                    state = -2;
                }
                @finally {
                    if (state == 1) {
                        [self.toastLabel setText:@"回贴成功"];
                        [self performSelector:@selector(show) withObject:nil afterDelay:0];
                        [self performSelector:@selector(hidden) withObject:nil afterDelay:1.0];
                        //[NSThread sleepForTimeInterval:2000];
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        [self.toastLabel setText:@"回贴失败"];
                        [self performSelector:@selector(show) withObject:nil afterDelay:0];
                        [self performSelector:@selector(hidden) withObject:nil afterDelay:1.0];
                    }
                }
                
                [request release];
                
            }else{
                //针对帖子的回复
                requestURL = [NSString stringWithFormat:@"%@bbs.topic.reply.do",[DOITUtil getUrlBase]];
                
                ASIFormDataRequest* request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:requestURL]];
                [request setPostValue:_fid forKey:@"fid"];
                [request setPostValue:_tid forKey:@"tid"];
                [request setPostValue:[UserInfo sharedInstance].username forKey:@"author"];
                [request setPostValue:sendContent forKey:@"message"];
                [request setPostValue:_userip forKey:@"useip"];
                [request setPostValue:[DOITUtil encodeBase64:dealImage] forKey:@"imageString"];
                [request startSynchronous];
                NSDictionary* dic = [[request responseString] JSONValue];
                NSString* statue = [dic objectForKey:@"state"];
                int state;
                @try {
                    state = [statue intValue];
                }
                @catch (NSException *exception) {
                    state = -2;
                }
                @finally {
                    if (state == 1) {
                        [self.toastLabel setText:@"回贴成功"];
                        [self performSelector:@selector(show) withObject:nil afterDelay:0];
                        [self performSelector:@selector(hidden) withObject:nil afterDelay:1.0];
                        //[NSThread sleepForTimeInterval:2000];
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        [self.toastLabel setText:@"回贴失败"];
                        [self performSelector:@selector(show) withObject:nil afterDelay:0];
                        [self performSelector:@selector(hidden) withObject:nil afterDelay:1.0];
                    }
                }

                [request release];
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }else{
            //跳转到登录页面
            LoginView* loginView = [[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
            [self.navigationController pushViewController:loginView animated:YES];
            [loginView release];
        }
    }else{
        [self.toastLabel setText:@"回贴内容不能为空"];
        [self performSelector:@selector(show) withObject:nil afterDelay:0];
        [self performSelector:@selector(hidden) withObject:nil afterDelay:1.0];
    }
}

//选择图片按钮事件处理
-(IBAction)selectImgClick:(id)sender{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [self presentModalViewController:imagePickerController animated:YES];
    [imagePickerController release];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    dealImage = [image scaleToSize:CGSizeMake(image.size.width/2, image.size.height/2)];
    selImageView.image = dealImage;
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissModalViewControllerAnimated:YES];
}

//启动相机事件处理
-(IBAction)startCamareClick:(id)sender{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    textView.delegate=self;
    [super viewDidLoad];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)TextView{
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];  
    [topView setAlpha:0.8];
    [topView setBarStyle:UIBarStyleBlack];  
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];  
    
    
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(textFieldDone)];  
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];  
    
    [doneButton release];  
    
    [btnSpace release];  
    
    [topView setItems:buttonsArray];  
    
    [TextView setInputAccessoryView:topView]; 
    return YES;
}

-(void)textFieldDone{
    [self.textView resignFirstResponder];
}

-(void)dealloc{
    [self.tid release];
    [self.pid release];
    [self.fid release];
    [self.userip release];
    [self.toastLabel release];
    [self.textView release];
    [self.selImageView release];
    [super dealloc];
}

@end
