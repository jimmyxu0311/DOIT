//
//  RegisterView.m
//  DOIT
//
//  Created by AppDev on 11-12-13.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RegisterView.h"
#import "BAEditableCell.h"
#import "DOITUtil.h"
#import "JSON.h"
#import "UserInfo.h"

@implementation RegisterView
@synthesize registerView;
@synthesize toastLabel;


@synthesize username;
@synthesize password;
@synthesize email;
@synthesize configpassword;
@synthesize telnumber;
@synthesize connection = _connection;

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

- (void)unloadViews {
	self.registerView = nil;
    self.toastLabel = nil;
    if (_data != nil) {
        [_data release];
    }
}

- (void)dealloc {
	[self unloadViews];
	self.username = nil;
	self.password = nil;
    self.email = nil;
    self.configpassword = nil;
    self.telnumber = nil;
	[super dealloc];
}

- (void)viewDidUnload {
	[self unloadViews];
    [super viewDidUnload];
}

+ (BOOL)validEmail:(NSString *)email {
	NSRegularExpression *regexpObject = [NSRegularExpression regularExpressionWithPattern:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
																				  options:0
																					error:NULL];
	NSRange range = [regexpObject rangeOfFirstMatchInString:email
													options:0
													  range:NSMakeRange(0, [email length])];
	if (range.location == NSNotFound || range.length != [email length]) {
		return NO;
	}
	return YES;
}

- (BOOL)validateForm {
    if (!self.username || [self.username length] == 0) {
		[self.toastLabel setText:@"帐号不能为空！"];
        self.toastLabel.alpha = 1;
		return NO;
	}
    if ([self.username length] > 15 || [self.username length] < 4) {
        [self.toastLabel setText:@"帐号长度应为4～15位！"];
        self.toastLabel.alpha = 1;
		return NO;
    }
    if (!self.email || [self.email length] == 0) {
        [self.toastLabel setText:@"email不能为空！"];
        self.toastLabel.alpha = 1;
		return NO;
    }
    if (![[self class] validEmail:self.email]) {
		[self.toastLabel setText:@"email格式不正确！"];
        self.toastLabel.alpha = 1;
		return NO;
	}
	if (!self.password || [self.password length] == 0) {
		[self.toastLabel setText:@"密码不能为空！"];
        self.toastLabel.alpha = 1;
		return NO;
	}
    if ([self.password length] > 20) {
		[self.toastLabel setText:@"密码太长！"];
        self.toastLabel.alpha = 1;
		return NO;
	}
    if (!self.configpassword || [self.configpassword length] == 0) {
		[self.toastLabel setText:@"确认密码不能为空！"];
        self.toastLabel.alpha = 1;
		return NO;
	}
    if (![self.configpassword isEqualToString:self.password]) {
		[self.toastLabel setText:@"确认密码和密码不一致！"];
        self.toastLabel.alpha = 1;
		return NO;
	}
	return YES;
}

-(IBAction)complete:(id)sender{
    [BAEditableCell stopEditing:self.registerView];
    if ([self validateForm]) {
        self.toastLabel.alpha = 0;
    }
}


-(IBAction)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)registerClick:(id)sender{
    [BAEditableCell stopEditing:self.registerView];
    if ([self validateForm]) {
		self.toastLabel.alpha = 0;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSString* urlString = nil;
        if ([self.telnumber length] == 0) {
             urlString = [NSString stringWithFormat:@"http://passport.doit.com.cn/jsp/doitapi/reg_ios.jsp?username=%@&password=%@&email=%@",[DOITUtil encodeStrBase64:self.username],[DOITUtil encodeStrBase64:self.password],[DOITUtil encodeStrBase64:self.email]];
        }else{
             urlString = [NSString stringWithFormat:@"http://passport.doit.com.cn/jsp/doitapi/reg_ios.jsp?username=%@&password=%@&email=%@&celnumber=%@",[DOITUtil encodeStrBase64:self.username],[DOITUtil encodeStrBase64:self.password],[DOITUtil encodeStrBase64:self.email],[DOITUtil encodeStrBase64:self.telnumber]];
        }
        NSURL* url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [connection release];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
        NSDictionary* dic = [jsonData JSONValue];
        if (dic != nil) {
            [UserInfo sharedInstance].username = [dic objectForKey:@"username"];
            [UserInfo sharedInstance].email = [dic objectForKey:@"email"];
            [UserInfo sharedInstance].celnumber = [dic objectForKey:@"celnumber"];
            [UserInfo sharedInstance].result = [dic objectForKey:@"result"];
            
            if ([[UserInfo sharedInstance].result isEqualToString:@"success"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [_data release];
                _data = [[NSMutableData alloc] init];
                [self.toastLabel setText:[UserInfo sharedInstance].result];
                self.toastLabel.alpha = 1;
            }
        }
    }
    [jsonData release];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //[connection release];
}

- (void)textDidChange:(UITextField *)textField {
	if (textField.tag == 0) {
		self.username = textField.text;
	} else if (textField.tag == 1) {
		self.email = textField.text;
	}else if (textField.tag == 2){
        self.password = textField.text;
    }else if (textField.tag == 3){
        self.configpassword = textField.text;
    }else if (textField.tag == 4){
        self.telnumber = textField.text;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableViewA {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableViewA numberOfRowsInSection:(NSInteger)section {
	return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableViewA cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BAEditableCell *cell = (BAEditableCell *)[tableViewA dequeueReusableCellWithIdentifier:@"LoginCell"];
	if (!cell) {
		cell = [[[BAEditableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LoginCell"] autorelease];
	}
	cell.textField.delegate = self;
	[cell.textField removeTarget:nil action:NULL forControlEvents:UIControlEventEditingChanged];
	[cell.textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
	if (indexPath.row == 0) {
		cell.textLabel.text = @"帐 号:";
		cell.detailTextLabel.text = nil;
		cell.textField.placeholder = @"请输入帐号";
		cell.textField.text = self.username;
		cell.textField.secureTextEntry = NO;
		cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
		//cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
		cell.textField.tag = indexPath.row;
	} else if (indexPath.row == 1) {
		cell.textLabel.text = @"邮 箱:";
		cell.detailTextLabel.text = nil;
		cell.textField.placeholder = @"请输入常用邮箱";
		cell.textField.text = self.email;
		cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
		cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
		cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
		cell.textField.tag = indexPath.row;
	}else if (indexPath.row == 2) {
		cell.textLabel.text = @"密 码:";
		cell.detailTextLabel.text = nil;
		cell.textField.placeholder = @"请输入密码";
		cell.textField.text = self.password;
		cell.textField.secureTextEntry = YES;
		cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
		cell.textField.keyboardType = UIKeyboardTypeDefault;
		cell.textField.tag = indexPath.row;
	}else if (indexPath.row == 3) {
		cell.textLabel.text = @"确认密码:";
		cell.detailTextLabel.text = nil;
		cell.textField.placeholder = @"请再次输入密码";
		cell.textField.text = self.configpassword;
		cell.textField.secureTextEntry = YES;
		cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
		cell.textField.keyboardType = UIKeyboardTypeDefault;
		cell.textField.tag = indexPath.row;
	}else if (indexPath.row == 4) {
		cell.textLabel.text = @"联系方式:";
		cell.detailTextLabel.text = nil;
		cell.textField.placeholder = @"请输入联系方式";
		cell.textField.text = self.telnumber;
		//cell.textField.secureTextEntry = YES;
		cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
		cell.textField.keyboardType = UIKeyboardTypeNumberPad;
		cell.textField.tag = indexPath.row;
	}
	return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	//[textField resignFirstResponder];
	return YES;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _data = [[NSMutableData alloc] init];
}

@end
