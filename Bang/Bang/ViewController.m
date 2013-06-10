//
//  ViewController.m
//  Bang
//
//  Created by Martin on 5/2/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "ViewController.h"
//#import <tgmath.h>
#import "InGameMenu.h"
#import "EndRoudVC.h"
#import "Item.h"
#import "FMDBAccess.h"
#import "PlistHelper.h"
#import "GameCenterManager.h"
#import "AudioManager.h"
#import "DataManager.h"
#import <QuartzCore/QuartzCore.h>
#import "Helper.h"


float const kTIME_INTERVAL = 0.01f;
float const kTIME_LIMIT = 30.0f;
float const kMIN_SCORE = 60.0f;

@implementation ViewController{
    NSTimer *timerMain;
    NSMutableArray *listObjects; //Holds the objects(item) used this class.

    UIImageView *stageActiveButton;
    InGameMenu *subMenu;
    EndRoudVC *endRoundMenu;
    float countDownTimer;
    float timeLimit;
    float speed;
    int score;
    int pointsToAdd;
    float counter;
    int comboStreak;
    int highestComboStreak;
    int playerLife;
    int numberOfQuestions;
    int missedQuestions;
    int correctAnswers;
    int wrongAnswers;
    BOOL didSelectAnswer;
    GameSettings gameSettings;
    NSURL *soundFileUrl;
    float progressBarWidth;
    MyButton *buttonPause;
    NSDictionary *data; //user data
    NSUserDefaults *defaults;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    defaults = [NSUserDefaults standardUserDefaults];
    data = [defaults objectForKey:kUSER_DATA];
    
    if ([self isViewLoaded]) {
        gameSettings = [DataManager sharedInstance].gameSettings;
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sound_wrong" ofType:@"mp3" inDirectory:@""];
//        soundFileUrl = [NSURL fileURLWithPath:filePath isDirectory:NO];
        [self setFixedUi];
        timerMain = [NSTimer timerWithTimeInterval:kTIME_INTERVAL target:self selector:@selector(runLoop:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:timerMain forMode:NSRunLoopCommonModes];
        [self createObjects];
        [self willStartGame];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [timerMain invalidate];
    timerMain = nil;
}

#pragma mark - Logic
- (void)createObjects{
    [listObjects removeAllObjects];
    listObjects = nil;
    listObjects = [FMDBAccess getListItemWithSetId:gameSettings.setId];
}

- (void)setDefaultValues{
    timeLimit = kTIME_LIMIT; //only affects normal mode but is use in all mode
    score = 0;
    pointsToAdd = 0;
    counter = 0;
    comboStreak = 0;
    highestComboStreak = 0;
    numberOfQuestions = 0; //do not use this for computing additional score
    missedQuestions = 0;
    wrongAnswers = 0;
    correctAnswers = 0;
    didSelectAnswer = YES; //was set to yes because of the counter in generateUI method
    switch (gameSettings.gameMode) {
        case modeTimeAttack:
            countDownTimer = timeLimit;
            speed = 0.7f;
            playerLife = 0;
            break;
        case modeSurvial:
            countDownTimer = 0;
            speed = 1.2f;
            playerLife = 1;
            break;
        case modeNormal:
            countDownTimer = timeLimit;
            speed = 0.0f;
            playerLife = 0;
            break;
        case modeTutorial:
            countDownTimer = 0;
            speed = 0.0f;
            playerLife = 0;
            break;
        default:
            break;
    }
    [self changeState:stateWillStart]; //Do any pre animation in this state
    labelGetSetGo.hidden = NO;
    scrollView.hidden = NO;
}

- (void)willStartGame{
    [UIView animateWithDuration:0.5f animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f animations:^{
            self.view.alpha = 1;
            [self cleanup];
            [self setDefaultValues];
            [self startGame];
        }];
    }];
}

- (void)startGame{
    [self changeState:stateStart];
}

- (void)runLoop:(NSTimer *)tick{
    switch (_gamestate) {
        case stateStart:
            [self stateStart:tick];
            break;
        case statePlaying:
            [self statePlaying:tick];
            break;
        case statePause:
            break;
        case stateEnd:
            [self stateEnd:tick];
            break;
        default:
            break;
    }
    [self updateUi:tick];
}

- (void)changeState:(GameState)state{
    _gamePreviousState = _gamestate;
    _gamestate = state;
}

#pragma mark - UI Stuff
- (void)setFixedUi{
    viewSelection = [[UIView alloc]init];
    viewSelection.frame = CGRectMake(43, 205, 235, 72);
    viewSelection.backgroundColor = [UIColor clearColor];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"black-circleBG.png"]];
    [scrollView addSubview:viewSelection];
    
    UIView *viewLabelContainer = [[UIView alloc]init];
    viewLabelContainer.frame = CGRectMake(0, 0, 320, 45);
    viewLabelContainer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topBar.png"]];//UICOLOR_FROM_HEX(0x482982)
    [self.view addSubview:viewLabelContainer];
    
    UiLabelOutline *labelBest = [[UiLabelOutline alloc]init];
    labelBest.frame = CGRectMake(10, 5, 140, 25);
    labelBest.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    labelBest.textAlignment = UITextAlignmentLeft;
    labelBest.textColor = UICOLOR_FROM_HEX(0xe3c332);
    labelBest.text = [NSString stringWithFormat:@"BEST: %d",[[data objectForKey:kUSER_BEST_SCORE] intValue]];
    labelBest.backgroundColor = [UIColor clearColor];
    [viewLabelContainer addSubview:labelBest];
    
    labelScore = [[UiLabelOutline alloc]init];
    labelScore.frame = CGRectMake(160-45, 5, 90, 25);
    labelScore.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    labelScore.textAlignment = UITextAlignmentCenter;
    labelScore.textColor = UICOLOR_FROM_HEX(0xe3c332);
    labelScore.backgroundColor = [UIColor clearColor];
    [viewLabelContainer addSubview:labelScore];
    
    buttonPause = [[MyButton alloc]init];
    [buttonPause setImage:[UIImage imageNamed:@"iconPause.png"] forState:UIControlStateNormal];
    buttonPause.frame = CGRectMake(280, 10, 30, 25);
    buttonPause.layer.borderColor = [UIColor clearColor].CGColor;
    [buttonPause addTarget:self action:@selector(pauseResume:) forControlEvents:UIControlEventTouchDown];
    [viewLabelContainer addSubview:buttonPause];
    
    UIView *viewProgressBarContainer;
    UIColor *color;
    switch (gameSettings.gameMode) {
            
        case modeNormal:
            labelTime = [[UiLabelOutline alloc]init];
            labelTime.frame = CGRectMake(10, 24, 60, 25);
            labelTime.textAlignment = UITextAlignmentLeft;
            labelTime.textColor = UICOLOR_FROM_HEX(0x868686);
            labelTime.backgroundColor = [UIColor clearColor];
            [viewLabelContainer addSubview:labelTime];
            
            viewProgressBarContainer = [[UIView alloc]init];
            viewProgressBarContainer.frame = CGRectMake(labelTime.frame.origin.x+labelTime.frame.size.width, 32, 200, 10);
            viewProgressBarContainer.layer.borderWidth = 2.0f;
//            viewProgressBarContainer.backgroundColor = UICOLOR_FROM_HEX(0x868686);
            color = UICOLOR_FROM_HEX(0xc2c2c2);
            viewProgressBarContainer.layer.borderColor = color.CGColor;//[UIColor grayColor].CGColor;
            
            viewProgressBar = [[UIImageView alloc] init];
            viewProgressBar.image = [Helper grayscaleImage:[UIImage imageNamed:@"progressBarFill.png"] color:[UIColor darkGrayColor]];
            viewProgressBar.frame = viewProgressBarContainer.frame;
            [viewLabelContainer addSubview:viewProgressBar];
            [viewLabelContainer addSubview:viewProgressBarContainer];
            
            progressBarWidth = viewProgressBar.frame.size.width;
            break;
        case modeSurvial:
            labelLife = [[UiLabelOutline alloc]init];
            labelLife.frame = CGRectMake(10, 25, 60, 25);
            labelLife.textAlignment = UITextAlignmentLeft;
            labelLife.backgroundColor = [UIColor clearColor];
            [viewLabelContainer addSubview:labelLife];
            break;
        case modeTimeAttack:
            labelTime = [[UiLabelOutline alloc]init];
            labelTime.frame = CGRectMake(10, 25, 60, 25);
            labelTime.textAlignment = UITextAlignmentLeft;
            labelTime.backgroundColor = [UIColor clearColor];
            [viewLabelContainer addSubview:labelTime];
            
            viewProgressBarContainer = [[UIView alloc]init];
            viewProgressBarContainer.frame = CGRectMake(labelTime.frame.origin.x+labelTime.frame.size.width, 32, 200, 10);
            viewProgressBarContainer.layer.borderWidth = 2.0f;
            viewProgressBarContainer.layer.borderColor = [UIColor grayColor].CGColor;
            
            viewProgressBar = [[UIImageView alloc] init];
            viewProgressBar.image = [UIImage imageNamed:@"progressBarFill.png"];
            viewProgressBar.frame = viewProgressBarContainer.frame;
            [viewLabelContainer addSubview:viewProgressBar];
            [viewLabelContainer addSubview:viewProgressBarContainer];
            break;
        default:
            break;
    }
    
}

- (void)generateUi{
    if (!didSelectAnswer) {
        wrongAnswers++;
        missedQuestions++;
        comboStreak = 0;
    }
    didSelectAnswer = NO;
    
    NSMutableArray *listItems = [[NSMutableArray alloc]init];
    NSMutableArray *selectedItems = [[NSMutableArray alloc]init];
    
    //Create buttons with item data (uniqueId, image)
    for (int x=0; x<listObjects.count; x++) {
        Item *object = [listObjects objectAtIndex:x];
        MyButton *btn = [[MyButton alloc]init];
        [btn addTarget:self action:@selector(bang:) forControlEvents:UIControlEventTouchDown];
        btn.imageName = object.imageName;
        if (gameSettings.gameMode == modeTimeAttack) {
            [btn setImage:[UIImage imageNamed:object.imageName] forState:UIControlStateDisabled];
            [btn setImage:[UIImage imageNamed:@"image-questionMark.png"] forState:UIControlStateNormal];
        }
        else{
            UIImage *temp = [UIImage imageNamed:object.imageName];
            [btn setImage:temp forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:object.imageName] forState:UIControlStateDisabled];
        }
        btn.uniqueId = object.uniqueId;
        btn.point = object.point;
        [listItems addObject:btn];
        //NSLog(@"%@",object.imageName);
    }
    
    NSMutableArray *temp = [[NSMutableArray alloc]initWithArray:listItems];
    if (temp.count <=0) {
        return;
    }
    int tempCounter = 0;
    int i = 0;
    int xPos = 0;
    int yPos = 0;
    int offset = 0;
    CGSize btnSize = CGSizeMake(70, 70);
    while (tempCounter < 3) {
        i = arc4random() % temp.count;
        offset = tempCounter*13;
        MyButton *btn = [temp objectAtIndex:i];
        xPos = tempCounter*btnSize.width + offset;
        if (btn) {
            btn.frame = (CGRect){.origin={xPos,yPos},.size=btnSize};
            btn.transform = CGAffineTransformMakeScale(0.3,0.3);
            [UIView animateWithDuration:0.3f animations:^{
                btn.transform = CGAffineTransformMakeScale(1,1);
                [viewSelection addSubview:btn];
            }];
            [selectedItems addObject:btn];
            [temp removeObject:btn];
            tempCounter++;
        }
    }

    int selected = arc4random() % selectedItems.count;
    MyButton *btnTemp = [selectedItems objectAtIndex:selected];

    stageActiveButton = [[UIImageView alloc]initWithImage:[UIImage imageNamed:btnTemp.imageName]];
    stageActiveButton.frame = CGRectMake(0, 0, 120, 120);
    stageActiveButton.transform = CGAffineTransformMakeScale(0.3,0.3);
    stageActiveButton.layer.borderWidth = 3.0f;
    [UIView animateWithDuration:0.3f animations:^{
        stageActiveButton.transform = CGAffineTransformMakeScale(1,1);
    }];
    stageActiveButton.accessibilityHint = btnTemp.uniqueId;
    [viewStage addSubview:stageActiveButton];
    
    [temp removeAllObjects];
    temp = nil;
    [selectedItems removeAllObjects];
    selectedItems = nil;
    [listItems removeAllObjects];
    listItems = nil;
    
    numberOfQuestions++;
}

- (void)updateUi:(NSTimer *)tick{
    score = (score > 0)?score:0;

//    labelScore.text = [NSString stringWithFormat:@"Q:%d | CA:%d | WA:%d Score:%d | HC:%d",numberOfQuestions,correctAnswers,wrongAnswers,score,highestComboStreak];
    labelScore.text = [NSString stringWithFormat:@"%d",score];

    labelTime.text = [NSString stringWithFormat:@"%0.2f",(countDownTimer>0)?countDownTimer:0.00f];
    if (pointsToAdd >0) {
        pointsToAdd--;
        score++;
    }
    if (pointsToAdd <0 && score>=0) {
        pointsToAdd++;
        score--;
        if (score <= 0) {
            pointsToAdd = 0;
        }
    }
    
    CGRect temp;
    float width;
    switch (_gamestate) {
        case stateStart:
            buttonPause.enabled = YES;
            break;
        case statePlaying:
            buttonPause.enabled = YES;
            switch (gameSettings.gameMode) {
                case modeNormal:
                    labelTime.text = [NSString stringWithFormat:@"%0.2f",(countDownTimer>0)?countDownTimer:0.00f];
                    temp = viewProgressBar.frame;
                    width =  (progressBarWidth / timeLimit) * countDownTimer;
                    temp.size.width = width;
                    viewProgressBar.frame = temp;
                    break;
                case modeSurvial:
                    break;
                case modeTimeAttack:
                    labelTime.text = [NSString stringWithFormat:@"%0.2f",(countDownTimer>0)?countDownTimer:0.00f];
                    temp = viewProgressBar.frame;
                    width =  (progressBarWidth / timeLimit) * countDownTimer;
                    temp.size.width = width;
                    viewProgressBar.frame = temp;
                    break;
                default:
                    break;
            }
            break;
        case stateEnd:
            buttonPause.enabled = NO;
            break;
        case statePause:
            buttonPause.enabled = NO;
            break;
        default:
            break;
    }
}

- (void)cleanup{
    for (MyButton *btn in [viewSelection subviews]) {
        [btn removeFromSuperview];
    }
    
    [stageActiveButton removeFromSuperview];
    stageActiveButton = nil;
    
    [subMenu hideMenu];
    subMenu = nil;
    
    [endRoundMenu hideEndRound];
    endRoundMenu = nil;
}

- (void)generateUiBubble:(id)sender{ // UI that fadesin above the answers when user taps on it.
    CGSize bubbleSize = CGSizeMake(50, 30);
    MyButton *temp = (MyButton *)sender;
    CGRect frame = [viewSelection convertRect:temp.frame toView:scrollView];
    CGPoint coords = {frame.origin.x+frame.size.width/2-bubbleSize.width/2,frame.origin.y};
    UiLabelOutline *label = [[UiLabelOutline alloc]init];
    label.text = [NSString stringWithFormat:@"+%d",temp.point];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = UICOLOR_FROM_HEX(0xe3c332);
    label.frame = (CGRect){.origin=coords,.size=bubbleSize};
    [scrollView addSubview:label];
    
    coords.y -= 50;
    frame = (CGRect){.origin=coords,.size=bubbleSize};
    [UIView animateWithDuration:0.5 animations:^{
        label.frame = frame;
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [label removeFromSuperview];
        });
    }];
    
}

#pragma mark - Actions
- (void)bang:(MyButton *)sender{
    didSelectAnswer = YES;
    BOOL isCorrect = [sender.uniqueId isEqualToString:stageActiveButton.accessibilityHint];
    (isCorrect)?[self didSelectCorrectAnswer:sender]:[self didSelectWrongAnswer:sender];
    for (MyButton *btn in [viewSelection subviews]) {
        btn.enabled = NO;
        btn.layer.borderColor = [UIColor redColor].CGColor;
        if ([btn.uniqueId isEqualToString:stageActiveButton.accessibilityHint]) {
            btn.layer.borderColor = [UIColor greenColor].CGColor;
        }
    }
    
    switch (gameSettings.gameMode) {
        case modeTimeAttack:
            break;
        case modeSurvial:
            //set counter to trigger automatic question change
            counter = timeLimit/(timeLimit*speed);
            break;
        case modeNormal:
            counter = timeLimit/(timeLimit*speed);
            break;
        case modeTutorial:
            counter = timeLimit/(timeLimit*speed);
            break;
        default:
            break;
    }
}

- (void)didSelectCorrectAnswer:(MyButton *)sender{
    correctAnswers += 1;
    [self generateUiBubble:sender];
    pointsToAdd += sender.point;
    comboStreak++;
    highestComboStreak = (comboStreak >= highestComboStreak)?comboStreak:highestComboStreak;
    // Delay execution of my block for 10 seconds.
    
}

- (void)didSelectWrongAnswer:(MyButton *)sender{
    wrongAnswers += 1;
    switch (gameSettings.gameMode) {
        case modeTimeAttack:
            countDownTimer -= 0.0f; //deduct time in countdown
            playerLife = 0;
            break;
        case modeSurvial:
            playerLife --;
            countDownTimer -= 0.0f; //deduct time in countdown
            if (playerLife <= 0) {
                [self changeState:stateEnd];
            }
            break;
        case modeNormal:
            playerLife = 0;
            countDownTimer -= 0.0f; //deduct time in countdown
            break;
        case modeTutorial:
            //no end game
            playerLife = 0;
            countDownTimer -= 0.0f; //deduct time in countdown
            break;
            
        default:
            break;
    }
    comboStreak = 0;
    [AudioManager playSound:soundFileUrl];
    pointsToAdd += -sender.point;
}

- (IBAction)didPressPowerup:(id)sender{
    countDownTimer += 5.0f; // add time penalty for wrong answer
}

- (IBAction)pauseResume:(UIButton *)sender{
    if (_gamestate == statePlaying || _gamestate == stateStart || _gamestate == stateEnd) {
        scrollView.hidden = YES;
        subMenu = [[InGameMenu alloc]init];
        subMenu.frame = scrollView.frame;
        subMenu.center = scrollView.center;
        __weak typeof(self) weakSelf = self;
        subMenu.onPressRestart = ^{
            [weakSelf willStartGame];
        };
        
        subMenu.onPressHome = ^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
        
        subMenu.onPressContinue = ^{
            [weakSelf pauseResume:nil];
        };
        [subMenu showMenu:self.view];
        [self changeState:statePause];
    }
    else if(_gamestate == statePause){
        scrollView.hidden = NO;
        [self changeState:_gamePreviousState];
        [subMenu hideMenu];
        subMenu = nil;
    }
}

#pragma mark - Methods for different mode
- (void)statePlaying:(NSTimer *)tick{
    switch (gameSettings.gameMode) {
        case modeTimeAttack:
            counter += tick.timeInterval;
            countDownTimer -= tick.timeInterval;
            if (counter >= timeLimit/(timeLimit*speed)) {
                [self cleanup];
                [self generateUi];
                counter = 0;
            }
            if (countDownTimer <= 0) {
                [self changeState:stateEnd];
            }
            break;
        case modeSurvial:
            counter += tick.timeInterval;
            countDownTimer -= tick.timeInterval;
            if (counter >= timeLimit/(timeLimit*speed)) {
                [self cleanup];
                [self generateUi];
                counter = 0;
            }
            break;
        case modeNormal:
            counter += tick.timeInterval;
            countDownTimer -= tick.timeInterval;
            if (counter >= timeLimit/(timeLimit*speed)) {
                [self cleanup];
                [self generateUi];
                counter = 0;
            }
            if (countDownTimer <= 0) {
                //                [[[GameCenterManager sharedInstance]leaderboard]reportScore:score forCategory:nil];
                //                if (score > 39) {
                //                    [[[GameCenterManager sharedInstance]achievement]submitAchievement:@"RW_Achievement_001" percentComplete:100];
                //                }
                [self changeState:stateEnd];
            }
            break;
        case modeTutorial:
            counter += tick.timeInterval;
            countDownTimer -= tick.timeInterval;
            if (counter >= timeLimit/(timeLimit*speed)) {
                [self cleanup];
                [self generateUi];
                counter = 0;
            }
            break;
        default:
            break;
    }
}

- (void)stateStart:(NSTimer *)tick{
    switch (gameSettings.gameMode) {
        case modeTimeAttack:
            counter += tick.timeInterval;
            labelGetSetGo.text =[NSString stringWithFormat:@"%0.0f",ceilf(ABS(counter-3.0f))] ;
            if (counter > 3) {
                labelGetSetGo.hidden = YES;
                [self changeState:statePlaying];
            }
            break;
        case modeSurvial:
            counter += tick.timeInterval;
            labelGetSetGo.text =[NSString stringWithFormat:@"%0.0f",ceilf(ABS(counter-3.0f))] ;
            if (counter > 3) {
                labelGetSetGo.hidden = YES;
                [self changeState:statePlaying];
            }
            break;
        case modeNormal:
            counter += tick.timeInterval;
            labelGetSetGo.text =[NSString stringWithFormat:@"%0.0f",ceilf(ABS(counter-3.0f))] ;
            if (counter > 3) {
                labelGetSetGo.hidden = YES;
                [self changeState:statePlaying];
                [self generateUi];
            }
            break;
        case modeTutorial:
            counter += tick.timeInterval;
            labelGetSetGo.text =[NSString stringWithFormat:@"%0.0f",ceilf(ABS(counter-3.0f))] ;
            if (counter > 3) {
                labelGetSetGo.hidden = YES;
                [self changeState:statePlaying];
                [self generateUi];
            }
            break;
        default:
            break;
    }
}

- (void)stateEnd:(NSTimer *)tick{
    if (!endRoundMenu) {
        scrollView.hidden = YES;
        endRoundMenu = [[EndRoudVC alloc]init];
        endRoundMenu.frame = scrollView.frame;
        endRoundMenu.center = scrollView.center;
        __weak typeof(self) weakSelf = self;
        endRoundMenu.onPressRestart = ^{
            [weakSelf willStartGame];
        };
        
        endRoundMenu.onPressHome = ^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
        
        endRoundMenu.onPressContinue = ^{
            scrollView.hidden = NO;
//            endRoundMenu = nil;
        };
        [endRoundMenu showEndRound:self.view];
        [self saveData];
    }
}

#pragma mark - Save
- (void)saveData{
    //NOTE: SAVE ONLY AT THE END OF THE GAME
    
    //roundscore math
    int multiplier = [[data objectForKey:kSCORE_MULTIPLIER] intValue];
    multiplier = (multiplier <= 0)?1:multiplier;
    float comboBonus = ceilf(highestComboStreak*multiplier);
    score = score + comboBonus;

    //coins math
    int totalCoins =[[data objectForKey:kTOTAL_COINS] intValue];
    totalCoins += correctAnswers + comboBonus;
    
    //previous saved data
    float bestScore = [[data objectForKey:kUSER_BEST_SCORE] floatValue];
    int bestCombo = [[data objectForKey:kUSER_BEST_COMBO] intValue];
    int correctAnswer = [[data objectForKey:kUSER_CORRECT_ANSWERS] intValue] + correctAnswers;
    int wrongAnswer = [[data objectForKey:kUSER_WRONG_ANSWERS] intValue] + wrongAnswers;
    
    //compare
    bestScore = (score > bestScore)?score:bestScore;
    bestCombo = (highestComboStreak >bestCombo)?highestComboStreak:bestCombo;
    
    //save data
    NSDictionary *toSave = @{kUSER_BEST_SCORE:@(bestScore),kUSER_BEST_COMBO:@(bestCombo),kUSER_CORRECT_ANSWERS:@(correctAnswer),kUSER_WRONG_ANSWERS:@(wrongAnswer),kTOTAL_COINS:@(totalCoins)};
    [defaults setObject:toSave forKey:kUSER_DATA];
    [defaults synchronize];
    NSLog(@"DATA SAVED!!");
}


@end
