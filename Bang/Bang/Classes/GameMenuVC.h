//
//  GameMenuVC.h
//  Bang
//
//  Created by Martin on 5/25/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GameMenuVC : UIViewController
@property(nonatomic, retain) CALayer *cloudLayer;
@property(nonatomic, retain) CABasicAnimation *cloudLayerAnimation;
@property(nonatomic, retain) IBOutlet UIImageView *backgroundImageView;

- (IBAction)goMultiplayer:(id)sender;
@end
