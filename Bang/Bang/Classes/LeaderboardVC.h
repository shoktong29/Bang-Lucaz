//
//  LeaderboardVC.h
//  Bang
//
//  Created by Martin on 6/12/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaderboardVC : UIViewController
@property (nonatomic, strong) IBOutlet UITableView *tvLeaderboard;
- (IBAction)reloadData:(id)sender;
- (IBAction)goDismiss:(id)sender;
@end
