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
    NSString *query = [NSString stringWithFormat:@"CREATE TABLE %@(unique_id TEXT PRIMARY KEY,set_id TEXT, image_name TEXT, second_image TEXT, point_value INTEGER, is_available INTEGER, price INTEGER);",kTABLE_ITEM];
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
    query =[NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(\"%@\",\"%@\",\"%@\",\"%@\",\"%d\", %d, %d)",kTABLE_ITEM,[data.uniqueId lowercaseString],[data.setId lowercaseString],data.imageName,data.secondImage, data.point,data.isAvailable,data.price];
//    query =[NSString stringWithFormat:@"INSERT INTO %@ VALUES(\"%@\",\"%@\",\"%@\",\"%d\", %d, %d)",kTABLE_ITEM,[data.uniqueId lowercaseString],[data.setId lowercaseString],data.imageName,data.point,data.isAvailable,data.price];

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
        NSDictionary *plistData = [PlistHelper getDictionary:@"ItemData2"];
        for (NSDictionary *set in [plistData allValues]) {
            NSString *setId = [set objectForKey:@"set_id"];
            CGPoint points = CGPointFromString([set objectForKey:@"points"]);
            int price = [[set objectForKey:@"price"] intValue];
            for (NSDictionary *data in [set objectForKey:@"entries"]) {
                Item *object = [[Item alloc]init];
                object.uniqueId = [data objectForKey:@"unique_id"];
                object.imageName = [data objectForKey:@"image_name"];
                object.secondImage = [data objectForKey:@"image_second"];
                object.setId = setId;
                object.point = AVERAGE(points.x, points.y);
                object.price = price;
                if([setId intValue] == 1){
                    object.isAvailable = YES; // 1st set should be available for playing
                }
                [FMDBAccess insertData:object];
            }
        }
}

+ (NSMutableArray *) getListItemWithSetId:(NSString *)s{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    FMDatabase *db = [FMDatabase databaseWithPath:[FMDBAccess getDatabasePath]];
    
    [db open];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE set_id LIKE \"%@\"",kTABLE_ITEM,s];
    FMResultSet *results = [db executeQuery:query];
    while([results next]){
        Item *object = [[Item alloc] init];
        object.uniqueId = [results stringForColumn:@"unique_id"];
        object.imageName = [results stringForColumn:@"image_name"];
        object.secondImage = [results stringForColumn:@"second_image"];
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
                                @"image_name":[results stringForColumn:@"image_name"],
                                @"second_image":[results stringForColumn:@"second_image"],
                                @"is_available":@([results intForColumn:@"is_available"]),
                                @"price":@([results intForColumn:@"price"])};
        [temp addObject:data];
    }
    [db close];
    return temp;
}

+ (BOOL)buyPackageWithSetId:(NSString *)s{
    FMDatabase *db = [FMDatabase databaseWithPath:[FMDBAccess getDatabasePath]];
    [db open];
    NSString *query;
    query =[NSString stringWithFormat:@"UPDATE %@ SET is_available=1 WHERE set_id = %@",kTABLE_ITEM,s];
    BOOL success = [db executeUpdate:query];
    [db close];
    (success)?NSLog(@"Success!"):NSLog(@"Failed!");
    return success;
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
