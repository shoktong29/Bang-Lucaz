//
//  FMDBAccess.m
//  MoneyTracker
//
//  Created by Martin on 4/4/13.
//
//

#import "FMDBAccess.h"
#import "PlistHelper.h"
#define kDB_NAME @"User.db"
#define kTABLE_ITEM @"Item"

@implementation FMDBAccess

+ (NSString *)getDatabasePath{
//    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kDB_NAME];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:kDB_NAME];
    return writableDBPath;
}

+ (void) createAndCheckDatabase{
    BOOL success;
    
    NSString *databasePathFromApp = [FMDBAccess getDatabasePath];
    NSLog(@"DB Path: %@",databasePathFromApp);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:[FMDBAccess getDatabasePath]];
    if(success)
        return;
    [fileManager copyItemAtPath:databasePathFromApp toPath:[FMDBAccess getDatabasePath] error:nil];
}

+ (BOOL)createDBtables{
    FMDatabase *db = [FMDatabase databaseWithPath:[FMDBAccess getDatabasePath]];
    
    [db open];
    BOOL success;
    NSString *query = [NSString stringWithFormat:@"CREATE TABLE %@(unique_id TEXT PRIMARY KEY,set_id TEXT, image_name TEXT, point_value INTEGER);",kTABLE_ITEM];
    success = [db executeUpdate:query];
    [db close];
    
    (success)?NSLog(@"Success creating table!"):NSLog(@"Failed creating table!");//Existing table?
    return success;
}

+ (BOOL)insertData:(Item *)data{
    FMDatabase *db = [FMDatabase databaseWithPath:[FMDBAccess getDatabasePath]];
    [db open];
    NSString *query;
    query =[NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(\"%@\",\"%@\",\"%@\",\"%d\")",kTABLE_ITEM,[data.uniqueId lowercaseString],[data.setId lowercaseString],data.imageName,data.point];
    BOOL success = [db executeUpdate:query];
    [db close];
    
    (success)?NSLog(@"Success!"):NSLog(@"Failed!");
    return success;
}

+ (void)createData{
    int minPoint = 5;
    int maxPoint = 8;
    NSArray *plistData = [PlistHelper getArray:@"ItemData"];
    for (NSArray *set in plistData) {
        for (NSDictionary *data in set) {
            Item *object = [[Item alloc]init];
            object.uniqueId = [data objectForKey:@"unique_id"];
            object.setId = [data objectForKey:@"set_id"];
            object.imageName = [data objectForKey:@"image_name"];
            object.point = minPoint+ arc4random() % (maxPoint-minPoint);
            [FMDBAccess insertData:object];
        }
    }
}

+ (NSMutableArray *) getListItemWithSetId:(int)s{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    FMDatabase *db = [FMDatabase databaseWithPath:[FMDBAccess getDatabasePath]];
    
    [db open];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE set_id LIKE \"%d\"",kTABLE_ITEM,s];
    FMResultSet *results = [db executeQuery:query];
    while([results next]){
        Item *object = [[Item alloc] init];
        object.uniqueId = [results stringForColumn:@"unique_id"];
        object.imageName = [results stringForColumn:@"image_name"];
        object.point = [results intForColumn:@"point_value"];
        [temp addObject:object];
    }
    [db close];
    return temp;
}

+ (NSMutableArray *) getSetIds{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    FMDatabase *db = [FMDatabase databaseWithPath:[FMDBAccess getDatabasePath]];
    
    [db open];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ GROUP BY set_id",kTABLE_ITEM];
    FMResultSet *results = [db executeQuery:query];
    while([results next]){
        NSDictionary *data = @{@"set_id":[results stringForColumn:@"set_id"],
                                @"unique_id":[results stringForColumn:@"unique_id"],
                                @"image_name":[results stringForColumn:@"image_name"]};
        [temp addObject:data];
    }
    [db close];
    return temp;
}


@end
