//
//  DBManager.h
//  DBManagerDemo
//
//  Created by liyoubing on 15/7/15.
//  Copyright (c) 2015年 liyoubing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

//#import "LogMessage+CoreDataClass.h"
#import "LogMessage+CoreDataProperties.h"
@interface DBManager : NSObject

+ (instancetype)shareInstance;

//1.打开数据库
//- (void)openDB;

//创建MO对象
- (NSManagedObject *)createMO:(NSString *)entityName;

//2.添加数据(MO)
- (void)addManagerObject:(NSManagedObject *)mo;

//3.查询数据
- (NSArray *)queryWithEntityName:(NSString *)entityName
                   withPredicate:(NSPredicate *)predicate;

//4.修改数据
- (void)updateMO:(NSManagedObject *)mo;
//
//5.删除数据
- (void)deleteMO:(NSManagedObject *)mo;


@end
