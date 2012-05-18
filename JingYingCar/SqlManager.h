//
//  SqlManager.h
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "sqlite3.h"

@interface SqlManager : NSObject
{
    NSOperationQueue *operationQueue;
	NSLock *lock;  
	//int isOpen;
	sqlite3		*database;
	NSString	*databasePath;
}

+ (id)sharedManager;
- (id)init;
- (NSString *)databaseFullPath;
- (BOOL)prepareDatabase;

-(BOOL)saveDoc:(NSData *)doc address:(NSString *)address;

-(NSArray *)getHotNewsList;
-(NSInteger)saveHotNewsList:(NSArray *)list isTopOrList:(NSString *)type;
-(NSInteger)saveHotNewsListInfo:(NSDictionary *)dic_info isTopOrList:(NSString *)type;
-(NSDictionary *)getNewsListWithID:(NSString *)newsID;

-(BOOL)saveHotNewsImg:(NSString *)str_id imgAddress:(NSString *)imgAddress imgType:(int)imgType;

-(NSDictionary *)getNewsDetail:(NSString *)newsID;
-(BOOL)saveHotNewsDetail:(NSDictionary *)newsDetail;
-(NSArray *)getImagesList;
-(NSArray *)getImagesTopList;
-(BOOL)saveImagesList:(NSArray *)list isTopOrList:(NSString *)type;
-(NSInteger)saveImageListInfo:(NSDictionary *)dic_info isTopOrList:(NSString *)type;
-(NSArray *)getTopicList;
-(BOOL)saveTopicList:(NSArray *)list;
-(NSInteger)saveTopicInfo:(NSDictionary *)dic_info;
-(NSDictionary *)getTopicListWithID:(NSString *)topicID;
-(BOOL)saveTopicImage:(NSString *)str_id imgAddress:(NSString *)imgAddress;
-(NSDictionary *)getImageListWithID:(NSString *)imgID;
-(BOOL)saveImagesImg:(NSString *)str_id imgAddress:(NSString *)imgAddress imgType:(int)imgType;
-(NSDictionary *)getImageDetail:(NSString *)newsID;
-(BOOL)saveImageDetail:(NSDictionary *)newsDetail;
-(BOOL)saveTopicDetail:(NSDictionary *)newsDetail;
-(NSArray *)getTopicListWithFatherID:(NSString *)fatherID;
-(NSDictionary *)getMagazineInfoWithID:(NSString *)magazineID;
-(NSInteger)getTopicsUnreadedNumber;
-(NSInteger)getImagesUnreadedNumber;


-(NSInteger)saveImageSeries:(NSDictionary *)dic_info ID:(NSString *)str_id;
-(NSArray *)getImagesSeriesWithID:(NSString *)str_id;
-(BOOL)saveImagesSeriesImg:(NSString *)str_id imgAddress:(NSString *)imgAddress imgType:(int)imgType  imgID:(NSString *)str_imgID;
-(NSDictionary *)getImagesSeriesWithID:(NSString *)str_id imgID:(NSString *)str_imgID;

-(NSInteger)saveMagazineList:(NSArray *)list;
-(NSInteger)saveMagazineItem:(NSDictionary *)dic_info;
-(BOOL)saveMagezineCover:(NSString *)str_id imgAddress:(NSString *)str_address;
-(BOOL)saveMagezine:(NSString *)str_id magazineAddress:(NSString *)str_address;
-(NSDictionary *)getMagazineInfoWithID:(NSString *)magazineID;
-(NSArray *)getUndownloadedMagazineList;
-(NSArray *)getDownloadedMagazineList;
-(NSArray *)getMagazineList;
-(NSInteger)deleteMagazine:(NSString *)str_id;

-(NSInteger)addMyCollectionWithFatherID:(NSString *)str_fatherID childID:(NSString *)str_childID;
-(NSArray *)getCollectionList;
-(NSInteger)isCollected:(NSString *)str_id;
-(NSInteger)deleteCollection:(NSString *)str_id;

-(NSDictionary *)readConfigure;
-(BOOL)saveConfigure:(NSDictionary *)dic_parameter;
-(void)emptyBuffer:(int)time;

-(void)initHotNewsLastShow;
-(void)initImagesLastShow;
-(void)initTopicLastShow;

-(void)deleteHotNews:(NSString *)str_id;
-(void)deleteTopic:(NSString *)str_id;
-(void)deleteImage:(NSString *)str_id;

@end
