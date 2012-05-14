//
//  SqlManager.m
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SqlManager.h"
#import "DDXML.h"

@implementation SqlManager

+ (id)sharedManager{
	//
	static id sharedManager = nil;
	if(sharedManager == nil){
		sharedManager = [[self alloc] init];
	}
	return sharedManager;
	//
}

- (id)init{
	if (self = [super init]) { 
		operationQueue=[[NSOperationQueue alloc]init];
		[operationQueue setMaxConcurrentOperationCount:2];
		lock=[[NSLock alloc]init];
		[self prepareDatabase];
        
		int n = sqlite3_open([databasePath UTF8String], &database);
		if(n != SQLITE_OK){
			NSLog(@"can not open the database");
			return self;
		}
	}
	return self;
}


- (NSString *)databaseFullPath{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *_databaseFullPath = [documentsDirectory stringByAppendingPathComponent:@"/Caches/JingYing.sqlite"];
    NSLog(@"_databaseFullPath:%@",_databaseFullPath);
	
	//strDatabasePath = [documentsDirectory stringByAppendingPathComponent:@"gtfund0.sqlite"];
	//strDatabasePath0 = [documentsDirectory stringByAppendingPathComponent:@"gtfund1.sqlite"];
	
	return _databaseFullPath;
}

- (BOOL)prepareDatabase{
	//
	//databaseName = @"Medical";
	
	BOOL result;
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
	databasePath = [self databaseFullPath];
	//databasePath = _databaseFullPath;
    
    result = [fileManager fileExistsAtPath:databasePath];
    NSLog(@"databasePath:%@,%d",databasePath,result);
	if (result){ 
		return result;
	}
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"JingYing.sqlite"];
    result = [fileManager fileExistsAtPath:defaultDBPath];
    NSLog(@"defaultDBPath:%@,%d",defaultDBPath,result);
	
	result = [fileManager copyItemAtPath:defaultDBPath toPath:databasePath error:&error];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    int temp= [fileManager createDirectoryAtPath:[documentsDirectory stringByAppendingPathComponent:@"/Caches/Host"] withIntermediateDirectories:YES attributes:nil error:&error];
    NSLog(@"%d",temp);
    
    NSString *str_configurePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Configure.xml"];
    NSArray *arr_docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [arr_docPaths objectAtIndex:0];
    result = [fileManager copyItemAtPath:str_configurePath toPath:[documentPath stringByAppendingPathComponent:@"Configure.xml"] error:&error];
    if (result == NO) {
        NSLog(@"%@",[error localizedDescription]);
    }
    
    [fileManager createDirectoryAtPath:[documentsDirectory stringByAppendingPathComponent:@"/Caches/Image"] withIntermediateDirectories:YES attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[documentsDirectory stringByAppendingPathComponent:@"/Caches/Topic"] withIntermediateDirectories:YES attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[documentsDirectory stringByAppendingPathComponent:@"/Caches/Image"] withIntermediateDirectories:YES attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[documentsDirectory stringByAppendingPathComponent:@"/Caches/Magazine"] withIntermediateDirectories:YES attributes:nil error:&error];
	
    if (!result) {
        //NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
		return NO;
    }else {
        return YES;
    }
}

#pragma mark -
#pragma mark charToString
//char转string
-(NSString *)charToString:(char *)c
{
	NSString *result = @"";
	if (c) {
		result = [NSString stringWithUTF8String:c];
	}
	return result;
}

#pragma mark -
#pragma mark saveDoc
-(BOOL)saveDoc:(NSData *)doc address:(NSString *)address
{
    BOOL result;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    result = [fileManager createFileAtPath:address contents:doc attributes:nil];
    return result;
}

#pragma mark -
#pragma mark sqlFunction

#pragma mark -
#pragma mark hotNews
-(NSArray *)getHotNewsList
{
    [lock lock];
    NSMutableArray *arr_result = [[NSMutableArray alloc] init];
    NSString *str_sqlOrder = @"select HN_createTime,HN_title,HN_summary,HN_class,HN_smallImgUrl,HN_largeImgUrl,HN_smallImgAddress,HN_largeImgAddress,HN_otherID,HN_isLastShow from tbl_hotNews order by HN_createTime desc";
    NSLog(@"str_sqlOrder:%@",str_sqlOrder);
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    NSString *str_detail = @"";
    NSMutableArray *arr_top = [[NSMutableArray alloc] init];
    NSMutableArray *arr_news = [[NSMutableArray alloc] init];
    while (code == SQLITE_ROW) {
		NSMutableDictionary *dic_news = [[NSMutableDictionary alloc] init];
        str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
		[dic_news setObject:str_detail forKey:@"createTime"];
		str_detail = [self charToString:sqlite3_column_text(stmt, 1)];
		[dic_news setObject:str_detail forKey:@"title"];
		str_detail = [self charToString:sqlite3_column_text(stmt, 2)];
		[dic_news setObject:str_detail forKey:@"summary"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 3)];
		[dic_news setObject:str_detail forKey:@"class"];
		str_detail = [self charToString:sqlite3_column_text(stmt, 4)];
		[dic_news setObject:str_detail forKey:@"smallImgUrl"];
		str_detail = [self charToString:sqlite3_column_text(stmt, 5)];
		[dic_news setObject:str_detail forKey:@"largeImgUrl"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 6)];
		[dic_news setObject:str_detail forKey:@"smallImgAddress"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 7)];
		[dic_news setObject:str_detail forKey:@"largeImgAddress"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 8)];
		[dic_news setObject:str_detail forKey:@"id"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 9)];
		[dic_news setObject:str_detail forKey:@"isLastShow"];
        if ([str_detail isEqualToString:@"1"]) {
            [arr_top addObject:dic_news];
        }
		else {
            [arr_news addObject:dic_news];
        }
        code = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    [arr_result addObject:arr_top];
    [arr_result addObject:arr_news];
    [lock unlock];
    return arr_result;
}

-(NSInteger)saveHotNewsList:(NSArray *)list isTopOrList:(NSString *)type
{
    [lock lock];
	NSDate *time = [NSDate date];
	NSDateFormatter *dateForm_time = [[NSDateFormatter alloc] init];
	[dateForm_time setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
	[dateForm_time setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *strTime = [dateForm_time stringFromDate:time];
    NSInteger result = 0;
    char *merror = nil;
	char *char_sqlOrder;
    NSString *str_sqlOrder = @"";
    if ([type isEqualToString:@"0"]) {
        str_sqlOrder = @"UPDATE tbl_hotNews SET HN_isLastShowTop = '0'";
    }
    else {
        str_sqlOrder = @"UPDATE tbl_hotNews SET HN_isLastShowList = '0'";
    }
    char_sqlOrder = (char *)[str_sqlOrder UTF8String];
    result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
    if(result != SQLITE_OK){
        NSLog(@"saveNewsList,Failed to updatelastshow,errorCode:%d",result);
    }
    for (int i = 0; i < [list count]; i++) {
        NSDictionary *dic_news = [list objectAtIndex:i];
        NSString *str_id = [dic_news objectForKey:@"id"];
        NSString *str_title = [dic_news objectForKey:@"title"];
        NSString *str_summary = [dic_news objectForKey:@"summary"];
        NSString *str_class = [dic_news objectForKey:@"class"];
        NSString *str_createTime = [dic_news objectForKey:@"createTime"];
        NSString *str_sImgUrl = [dic_news objectForKey:@"smallImgUrl"];
        NSString *str_lImgUrl = [dic_news objectForKey:@"largeImgUrl"];
        if ([type isEqualToString:@"0"]) {
            str_sqlOrder = [NSString stringWithFormat:@"select HN_createTime,HN_title,HN_summary,HN_class,HN_smallImgUrl,HN_largeImgUrl,HN_isLastShowTop from tbl_hotNews where HN_otherID = '%@' order by HN_createTime desc",str_id];
        }
        else {
            str_sqlOrder = [NSString stringWithFormat:@"select HN_createTime,HN_title,HN_summary,HN_class,HN_smallImgUrl,HN_largeImgUrl,HN_isLastShowList from tbl_hotNews where HN_otherID = '%@' order by HN_createTime desc",str_id];
        }
        char *sql = (char *)[str_sqlOrder UTF8String];
        sqlite3_stmt *stmt;
        sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
        int code = sqlite3_step(stmt);
        if (code == SQLITE_ROW) {
            NSString *str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
            if ([str_detail isEqualToString:str_createTime]) {
                
            }
            else {
                if ([type isEqualToString:@"0"]) {
                    str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_hotNews SET HN_createTime = '%@',HN_title = '%@',HN_summary = '%@',HN_class = '%@',HN_smallImgUrl = '%@',HN_largeImgUrl = '%@',HN_isReaded = '0',HN_isLastShowTop = '1' where HN_otherID = '%@'",str_createTime,str_title,str_summary,str_class,str_sImgUrl,str_lImgUrl ,str_id];
                }
                else {
                    str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_hotNews SET HN_createTime = '%@',HN_title = '%@',HN_summary = '%@',HN_class = '%@',HN_smallImgUrl = '%@',HN_largeImgUrl = '%@',HN_isReaded = '0',HN_isLastShowList = '1' where HN_otherID = '%@'",str_createTime,str_title,str_summary,str_class,str_sImgUrl,str_lImgUrl ,str_id];
                }
                char_sqlOrder = (char *)[str_sqlOrder UTF8String];
                result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
                if(result != SQLITE_OK){
                    NSLog(@"saveNewsList,Failed to update,errorCode:%d",result);
                }
            }
        }
        else
        {
            if ([type isEqualToString:@"0"]) {
                str_sqlOrder = [NSString stringWithFormat:@"insert into tbl_hotNews(HN_createTime,HN_title,HN_summary,HN_class,HN_smallImgUrl,HN_largeImgUrl,HN_otherID,HN_isReaded,HN_isLastShowTop) values('%@','%@','%@','%@','%@','%@','%@','0','1')",str_createTime,str_title,str_summary,str_class,str_sImgUrl,str_lImgUrl,str_id];
            }
            else {
                str_sqlOrder = [NSString stringWithFormat:@"insert into tbl_hotNews(HN_createTime,HN_title,HN_summary,HN_class,HN_smallImgUrl,HN_largeImgUrl,HN_otherID,HN_isReaded,HN_isLastShowList) values('%@','%@','%@','%@','%@','%@','%@','0','1')",str_createTime,str_title,str_summary,str_class,str_sImgUrl,str_lImgUrl,str_id];
            }
            char_sqlOrder = (char *)[str_sqlOrder UTF8String];
            result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
//            if (merror) {
//                NSLog(@"Failed to insert,errorCode:%d",result);
//                //NSLog(@"%@", [NSString stringWithCString:merror]);
//            }
            if(result != SQLITE_OK){
                NSLog(@"saveNewsList,Failed to insert,errorCode:%d,%@,%@",result,str_id,str_sqlOrder);
            }
        }
        sqlite3_finalize(stmt);
    }
	[lock unlock];
	return result;
}

-(void)initHotNewsLastShow
{
    NSInteger result = 0;
    char *merror = nil;
	char *char_sqlOrder;
    NSString *str_sqlOrder = @"UPDATE tbl_hotNews SET HN_isLastShow = '0'";
    char_sqlOrder = (char *)[str_sqlOrder UTF8String];
    result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
    if(result != SQLITE_OK){
        NSLog(@"initHotNewsLastShow,Failed to update,errorCode:%d",result);
    }
}

-(NSInteger)saveHotNewsListInfo:(NSDictionary *)dic_info isTopOrList:(NSString *)type
{
    [lock lock];
	NSDate *time = [NSDate date];
	NSDateFormatter *dateForm_time = [[NSDateFormatter alloc] init];
	[dateForm_time setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
	[dateForm_time setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *strTime = [dateForm_time stringFromDate:time];
    NSInteger result = 0;
    char *merror = nil;
	char *char_sqlOrder;
    NSString *str_sqlOrder = @"";
    NSString *str_id = [dic_info objectForKey:@"id"];
    NSString *str_title = [dic_info objectForKey:@"title"];
    NSString *str_summary = [dic_info objectForKey:@"summary"];
    NSString *str_class = [dic_info objectForKey:@"class"];
    NSString *str_createTime = [dic_info objectForKey:@"createTime"];
    NSString *str_sImgUrl = [dic_info objectForKey:@"smallImgUrl"];
    NSString *str_lImgUrl = [dic_info objectForKey:@"largeImgUrl"];
    str_sqlOrder = [NSString stringWithFormat:@"select HN_createTime,HN_title,HN_summary,HN_class,HN_smallImgUrl,HN_largeImgUrl,HN_isLastShow from tbl_hotNews where HN_otherID = '%@' order by HN_createTime desc",str_id];
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    if (code == SQLITE_ROW) {
        NSString *str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
        if ([str_detail isEqualToString:str_createTime]) {
            str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_hotNews SET HN_isLastShow = '1' where HN_otherID = '%@'",str_id];
            char_sqlOrder = (char *)[str_sqlOrder UTF8String];
            result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
            if(result != SQLITE_OK){
                NSLog(@"saveNewsList,Failed to update,errorCode:%d",result);
            }
            else {
                result = 101;
            }
        }
        else {
            if ([type isEqualToString:@"0"]) {
                str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_hotNews SET HN_createTime = '%@',HN_title = '%@',HN_summary = '%@',HN_class = '%@',HN_smallImgUrl = '%@',HN_largeImgUrl = '%@',HN_isReaded = '0',HN_isLastShow = '1' where HN_otherID = '%@'",str_createTime,str_title,str_summary,str_class,str_sImgUrl,str_lImgUrl ,str_id];
            }
            else {
                str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_hotNews SET HN_createTime = '%@',HN_title = '%@',HN_summary = '%@',HN_class = '%@',HN_smallImgUrl = '%@',HN_largeImgUrl = '%@',HN_isReaded = '0',HN_isLastShow = '0' where HN_otherID = '%@'",str_createTime,str_title,str_summary,str_class,str_sImgUrl,str_lImgUrl ,str_id];
            }
            char_sqlOrder = (char *)[str_sqlOrder UTF8String];
            result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
            if(result != SQLITE_OK){
                NSLog(@"saveNewsList,Failed to update,errorCode:%d",result);
            }
            else {
                result = 102;
            }
        }
    }
    else
    {
        if ([type isEqualToString:@"0"]) {
            str_sqlOrder = [NSString stringWithFormat:@"insert into tbl_hotNews(HN_createTime,HN_title,HN_summary,HN_class,HN_smallImgUrl,HN_largeImgUrl,HN_otherID,HN_isReaded,HN_isLastShow) values('%@','%@','%@','%@','%@','%@','%@','0','1')",str_createTime,str_title,str_summary,str_class,str_sImgUrl,str_lImgUrl,str_id];
        }
        else {
            str_sqlOrder = [NSString stringWithFormat:@"insert into tbl_hotNews(HN_createTime,HN_title,HN_summary,HN_class,HN_smallImgUrl,HN_largeImgUrl,HN_otherID,HN_isReaded,HN_isLastShow) values('%@','%@','%@','%@','%@','%@','%@','0','0')",str_createTime,str_title,str_summary,str_class,str_sImgUrl,str_lImgUrl,str_id];
        }
        char_sqlOrder = (char *)[str_sqlOrder UTF8String];
        result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
        //            if (merror) {
        //                NSLog(@"Failed to insert,errorCode:%d",result);
        //                //NSLog(@"%@", [NSString stringWithCString:merror]);
        //            }
        if(result != SQLITE_OK){
            NSLog(@"saveNewsList,Failed to insert,errorCode:%d,%@,%@",result,str_id,str_sqlOrder);
        }
        else {
            result = 103;
        }
    }
    sqlite3_finalize(stmt);
	[lock unlock];
	return result;
}


//0-大图 1-小图
-(BOOL)saveHotNewsImg:(NSString *)str_id imgAddress:(NSString *)imgAddress imgType:(int)imgType
{
    [lock lock];
    int result = 0;
    char *merror = nil;
    NSString *str_sqlOrder;
    if (imgType == 0) {
        str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_hotNews SET HN_largeImgAddress = '%@' where HN_otherID = '%@'",imgAddress ,str_id];
    }
    if (imgType == 1) {
        str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_hotNews SET HN_smallImgAddress = '%@' where HN_otherID = '%@'",imgAddress ,str_id];
    }
    char *char_sqlOrder = (char *)[str_sqlOrder UTF8String];
    result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
    if(result != SQLITE_OK){
        NSLog(@"saveNewsimg,Failed to update,errorCode:%d",result);
        NSLog(@"%@",str_sqlOrder);
        
    }
    [lock unlock];
    return result;
}

-(NSDictionary *)getNewsListWithID:(NSString *)newsID
{
    [lock lock];
    NSMutableDictionary *dic_result = [[NSMutableDictionary alloc] init];
    NSString *str_sqlOrder = [NSString stringWithFormat:@"select HN_createTime,HN_title,HN_summary,HN_class,HN_smallImgUrl,HN_largeImgUrl,HN_smallImgAddress,HN_largeImgAddress,HN_otherID from tbl_hotNews where HN_otherID = '%@'",newsID];
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    NSString *str_detail = @"";
    while (code == SQLITE_ROW) {
		NSMutableDictionary *dic_news = [[NSMutableDictionary alloc] init];
		str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
		[dic_result setObject:str_detail forKey:@"createTime"];
		str_detail = [self charToString:sqlite3_column_text(stmt, 1)];
		[dic_result setObject:str_detail forKey:@"title"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 2)];
		[dic_result setObject:str_detail forKey:@"summary"];
		str_detail = [self charToString:sqlite3_column_text(stmt, 3)];
		[dic_result setObject:str_detail forKey:@"class"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 4)];
		[dic_result setObject:str_detail forKey:@"smallImgUrl"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 5)];
		[dic_result setObject:str_detail forKey:@"largeImgUrl"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 6)];
		[dic_result setObject:str_detail forKey:@"smallImgAddress"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 7)];
		[dic_result setObject:str_detail forKey:@"largeImgAddress"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 8)];
		[dic_result setObject:str_detail forKey:@"id"];
        
        code = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    [lock unlock];
    return dic_result;
}

-(NSDictionary *)getNewsDetail:(NSString *)newsID
{
    [lock lock];
    NSMutableDictionary *dic_result = [[NSMutableDictionary alloc] init];
    NSString *str_sqlOrder = [NSString stringWithFormat:@"select HN_title,HN_contentImgAddress,HN_contentDetail,HN_isReaded,HN_contentImgUrl,HN_class,HN_url from tbl_hotNews where HN_otherID = '%@'",newsID];
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    NSString *str_detail = @"";
    while (code == SQLITE_ROW) {
		str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
		[dic_result setObject:str_detail forKey:@"contentTitle"];
		str_detail = [self charToString:sqlite3_column_text(stmt, 1)];
		[dic_result setObject:str_detail forKey:@"contentImgAddress"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 2)];
		[dic_result setObject:str_detail forKey:@"contentDetail"];
		str_detail = [self charToString:sqlite3_column_text(stmt, 3)];
		[dic_result setObject:str_detail forKey:@"isReaded"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 4)];
		[dic_result setObject:str_detail forKey:@"contentImgUrl"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 5)];
		[dic_result setObject:str_detail forKey:@"class"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 6)];
		[dic_result setObject:str_detail forKey:@"contentUrl"];
        code = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    [lock unlock];
    return dic_result;
}

-(BOOL)saveHotNewsDetail:(NSDictionary *)newsDetail
{
    [lock lock];
	NSDate *time = [NSDate date];
	NSDateFormatter *dateForm_time = [[NSDateFormatter alloc] init];
	[dateForm_time setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
	[dateForm_time setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *strTime = [dateForm_time stringFromDate:time];
	int result = 0;
    char *merror = nil;
	char *char_sqlOrder;
    NSString *str_id = [newsDetail objectForKey:@"id"];
    //NSLog(@"newsdetail:%@",newsDetail);
    NSString *str_sqlOrder = [NSString stringWithFormat:@"select HN_class from tbl_hotNews where HN_otherID = '%@'",str_id];
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    if (code == SQLITE_ROW) {
        NSString *str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
        if ([str_detail isEqualToString:@"1"]) {
            NSString *str_contentTitle = [newsDetail objectForKey:@"contentTitle"];
            NSString *str_contentImgAddress = [newsDetail objectForKey:@"contentImgAddress"];
            NSString *str_contentDetail = [newsDetail objectForKey:@"contentDetail"];
            NSString *str_contentImgUrl = [newsDetail objectForKey:@"contentImgUrl"];
            str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_hotNews SET HN_contentTitle = '%@',HN_contentImgUrl = '%@',HN_contentImgAddress = '%@',HN_contentDetail = '%@',HN_isReaded = '1' where HN_otherID = '%@'",str_contentTitle,str_contentImgUrl,str_contentImgAddress,str_contentDetail ,str_id];
            char_sqlOrder = (char *)[str_sqlOrder UTF8String];
            result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
            if(result != SQLITE_OK){
                NSLog(@"saveNewsDetail,Failed to update,errorCode:%d",result);
                [lock unlock];
                return result;
            }
        }
        else {
            NSString *str_url = [newsDetail objectForKey:@"url"];
            str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_hotNews SET HN_url = '%@'',HN_isReaded = '1' where HN_otherID = '%@'",str_url,str_id];
            char_sqlOrder = (char *)[str_sqlOrder UTF8String];
            result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
            if(result != SQLITE_OK){
                NSLog(@"saveNewsDetail,Failed to update,errorCode:%d",result);
                [lock unlock];
                return result;
            }
        }
        sqlite3_finalize(stmt);
    }
//    else
//    {
//        sqlite3_finalize(stmt);
//        str_sqlOrder = [NSString stringWithFormat:@"insert into tbl_hotNews(HN_contentTitle,HN_contentImgAddress,HN_contentDetail,HN_shouldRefresh) values('%@','%@','%@','1')",str_contentTitle,str_contentImgAddress,str_contentDetail];
//        char_sqlOrder = (char *)[str_sqlOrder UTF8String];
//        result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
////            if (merror) {
////                NSLog(@"Failed to insert,errorCode:%d",result);
////                //NSLog(@"%@", [NSString stringWithCString:merror]);
////            }
//        if(result != SQLITE_OK){
//            NSLog(@"saveNewsList,Failed to insert,errorCode:%d,%@,%@",result,str_id,str_sqlOrder);
//            [lock unlock];
//            return result;
//        }
//    }
	[lock unlock];
	return result;
}

-(void)deleteHotNews:(NSString *)str_id
{
    [lock lock];
    int result = 1;
    char *merror = nil;
    NSString *str_sqlOrder = [NSString stringWithFormat:@"select HN_smallImgAddress,HN_largeImgAddress,HN_contentImgAddress from tbl_hotNews where HN_otherID = '%@'",str_id];
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    NSString *str_detail = @"";
    if (code == SQLITE_ROW) {
        NSError *error = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
        if ([str_detail length] > 0) {
            [fileManager removeItemAtPath:str_detail error:&error];
        }
        str_detail = [self charToString:sqlite3_column_text(stmt, 1)];
        if ([str_detail length] > 0) {
            [fileManager removeItemAtPath:str_detail error:&error];
        }
        str_detail = [self charToString:sqlite3_column_text(stmt, 2)];
        if ([str_detail length] > 0) {
            [fileManager removeItemAtPath:str_detail error:&error];
        }
    }
    sqlite3_finalize(stmt);
    str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_hotNews SET HN_smallImgAddress = '',HN_largeImgAddress = '',HN_isReaded = '0',HN_contentImgAddress = '',HN_isLastShow = '1',HN_isEnabled = '1' where HN_otherID = '%@'",str_id];
    char *char_sqlOrder = (char *)[str_sqlOrder UTF8String];
    result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
    if(result != SQLITE_OK){
        NSLog(@"deleteHotNews,Failed to update,errorCode:%d",result);
        NSLog(@"%@",str_sqlOrder);
    }
    
    [lock unlock];
}

#pragma mark -
#pragma mark imglist

-(NSArray *)getImagesList
{
    [lock lock];
    NSMutableArray *arr_result = [[NSMutableArray alloc] init];
    NSString *str_sqlOrder = [NSString stringWithFormat:@"select IMG_isLastShow,IMG_title,IMG_createTime,IMG_smallImgAddress,IMG_largeImgAddress,IMG_smallImgUrl,IMG_largeImgUrl,IMG_summary,IMG_otherID from tbl_images order by IMG_createTime desc"];
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    NSString *str_detail = @"";
    while (code == SQLITE_ROW) {
        str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
        if ([str_detail isEqualToString:@"1"]) {
            
        }
        else {
            NSMutableDictionary *dic_news = [[NSMutableDictionary alloc] init];
            [dic_news setObject:str_detail forKey:@"isLastShow"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 1)];
            [dic_news setObject:str_detail forKey:@"title"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 2)];
            NSLog(@"createTime:%@",str_detail);
            [dic_news setObject:str_detail forKey:@"createTime"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 3)];
            [dic_news setObject:str_detail forKey:@"smallImgAddress"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 4)];
            [dic_news setObject:str_detail forKey:@"largeImgAddress"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 5)];
            [dic_news setObject:str_detail forKey:@"smallImgUrl"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 6)];
            [dic_news setObject:str_detail forKey:@"largeImgUrl"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 7)];
            [dic_news setObject:str_detail forKey:@"summary"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 8)];
            [dic_news setObject:str_detail forKey:@"id"];
            
            [arr_result addObject:dic_news];
        }
		
        code = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    [lock unlock];
    return arr_result;
}

-(NSArray *)getImagesTopList
{
    [lock lock];
    NSMutableArray *arr_result = [[NSMutableArray alloc] init];
    NSString *str_sqlOrder = [NSString stringWithFormat:@"select IMG_isLastShow,IMG_title,IMG_createTime,IMG_smallImgAddress,IMG_largeImgAddress,IMG_smallImgUrl,IMG_largeImgUrl,IMG_summary,IMG_otherID from tbl_images order by IMG_createTime desc"];
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    NSString *str_detail = @"";
    while (code == SQLITE_ROW) {
        str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
        if ([str_detail isEqualToString:@"1"]) {
            NSMutableDictionary *dic_news = [[NSMutableDictionary alloc] init];
            [dic_news setObject:str_detail forKey:@"isLastShow"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 1)];
            [dic_news setObject:str_detail forKey:@"title"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 2)];
            [dic_news setObject:str_detail forKey:@"createTime"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 3)];
            [dic_news setObject:str_detail forKey:@"smallImgAddress"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 4)];
            [dic_news setObject:str_detail forKey:@"largeImgAddress"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 5)];
            [dic_news setObject:str_detail forKey:@"smallImgUrl"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 6)];
            [dic_news setObject:str_detail forKey:@"largeImgUrl"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 7)];
            [dic_news setObject:str_detail forKey:@"summary"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 8)];
            [dic_news setObject:str_detail forKey:@"id"];
            [arr_result addObject:dic_news];
        }
        code = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    [lock unlock];
    return arr_result;
}

-(BOOL)saveImagesList:(NSArray *)list isTopOrList:(NSString *)type
{
    [lock lock];
	NSDate *time = [NSDate date];
	NSDateFormatter *dateForm_time = [[NSDateFormatter alloc] init];
	[dateForm_time setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
	[dateForm_time setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *strTime = [dateForm_time stringFromDate:time];
	int result = 0;
    char *merror = nil;
	char *char_sqlOrder;
    for (int i = 0; i < [list count]; i++) {
        NSDictionary *dic_news = [list objectAtIndex:i];
        NSString *str_id = [dic_news objectForKey:@"id"];
        NSString *str_title = [dic_news objectForKey:@"title"];
        NSString *str_summary = [dic_news objectForKey:@"summary"];
        NSString *str_createTime = [dic_news objectForKey:@"createTime"];
        NSString *str_sImgUrl = [dic_news objectForKey:@"smallImgUrl"];
        NSString *str_lImgUrl = [dic_news objectForKey:@"largeImgUrl"];
        NSString *str_sqlOrder = [NSString stringWithFormat:@"select IMG_createTime from tbl_images where IMG_otherID = '%@'",str_id];
        char *sql = (char *)[str_sqlOrder UTF8String];
        sqlite3_stmt *stmt;
        sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
        int code = sqlite3_step(stmt);
        if (code == SQLITE_ROW) {
            NSString *str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
            if ([str_detail isEqualToString:str_createTime]) {
                
            }
            else {
                if ([type isEqualToString:@"0"]) {
                    str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_images SET IMG_createTime = '%@',IMG_title = '%@',IMG_summary = '%@',IMG_smallImgUrl = '%@',IMG_largeImgUrl = '%@',IMG_isReaded = '0',IMG_isLastShow = '1' where IMG_otherID = '%@'",str_createTime,str_title,str_summary,str_sImgUrl,str_lImgUrl ,str_id];
                }
                else {
                    str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_images SET IMG_createTime = '%@',IMG_title = '%@',IMG_summary = '%@',IMG_smallImgUrl = '%@',IMG_largeImgUrl = '%@',IMG_isReaded = '0' where IMG_otherID = '%@'",str_createTime,str_title,str_summary,str_sImgUrl,str_lImgUrl ,str_id];
                }
            
                char_sqlOrder = (char *)[str_sqlOrder UTF8String];
                result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
                if(result != SQLITE_OK){
                    NSLog(@"saveNewsList,Failed to update,errorCode:%d",result);
                }
                sqlite3_finalize(stmt);
            }
        }
        else
        {
            sqlite3_finalize(stmt);
            if ([type isEqualToString:@"0"]) {
                str_sqlOrder = [NSString stringWithFormat:@"insert into tbl_images(IMG_otherID,IMG_createTime,IMG_title,IMG_summary,IMG_smallImgUrl,IMG_largeImgUrl,IMG_isReaded,IMG_isLastShow) values('%@','%@','%@','%@','%@','%@','0','1')",str_id,str_createTime,str_title,str_summary,str_sImgUrl,str_lImgUrl];
            }
            else {
                 str_sqlOrder = [NSString stringWithFormat:@"insert into tbl_images(IMG_otherID,IMG_createTime,IMG_title,IMG_summary,IMG_smallImgUrl,IMG_largeImgUrl,IMG_isReaded) values('%@','%@','%@','%@','%@','%@','0')",str_id,str_createTime,str_title,str_summary,str_sImgUrl,str_lImgUrl];
            }
            char_sqlOrder = (char *)[str_sqlOrder UTF8String];
            result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
            //            if (merror) {
            //                NSLog(@"Failed to insert,errorCode:%d",result);
            //                //NSLog(@"%@", [NSString stringWithCString:merror]);
            //            }
            if(result != SQLITE_OK){
                NSLog(@"saveNewsList,Failed to insert,errorCode:%d,%@,%@",result,str_id,str_sqlOrder);
            }
        }
    }
	[lock unlock];
	return result;
}

-(void)initImagesLastShow
{
    NSInteger result = 0;
    char *merror = nil;
	char *char_sqlOrder;
    NSString *str_sqlOrder = @"UPDATE tbl_images SET IMG_isLastShow = '0'";
    char_sqlOrder = (char *)[str_sqlOrder UTF8String];
    result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
    if(result != SQLITE_OK){
        NSLog(@"initImagesLastShow,Failed to update,errorCode:%d",result);
    }
}

-(NSDictionary *)getImageListWithID:(NSString *)imgID
{
    [lock lock];
    NSMutableDictionary *dic_result = [[NSMutableDictionary alloc] init];
    NSString *str_sqlOrder = [NSString stringWithFormat:@"select IMG_createTime,IMG_title,IMG_summary,IMG_smallImgUrl,IMG_largeImgUrl,IMG_smallImgAddress,IMG_largeImgAddress,IMG_isLastShow,IMG_isReaded from tbl_images where IMG_otherID = '%@'",imgID];
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    NSString *str_detail = @"";
    while (code == SQLITE_ROW) {
		NSMutableDictionary *dic_news = [[NSMutableDictionary alloc] init];
		str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
		[dic_result setObject:str_detail forKey:@"createTime"];
		str_detail = [self charToString:sqlite3_column_text(stmt, 1)];
		[dic_result setObject:str_detail forKey:@"title"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 2)];
		[dic_result setObject:str_detail forKey:@"summary"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 3)];
		[dic_result setObject:str_detail forKey:@"smallImgUrl"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 4)];
		[dic_result setObject:str_detail forKey:@"largeImgUrl"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 5)];
		[dic_result setObject:str_detail forKey:@"smallImgAddress"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 6)];
		[dic_result setObject:str_detail forKey:@"largeImgAddress"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 7)];
		[dic_result setObject:str_detail forKey:@"isLastShow"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 8)];
		[dic_result setObject:str_detail forKey:@"isReaded"];
        [dic_result setObject:imgID forKey:@"id"];
        code = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    [lock unlock];
    return dic_result;
}

-(NSInteger)saveImageListInfo:(NSDictionary *)dic_info isTopOrList:(NSString *)type
{
    [lock lock];
	NSDate *time = [NSDate date];
	NSDateFormatter *dateForm_time = [[NSDateFormatter alloc] init];
	[dateForm_time setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
	[dateForm_time setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *strTime = [dateForm_time stringFromDate:time];
	int result = 0;
    char *merror = nil;
	char *char_sqlOrder;
    NSString *str_id = [dic_info objectForKey:@"id"];
    NSString *str_title = [dic_info objectForKey:@"title"];
    NSString *str_summary = [dic_info objectForKey:@"summary"];
    NSString *str_createTime = [dic_info objectForKey:@"createTime"];
    NSString *str_sImgUrl = [dic_info objectForKey:@"smallImgUrl"];
    NSString *str_lImgUrl = [dic_info objectForKey:@"largeImgUrl"];
    NSString *str_sqlOrder = [NSString stringWithFormat:@"select IMG_createTime from tbl_images where IMG_otherID = '%@'",str_id];
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    if (code == SQLITE_ROW) {
        NSString *str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
        if ([str_detail isEqualToString:str_createTime]) {
            str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_images SET IMG_isLastShow = '1' where IMG_otherID = '%@'",str_id];
            
            char_sqlOrder = (char *)[str_sqlOrder UTF8String];
            result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
            if(result != SQLITE_OK){
                NSLog(@"saveNewsList,Failed to update,errorCode:%d",result);
            }
            else {
                result = 101;
            }
        }
        else {
            if ([type isEqualToString:@"0"]) {
                str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_images SET IMG_createTime = '%@',IMG_title = '%@',IMG_summary = '%@',IMG_smallImgUrl = '%@',IMG_largeImgUrl = '%@',IMG_isReaded = '0',IMG_isLastShow = '1',IMG_smallImgAddress = '',IMG_largeImgAddress = '' where IMG_otherID = '%@'",str_createTime,str_title,str_summary,str_sImgUrl,str_lImgUrl ,str_id];
            }
            else {
                str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_images SET IMG_createTime = '%@',IMG_title = '%@',IMG_summary = '%@',IMG_smallImgUrl = '%@',IMG_largeImgUrl = '%@',IMG_isReaded = '0',IMG_isLastShow = '0',IMG_smallImgAddress = '',IMG_largeImgAddress = '' where IMG_otherID = '%@'",str_createTime,str_title,str_summary,str_sImgUrl,str_lImgUrl ,str_id];
            }
            
            char_sqlOrder = (char *)[str_sqlOrder UTF8String];
            result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
            if(result != SQLITE_OK){
                NSLog(@"saveNewsList,Failed to update,errorCode:%d",result);
            }
            else {
                result = 102;
            }
            sqlite3_finalize(stmt);
        }
    }
    else
    {
        sqlite3_finalize(stmt);
        if ([type isEqualToString:@"0"]) {
            str_sqlOrder = [NSString stringWithFormat:@"insert into tbl_images(IMG_otherID,IMG_createTime,IMG_title,IMG_summary,IMG_smallImgUrl,IMG_largeImgUrl,IMG_isReaded,IMG_isLastShow) values('%@','%@','%@','%@','%@','%@','0','1')",str_id,str_createTime,str_title,str_summary,str_sImgUrl,str_lImgUrl];
        }
        else {
            str_sqlOrder = [NSString stringWithFormat:@"insert into tbl_images(IMG_otherID,IMG_createTime,IMG_title,IMG_summary,IMG_smallImgUrl,IMG_largeImgUrl,IMG_isReaded) values('%@','%@','%@','%@','%@','%@','0')",str_id,str_createTime,str_title,str_summary,str_sImgUrl,str_lImgUrl];
        }
        char_sqlOrder = (char *)[str_sqlOrder UTF8String];
        result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
        //            if (merror) {
        //                NSLog(@"Failed to insert,errorCode:%d",result);
        //                //NSLog(@"%@", [NSString stringWithCString:merror]);
        //            }
        if(result != SQLITE_OK){
            NSLog(@"saveNewsList,Failed to insert,errorCode:%d,%@,%@",result,str_id,str_sqlOrder);
        }
        else {
            result = 103;
        }
    }
	[lock unlock];
	return result;
}


//0-大图 1-小图
-(BOOL)saveImagesImg:(NSString *)str_id imgAddress:(NSString *)imgAddress imgType:(int)imgType
{
    [lock lock];
    int result = 0;
    char *merror = nil;
    NSString *str_sqlOrder;
    if (imgType == 0) {
        str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_images SET IMG_largeImgAddress = '%@' where IMG_otherID = '%@'",imgAddress ,str_id];
    }
    if (imgType == 1) {
        str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_images SET IMG_smallImgAddress = '%@' where IMG_otherID = '%@'",imgAddress ,str_id];
    }
    char *char_sqlOrder = (char *)[str_sqlOrder UTF8String];
    result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
    if(result != SQLITE_OK){
        NSLog(@"saveImgImg,Failed to update,errorCode:%d",result);
        NSLog(@"%@",str_sqlOrder);
    }
    [lock unlock];
    return result;
}

-(NSDictionary *)getImageDetail:(NSString *)newsID
{
    [lock lock];
    NSMutableDictionary *dic_result = [[NSMutableDictionary alloc] init];
    NSString *str_sqlOrder = [NSString stringWithFormat:@"select IMG_contentTitle,IMG_contentImgAddress,IMG_contentDetail,IMG_isReaded,IMG_contentImgUrl from tbl_images where IMG_otherID = '%@'",newsID];
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    NSString *str_detail = @"";
    while (code == SQLITE_ROW) {
		str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
		[dic_result setObject:str_detail forKey:@"contentTitle"];
		str_detail = [self charToString:sqlite3_column_text(stmt, 1)];
		[dic_result setObject:str_detail forKey:@"contentImgAddress"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 2)];
		[dic_result setObject:str_detail forKey:@"contentDetail"];
		str_detail = [self charToString:sqlite3_column_text(stmt, 3)];
		[dic_result setObject:str_detail forKey:@"isReaded"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 4)];
		[dic_result setObject:str_detail forKey:@"contentImgUrl"];
        code = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    [lock unlock];
    return dic_result;
}

-(BOOL)saveImageDetail:(NSDictionary *)newsDetail
{
    [lock lock];
	NSDate *time = [NSDate date];
	NSDateFormatter *dateForm_time = [[NSDateFormatter alloc] init];
	[dateForm_time setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
	[dateForm_time setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *strTime = [dateForm_time stringFromDate:time];
	int result = 0;
    char *merror = nil;
	char *char_sqlOrder;
    NSString *str_id = [newsDetail objectForKey:@"id"];
    
    NSString *str_contentTitle = [newsDetail objectForKey:@"contentTitle"];
    NSString *str_contentImgAddress = [newsDetail objectForKey:@"contentImgAddress"];
    NSString *str_contentDetail = [newsDetail objectForKey:@"contentDetail"];
    NSString *str_contentImgUrl = [newsDetail objectForKey:@"contentImgUrl"];
    NSString *str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_images SET IMG_contentTitle = '%@',IMG_contentImgUrl = '%@',IMG_contentImgAddress = '%@',IMG_contentDetail = '%@',IMG_isReaded = '1' where IMG_otherID = '%@'",str_contentTitle,str_contentImgUrl,str_contentImgAddress,str_contentDetail ,str_id];
    char_sqlOrder = (char *)[str_sqlOrder UTF8String];
    result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
    if(result != SQLITE_OK){
        NSLog(@"saveNewsDetail,Failed to update,errorCode:%d",result);
        [lock unlock];
        return result;
    }
	[lock unlock];
	return result;
}

-(NSInteger)getImagesUnreadedNumber
{
    [lock lock];
    NSInteger result = 0;
    NSString *str_sqlOrder = [NSString stringWithFormat:@"select * from tbl_images where IMG_isReaded = '1'"];
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    while (code == SQLITE_ROW) {
		result ++;
        code = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    [lock unlock];
    return result;
}

-(NSInteger)saveImageSeries:(NSDictionary *)dic_info ID:(NSString *)str_id
{
    [lock lock];
	NSDate *time = [NSDate date];
	NSDateFormatter *dateForm_time = [[NSDateFormatter alloc] init];
	[dateForm_time setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
	[dateForm_time setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *strTime = [dateForm_time stringFromDate:time];
	int result = 0;
    char *merror = nil;
	char *char_sqlOrder;
    
    NSString *str_contentTitle = [dic_info objectForKey:@"contentTitle"];
    NSString *str_smallImgUrl = [dic_info objectForKey:@"smallImgUrl"];
    NSString *str_contentDetail = [dic_info objectForKey:@"contentDetail"];
    NSString *str_largeImgUrl = [dic_info objectForKey:@"largeImgUrl"];
    NSString *str_imgID = [dic_info objectForKey:@"imgID"];
    NSString *str_sqlOrder = [NSString stringWithFormat:@"select * from tbl_imagesSeries where IS_otherID = '%@' and IS_imgID = '%@'",str_id,str_imgID];
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    if (code == SQLITE_ROW) {
        str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_imagesSeries SET IS_contentTitle = '%@',IS_smallImgUrl = '%@',IS_largeImgUrl = '%@',IS_contentDetail = '%@',IS_smallImgAddress = '',IS_largeImgAddress = '' where IS_otherID = '%@' and IS_imgID = '%@'",str_contentTitle,str_smallImgUrl,str_contentDetail,str_largeImgUrl ,str_id,str_imgID];
        char_sqlOrder = (char *)[str_sqlOrder UTF8String];
        result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
        if(result != SQLITE_OK){
            NSLog(@"saveNewsDetail,Failed to update,errorCode:%d",result);
        }
        else {
            result = 102;
            str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_images SET IMG_isReaded = '0' where IMG_otherID = '%@'",str_id];
            char_sqlOrder = (char *)[str_sqlOrder UTF8String];
            sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
        }
    }
    else {
        str_sqlOrder = [NSString stringWithFormat:@"insert into tbl_imagesSeries(IS_contentTitle,IS_contentDetail,IS_smallImgUrl,IS_largeImgUrl,IS_imgID,IS_otherID) values('%@','%@','%@','%@','%@','%@')",str_contentTitle,str_contentDetail,str_smallImgUrl,str_largeImgUrl,str_imgID,str_id];
        char_sqlOrder = (char *)[str_sqlOrder UTF8String];
        result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
        if(result != SQLITE_OK){
            NSLog(@"saveNewsList,Failed to insert,errorCode:%d,%@,%@",result,str_id,str_sqlOrder);
        }
        else {
            result = 103;
        }
    }
	[lock unlock];
	return result;
}

-(NSArray *)getImagesSeriesWithID:(NSString *)str_id
{
    [lock lock];
	NSMutableArray *arr_result = [[NSMutableArray alloc] init];
    
    NSString *str_sqlOrder = [NSString stringWithFormat:@"select IS_contentTitle,IS_contentDetail,IS_smallImgUrl,IS_smallImgAddress,IS_largeImgUrl,IS_largeImgAddress,IS_imgID from tbl_imagesSeries where IS_otherID = '%@'",str_id];
    char *char_sqlOrder = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, char_sqlOrder, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    NSString *str_detail = @"";
    while (code == SQLITE_ROW) {
		NSMutableDictionary *dic_news = [[NSMutableDictionary alloc] init];
		str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
		[dic_news setObject:str_detail forKey:@"contentTitle"];
		str_detail = [self charToString:sqlite3_column_text(stmt, 1)];
		[dic_news setObject:str_detail forKey:@"contentDetail"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 2)];
		[dic_news setObject:str_detail forKey:@"smallImgUrl"];
		str_detail = [self charToString:sqlite3_column_text(stmt, 3)];
		[dic_news setObject:str_detail forKey:@"smallImgAddress"];
		str_detail = [self charToString:sqlite3_column_text(stmt, 4)];
		[dic_news setObject:str_detail forKey:@"largeImgUrl"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 5)];
		[dic_news setObject:str_detail forKey:@"largeImgAddress"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 6)];
		[dic_news setObject:str_detail forKey:@"imgID"];
        code = sqlite3_step(stmt);
        [arr_result addObject:dic_news];
    }
    sqlite3_finalize(stmt);
	[lock unlock];
	return arr_result;
}

-(NSDictionary *)getImagesSeriesWithID:(NSString *)str_id imgID:(NSString *)str_imgID
{
    [lock lock];
	NSMutableDictionary *dic_result = [[NSMutableDictionary alloc] init];
    
    NSString *str_sqlOrder = [NSString stringWithFormat:@"select IS_contentTitle,IS_contentDetail,IS_smallImgUrl,IS_smallImgAddress,IS_largeImgUrl,IS_largeImgAddress from tbl_imagesSeries where IS_otherID = '%@' and IS_imgID = '%@'",str_id,str_imgID];
    char *char_sqlOrder = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, char_sqlOrder, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    NSString *str_detail = @"";
    while (code == SQLITE_ROW) {
		str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
		[dic_result setObject:str_detail forKey:@"contentTitle"];
		str_detail = [self charToString:sqlite3_column_text(stmt, 1)];
		[dic_result setObject:str_detail forKey:@"contentDetail"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 2)];
		[dic_result setObject:str_detail forKey:@"smallImgUrl"];
		str_detail = [self charToString:sqlite3_column_text(stmt, 3)];
		[dic_result setObject:str_detail forKey:@"smallImgAddress"];
		str_detail = [self charToString:sqlite3_column_text(stmt, 4)];
		[dic_result setObject:str_detail forKey:@"largeImgUrl"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 5)];
		[dic_result setObject:str_detail forKey:@"largeImgAddress"];
        [dic_result setObject:str_imgID forKey:@"imgID"];
        code = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
	[lock unlock];
	return dic_result;
}

-(BOOL)saveImagesSeriesImg:(NSString *)str_id imgAddress:(NSString *)imgAddress imgType:(int)imgType imgID:(NSString *)str_imgID
{
    [lock lock];
    int result = 0;
    char *merror = nil;
    NSString *str_sqlOrder;
    if (imgType == 0) {
        str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_imagesSeries SET IS_largeImgAddress = '%@' where IS_otherID = '%@' and IS_imgID = '%@'",imgAddress ,str_id,str_imgID];
    }
    if (imgType == 1) {
        str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_imagesSeries SET IS_smallImgAddress = '%@' where IS_otherID = '%@' and IS_imgID = '%@'",imgAddress ,str_id,str_imgID];
    }
    char *char_sqlOrder = (char *)[str_sqlOrder UTF8String];
    result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
    if(result != SQLITE_OK){
        NSLog(@"saveImgImg,Failed to update,errorCode:%d",result);
        NSLog(@"%@",str_sqlOrder);
    }
    str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_images SET IMG_isReaded = '1' where IMG_otherID = '%@'",str_id];
    char_sqlOrder = (char *)[str_sqlOrder UTF8String];
    sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
    [lock unlock];
    return result;
}

-(void)deleteImage:(NSString *)str_id
{
    [lock lock];
    int result = 1;
    char *merror = nil;
    NSString *str_sqlOrder = [NSString stringWithFormat:@"select IMG_smallImgAddress,IMG_largeImgAddress from tbl_images where IMG_otherID = '%@'",str_id];
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    NSString *str_detail = @"";
    if (code == SQLITE_ROW) {
        NSError *error = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
        if ([str_detail length] > 0) {
            [fileManager removeItemAtPath:str_detail error:&error];
        }
        str_detail = [self charToString:sqlite3_column_text(stmt, 1)];
        if ([str_detail length] > 0) {
            [fileManager removeItemAtPath:str_detail error:&error];
        }
    }
    sqlite3_finalize(stmt);
    str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_hotNews SET HN_smallImgAddress = '',HN_largeImgAddress = '',HN_isReaded = '0',HN_contentImgAddress = '',HN_isLastShow = '1',HN_isEnabled = '1' where HN_otherID = '%@'",str_id];
    char *char_sqlOrder = (char *)[str_sqlOrder UTF8String];
    result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
    if(result != SQLITE_OK){
        NSLog(@"deleteImage,Failed to update,errorCode:%d",result);
        NSLog(@"%@",str_sqlOrder);
    }
    
    str_sqlOrder = [NSString stringWithFormat:@"select IS_smallImgAddress,IMG_largeImgAddress from tbl_imagesSeries where IS_otherID = '%@'",str_id];
    sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    code = sqlite3_step(stmt);
    while(code == SQLITE_ROW) {
        NSError *error = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
        if ([str_detail length] > 0) {
            [fileManager removeItemAtPath:str_detail error:&error];
        }
        str_detail = [self charToString:sqlite3_column_text(stmt, 1)];
        if ([str_detail length] > 0) {
            [fileManager removeItemAtPath:str_detail error:&error];
        }
    }
    sqlite3_finalize(stmt);
    str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_imagesSeries SET IS_smallImgAddress = '',IS_largeImgAddress = '',IS_isEnabled = '1' where IS_otherID = '%@'",str_id];
    char_sqlOrder = (char *)[str_sqlOrder UTF8String];
    result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
    if(result != SQLITE_OK){
        NSLog(@"deleteImage,Failed to update,errorCode:%d",result);
        NSLog(@"%@",str_sqlOrder);
    }
    
    [lock unlock];
}

#pragma mark -
#pragma mark topiclist

-(NSArray *)getTopicList
{
    [lock lock];
    NSMutableArray *arr_result = [[NSMutableArray alloc] init];
    NSString *str_sqlOrder = [NSString stringWithFormat:@"select TPC_title,TPC_class,TPC_createTime,TPC_imgAddress,TPC_summary,TPC_otherID,TPC_isReaded,TPC_imgUrl,TPC_fatherID from tbl_topic where TPC_isLastShow = '1' order by TPC_createTime desc"];
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    NSString *str_detail = @"";
    NSMutableArray *arr_engine = [[NSMutableArray alloc] init];
    NSMutableArray *arr_ontheway = [[NSMutableArray alloc] init];
    NSMutableArray *arr_view = [[NSMutableArray alloc] init];
    NSMutableArray *arr_acceraltion = [[NSMutableArray alloc] init];
    while (code == SQLITE_ROW) {
		NSMutableDictionary *dic_news = [[NSMutableDictionary alloc] init];
		str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
		[dic_news setObject:str_detail forKey:@"title"];
		str_detail = [self charToString:sqlite3_column_text(stmt, 1)];
		[dic_news setObject:str_detail forKey:@"class"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 2)];
		[dic_news setObject:str_detail forKey:@"createTime"];
		str_detail = [self charToString:sqlite3_column_text(stmt, 3)];
		[dic_news setObject:str_detail forKey:@"smallImgAddress"];
		str_detail = [self charToString:sqlite3_column_text(stmt, 4)];
		[dic_news setObject:str_detail forKey:@"summary"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 5)];
		[dic_news setObject:str_detail forKey:@"id"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 6)];
		[dic_news setObject:str_detail forKey:@"isReaded"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 7)];
		[dic_news setObject:str_detail forKey:@"smallImgUrl"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 8)];
		[dic_news setObject:str_detail forKey:@"fatherID"];
        switch ([str_detail intValue]) {
            case 0:
            {
                [arr_engine addObject:dic_news];
            }
                break;
            case 1:
            {
                [arr_ontheway addObject:dic_news];
            }
                break;
            case 2:
            {
                [arr_view addObject:dic_news];
            }
                break;
            case 3:
            {
                [arr_acceraltion addObject:dic_news];
            }
                break;
            default:
                break;
        }
        code = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    [arr_result addObject:arr_engine];
    [arr_result addObject:arr_ontheway];
    [arr_result addObject:arr_view];
    [arr_result addObject:arr_acceraltion];
    [lock unlock];
    return arr_result;
}

-(NSArray *)getTopicListWithFatherID:(NSString *)fatherID
{
    [lock lock];
    NSMutableArray *arr_result = [[NSMutableArray alloc] init];
    NSString *str_sqlOrder = [NSString stringWithFormat:@"select TPC_fatherID,TPC_title,TPC_class,TPC_createTime,TPC_imgAddress,TPC_summary,TPC_otherID,TPC_isReaded,TPC_imgUrl from tbl_topic where TPC_isLastShow = '1' order by TPC_createTime desc"];
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    NSString *str_detail = @"";
    while (code == SQLITE_ROW) {
		NSMutableDictionary *dic_news = [[NSMutableDictionary alloc] init];
        str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
        if ([str_detail isEqualToString:fatherID]) {
            [dic_news setObject:str_detail forKey:@"fatherID"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 1)];
            [dic_news setObject:str_detail forKey:@"title"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 2)];
            [dic_news setObject:str_detail forKey:@"class"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 3)];
            [dic_news setObject:str_detail forKey:@"createTime"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 4)];
            [dic_news setObject:str_detail forKey:@"smallImgAddress"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 5)];
            [dic_news setObject:str_detail forKey:@"summary"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 6)];
            [dic_news setObject:str_detail forKey:@"id"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 7)];
            [dic_news setObject:str_detail forKey:@"isReaded"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 8)];
            [dic_news setObject:str_detail forKey:@"smallImgUrl"];
            [arr_result addObject:dic_news];
        }
        code = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    [lock unlock];
    return arr_result;
}

-(BOOL)saveTopicList:(NSArray *)list
{
    [lock lock];
	NSDate *time = [NSDate date];
	NSDateFormatter *dateForm_time = [[NSDateFormatter alloc] init];
	[dateForm_time setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
	[dateForm_time setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *strTime = [dateForm_time stringFromDate:time];
	int result = 0;
    char *merror = nil;
	char *char_sqlOrder;
    for (int i = 0; i < [list count]; i++) {
        NSDictionary *dic_news = [list objectAtIndex:i];
        NSString *str_id = [dic_news objectForKey:@"id"];
        NSString *str_title = [dic_news objectForKey:@"title"];
        NSString *str_summary = [dic_news objectForKey:@"summary"];
        NSString *str_class = [dic_news objectForKey:@"class"];
        NSString *str_createTime = [dic_news objectForKey:@"createTime"];
        NSString *str_imgUrl = [dic_news objectForKey:@"smallImgUrl"];
        NSString *str_fatherID = [dic_news objectForKey:@"fatherID"];
        NSString *str_sqlOrder = [NSString stringWithFormat:@"select TPC_createTime from tbl_topic where TPC_otherID = '%@'",str_id];
        char *sql = (char *)[str_sqlOrder UTF8String];
        sqlite3_stmt *stmt;
        sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
        int code = sqlite3_step(stmt);
        if (code == SQLITE_ROW) {
            NSString *str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
            sqlite3_finalize(stmt);
            if ([str_detail isEqualToString:str_createTime]) {
                
            }
            else {
                str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_topic SET TPC_createTime = '%@',TPC_title = '%@',TPC_summary = '%@',TPC_class = '%@',TPC_imgUrl = '%@',TPC_fatherID = '%@',TPC_shouldRefresh = '0',TPC_isReaded = '0' where TPC_otherID = '%@'",str_createTime,str_title,str_summary,str_class,str_imgUrl ,str_fatherID,str_id];
                char_sqlOrder = (char *)[str_sqlOrder UTF8String];
                result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
                if(result != SQLITE_OK){
                    NSLog(@"saveTopicList,Failed to update,errorCode:%d,%@",result,str_sqlOrder);
                }
            }
        }
        else
        {
            sqlite3_finalize(stmt);
            str_sqlOrder = [NSString stringWithFormat:@"insert into tbl_topic(TPC_createTime,TPC_title,TPC_summary,TPC_class,TPC_imgUrl,TPC_otherID,TPC_fatherID,TPC_shouldRefresh,TPC_isReaded) values('%@','%@','%@','%@','%@','%@','%@','0','0')",str_createTime,str_title,str_summary,str_class,str_imgUrl,str_id,str_fatherID];
            char_sqlOrder = (char *)[str_sqlOrder UTF8String];
            result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
            //            if (merror) {
            //                NSLog(@"Failed to insert,errorCode:%d",result);
            //                //NSLog(@"%@", [NSString stringWithCString:merror]);
            //            }
            if(result != SQLITE_OK){
                NSLog(@"saveTopicList,Failed to insert,errorCode:%d,%@,%@",result,str_id,str_sqlOrder);
            }
        }
    }
	[lock unlock];
	return result;
}

-(void)initTopicLastShow
{
    NSInteger result = 0;
    char *merror = nil;
	char *char_sqlOrder;
    NSString *str_sqlOrder = @"UPDATE tbl_topic SET TPC_isLastShow = '0'";
    char_sqlOrder = (char *)[str_sqlOrder UTF8String];
    result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
    if(result != SQLITE_OK){
        NSLog(@"initTopicLastShow,Failed to update,errorCode:%d",result);
    }
}

-(NSInteger)saveTopicInfo:(NSDictionary *)dic_info
{
    [lock lock];
	NSDate *time = [NSDate date];
	NSDateFormatter *dateForm_time = [[NSDateFormatter alloc] init];
	[dateForm_time setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
	[dateForm_time setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *strTime = [dateForm_time stringFromDate:time];
	int result = 0;
    char *merror = nil;
	char *char_sqlOrder;
    NSString *str_id = [dic_info objectForKey:@"id"];
    NSString *str_title = [dic_info objectForKey:@"title"];
    NSString *str_summary = [dic_info objectForKey:@"summary"];
    NSString *str_class = [dic_info objectForKey:@"class"];
    NSString *str_createTime = [dic_info objectForKey:@"createTime"];
    NSString *str_imgUrl = [dic_info objectForKey:@"smallImgUrl"];
    NSString *str_fatherID = [dic_info objectForKey:@"fatherID"];
    NSString *str_sqlOrder = [NSString stringWithFormat:@"select TPC_createTime from tbl_topic where TPC_otherID = '%@'",str_id];
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    if (code == SQLITE_ROW) {
        NSString *str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
        sqlite3_finalize(stmt);
        if ([str_detail isEqualToString:str_createTime]) {
            str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_topic SET TPC_isLastShow = '1' where TPC_otherID = '%@'",str_id];
            char_sqlOrder = (char *)[str_sqlOrder UTF8String];
            result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
            if(result != SQLITE_OK){
                NSLog(@"saveTopicList,Failed to update,errorCode:%d,%@",result,str_sqlOrder);
            }
            else {
                result = 101;
            }
        }
        else {
            str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_topic SET TPC_createTime = '%@',TPC_title = '%@',TPC_summary = '%@',TPC_class = '%@',TPC_imgUrl = '%@',TPC_fatherID = '%@',TPC_shouldRefresh = '0',TPC_isReaded = '0',TPC_isLastShow = '1' where TPC_otherID = '%@'",str_createTime,str_title,str_summary,str_class,str_imgUrl ,str_fatherID,str_id];
            char_sqlOrder = (char *)[str_sqlOrder UTF8String];
            result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
            if(result != SQLITE_OK){
                NSLog(@"saveTopicList,Failed to update,errorCode:%d,%@",result,str_sqlOrder);
            }
            else {
                result = 102;
            }
        }
    }
    else
    {
        sqlite3_finalize(stmt);
        str_sqlOrder = [NSString stringWithFormat:@"insert into tbl_topic(TPC_createTime,TPC_title,TPC_summary,TPC_class,TPC_imgUrl,TPC_otherID,TPC_fatherID,TPC_shouldRefresh,TPC_isReaded,TPC_isLastShow) values('%@','%@','%@','%@','%@','%@','%@','0','0','1')",str_createTime,str_title,str_summary,str_class,str_imgUrl,str_id,str_fatherID];
        char_sqlOrder = (char *)[str_sqlOrder UTF8String];
        result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
        //            if (merror) {
        //                NSLog(@"Failed to insert,errorCode:%d",result);
        //                //NSLog(@"%@", [NSString stringWithCString:merror]);
        //            }
        if(result != SQLITE_OK){
            NSLog(@"saveTopicList,Failed to insert,errorCode:%d,%@,%@",result,str_id,str_sqlOrder);
        }
        else {
            result = 103;
        }
    }
	[lock unlock];
	return result;
}

-(NSDictionary *)getTopicListWithID:(NSString *)topicID
{
    [lock lock];
    NSMutableDictionary *dic_result = [[NSMutableDictionary alloc] init];
    NSString *str_sqlOrder = [NSString stringWithFormat:@"select TPC_fatherID,TPC_createTime,TPC_title,TPC_summary,TPC_class,TPC_imgUrl,TPC_imgAddress,TPC_shouldRefresh,TPC_isReaded,TPC_contentImgAddress,TPC_contentTitle,TPC_contentDetail from tbl_topic where TPC_otherID = '%@'",topicID];
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    NSString *str_detail = @"";
    while (code == SQLITE_ROW) {
		NSMutableDictionary *dic_news = [[NSMutableDictionary alloc] init];
        str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
		[dic_result setObject:str_detail forKey:@"fatherID"];
		str_detail = [self charToString:sqlite3_column_text(stmt, 1)];
		[dic_result setObject:str_detail forKey:@"createTime"];
		str_detail = [self charToString:sqlite3_column_text(stmt, 2)];
		[dic_result setObject:str_detail forKey:@"title"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 3)];
		[dic_result setObject:str_detail forKey:@"summary"];
		str_detail = [self charToString:sqlite3_column_text(stmt, 4)];
		[dic_result setObject:str_detail forKey:@"class"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 5)];
		[dic_result setObject:str_detail forKey:@"smallImgUrl"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 6)];
		[dic_result setObject:str_detail forKey:@"smallImgAddress"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 7)];
		[dic_result setObject:str_detail forKey:@"shouldRefresh"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 8)];
		[dic_result setObject:str_detail forKey:@"isReaded"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 9)];
		[dic_result setObject:str_detail forKey:@"contentImgAddress"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 10)];
		[dic_result setObject:str_detail forKey:@"contentTitle"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 11)];
		[dic_result setObject:str_detail forKey:@"contentDetail"];
        [dic_result setObject:topicID forKey:@"id"];
        
        code = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    [lock unlock];
    return dic_result;
}

-(BOOL)saveTopicImage:(NSString *)str_id imgAddress:(NSString *)imgAddress
{
    [lock lock];
    int result = 0;
    char *merror = nil;
    NSString *str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_topic SET TPC_imgAddress = '%@',TPC_shouldRefresh = '1' where TPC_otherID = '%@'",imgAddress ,str_id];
    char *char_sqlOrder = (char *)[str_sqlOrder UTF8String];
    result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
    if(result != SQLITE_OK){
        NSLog(@"saveTopicImg,Failed to update,errorCode:%d",result);
        NSLog(@"%@",str_sqlOrder);
    }
    [lock unlock];
    return result;
}

-(BOOL)saveTopicDetail:(NSDictionary *)newsDetail
{
    [lock lock];
	NSDate *time = [NSDate date];
	NSDateFormatter *dateForm_time = [[NSDateFormatter alloc] init];
	[dateForm_time setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
	[dateForm_time setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *strTime = [dateForm_time stringFromDate:time];
	int result = 0;
    char *merror = nil;
	char *char_sqlOrder;
    NSString *str_id = [newsDetail objectForKey:@"id"];
    
    NSString *str_sqlOrder = [NSString stringWithFormat:@"select TPC_class from tbl_topic where TPC_otherID = '%@'",str_id];
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    if (code == SQLITE_ROW) {
        NSString *str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
        sqlite3_finalize(stmt);
        if ([str_detail isEqualToString:@"1"]) {
            NSString *str_contentTitle = [newsDetail objectForKey:@"contentTitle"];
            NSString *str_contentImgAddress = [newsDetail objectForKey:@"contentImgAddress"];
            NSString *str_contentDetail = [newsDetail objectForKey:@"contentDetail"];
            NSString *str_contentImgUrl = [newsDetail objectForKey:@"contentImgUrl"];
            str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_topic SET TPC_contentTitle = '%@',TPC_contentImgUrl = '%@',TPC_contentImgAddress = '%@',TPC_contentDetail = '%@',TPC_isReaded = '1' where TPC_otherID = '%@'",str_contentTitle,str_contentImgUrl,str_contentImgAddress,str_contentDetail ,str_id];
            char_sqlOrder = (char *)[str_sqlOrder UTF8String];
            result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
            if(result != SQLITE_OK){
                NSLog(@"saveNewsDetail,Failed to update,errorCode:%d,%@",result,str_sqlOrder);
                [lock unlock];
                return result;
            }
        }
        else {
            NSString *str_url = [newsDetail objectForKey:@"url"];
            str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_topic SET TPC_url = '%@'',TPC_isReaded = '1' where TPC_otherID = '%@'",str_url,str_id];
            char_sqlOrder = (char *)[str_sqlOrder UTF8String];
            result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
            if(result != SQLITE_OK){
                NSLog(@"saveNewsDetail,Failed to update,errorCode:%d",result);
                [lock unlock];
                return result;
            }
        }
    }
    //    else
    //    {
    //        sqlite3_finalize(stmt);
    //        str_sqlOrder = [NSString stringWithFormat:@"insert into tbl_hotNews(HN_contentTitle,HN_contentImgAddress,HN_contentDetail,HN_shouldRefresh) values('%@','%@','%@','1')",str_contentTitle,str_contentImgAddress,str_contentDetail];
    //        char_sqlOrder = (char *)[str_sqlOrder UTF8String];
    //        result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
    ////            if (merror) {
    ////                NSLog(@"Failed to insert,errorCode:%d",result);
    ////                //NSLog(@"%@", [NSString stringWithCString:merror]);
    ////            }
    //        if(result != SQLITE_OK){
    //            NSLog(@"saveNewsList,Failed to insert,errorCode:%d,%@,%@",result,str_id,str_sqlOrder);
    //            [lock unlock];
    //            return result;
    //        }
    //    }
	[lock unlock];
	return result;
}

-(NSInteger)getTopicsUnreadedNumber
{
    [lock lock];
    NSInteger result = 0;
    NSString *str_sqlOrder = [NSString stringWithFormat:@"select * from tbl_topic where TPC_isReaded = '1'"];
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    while (code == SQLITE_ROW) {
		result ++;
        code = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    [lock unlock];
    return result;
}

-(void)deleteTopic:(NSString *)str_id
{
    [lock lock];
    int result = 1;
    char *merror = nil;
    NSString *str_sqlOrder = [NSString stringWithFormat:@"select TPC_imgAddress,TPC_contentImgAddress from tbl_topic where TPC_otherID = '%@'",str_id];
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    NSString *str_detail = @"";
    if (code == SQLITE_ROW) {
        NSError *error = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
        if ([str_detail length] > 0) {
            [fileManager removeItemAtPath:str_detail error:&error];
        }
        str_detail = [self charToString:sqlite3_column_text(stmt, 1)];
        if ([str_detail length] > 0) {
            [fileManager removeItemAtPath:str_detail error:&error];
        }
    }
    sqlite3_finalize(stmt);
    str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_topic SET TPC_imgAddress = '',TPC_isReaded = '0',TPC_contentImgAddress = '',TPC_isLastShow = '1',TPC_isEnabled = '1' where TPC_otherID = '%@'",str_id];
    char *char_sqlOrder = (char *)[str_sqlOrder UTF8String];
    result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
    if(result != SQLITE_OK){
        NSLog(@"deleteTopic,Failed to update,errorCode:%d",result);
        NSLog(@"%@",str_sqlOrder);
    }
    
    [lock unlock];
}

#pragma mark -
#pragma mark collection
-(NSInteger)addMyCollectionWithFatherID:(NSString *)str_fatherID childID:(NSString *)str_childID
{
    [lock lock];
    int result;
    char *merror = nil;
    NSString *str_sqlOrder = [NSString stringWithFormat:@"select MC_isEnabled from tbl_myCollection where MC_fatherID = '%@' and MC_childID = '%@'",str_fatherID,str_childID];
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    char *char_sqlOrder;
    if (code == SQLITE_ROW) {
        NSLog(@"str_sqlOrder:%@",str_sqlOrder);
        NSString *str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
        if ([str_detail isEqualToString:@"0"]) {
            [lock unlock];
            return 1;
        }
        else {
            str_sqlOrder = [NSString stringWithFormat:@"update tbl_myCollection set MC_isEnabled = '0' where MC_childID = '%@'",str_childID];
            char_sqlOrder = (char *)[str_sqlOrder UTF8String];
            result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
            if(result != SQLITE_OK){
                NSLog(@"addMyCollectionWithFatherID,Failed to update,errorCode:%d",result);
            }
            [lock unlock];
            return result;
        }
    }
    str_sqlOrder = [NSString stringWithFormat:@"insert into tbl_myCollection(MC_fatherID,MC_childID) values('%@','%@')",str_fatherID,str_childID];
    char_sqlOrder = (char *)[str_sqlOrder UTF8String];
    result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
//            if (merror) {
//                NSLog(@"Failed to insert,errorCode:%d",result);
//                //NSLog(@"%@", [NSString stringWithCString:merror]);
//            }
    if(result != SQLITE_OK){
        NSLog(@"saveTopicList,Failed to insert,errorCode:%d,%@",result,str_sqlOrder);
    }
    
    [lock unlock];
    return result;
}

-(NSArray *)getCollectionList
{
    [lock lock];
    NSMutableArray *arr_result = [[NSMutableArray alloc] init];
    char *merror = nil;
    NSString *str_sqlOrder = [NSString stringWithFormat:@"select MC_fatherID,MC_childID from tbl_myCollection where MC_isEnabled = '0'"];
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    NSString *str_detail = @"";
    while(code == SQLITE_ROW) {
        NSMutableDictionary *dic_collection = [[NSMutableDictionary alloc] init];
        str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
		[dic_collection setObject:str_detail forKey:@"fatherID"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 1)];
		[dic_collection setObject:str_detail forKey:@"childID"];
        [arr_result addObject:dic_collection];
        code = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    [lock unlock];
    return arr_result;
}

-(NSInteger)isCollected:(NSString *)str_id
{
    [lock lock];
    int result = 0;
    char *merror = nil;
    NSString *str_sqlOrder = [NSString stringWithFormat:@"select * from tbl_myCollection where MC_childID = '%@' and MC_isEnabled = '0'",str_id];
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    if (code == SQLITE_ROW) {
        result = 1;
    }
    sqlite3_finalize(stmt);
    [lock unlock];
    return result;
}

-(NSInteger)deleteCollection:(NSString *)str_id
{
    [lock lock];
    int result = 0;
    char *merror = nil;
    NSString *str_sqlOrder = [NSString stringWithFormat:@"update tbl_myCollection set MC_isEnabled = '1' where MC_childID = '%@'",str_id];
    char *char_sqlOrder = (char *)[str_sqlOrder UTF8String];
    result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
    if(result != SQLITE_OK){
        NSLog(@"deleteCollection,Failed to update,errorCode:%d",result);
    }
    [lock unlock];
    return result;
}

#pragma mark -
#pragma mark magzine
-(NSInteger)saveMagazineList:(NSArray *)list
{
    [lock lock];
	NSDate *time = [NSDate date];
	NSDateFormatter *dateForm_time = [[NSDateFormatter alloc] init];
	[dateForm_time setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
	[dateForm_time setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *strTime = [dateForm_time stringFromDate:time];
	int result = 0;
    char *merror = nil;
	char *char_sqlOrder;
    for (int i = 0; i < [list count]; i++) {
        NSDictionary *dic_news = [list objectAtIndex:i];
        NSString *str_id = [dic_news objectForKey:@"id"];
        NSString *str_title = [dic_news objectForKey:@"title"];
        NSString *str_createTime = [dic_news objectForKey:@"createTime"];
        NSString *str_imgUrl = [dic_news objectForKey:@"coverImgUrl"];
        NSString *str_url = [dic_news objectForKey:@"url"];
        NSString *str_summary = [dic_news objectForKey:@"summary"];
        NSString *str_sqlOrder = [NSString stringWithFormat:@"select * from tbl_magazine where MGZ_otherID = '%@'",str_id];
        char *sql = (char *)[str_sqlOrder UTF8String];
        sqlite3_stmt *stmt;
        sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
        int code = sqlite3_step(stmt);
        if (code == SQLITE_ROW) {
//            NSString *str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
//            NSLog(@"str_detail:%@",str_detail);
//            sqlite3_finalize(stmt);
//            if ([str_detail isEqualToString:str_createTime]) {
//                
//            }
//            else {
//                str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_magazine SET MGZ_createTime = '%@',MGZ_title = '%@',MGZ_coverImgUrl = '%@',MGZ_url = '%@',MGZ_isReaded = '0' where MGZ_otherID = '%@'",str_createTime,str_title,str_imgUrl ,str_url,str_id];
//                char_sqlOrder = (char *)[str_sqlOrder UTF8String];
//                result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
//                if(result != SQLITE_OK){
//                    NSLog(@"saveTopicList,Failed to update,errorCode:%d",result);
//                }
//            }
        }
        else
        {
            sqlite3_finalize(stmt);
            NSString *str_sqlOrder = [NSString stringWithFormat:@"insert into tbl_magazine(MGZ_title,MGZ_coverImgUrl,MGZ_url,MGZ_isReaded,MGZ_otherID,MGZ_createTime,MGZ_summary) values('%@','%@','%@','0','%@','%@','%@')",str_title,str_imgUrl,str_url,str_id,str_createTime,str_summary];
            char_sqlOrder = (char *)[str_sqlOrder UTF8String];
            result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
//            if (merror) {
//                NSLog(@"Failed to insert,errorCode:%d",result);
//                //NSLog(@"%@", [NSString stringWithCString:merror]);
//            }
            if(result != SQLITE_OK){
                NSLog(@"saveTopicList,Failed to insert,errorCode:%d,%@,%@",result,str_id,str_sqlOrder);
            }
        }
    }
	[lock unlock];
	return result;
}

-(NSInteger)saveMagazineItem:(NSDictionary *)dic_info
{
    [lock lock];
	NSDate *time = [NSDate date];
	NSDateFormatter *dateForm_time = [[NSDateFormatter alloc] init];
	[dateForm_time setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
	[dateForm_time setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *strTime = [dateForm_time stringFromDate:time];
	int result = 0;
    char *merror = nil;
	char *char_sqlOrder;

    NSString *str_id = [dic_info objectForKey:@"id"];
    NSString *str_title = [dic_info objectForKey:@"title"];
    NSString *str_createTime = [dic_info objectForKey:@"createTime"];
    NSString *str_imgUrl = [dic_info objectForKey:@"coverImgUrl"];
    NSString *str_url = [dic_info objectForKey:@"url"];
    NSString *str_summary = [dic_info objectForKey:@"summary"];
    NSString *str_sqlOrder = [NSString stringWithFormat:@"select MGZ_createTime from tbl_magazine where MGZ_otherID = '%@' and MGZ_isEnabled = '0'",str_id];
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    NSString *str_detail = @"";
    if (code == SQLITE_ROW) {
        str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
        if ([str_detail isEqualToString:str_createTime]) {
            result = 101;
        }
        else {
            str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_magazine SET MGZ_createTime = '%@',MGZ_title = '%@',MGZ_summary = '%@',MGZ_coverImgUrl = '%@',MGZ_url = '%@',MGZ_isReaded = '0',MGZ_coverImgAddress = '',MGZ_address = '' where MGZ_otherID = '%@'",str_createTime,str_title,str_summary,str_imgUrl ,str_url,str_id];
            char_sqlOrder = (char *)[str_sqlOrder UTF8String];
            result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
            if(result != SQLITE_OK){
                NSLog(@"saveMagazineItem,Failed to update,errorCode:%d,%@",result,str_sqlOrder);
            }
            else {
                result = 102;
            }
        }
    }
    else
    {
        sqlite3_finalize(stmt);
        NSString *str_sqlOrder = [NSString stringWithFormat:@"insert into tbl_magazine(MGZ_title,MGZ_coverImgUrl,MGZ_url,MGZ_isReaded,MGZ_otherID,MGZ_createTime,MGZ_summary) values('%@','%@','%@','0','%@','%@','%@')",str_title,str_imgUrl,str_url,str_id,str_createTime,str_summary];
        char_sqlOrder = (char *)[str_sqlOrder UTF8String];
        result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
        //            if (merror) {
        //                NSLog(@"Failed to insert,errorCode:%d",result);
        //                //NSLog(@"%@", [NSString stringWithCString:merror]);
        //            }
        if(result != SQLITE_OK){
            NSLog(@"saveTopicList,Failed to insert,errorCode:%d,%@,%@",result,str_id,str_sqlOrder);
        }
        else {
            result = 103;
        }
    }
	[lock unlock];
	return result;
}

-(NSArray *)getMagazineList
{
    [lock lock];
    NSMutableArray *arr_result = [[NSMutableArray alloc] init];
    NSString *str_sqlOrder = @"select MGZ_title,MGZ_summary,MGZ_coverImgUrl,MGZ_url,MGZ_isReaded,MGZ_coverImgAddress,MGZ_address,MGZ_createTime,MGZ_otherID from tbl_magazine where MGZ_isEnabled = '0' order by MGZ_createTime";
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    NSString *str_detail = @"";
    while (code == SQLITE_ROW) {
        NSMutableDictionary *dic_result = [[NSMutableDictionary alloc] init];
		str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
		[dic_result setObject:str_detail forKey:@"title"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 1)];
		[dic_result setObject:str_detail forKey:@"summary"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 2)];
		[dic_result setObject:str_detail forKey:@"coverImgUrl"];
		str_detail = [self charToString:sqlite3_column_text(stmt, 3)];
		[dic_result setObject:str_detail forKey:@"url"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 4)];
		[dic_result setObject:str_detail forKey:@"isReaded"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 5)];
		[dic_result setObject:str_detail forKey:@"coverImgAddress"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 6)];
		[dic_result setObject:str_detail forKey:@"address"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 7)];
		[dic_result setObject:str_detail forKey:@"createTime"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 8)];
        [dic_result setObject:str_detail forKey:@"id"];
        if ([arr_result count] == 0) {
            [arr_result addObject:dic_result];
        }
        else {
            [arr_result insertObject:dic_result atIndex:0];
        }
        code = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    [lock unlock];
    return arr_result;
}

-(BOOL)saveMagezineCover:(NSString *)str_id imgAddress:(NSString *)str_address
{
    [lock lock];
    int result = 0;
    char *merror = nil;
    NSString *str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_magazine SET MGZ_coverImgAddress = '%@' where MGZ_otherID = '%@'",str_address ,str_id];
    char *char_sqlOrder = (char *)[str_sqlOrder UTF8String];
    result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
    if(result != SQLITE_OK){
        NSLog(@"saveCoverImg,Failed to update,errorCode:%d",result);
        NSLog(@"%@",str_sqlOrder);
    }
    [lock unlock];
    return result;
}

-(BOOL)saveMagezine:(NSString *)str_id magazineAddress:(NSString *)str_address
{
    [lock lock];
    int result = 0;
    char *merror = nil;
    NSString *str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_magazine SET MGZ_address = '%@' where MGZ_otherID = '%@'",str_address ,str_id];
    char *char_sqlOrder = (char *)[str_sqlOrder UTF8String];
    result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
    if(result != SQLITE_OK){
        NSLog(@"saveMagazine,Failed to update,errorCode:%d",result);
        NSLog(@"%@",str_sqlOrder);
    }
    [lock unlock];
    return result;
}

-(NSDictionary *)getMagazineInfoWithID:(NSString *)magazineID
{
    [lock lock];
    NSMutableDictionary *dic_result = [[NSMutableDictionary alloc] init];
    NSString *str_sqlOrder = [NSString stringWithFormat:@"select MGZ_title,MGZ_summary,MGZ_coverImgUrl,MGZ_url,MGZ_isReaded,MGZ_coverImgAddress,MGZ_address,MGZ_createTime from tbl_magazine where MGZ_otherID = '%@'",magazineID];
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    NSString *str_detail = @"";
    while (code == SQLITE_ROW) {
		str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
		[dic_result setObject:str_detail forKey:@"title"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 1)];
		[dic_result setObject:str_detail forKey:@"summary"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 2)];
		[dic_result setObject:str_detail forKey:@"coverImgUrl"];
		str_detail = [self charToString:sqlite3_column_text(stmt, 3)];
		[dic_result setObject:str_detail forKey:@"url"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 4)];
		[dic_result setObject:str_detail forKey:@"isReaded"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 5)];
		[dic_result setObject:str_detail forKey:@"coverImgAddress"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 6)];
		[dic_result setObject:str_detail forKey:@"address"];
        str_detail = [self charToString:sqlite3_column_text(stmt, 7)];
		[dic_result setObject:str_detail forKey:@"createTime"];
        [dic_result setObject:magazineID forKey:@"id"];
        
        code = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    [lock unlock];
    return dic_result;
}

-(NSArray *)getDownloadedMagazineList
{
    [lock lock];
    NSMutableArray *arr_result = [[NSMutableArray alloc] init];
    NSString *str_sqlOrder = @"select MGZ_address,MGZ_title,MGZ_summary,MGZ_coverImgUrl,MGZ_url,MGZ_isReaded,MGZ_coverImgAddress,MGZ_createTime,MGZ_otherID from tbl_magazine";
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    NSString *str_detail = @"";
    while (code == SQLITE_ROW) {
        str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
        if ([str_detail length] > 0) {
            NSMutableDictionary *dic_info = [[NSMutableDictionary alloc] init];
            [dic_info setObject:str_detail forKey:@"address"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 1)];
            [dic_info setObject:str_detail forKey:@"title"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 2)];
            [dic_info setObject:str_detail forKey:@"summary"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 3)];
            [dic_info setObject:str_detail forKey:@"coverImgUrl"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 4)];
            [dic_info setObject:str_detail forKey:@"url"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 5)];
            [dic_info setObject:str_detail forKey:@"isReaded"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 6)];
            [dic_info setObject:str_detail forKey:@"coverImgAddress"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 7)];
            [dic_info setObject:str_detail forKey:@"createTime"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 8)];
            [dic_info setObject:str_detail forKey:@"id"];
            [arr_result addObject:dic_info];
        }
        code = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    [lock unlock];
    return arr_result;
}

-(NSArray *)getUndownloadedMagazineList
{
    [lock lock];
    NSMutableArray *arr_result = [[NSMutableArray alloc] init];
    NSString *str_sqlOrder = @"select MGZ_address,MGZ_title,MGZ_summary,MGZ_coverImgUrl,MGZ_url,MGZ_isReaded,MGZ_coverImgAddress,MGZ_createTime,MGZ_otherID from tbl_magazine";
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    NSString *str_detail = @"";
    while (code == SQLITE_ROW) {
        str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
        if ([str_detail length] == 0) {
            NSMutableDictionary *dic_info = [[NSMutableDictionary alloc] init];
            [dic_info setObject:str_detail forKey:@"address"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 1)];
            [dic_info setObject:str_detail forKey:@"title"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 2)];
            [dic_info setObject:str_detail forKey:@"summary"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 3)];
            [dic_info setObject:str_detail forKey:@"coverImgUrl"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 4)];
            [dic_info setObject:str_detail forKey:@"url"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 5)];
            [dic_info setObject:str_detail forKey:@"isReaded"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 6)];
            [dic_info setObject:str_detail forKey:@"coverImgAddress"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 7)];
            [dic_info setObject:str_detail forKey:@"createTime"];
            str_detail = [self charToString:sqlite3_column_text(stmt, 8)];
            [dic_info setObject:str_detail forKey:@"id"];
            [arr_result addObject:dic_info];
        }
        code = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    [lock unlock];
    return arr_result;
}

-(NSInteger)deleteMagazine:(NSString *)str_id
{
    [lock lock];
    int result = 1;
    char *merror = nil;
    NSString *str_sqlOrder = [NSString stringWithFormat:@"select MGZ_address from tbl_magazine where MGZ_otherID = '%@'",str_id];
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    NSString *str_detail = @"";
    if (code == SQLITE_ROW) {
        str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
        sqlite3_finalize(stmt);
    }
    if ([str_detail length] > 0) {
        NSError *error = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager removeItemAtPath:str_detail error:&error] == YES) {
            NSString *str_sqlOrder = [NSString stringWithFormat:@"UPDATE tbl_magazine SET MGZ_address = '',MGZ_isReaded = '0' where MGZ_otherID = '%@'",str_id];
            char *char_sqlOrder = (char *)[str_sqlOrder UTF8String];
            result = sqlite3_exec(database, char_sqlOrder, 0, 0,&merror);
            if(result != SQLITE_OK){
                NSLog(@"saveMagazine,Failed to update,errorCode:%d",result);
                NSLog(@"%@",str_sqlOrder);
            }
        }
    }
    else {
        result = 0;
    }
    
    [lock unlock];
    return result;
}


#pragma mark -
#pragma mark readConfigure
-(NSDictionary *)readConfigure
{
    NSArray *arr_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *str_path = [[arr_paths objectAtIndex:0] stringByAppendingPathComponent:@"Configure.xml"];
    NSError *error = nil;
    NSString *str_configure = [NSString stringWithContentsOfFile:str_path encoding:NSUTF8StringEncoding error:&error];
    DDXMLDocument* xmlDoc = [[DDXMLDocument alloc] initWithXMLString:str_configure options:0 error:&error];
    if (error) {
        NSLog(@"%@",[error localizedDescription]);
    }
    NSMutableDictionary *dic_result = [[NSMutableDictionary alloc] init];
    NSArray *arr_configures = [xmlDoc nodesForXPath:@"//Configure" error:&error];
    for (DDXMLElement *element_configure in arr_configures) {
        NSArray *arr_fontSize = [element_configure elementsForName:@"FontSize"];
        NSString *str_fontSize = [[arr_fontSize objectAtIndex:0] stringValue];
        NSArray *arr_bufferTime = [element_configure elementsForName:@"BufferTime"];
        NSString *str_bufferTime = [[arr_bufferTime objectAtIndex:0] stringValue];
        [dic_result setObject:str_fontSize forKey:@"fontSize"];
        [dic_result setObject:str_bufferTime forKey:@"bufferTime"];
    }
    return dic_result;
}

-(BOOL)saveConfigure:(NSDictionary *)dic_parameter
{
    NSLog(@"%@",dic_parameter);
    BOOL result = NO;
    NSString *str_fontSize = [dic_parameter objectForKey:@"fontSize"];
    NSString *str_bufferTime = [dic_parameter objectForKey:@"bufferTime"];
    DDXMLNode *node_fontSize = [DDXMLNode elementWithName:@"FontSize" stringValue:str_fontSize];
    DDXMLNode *node_bufferTime = [DDXMLNode elementWithName:@"BufferTime" stringValue:str_bufferTime];
    NSArray *arr_configure = [[NSArray alloc] initWithObjects:node_fontSize,node_bufferTime,nil];
    DDXMLElement *element_configure = [[DDXMLElement alloc] initWithName: @"Configure"];
    [element_configure setChildren:arr_configure];
    NSString *str_configure = [element_configure XMLString];
    NSData *data_configure = [str_configure dataUsingEncoding:NSUTF8StringEncoding];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *arr_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *str_path = [[arr_paths objectAtIndex:0] stringByAppendingPathComponent:@"Configure.xml"];
    result = [fileManager createFileAtPath:str_path contents:data_configure attributes:nil];
    return result;
}

-(void)emptyBuffer:(int)time
{
    int bufferTime = 0;
    switch (time) {
        case 0:
        {
            bufferTime = 0;
        }
            break;
        case 1:
        {
            bufferTime = 24*60*60;
        }
            break;
        case 2:
        {
            bufferTime = 24*60*60*7;
        }
            break;
        case 3:
        {
            bufferTime = 24*60*60*30;
        }
            break;
        case 4:
        {
            bufferTime = -1;
            return;
        }
            break;
        default:
            break;
    }
    [lock lock];
    NSMutableArray *arr_item = [[NSMutableArray alloc] init];
    NSString *str_sqlOrder = @"select HN_createTime,HN_otherID from tbl_hotNews where HN_isEnabled = '0' order by HN_createTime";
    char *sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    int code = sqlite3_step(stmt);
    NSString *str_detail = @"";
    NSDateFormatter *dateForm_time = [[NSDateFormatter alloc] init];
    [dateForm_time setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [dateForm_time setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    while (code == SQLITE_ROW) {
		str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
        NSDate *date_temp = [dateForm_time dateFromString:str_detail];
        NSTimeInterval timeInterval = [date_temp timeIntervalSinceNow];
        if (abs(timeInterval) > bufferTime) {
            str_detail = [self charToString:sqlite3_column_text(stmt, 1)];
            [arr_item addObject:str_detail];
        }
        code = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    [lock unlock];
    for (int i = 0; i < [arr_item count]; i++) {
        NSString *str_id = [arr_item objectAtIndex:i];
        [self deleteHotNews:str_id];
    }
    [arr_item removeAllObjects];
    [lock lock];
    str_sqlOrder = @"select TPC_createTime,TPC_otherID from tbl_topic where TPC_isEnabled = '0' order by TPC_createTime";
    sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    code = sqlite3_step(stmt);
    while (code == SQLITE_ROW) {
		str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
        NSDate *date_temp = [dateForm_time dateFromString:str_detail];
        NSTimeInterval timeInterval = [date_temp timeIntervalSinceNow];
        if (abs(timeInterval) > bufferTime) {
            str_detail = [self charToString:sqlite3_column_text(stmt, 1)];
            [arr_item addObject:str_detail];
        }
        code = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    [lock unlock];
    for (int i = 0; i < [arr_item count]; i++) {
        NSString *str_id = [arr_item objectAtIndex:i];
        [self deleteTopic:str_id];
    }
    [arr_item removeAllObjects];
    [lock lock];
    str_sqlOrder = @"select IMG_createTime,IMG_otherID from tbl_hotNews where IMG_isEnabled = '0' order by IMG_createTime";
    sql = (char *)[str_sqlOrder UTF8String];
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    code = sqlite3_step(stmt);
    while (code == SQLITE_ROW) {
		str_detail = [self charToString:sqlite3_column_text(stmt, 0)];
        NSDate *date_temp = [dateForm_time dateFromString:str_detail];
        NSTimeInterval timeInterval = [date_temp timeIntervalSinceNow];
        if (abs(timeInterval) > bufferTime) {
            str_detail = [self charToString:sqlite3_column_text(stmt, 1)];
            [arr_item addObject:str_detail];
        }
        code = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    [lock unlock];
    for (int i = 0; i < [arr_item count]; i++) {
        NSString *str_id = [arr_item objectAtIndex:i];
        [self deleteImage:str_id];
    }
}

@end
