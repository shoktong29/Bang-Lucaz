//
//  InGameMenu.h
//  Bang
//
//  Created by Martin on 5/6/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InGameMenuDelegate <NSObject>
@required
- (void)didPressRestart;
- (void)didPressHome;
- (void)didPressContinue;
@end

@interface InGameMenu : UIView
@property(nonatomic, unsafe_unretained) id<InGameMenuDelegate> delegate;
- (void)showMenu:(UIView *)view;
- (void)hideMenu;

@end
