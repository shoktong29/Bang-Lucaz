//
//  FMDBAccess.m
//  MoneyTracker
//
//  Created by Martin on 4/4/13.
//
//

#import "FMDBAccess.h"
#import "PlistHelper.h"
#define kDB_NAME @"Default.db"
#define kTABLE_ITEM @"Item"
#define kTABLE_USER @"UserData"

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
    
    query = [NSString stringWithFormat:@"CREATE TABLE %@(unique_id PRIMARY KEY UNIQUE, %@ REAL, %@ REAL, %@ REAL, %@ INTEGER, %@ INTEGER, %@ INTEGER, %@ INTEGER, %@ INTEGER);",kTABLE_USER,kUSER_BEST_SCORE_NORMAL,kUSER_BEST_SCORE_SURVIVAL,kUSER_BEST_SCORE_LUCKY,kUSER_BEST_COMBO_NORMAL,kUSER_BEST_COMBO_SURVIVAL,kUSER_BEST_COMBO_LUCKY,kSCORE_MULTIPLIER,kTOTAL_COINS];
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

+ (BOOL)saveUserData:(UserData )data{
    FMDatabase *db = [FMDatabase databaseWithPath:[FMDBAccess getDatabasePath]];
    [db open];
    NSString *query;
    query =[NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(%d,%0.2f,%0.2f,%0.2f,%d,%d,%d,%d,%d)",kTABLE_USER,data.uniqueId,data.bestNormalScore,data.bestSurvivalScore,data.bestLuckyScore,data.bestNormalCombo,data.bestSurvivalCombo,data.bestLuckyCombo,data.multiplier,data.coins];
    BOOL success = [db executeUpdate:query];
    [db close];
    (success)?NSLog(@"Success!"):NSLog(@"Failed!");
    return success;
}

+ (void)createData{
    int minPoint = 5;
    int maxPoint = 8;
    int setId = 0;
    NSArray *plistData = [PlistHelper getArray:@"ItemData"];
    for (NSArray *set in plistData) {
        setId++;
        for (NSDictionary *data in set) {
            Item *object = [[Item alloc]init];
            object.uniqueId = [data objectForKey:@"unique_id"];
            object.setId = [NSString stringWithFormat:@"%d",setId];
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


+ (UserData)loadUserData{
    UserData userData = UserDataMakeDefault();
    FMDatabase *db = [FMDatabase databaseWithPath:[FMDBAccess getDatabasePath]];
    
    [db open];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT 1",kTABLE_USER];
    FMResultSet *results = [db executeQuery:query];
    while([results next]){
        userData.uniqueId = [results intForColumn:@"unique_id"];
        userData.bestNormalScore = [results longForColumn:kUSER_BEST_SCORE_NORMAL];
        userData.bestNormalCombo = [results intForColumn:kUSER_BEST_COMBO_NORMAL];
        userData.bestSurvivalScore = [results longForColumn:kUSER_BEST_SCORE_SURVIVAL];
        userData.bestSurvivalCombo = [results intForColumn:kUSER_BEST_COMBO_SURVIVAL];
        userData.bestLuckyScore = [results longForColumn:kUSER_BEST_SCORE_LUCKY];
        userData.bestLuckyCombo = [results intForColumn:kUSER_BEST_COMBO_LUCKY];
        userData.multiplier = [results intForColumn:kSCORE_MULTIPLIER];
        userData.coins = [results intForColumn:kTOTAL_COINS];
    }
    [db close];
    return userData;
}


@end
