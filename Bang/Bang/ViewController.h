//
//  ViewController.h
//  Bang
//
//  Created by Martin on 5/2/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyButton.h"
#import "GameElement.h"
#import <QuartzCore/QuartzCore.h>
#import "UiLabelOutline.h"

@interface ViewController : UIViewController{
    IBOutlet    UIView *viewStage;
    IBOutlet    UIView *viewSelection;
    IBOutlet    UIScrollView *scrollView; 
    IBOutlet    UILabel *labelGetSetGo;
//    MyButton *startButton;
    GameState   _gamestate;
    GameState   _gamePreviousState;
    UiLabelOutline *labelTime;
    UiLabelOutline *labelLife;
    UiLabelOutline *labelScore;
    UiLabelOutline *labelBest;
    UIImageView *viewProgressBar;
    
}
@property (nonatomic, retain) CALayer *cloudLayer;
@property (nonatomic, retain) CABasicAnimation *cloudLayerAnimation;
@property (nonatomic, retain) IBOutlet UIImageView *cloudsImageView;
@property (nonatomic, strong) void(^onCompletion)(void);
- (IBAction)pauseResume:(id)sender;
//to programmer:
// make a difficulty level
//      tutorial mode set the automatic question change to manual and countdown timer is off
//      easy mode wait sets the automatic question change for 3 secs
//      medium mode sets the automatic question change for 2 secs
//      hard mode sets the automatic question change for 0.5 secs
//      survial set the qutomatic question change to manual timer is off and life = 3;
//      Lucky mode = at the start of the game user has a score already and needs to drain it to zero by selecting wrong answer, the catch is images are not shown.
//  Lucky mode2 = score starts at zero and no time limit and user must reach some % of score to finish the stage. The catch is, the number of items is limited.

@end
