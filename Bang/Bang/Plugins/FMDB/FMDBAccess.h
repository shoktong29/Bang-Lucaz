//
//  FMDBAccess.h
//  MoneyTracker
//
//  Created by Martin on 4/4/13.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "Item.h"
#import "GameElement.h"

@interface FMDBAccess : NSObject

+ (NSString *)getDatabasePath;
+ (void) createAndCheckDatabase;
+ (BOOL) createDBtables;
+ (void)createData;
+ (BOOL)insertData:(Item *)data;
+ (BOOL)saveUserData:(UserData )data;
+ (UserData)loadUserData;
+ (NSMutableArray *) getSetIds;
+ (NSMutableArray *) getListItemWithSetId:(NSString *)s;
+ (BOOL)buyPackageWithSetId:(NSString *)s;
@end
