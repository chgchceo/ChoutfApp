//
//  DBManager.m
//  DBManagerDemo
//
//  Created by mac on 15-7-27.
//  Copyright (c) 2015年 chgch. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager
{
    NSManagedObjectContext *_context;
}

//创建对象
+(instancetype)shareInstance{

    static dispatch_once_t onceToken;
  static   DBManager *manager ;
    dispatch_once(&onceToken, ^{
        
        manager = [[DBManager alloc] init];
        
        //数据库只需打开一次
        [manager openDB];
        
    });

    return manager;
}
//打开数据库  ,不开放
- (void)openDB{
    
    //加载数据模型文件
    
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"MyData" withExtension:@"momd"];
    
    NSManagedObjectModel *managerModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:fileURL];
    
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managerModel];
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MyData.sqlite"];
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    NSError *error = nil;
   [ store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    
    if (error) {
        NSLog(@"打开数据库失败:%@",error);
    }else{
        NSLog(@"打开数据库成功");
    }
    
    //3.操作数据库
    _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _context.persistentStoreCoordinator = store;
    
}

//创建mo对象
-(NSManagedObject *)createMO:(NSString *)entieyName{
    
  NSManagedObject *mo =  [NSEntityDescription insertNewObjectForEntityForName:entieyName inManagedObjectContext:_context];
    
    return mo;
    
}

//添加用户
-(void)addManagerObject:(NSManagedObject *)mo{
    
    [_context insertObject:mo];
    
    //保存数据
    [_context save:nil];
    
}

//查询数据

-(NSArray *)queryWithEntityName:(NSString *)entityName withPredicate:(NSPredicate *)predicate{
    
    NSFetchRequest *request = [NSFetchRequest   fetchRequestWithEntityName:entityName];
    
    if(predicate){
        
        request.predicate = predicate;
    }
    NSArray *result =  [_context executeFetchRequest:request error:nil];
    
    return result;
}


//修改数据
- (void)updateMO:(NSManagedObject *)mo{
    
    if(mo == nil){
        
        return ;
    }
    
    [_context save:nil];
    
}

//删除数据
- (void)deleteMO:(NSManagedObject *)mo{
    
    if(mo == nil){
        
        return;
    }
    
    [_context deleteObject:mo];
    
    [_context save:nil];
    
}



@end
