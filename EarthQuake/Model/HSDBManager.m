//
//  HSDBManager.m
//  HSMCBStandardEdition
//
//  Created by jiangll on 13-7-25.
//  Copyright (c) 2013年 hisunsray. All rights reserved.
//

#import "HSDBManager.h"

@implementation HSDBManager
@synthesize sharedLocalDB;


#define SHT_LOCAL_DB_NAME                   @"stdlocal.sqlite" //本地数据库名称

#define EARTHQUAKE_TABLE                    @"earthquake" //地震原始表
#define COLLECTION_TABLE                    @"collect"//收藏表

+(HSDBManager*)sharedManager
{
    static HSDBManager *dbManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        dbManager = [[self alloc] init];
    });
    return dbManager;
    /*
    if (nil == dbManager) {
        @synchronized(self){
            if(nil == dbManager){
                dbManager = [[HSDBManager alloc]init];
            }
        }
    }
    return dbManager;
     */
}

-(id) init
{
    if (self = [super init]) {
    }
    return self;
}

//打开本地数据库，没有则创建
-(void)openLocalDB
{
    //关闭原来打开的数据库
    if (self.sharedLocalDB) {
        [self.sharedLocalDB close];
    }
    NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:SHT_LOCAL_DB_NAME];
	
    self.sharedLocalDB= [FMDatabase databaseWithPath:storePath];
    if (![self.sharedLocalDB open]) {
        ZLTRACE(@"open file error:%@",[sharedLocalDB lastErrorMessage]);
    }else{
        //如果还没有本地联系人表，先创建
        [self createEarthQuakeTable];
    }
}

- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark - 地震数据

//创建本地联系人表
-(BOOL)createEarthQuakeTable
{
    NSString *sql=@"CREATE TABLE ZEARTHQUAKE ( Z_PK INTEGER PRIMARY KEY, Z_ENT INTEGER, Z_OPT INTEGER, ZDATE TIMESTAMP, ZLATITUDE FLOAT, ZLONGITUDE FLOAT, ZMAGNITUDE FLOAT, ZUSGSWEBLINK VARCHAR, ZLOCATION VARCHAR )";
    BOOL result=[self.sharedLocalDB executeUpdate:sql];
    if (!result) {
        ZLTRACE(@"%@",[self.sharedLocalDB lastErrorMessage]);
    }
    return result;
    
}

-(void)saveAllEarthquakes:(NSArray *)quakes;
{
    /*
    [self.sharedLocalDB beginTransaction];
    if (quakes&&[quakes count]) {
        [quakes retain];
        for (int i=0; i<[quakes count]; i++) {
            HSContact *contact=[contacts objectAtIndex:i];
            //HSLogDebug(@"not existContact:%@",contact.userID);
            NSString    *sql = [NSString stringWithFormat:@"replace into %@\
                                (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@)\
                                values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",CONTACT_TABLE_NAME,CONTACT_TABLE_SERVER_ID, CONTACT_TABLE_USERID,CONTACT_TABLE_USERNAME,CONTACT_TABLE_DEPARTMENT,CONTACT_TABLE_DUTY,CONTACT_TABLE_EMAIL,CONTACT_TABLE_PHONE,CONTACT_TABLE_AUTHTYPE,CONTACT_TABLE_USERSTATUS,CONTACT_TABLE_AVATAR_TYPE,CONTACT_TABLE_AVATAR_NAME,CONTACT_TABLE_SORTKEY,CONTACT_TABLE_PINYIN_ALL,CONTACT_TABLE_PINYIN_FIRST];
            
            NSString* strPinYinAll = [[ChineseToPinyin pinyinFromChiniseString:SENTENCED_EMPTY(contact.userName)] lowercaseString];
            //计算首字母算法有问题，暂不使用
            NSString* strPinYinFL  = [[ChineseToPinyin pinyinFirstFromChiniseString:SENTENCED_EMPTY(contact.userName)] lowercaseString];
            NSArray *sqlArray = [NSArray arrayWithObjects:
                                 [NSNumber numberWithLongLong:[contact.serverID longLongValue]],
                                 SENTENCED_EMPTY(contact.userID),
                                 SENTENCED_EMPTY(contact.userName),
                                 SENTENCED_EMPTY(contact.depart),
                                 SENTENCED_EMPTY(contact.duty),
                                 SENTENCED_EMPTY(contact.email),
                                 SENTENCED_EMPTY(contact.mobileNumbr),
                                 [NSNumber numberWithInt:HS_DEVICE_CONTACT_TYPE],
                                 [NSNumber numberWithInt:contact.onlineStatus],
                                 [NSNumber numberWithInt:contact.avatarType],
                                 SENTENCED_EMPTY(contact.avatarName),
                                 SENTENCED_EMPTY(contact.sortKey),
                                 SENTENCED_EMPTY(strPinYinAll),
                                 SENTENCED_EMPTY(strPinYinFL),nil];
            
            if (![self.sharedLocalDB executeUpdate:sql withArgumentsInArray:sqlArray]) {
                HSLogError(@"%@",[self.sharedLocalDB lastErrorMessage]);
            }
        }
        [quakes release];
    }
    [self.sharedLocalDB commit];
     */
}

//获取所有设备联系人
-(NSArray *)getAllEarthquakes
{
    /*
    NSString    *sql = [NSString stringWithFormat:@"select %@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@ from %@ where %@=%d",CONTACT_TABLE_KEY_ID,CONTACT_TABLE_SERVER_ID,CONTACT_TABLE_USERID, CONTACT_TABLE_USERNAME,CONTACT_TABLE_DEPARTMENT,CONTACT_TABLE_DUTY,CONTACT_TABLE_EMAIL,CONTACT_TABLE_PHONE,CONTACT_TABLE_AUTHTYPE,CONTACT_TABLE_AVATAR_TYPE,CONTACT_TABLE_AVATAR_NAME,CONTACT_TABLE_SORTKEY,CONTACT_TABLE_PINYIN_ALL,CONTACT_TABLE_PINYIN_FIRST,CONTACT_TABLE_USERSTATUS,CONTACT_TABLE_NAME,CONTACT_TABLE_AUTHTYPE,HS_DEVICE_CONTACT_TYPE];
    
    FMResultSet *result=[self.sharedLocalDB executeQuery:sql];
    NSMutableArray *arrResult=[NSMutableArray array];
    while ([result next]) {
        HSContact *item=[[HSContact alloc] init];
        item.keyID = [NSString stringWithFormat:@"%lld",[result longLongIntForColumn:CONTACT_TABLE_KEY_ID]];
        item.serverID = [NSString stringWithFormat:@"%lld",[result longLongIntForColumn:CONTACT_TABLE_SERVER_ID]];
        item.userID = [result stringForColumn:CONTACT_TABLE_USERID];
        item.userName = [result stringForColumn:CONTACT_TABLE_USERNAME];
        item.depart = [result stringForColumn:CONTACT_TABLE_DEPARTMENT];
        item.duty = [result stringForColumn:CONTACT_TABLE_DUTY];
        item.email = [result stringForColumn:CONTACT_TABLE_EMAIL];
        item.mobileNumbr = [result stringForColumn:CONTACT_TABLE_PHONE];
        item.authType = [result intForColumn:CONTACT_TABLE_AUTHTYPE];
        item.avatarType = [result intForColumn:CONTACT_TABLE_AVATAR_TYPE];
        item.avatarName = [result stringForColumn:CONTACT_TABLE_AVATAR_NAME];
        item.sortKey = [result stringForColumn:CONTACT_TABLE_SORTKEY];
        item.pinyinAll = [result stringForColumn:CONTACT_TABLE_PINYIN_ALL];
        item.pinyinFirst = [result stringForColumn:CONTACT_TABLE_PINYIN_FIRST];
        item.onlineStatus=1;
        
        [arrResult addObject:item];
        [item release];
    }
    return arrResult;
    */
    return nil;
}

//删除所有设备联系人
-(BOOL)deleteAllEarthquakes
{
    /*
    NSString *sql=[NSString stringWithFormat:@"delete from %@ where %@=%d",CONTACT_TABLE_NAME,CONTACT_TABLE_AUTHTYPE,HS_DEVICE_CONTACT_TYPE];
    BOOL result=[self.sharedLocalDB executeUpdate:sql];
    if (!result) {
        ZLTRACE(@"%@",[self.sharedLocalDB lastErrorMessage]);
    }
    return result;
     */
    return YES;
}

@end
