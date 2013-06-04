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

@interface FMDBAccess : NSObject

+ (NSString *)getDatabasePath;
+ (void) createAndCheckDatabase;
+ (BOOL) createDBtables;
+ (void)createData;
+ (BOOL)insertData:(Item *)data;
+ (NSMutableArray *) getSetIds;
+ (NSMutableArray *) getListItemWithSetId:(int)s;


@end
