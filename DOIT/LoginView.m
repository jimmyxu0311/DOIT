//
//  LoginView.m
//  DOIT
//
//  Created by AppDev on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "LoginView.h"
#import "BAEditableCell.h"
#import "RegisterView.h"
#import "DOITUtil.h"
#import "JSON.h"
#import "UserInfo.h"

@implementation LoginView
@synthesize loginView;
@synthesize userName;
@synthesize passWord;
@synthesize toastLabel;
@synthesize connection = _connection;

-(NSString*)dataFilePath{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentPath = [paths objectAtIndex:0];
    return [documentPath stringByAppendingPathComponent:@"userInfo.plist"];
}

//保存用户数据
-(void)saveData{
    NSString* filePath = [self dataFilePath];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:self.userName forKey:@"UserName"];
    [dict setObject:self.passWord forKey:@"PassWord"];
    [dict writeToFile:filePath atomically:YES];
    [dict release];
}

//读取数据
-(void)readData{
    NSString* filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        self.userName = [dict objectForKey:@"UserName"];
        self.passWord = [dict objectForKey:@"PassWord"];
        [dict release];
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

- (void)unloadViews {
	self.loginView = nil;
    self.toastLabel = nil;
    if (_data != nil) {
        [_data release];
    }
}

- (void)dealloc {
	[self unloadViews];
	self.userName = nil;
	self.passWord = nil;
	[super dealloc];
}

- (void)viewDidUnload {
	[self unloadViews];
    [super viewDidUnload];
}

- (BOOL)validateForm {
    if (!self.userName || [self.userName length] == 0) {
		[self.toastLabel setText:@"帐号不能为空！"];
        self.toastLabel.alpha = 1;
		return NO;
	}
    if (!self.passWord || [self.passWord length] == 0) {
		[self.toastLabel setText:@"密码不能为空！"];
        self.toastLabel.alpha = 1;
		return NO;
	}
    return YES;
}


-(IBAction)loginClick:(id)sender{
    [BAEditableCell stopEditing:self.loginView];
    
//    NSLog(@"%i",[self validateForm]);
    
	if ([self validateForm]) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		NSString* urlString = [NSString stringWithFormat:@"http://passport.doit.com.cn/jsp/doitapi/login_ios.jsp?loginname=%@&password=%@",[DOITUtil encodeStrBase64:self.userName],[DOITUtil encodeStrBase64:self.passWord]];
        NSURL* url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        _connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
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
    
//    NSLog(@"jsonData = %@",jsonData);
    
    if (jsonData != nil) {
        NSDictionary* dic = [jsonData JSONValue];
        if (dic != nil) {
            [UserInfo sharedInstance].result = [dic objectForKey:@"result"];
            [UserInfo sharedInstance].username = [dic objectForKey:@"username"];
            [UserInfo sharedInstance].email = [dic objectForKey:@"email"];
            [UserInfo sharedInstance].realname = [dic objectForKey:@"realname"];
            [UserInfo sharedInstance].gender = [dic objectForKey:@"gender"];
            [UserInfo sharedInstance].postcode = [dic objectForKey:@"postcode"];
            [UserInfo sharedInstance].copyname = [dic objectForKey:@"copyname"];
            [UserInfo sharedInstance].address = [dic objectForKey:@"address"];
            [UserInfo sharedInstance].city = [dic objectForKey:@"city"];
            [UserInfo sharedInstance].birthday = [dic objectForKey:@"birthday"];
            [UserInfo sharedInstance].province = [dic objectForKey:@"province"];
            [UserInfo sharedInstance].industrytype = [dic objectForKey:@"industrytype"];
            [UserInfo sharedInstance].department = [dic objectForKey:@"department"];
            [UserInfo sharedInstance].jposition = [dic objectForKey:@"jposition"];
            [UserInfo sharedInstance].telnumber = [dic objectForKey:@"telnumber"];
            [UserInfo sharedInstance].celnumber = [dic objectForKey:@"celnumber"];
            [UserInfo sharedInstance].headerimg = [dic objectForKey:@"headerimg"];
            if ([[dic objectForKey:@"result"] isEqualToString:@"success"]) {
                [self saveData];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                [_data release];
                _data = [[NSMutableData alloc] init];
                [self.toastLabel setText:[dic objectForKey:@"result"]];
                self.toastLabel.alpha = 1;
                dic = nil;
            }
        }
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [jsonData release];
    //[connection release];
}


-(IBAction)registerClick:(id)sender{
    [BAEditableCell stopEditing:self.loginView];
    RegisterView* registerView = [[RegisterView alloc] initWithNibName:@"RegisterView" bundle:nil];
    [self.navigationController pushViewController:registerView animated:YES];
    [registerView release];
}

-(IBAction)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textDidChange:(UITextField *)textField {
	if (textField.tag == 0) {
		self.userName = textField.text;
	} else if (textField.tag == 1) {
		self.passWord = textField.text;
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableViewA {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableViewA numberOfRowsInSection:(NSInteger)section {
	return 2;
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
		cell.textField.text = self.userName;
		cell.textField.secureTextEntry = NO;
		cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
		cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
		cell.textField.tag = indexPath.row;
	} else if (indexPath.row == 1) {
		cell.textLabel.text = @"密 码:";
		cell.detailTextLabel.text = nil;
		cell.textField.placeholder = @"请输入密码";
		cell.textField.text = self.passWord;
		cell.textField.secureTextEntry = YES;
		cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
		cell.textField.keyboardType = UIKeyboardTypeDefault;
		cell.textField.tag = indexPath.row;
	}
	return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self readData];
    _data = [[NSMutableData alloc] init];
}

@end
