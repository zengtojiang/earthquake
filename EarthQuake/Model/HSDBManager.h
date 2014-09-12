//
//  HSDBManager.h
//  HSMCBStandardEdition
//
//  Created by jiangll on 13-7-25.
//  Copyright (c) 2013年 hisunsray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface HSDBManager : NSObject
{
    FMDatabase  *sharedLocalDB;
}
@property(nonatomic,retain) FMDatabase  *sharedLocalDB;//本地数据库
+(HSDBManager*)sharedManager;


//打开本地数据库，没有则创建
-(void)openLocalDB;


#pragma mark - 地震数据
//创建地震表表
-(BOOL)createEarthQuakeTable;

//保存所有设备联系人
-(void)saveAllEarthquakes:(NSArray *)quakes;

//获取所有设备联系人
-(NSArray *)getAllEarthquakes;

//删除所有设备联系人
-(BOOL)deleteAllEarthquakes;

@end
/**
 CREATE TABLE android_metadata (locale TEXT);
 CREATE TABLE conf_exten_info (_id INTEGER PRIMARY KEY AUTOINCREMENT,flowid VARCHAR,extension VARCHAR,membername VARCHAR,membertype INTEGER,st VARCHAR);
 CREATE TABLE conf_info (_id INTEGER PRIMARY KEY AUTOINCREMENT,subj VARCHAR,stime VARCHAR,time INTEGER,url VARCHAR,totaltime INTEGER,creator VARCHAR,record INTEGER,flowid VARCHAR UNIQUE,st INTEGER,new INTEGER,conf_content VARCHAR,conf_startDate VARCHAR,conf_startTime VARCHAR,conf_mode INTEGER,call_type INTEGER,conf_members VARCHAR,conf_time VARCHAR,conf_password VARCHAR);
 CREATE TABLE download_info (_id INTEGER,thread_id INTEGER,sid VARCHAR,url VARCHAR,start_pos INTEGER,end_pos INTEGER,compelete_size INTEGER, primary key(thread_id,sid));
 CREATE TABLE downloader_info (_id INTEGER PRIMARY KEY AUTOINCREMENT,url VARCHAR,sid VARCHAR UNIQUE,localfile VARCHAR,threadcount INTEGER);
 CREATE TABLE ext_online (_id INTEGER PRIMARY KEY AUTOINCREMENT,extension1 VARCHAR UNIQUE,userStatus VARCHAR);
 CREATE TABLE im_info (_id INTEGER PRIMARY KEY AUTOINCREMENT,im_id VARCHAR UNIQUE,localNumber VARCHAR,dialNumber VARCHAR,groupNumber VARCHAR,receive_type VARCHAR,msg_type VARCHAR,file_download_path VARCHAR,status VARCHAR,file_local_path VARCHAR,text VARCHAR,send_date VARCHAR,msg_direction VARCHAR,record_duration VARCHAR,callDuration INTEGER,callState INTEGER,is_read INTEGER,playStatus INTEGER);
 CREATE TABLE phone_book (_id INTEGER PRIMARY KEY AUTOINCREMENT,sid INTEGER,authtype INTEGER,extension VARCHAR UNIQUE,userName VARCHAR,sortKey VARCHAR,telephone VARCHAR,mailBox VARCHAR,duty VARCHAR,department VARCHAR,pinyinFirstAll VARCHAR,pinyinAll VARCHAR,avatarName VARCHAR,avatarOldType VARCHAR,avatarOldName VARCHAR,userStatus INTEGER, avatarType INTEGER);
 CREATE TABLE upload_file (_id INTEGER PRIMARY KEY AUTOINCREMENT,ext VARCHAR,receiver VARCHAR,businessId VARCHAR,fileType VARCHAR,fileName VARCHAR,fileCode VARCHAR,filePath VARCHAR,uploadtype VARCHAR,uploadmark VARCHAR,uploadcrunum VARCHAR,totalsize VARCHAR,businessType VARCHAR,all_size VARCHAR,UNIQUE (businessId,fileCode));
 CREATE TABLE upload_file_info (_id INTEGER PRIMARY KEY AUTOINCREMENT,im_id VARCHAR UNIQUE,totalSize VARCHAR,uploadmark VARCHAR,filePath VARCHAR,fileName VARCHAR,downloadfilename VARCHAR,downloadpath VARCHAR,uploadtype INTEGER,currentSize VARCHAR);
 CREATE UNIQUE INDEX [uk_myconfexteninfo] ON [conf_exten_info] ([flowid], [extension]);
 */