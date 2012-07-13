//
//  SQLite3_Manager.m
//  DOIT
//
//  Created by AppDev on 11-12-13.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SQLite3_Manager.h"
#import "InformationSqlite.h"
#import "TipSqlite.h"
#import "Article.h"
#import "InformationDetail.h"

@implementation SQLite3_Manager

-(NSString*) paths{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *pathname = [path objectAtIndex:0];
	return [pathname stringByAppendingPathComponent:@"doit.sqlite"];
}

-(int) createInformationTable{
    sqlite3_open([[self paths] UTF8String], &database);
    const char* sql = "create table if not exists information(id integer primary key autoincrement,articleID text,title text,summary text,siteid text);";
    char* errorMsg;
    int success = sqlite3_exec(database, sql, NULL, NULL, &errorMsg);
    sqlite3_close(database);
    if (success == SQLITE_OK) 
        return 22;
    else
        return 33;
    
}

-(int) createTipTable{
    sqlite3_open([[self paths] UTF8String], &database);
    const char* sql = "create table if not exists tip(id integer primary key autoincrement,tid text,title text,fid text);";
    char* errorMsg;
    int success = sqlite3_exec(database, sql, NULL, NULL, &errorMsg);
    sqlite3_close(database);
    if (success == SQLITE_OK) 
        return 22;
    else
        return 33;

}

-(int) createInformationCacheTable{
    sqlite3_open([[self paths] UTF8String], &database);
    const char* sql = "create table if not exists informationcache(id integer primary key autoincrement,articleID text,title text,summary text,siteid text,pictrue text,articleType text,type text);";
    char* errorMsg;
    int success = sqlite3_exec(database, sql, NULL, NULL, &errorMsg);
    sqlite3_close(database);
    if (success == SQLITE_OK) 
        return 22;
    else
        return 33;
    
}

-(int) createInformationTop{
    sqlite3_open([[self paths] UTF8String], &database);
    const char* sql = "create table if not exists informationtop(id integer primary key autoincrement,articleID text,title text,summary text,siteid text,pictrue text,articleType text);";
    char* errorMsg;
    int success = sqlite3_exec(database, sql, NULL, NULL, &errorMsg);
    sqlite3_close(database);
    if (success == SQLITE_OK) 
        return 22;
    else
        return 33;
    
}

-(int) createInformationDetail{
    sqlite3_open([[self paths] UTF8String], &database);
    const char* sql = "create table if not exists informationDetail(id integer primary key autoincrement,commentNum text,summary text,content text,pageSize text,siteid text,url text);";
    char* errorMsg;
    int success = sqlite3_exec(database, sql, NULL, NULL, &errorMsg);
    sqlite3_close(database);
    if (success == SQLITE_OK) 
        return 22;
    else
        return 33;
    
}

-(int)selectInformation:(NSString *)articleID{
    if ([self createInformationTable] == 22) {
        sqlite3_open([[self paths] UTF8String], &database);
        NSString* sql = [NSString stringWithFormat:@"select * from information where articleID='%@'",articleID];
        sqlite3_stmt* statement = nil;
        int success = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
        int ids = -1;
        while (sqlite3_step(statement) == SQLITE_ROW) {
            ids = sqlite3_column_int(statement, 0);
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
        if (success == SQLITE_OK && ids > -1) 
            return 22;
        else
            return 33;
    }else{
        return 33;
    }

}

-(int)selectInformationCache:(NSString *)articleID type:(NSString*)type{
    if ([self createInformationTable] == 22) {
        sqlite3_open([[self paths] UTF8String], &database);
        NSString* sql = [NSString stringWithFormat:@"select * from informationcache where articleID='%@' and type='%@'",articleID,type];
        sqlite3_stmt* statement = nil;
        int success = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
        int ids = -1;
        while (sqlite3_step(statement) == SQLITE_ROW) {
            ids = sqlite3_column_int(statement, 0);
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
        if (success == SQLITE_OK && ids > -1) 
            return 22;
        else
            return 33;
    }else{
        return 33;
    }
    
}

-(int)selectInformationTop:(NSString *)articleID{
    if ([self createInformationTop] == 22) {
        sqlite3_open([[self paths] UTF8String], &database);
        NSString* sql = [NSString stringWithFormat:@"select * from informationtop where articleID='%@'",articleID];
        sqlite3_stmt* statement = nil;
        int success = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
        int ids = -1;
        while (sqlite3_step(statement) == SQLITE_ROW) {
            ids = sqlite3_column_int(statement, 0);
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
        if (success == SQLITE_OK && ids > -1) 
            return 22;
        else
            return 33;
    }else{
        return 33;
    }
    
}


-(int)selectInformationDetail:(NSString *)summary{
    if ([self createInformationDetail] == 22) {
        sqlite3_open([[self paths] UTF8String], &database);
        NSString* sql = [NSString stringWithFormat:@"select * from informationDetail where summary='%@'",summary];
        sqlite3_stmt* statement = nil;
        int success = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
        int ids = -1;
        while (sqlite3_step(statement) == SQLITE_ROW) {
            ids = sqlite3_column_int(statement, 0);
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
        if (success == SQLITE_OK && ids > -1) 
            return 22;
        else
            return 33;
    }else{
        return 33;
    }
    
}

-(int) insertInformation:(NSString *)articleID title:(NSString *)title summary:(NSString *)summary siteid:(NSString*)siteid{
    if ([self createInformationTable] == 22) {
        if ([self selectInformation:articleID] == 22) {
            return 44;
        }
        sqlite3_open([[self paths] UTF8String], &database);
        NSString* sql = [NSString stringWithFormat:@"INSERT INTO information(articleID,title,summary,siteid) VALUES('%@','%@','%@','%@')",articleID,title,summary,siteid];
        //sqlite3_stmt *statement;
        if(sqlite3_exec(database, [sql UTF8String], NULL, NULL, NULL) == SQLITE_OK) {
            sqlite3_close(database);
            return 22;
        }else
            sqlite3_close(database);
            return 33;
    }
    else{
        return 33;
    }
}

-(int) insertInformationCache:(NSString *)articleID title:(NSString *)title summary:(NSString *)summary siteid:(NSString*)siteid pictrue:(NSString*)pictrue articleType:(NSString*)articleType type:(NSString*)type{
    
    if ([self createInformationCacheTable] == 22) {
        if ([self selectInformationCache:articleID type:type] == 22) {
            return 44;
        }
        sqlite3_open([[self paths] UTF8String], &database);
        NSString* sql = [NSString stringWithFormat:@"INSERT INTO informationcache(articleID,title,summary,siteid,pictrue,articleType,type) VALUES('%@','%@','%@','%@','%@','%@','%@')",articleID,title,summary,siteid,pictrue,articleType,type];
        //sqlite3_stmt *statement;
        if(sqlite3_exec(database, [sql UTF8String], NULL, NULL, NULL) == SQLITE_OK) {
            sqlite3_close(database);
            return 22;
        }else
            sqlite3_close(database);
        return 33;
    }
    else{
        return 33;
    }

}

-(int) insertInformationTop:(NSString *)articleID title:(NSString *)title summary:(NSString *)summary siteid:(NSString*)siteid pictrue:(NSString*)pictrue articleType:(NSString*)articleType{
    
    if ([self createInformationTop] == 22) {
        if ([self selectInformationTop:articleID] == 22) {
            return 44;
        }
        sqlite3_open([[self paths] UTF8String], &database);
        NSString* sql = [NSString stringWithFormat:@"INSERT INTO informationtop(articleID,title,summary,siteid,pictrue,articleType) VALUES('%@','%@','%@','%@','%@','%@')",articleID,title,summary,siteid,pictrue,articleType];
        //sqlite3_stmt *statement;
        if(sqlite3_exec(database, [sql UTF8String], NULL, NULL, NULL) == SQLITE_OK) {
            sqlite3_close(database);
            return 22;
        }else
            sqlite3_close(database);
        return 33;
    }
    else{
        return 33;
    }
    
}


-(int) insertInformationDetail:(NSString *)commentNum summary:(NSString *)summary content:(NSString *)content pageSize:(NSString*)pageSize siteid:(NSString*)siteid url:(NSString*)url{
    
    if ([self createInformationDetail] == 22) {
        if ([self selectInformationDetail:summary] == 22) {
            return 44;
        }
        sqlite3_open([[self paths] UTF8String], &database);
        NSString* sql = [NSString stringWithFormat:@"INSERT INTO informationDetail(commentNum,summary,content,pageSize,siteid,url) VALUES('%@','%@','%@','%@','%@','%@')",commentNum,summary,content,pageSize,siteid,url];
        //sqlite3_stmt *statement;
        if(sqlite3_exec(database, [sql UTF8String], NULL, NULL, NULL) == SQLITE_OK) {
            sqlite3_close(database);
            return 22;
        }else
            sqlite3_close(database);
        return 33;
    }
    else{
        return 33;
    }
    
}

-(int) deleteInformation:(NSString*)articleID{
    if ([self createInformationTable] == 22) {
        sqlite3_open([[self paths] UTF8String], &database);
        NSString* sql = [NSString stringWithFormat:@"delete from information where articleID='%@'",articleID];
        char* errorMsg;
        int success = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg);
        sqlite3_close(database);
        if (success == SQLITE_OK) 
            return 22;
        else
            return 33;
    }else{
            return 33;
    }
}

-(int) deleteInformationCache{
    if ([self createInformationCacheTable] == 22) {
        sqlite3_open([[self paths] UTF8String], &database);
        NSString* sql = @"delete from informationcache";
        char* errorMsg;
        int success = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg);
        sqlite3_close(database);
        if (success == SQLITE_OK) 
            return 22;
        else
            return 33;
    }else{
        return 33;
    }
}

-(int) deleteInformationTop{
    if ([self createInformationCacheTable] == 22) {
        sqlite3_open([[self paths] UTF8String], &database);
        NSString* sql = @"delete from informationTop";
        char* errorMsg;
        int success = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg);
        sqlite3_close(database);
        if (success == SQLITE_OK) 
            return 22;
        else
            return 33;
    }else{
        return 33;
    }
}

-(int) deleteInformationDetail{
    if ([self createInformationDetail] == 22) {
        sqlite3_open([[self paths] UTF8String], &database);
        NSString* sql = @"delete from informationDetail";
        char* errorMsg;
        int success = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg);
        sqlite3_close(database);
        if (success == SQLITE_OK) 
            return 22;
        else
            return 33;
    }else{
        return 33;
    }
}

-(NSMutableArray*) queryInformationCache:(NSString*)type{
    NSMutableArray* array = [[[NSMutableArray alloc] init] autorelease];
    if ([self createInformationCacheTable] == 22) {
        sqlite3_open([[self paths] UTF8String], &database);
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM informationcache where type='%@'",type];
        sqlite3_stmt* statement;
        int success = (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL));
        //int ids = -1;
        while (sqlite3_step(statement) == SQLITE_ROW) {
            Article* information = [[Article alloc] init];            
            information.articleID = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            information.title = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            information.summary = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
            information.siteid = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
            information.pictrue = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding];
            information.articleType=[[NSString alloc] initWithCString:(char*)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
            [array addObject:information];
            [information release];
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
        if (success == SQLITE_OK) 
            return array;
        else
            return nil;
    }else
        return nil;
}

-(NSMutableArray*) queryInformationTop{
    NSMutableArray* array = [[[NSMutableArray alloc] init] autorelease];
    if ([self createInformationTop] == 22) {
        sqlite3_open([[self paths] UTF8String], &database);
        NSString* sql = @"SELECT * FROM informationtop";
        sqlite3_stmt* statement;
        int success = (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL));
        //int ids = -1;
        while (sqlite3_step(statement) == SQLITE_ROW) {
            Article* information = [[Article alloc] init];            
            information.articleID = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            information.title = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            information.summary = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
            information.siteid = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
            information.pictrue = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding];
            information.articleType=[[NSString alloc] initWithCString:(char*)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
            [array addObject:information];
            [information release];
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
        if (success == SQLITE_OK) 
            return array;
        else
            return nil;
    }else
        return nil;
}


-(NSMutableArray*) queryInformationDetail:(NSString*)summary{
    NSMutableArray* array = [[[NSMutableArray alloc] init] autorelease];
    if ([self createInformationCacheTable] == 22) {
        sqlite3_open([[self paths] UTF8String], &database);
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM informationDetail where summary='%@'",summary];
        sqlite3_stmt* statement;
        int success = (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL));
        //int ids = -1;
        while (sqlite3_step(statement) == SQLITE_ROW) {
            InformationDetail* information = [[InformationDetail alloc] init];            
            information.commentNum = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            information.summary = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            information.content = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
            information.pageSize = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
            information.siteID = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding];
            information.url = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
            [array addObject:information];
            [information release];
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
        if (success == SQLITE_OK) 
            return array;
        else
            return nil;
    }else
        return nil;
}

-(NSMutableArray*) queryInformation{
    NSMutableArray* array = [[[NSMutableArray alloc] init] autorelease];
    if ([self createInformationTable] == 22) {
        sqlite3_open([[self paths] UTF8String], &database);
        NSString* sql = [NSString stringWithString:@"SELECT * FROM information"];
        sqlite3_stmt* statement;
        int success = (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL));
        //int ids = -1;
        while (sqlite3_step(statement) == SQLITE_ROW) {
            InformationSqlite* information = [[InformationSqlite alloc] init];
            information.informationID = sqlite3_column_int(statement, 0);
            
            information.articleID = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            information.title = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            information.summary = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
            information.siteid = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
            [array addObject:information];
            [information release];
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
        if (success == SQLITE_OK) 
            return array;
        else
            return nil;
    }else
        return nil;
}

-(int)selectTip:(NSString *)tid{
    if ([self createTipTable] == 22) {
        sqlite3_open([[self paths] UTF8String], &database);
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM tip where tid=%@",tid];
        sqlite3_stmt* statement;
        int success = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
        int ids = -1;
        while (sqlite3_step(statement) == SQLITE_ROW) {
            ids = sqlite3_column_int(statement, 0);
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
        if (success == SQLITE_OK && ids > -1) 
            return 22;
        else
            return 33;
    }else{
        return 33;
    }
}


-(int)insertTip:(NSString *)tid title:(NSString *)title fid:(NSString *)fid{
    if ([self createTipTable] == 22) {
        if ([self selectTip:tid] == 22) {
            return 44;
        }
        sqlite3_open([[self paths] UTF8String], &database);
        NSString* sql = [NSString stringWithFormat:@"INSERT INTO tip(tid,title,fid) VALUES('%@','%@','%@')",tid,title,fid];
        //sqlite3_stmt *statement;
        if(sqlite3_exec(database, [sql UTF8String], NULL, NULL, NULL) == SQLITE_OK) {
            sqlite3_close(database);
            return 22;
        }
        else{
            sqlite3_close(database);
            return 33;
        }
    }
    else{
        return 33;
    }
}


-(int)deleteTip:(NSString *)tid{
    if ([self createInformationTable] == 22) {
        sqlite3_open([[self paths] UTF8String], &database);
        NSString* sql = [NSString stringWithFormat:@"delete from tip where tid=%@",tid];
        char* errorMsg;
        int success = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg);
        sqlite3_close(database);
        if (success == SQLITE_OK) 
            return 22;
        else
            return 33;
    }else{
        return 33;
    }
}


-(NSMutableArray*) queryTip{
    NSMutableArray* array = [[[NSMutableArray alloc] init] autorelease];
    if ([self createInformationTable] == 22) {
        sqlite3_open([[self paths] UTF8String], &database);
        NSString* sql = [NSString stringWithString:@"SELECT * FROM tip"];
        sqlite3_stmt* statement;
        int success = (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL));
        //int ids = -1;
        while (sqlite3_step(statement) == SQLITE_ROW) {
            TipSqlite* tip = [[TipSqlite alloc] init];
            tip.tipID = sqlite3_column_int(statement, 0);
           // NSLog(@"%s",sqlite3_column_text(statement, 1));
            tip.tid = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            tip.title = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            tip.bkid = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
            
            
            /*tip.tid =[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 1)];
            tip.title = [NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 2)];
            tip.bkid = [NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 3)];*/
            [array addObject:tip];
            [tip release];
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
        if (success == SQLITE_OK) 
            return array;
        else
            return nil;
    }else{
        return nil;
    }
}
@end
