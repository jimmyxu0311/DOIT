//
//  CommentListView.m
//  DOIT
//
//  Created by AppDev on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CommentListView.h"
#import "DOITUtil.h"
#import "CommendService.h"
#import "CommentViewCell.h"
#import "Commend.h"
#import "UserInfo.h"
#import "LoginView.h"

@implementation CommentListView
@synthesize listView;
@synthesize commentField;
@synthesize sendButton;
@synthesize backImage;
@synthesize siteid = _siteid;
@synthesize articleid = _articleid;
@synthesize userip = _userip;
@synthesize toastLabel;

static int pageIndex = 1;
static int pageSize = 20;
static float fieldY;
static float imgY;


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

-(IBAction)originalClick:(id)sender{
    pageIndex = 1;
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)publishClick:(id)sender{
    [self.commentField resignFirstResponder];
    NSString* sendContent = [[self.commentField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([sendContent length] > 0) {
        //self.sendButton.hidden = NO;
        if ([UserInfo sharedInstance].username != nil) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            NSString* sendRequest = [NSString stringWithFormat:@"%@article.post.comment.do?username=%@&siteid=%@&articleid=%@&content=%@&phoneip=%@",[DOITUtil getUrlBase],[UserInfo sharedInstance].username,_siteid,_articleid,sendContent,_userip];
            NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[sendRequest stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            NSURLConnection* theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            if (theConnection) {
                _data = [[NSMutableData data] retain];
            }else{
                
            }
        }else{
            LoginView* loginView = [[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
            [self.navigationController pushViewController:loginView animated:YES];
        }
    }else{
        self.toastLabel.text = @"回帖内容不能为空";
        [self performSelector:@selector(show) withObject:nil afterDelay:0];
        [self performSelector:@selector(hidden) withObject:nil afterDelay:1.0];
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
    [self performSelector:@selector(hidden) withObject:nil afterDelay:1.0];
    [jsonData release];
    [self.commentField setText:nil];
    [connection release];
    [_data release];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    commendListArray = [[NSMutableArray alloc] init];
    fieldY = self.commentField.frame.origin.y;
    imgY = self.backImage.frame.origin.y;
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    if ([commendListArray count] == 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSString* commendURL = [NSString stringWithFormat:@"%@article.show.list.do?actionType=comment&page=%d&requestNum=%d&siteId=%@&articleId=%@",[DOITUtil getUrlBase],pageIndex,pageSize,_siteid,_articleid];
        [NSThread detachNewThreadSelector:@selector(loadContent:) toTarget:self withObject:commendURL];
    }
}

-(void)loadContent:(NSString*)url{
    NSURL* requestURL = [NSURL URLWithString:url];
    NSArray* arr = [[CommendService getCommendArray:requestURL] retain];
    for (int i = 0; i < [arr count]; i++) {
        [commendListArray addObject:[arr objectAtIndex:i]];
    }
    [arr release];
    [self.listView reloadData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count = [commendListArray count] + 1;
    return count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath row] == [commendListArray count] + 1) {
        return 30;
    }
    return 50;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    if (row < [commendListArray count]) {
        static NSString *cellIndentifier = @"commendCell";
        CommentViewCell *cell = (CommentViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"CommentViewCell" owner:self options:nil];
            cell = (CommentViewCell *)[bundle objectAtIndex:0];
            
        }
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        Commend* commend = [commendListArray objectAtIndex:row];
        [cell setCell:commend.guestname time:commend.pubtime content:commend.content];
        return cell;
        
    }else{
        static NSString *cellIndentifier = @"cell";
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier] autorelease];
            
        }
        //[tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.text = @"查看更多";
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == [commendListArray count]) {
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        UITableViewCell* moreCell = [self.listView cellForRowAtIndexPath:indexPath];
        moreCell.textLabel.text = @"正在加载...";
        pageIndex++;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSString* commendURL = [NSString stringWithFormat:@"%@article.show.list.do?actionType=comment&page=%d&requestNum=%d&siteId=%@&articleId=%@",[DOITUtil getUrlBase],pageIndex,pageSize,_siteid,_articleid];
        [NSThread detachNewThreadSelector:@selector(loadContent:) toTarget:self withObject:commendURL];
    }
    [self.commentField resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil]; 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil]; 
}


- (void) keyboardWasShown:(NSNotification *) notif{ 
    NSDictionary *info = [notif userInfo]; 
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey]; 
    CGSize keyboardSize = [value CGRectValue].size; 
    [self.commentField setFrame:CGRectMake(self.commentField.frame.origin.x, fieldY - keyboardSize.height, self.commentField.frame.size.width, self.commentField.frame.size.height)];
    [self.sendButton setFrame:CGRectMake(self.sendButton.frame.origin.x, fieldY - keyboardSize.height, self.sendButton.frame.size.width, self.sendButton.frame.size.height)];
    [self.backImage setFrame:CGRectMake(self.backImage.frame.origin.x, imgY - keyboardSize.height, self.backImage.frame.size.width, self.backImage.frame.size.height)];

    keyboardWasShown = YES; 
} 

- (void) keyboardWasHidden:(NSNotification *) notif{ 
    [self.commentField setFrame:CGRectMake(self.commentField.frame.origin.x, fieldY, self.commentField.frame.size.width, self.commentField.frame.size.height)];
    [self.sendButton setFrame:CGRectMake(self.sendButton.frame.origin.x, fieldY, self.sendButton.frame.size.width, self.sendButton.frame.size.height)];
    [self.backImage setFrame:CGRectMake(self.backImage.frame.origin.x, imgY, self.backImage.frame.size.width, self.backImage.frame.size.height)];
    keyboardWasShown = NO; 
}


-(void)dealloc{
    [self.siteid release];
    [self.articleid release];
    [self.backImage release];
    [self.sendButton release];
    [self.commentField release];
    [self.listView release];
    [super dealloc];
}

@end
