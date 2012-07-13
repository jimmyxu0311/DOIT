//
//  SQLite3_Manager.h
//  DOIT
//
//  Created by AppDev on 11-12-13.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "/usr/include/sqlite3.h"

@interface SQLite3_Manager : NSObject{
    sqlite3* database;
}

//资讯数据库操作
-(int) insertInformation:(NSString*)articleID title:(NSString*)title summary:(NSString*)summary siteid:(NSString*)siteid;

-(int) deleteInformation:(NSString*)articleID;

-(int) selectInformation:(NSString*)articleID;

-(NSMutableArray*) queryInformation;

//资讯头部缓存数据库操作
-(int) insertInformationTop:(NSString *)articleID title:(NSString *)title summary:(NSString *)summary siteid:(NSString*)siteid pictrue:(NSString*)pictrue articleType:(NSString*)articleType;

-(int) deleteInformationTop;

-(int) selectInformationTop:(NSString *)articleID;

-(NSMutableArray*) queryInformationTop;

//资讯缓存数据库操作
-(int) insertInformationCache:(NSString *)articleID title:(NSString *)title summary:(NSString *)summary siteid:(NSString*)siteid pictrue:(NSString*)pictrue articleType:(NSString*)articleType type:(NSString*)type;

-(int) deleteInformationCache;

-(int) selectInformationCache:(NSString *)articleID type:(NSString*)type;

-(NSMutableArray*) queryInformationCache:(NSString*)type;

//资讯详细缓存数据库操作
-(int)selectInformationDetail:(NSString *)siteID;

-(int) insertInformationDetail:(NSString *)commentNum summary:(NSString *)summary content:(NSString *)content pageSize:(NSString*)pageSize siteid:(NSString*)siteid url:(NSString*)url;

-(int) deleteInformationDetail;

-(NSMutableArray*) queryInformationDetail:(NSString *)summary;

//帖子数据库操作
-(int) insertTip:(NSString*)tid title:(NSString*)title fid:(NSString*)fid;

-(int) deleteTip:(NSString*)tid;

-(int) deleteInformationDetail;

//-(int) selectTip:(NSString*)tid;
-(NSMutableArray*) queryTip;


@end
