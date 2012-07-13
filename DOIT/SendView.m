//
//  SendView.m
//  DOIT
//
//  Created by AppDev on 11-12-10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SendView.h"
#import "UIImage+CustomUIImage.h"
#import "DOITUtil.h"
#import "UserInfo.h"
#import "LoginView.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

@implementation SendView
@synthesize titleField;
@synthesize messageTextView;
@synthesize selImageView;
@synthesize toastLabel;

@synthesize fid = _fid;
@synthesize userip = _userip;



UIImage* dealImage;

//返回
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

//发帖
-(IBAction)sendClick:(id)sender{
    [self.titleField resignFirstResponder];
    [self.messageTextView resignFirstResponder];
    NSString* titleContent = [[self.titleField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* messageContent = [[self.messageTextView text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([titleContent length] > 0) {
        if ([messageContent length] > 0) {
            if ([UserInfo sharedInstance].username != nil) {
                NSString* requestURL = [NSString stringWithFormat:@"%@bbs.topic.post.do",[DOITUtil getUrlBase]];
                ASIFormDataRequest* request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:requestURL]];
                [request setPostValue:_fid forKey:@"fid"];
                [request setPostValue:[UserInfo sharedInstance].username forKey:@"author"];
                [request setPostValue:titleContent forKey:@"subject"];
                [request setPostValue:messageContent forKey:@"message"];
                [request setPostValue:_userip forKey:@"useip"];
                [request setPostValue:[DOITUtil encodeBase64:dealImage] forKey:@"imageString"];
                [request startSynchronous];
                NSDictionary* dic = [[request responseString] JSONValue];
                if (dic != nil) {
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
                            [self.toastLabel setText:@"发贴成功"];
                            [self performSelector:@selector(show) withObject:nil afterDelay:0];
                            [self performSelector:@selector(hidden) withObject:nil afterDelay:1.0];
                            //[NSThread sleepForTimeInterval:2000];
                            [self.navigationController popViewControllerAnimated:YES];
                        }else{
                            [self.toastLabel setText:@"发贴失败"];
                            [self performSelector:@selector(show) withObject:nil afterDelay:0];
                            [self performSelector:@selector(hidden) withObject:nil afterDelay:1.0];
                        }
                    }

                }
                [request release];
            }else{
                LoginView* loginView = [[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
                [self.navigationController pushViewController:loginView animated:YES];
                [loginView release];
            }
            
        }else{
            [self.toastLabel setText:@"内容不能为空"];
            [self performSelector:@selector(show) withObject:nil afterDelay:0];
            [self performSelector:@selector(hidden) withObject:nil afterDelay:1.0];
        }
    }else{
        [self.toastLabel setText:@"标题不能为空"];
        [self performSelector:@selector(show) withObject:nil afterDelay:0];
        [self performSelector:@selector(hidden) withObject:nil afterDelay:1.0];
    }
}

//打开图片库
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
    [super viewDidLoad];
   // NSLog(@"userip = %@, bkid = %@",_userip,_fid);
    self.titleField.placeholder = @"请输入标题...";
    [self.titleField addTarget:self action:@selector(textFieldDone) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.messageTextView.delegate=self;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];  
    [topView setAlpha:0.8];
    [topView setBarStyle:UIBarStyleBlack];  
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];  
    
    
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(textFieldDone)];  
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];  
    
    [doneButton release];  
    
    [btnSpace release];  
    
    [topView setItems:buttonsArray];  
    
    [textView setInputAccessoryView:topView]; 
    return YES;
}

-(void)textFieldDone{
    [titleField resignFirstResponder];
    [messageTextView resignFirstResponder];
}

-(void)dealloc{
    [self.userip release];
    [self.fid release];
    [self.selImageView release];
    [self.titleField release];
    [self.messageTextView release];
    [self.toastLabel release];
    [super dealloc];
}

@end
