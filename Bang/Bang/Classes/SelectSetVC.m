//
//  SelectSetVC.m
//  Bang
//
//  Created by Martin on 5/27/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "SelectSetVC.h"
#import "DataManager.h"
#import "GameMenuVC.h"
#import "ViewController.h"
#import "FMDBAccess.h"

@interface SelectSetVC ()

@end

@implementation SelectSetVC{
    GameSettings gameSettings;
    int page;
    BOOL isAnimating;
    NSArray *setIds;
    UIView *viewLabelContainer;
    UiLabelOutline *labelCoins;
    UserData userData;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setDefaultValues];
    [self setDefaultUi];
}

- (void)viewDidAppear:(BOOL)animated{
    [self animate];
}

- (void)setDefaultValues{
    gameSettings = [[DataManager sharedInstance]gameSettings];
    setIds = [FMDBAccess getSetIds];
    NSString *setId = [[setIds objectAtIndex:0] objectForKey:@"set_id"];
    gameSettings.setId = [setId intValue];
    [DataManager sharedInstance].gameSettings = gameSettings;
    userData = [FMDBAccess loadUserData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIButton *temp = sender;
    switch (temp.tag) {
        case 0:
            gameSettings.gameMode= modeNormal;
            break;
        case 1:
            gameSettings.gameMode = modeSurvial;
            break;
        case 2:
            gameSettings.gameMode = modeTimeAttack;
        default:
            break;  
    }
    [DataManager sharedInstance].gameSettings = gameSettings;
}

#pragma mark - Actions

- (IBAction)goGameMenuVC:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)goNext:(id)sender{
    if (page<_scrollView.subviews.count-1 && !isAnimating) {
        isAnimating = YES;
        float offset = _scrollView.frame.size.width * (page+1);
        [_scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    }
}

- (IBAction)goPrevious:(id)sender{
    if (page>0 && !isAnimating) {
        isAnimating = YES;
        float offset = _scrollView.frame.size.width * (page-1);
        [_scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    }
}

- (IBAction)goGameScene:(id)sender{
    UIImageView *iv = [[_scrollView subviews]objectAtIndex:page];
    if (iv.tag == 1) {
        [UIView animateWithDuration:0.5f animations:^{
            viewLabelContainer.frame = CGRectMake(10, -55, 300, 30);
        } completion:^(BOOL finished) {
            [self performSegueWithIdentifier:@"showViewController" sender:sender];
        }];
    }
    else{
        int price = [[[setIds objectAtIndex:page] objectForKey:@"price"] intValue];
        NSString *message = [NSString stringWithFormat:@"Do you want to buy and unlock this package for %dQ coins?",price];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Not now" otherButtonTitles:@"Yes please!", nil];
        [alert show];
    }
}
- (IBAction)goBuy:(id)sender{
//    MyButton *button = (MyButton *)sender;
//    NSString *setId = button.setId;
//    
//    NSString *setId2 = [[setIds objectAtIndex:page] objectForKey:@"set_id"];
//    NSLog(@"NOTHING TO DO HERE : %@ :%@",setId, setId2);
    [self goGameScene:sender];
}

- (void)processBuyPackage{
    NSString *setId = [[setIds objectAtIndex:page] objectForKey:@"set_id"];
    int price = [[[setIds objectAtIndex:page] objectForKey:@"price"] intValue];
    if(userData.coins >= price){
        BOOL success = [FMDBAccess buyPackageWithSetId:setId];
        if (success) {
            userData.coins -= price;
            [FMDBAccess saveUserData:userData];
        }
        [self reload];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Failed" message:@"You do not have enough coins to buy this package." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark - UI STUFF
- (void)setDefaultUi{
    [self cleanup];
    float kScrollObjHeight = 200;
    float kScrollObjWidth = 220;
    page = 0;
    //Setup scrollview and its content
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [_scrollView setCanCancelContentTouches:NO];
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    _scrollView.clipsToBounds = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    
    // load all the images from our bundle and add them to the scroll view
    NSUInteger i;
    for (i = 0; i < setIds.count; i++){
        NSDictionary *temp = [setIds objectAtIndex:i];
//        NSString *imageName = [temp objectForKey:@"image_name"];
        BOOL isAvailable = [[temp objectForKey:@"is_available"] boolValue];
        MyButton *setButton = [[MyButton alloc]init];
        setButton.imageName = [temp objectForKey:@"image_name"];
        setButton.setId = [temp objectForKey:@"set_id"];
        setButton.layer.borderColor = [UIColor clearColor].CGColor;
        UIImage *image = [UIImage imageNamed:(isAvailable)?setButton.imageName:@"lock.png"];
        setButton.frame = (CGRect){.origin=CGPointZero,.size=image.size};
        [setButton setBackgroundImage:image forState:UIControlStateNormal];
        
       if(!isAvailable){
           [setButton addTarget:self action:@selector(goBuy:) forControlEvents:UIControlEventTouchUpInside];
       }
        setButton.backgroundColor = [UIColor clearColor];
        setButton.tag = isAvailable;
        setButton.contentMode =  UIViewContentModeScaleAspectFill| UIViewContentModeCenter;
        
        CGRect rect = setButton.frame;
        rect.origin.x = kScrollObjWidth *i;
        rect.size.height = kScrollObjHeight;
        rect.size.width = kScrollObjWidth;
        setButton.frame = rect;
        [_scrollView addSubview:setButton];
    }
    [_scrollView setContentSize:CGSizeMake((setIds.count * kScrollObjWidth), [_scrollView bounds].size.height)];
    [_scrollView setContentOffset:CGPointZero];
    //topLabel
    if (!viewLabelContainer) {
        viewLabelContainer = [[UIView alloc]init];
        viewLabelContainer.frame = CGRectMake(10, -55, 300, 30);
        viewLabelContainer.layer.borderColor = [UIColor whiteColor].CGColor;
        viewLabelContainer.layer.borderWidth = 1.0f;
        viewLabelContainer.layer.cornerRadius = 5.0f;
        [self.view addSubview:viewLabelContainer];
        
        UIImageView *coinImage = [[UIImageView alloc]init];
        coinImage.frame = CGRectMake(10, 7, 20,20);
        coinImage.image = [UIImage imageNamed:@"qCoin.png"];
        coinImage.backgroundColor = [UIColor clearColor];
        [viewLabelContainer addSubview:coinImage];
        
        labelCoins = [[UiLabelOutline alloc]init];
        labelCoins.frame = CGRectMake(33, 5, 250, 25);
        labelCoins.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
        labelCoins.textAlignment = UITextAlignmentLeft;
        labelCoins.textColor = UICOLOR_FROM_HEX(0xe3c332);
        labelCoins.backgroundColor = [UIColor clearColor];
        [viewLabelContainer addSubview:labelCoins];
    }
    else{
        viewLabelContainer.frame = CGRectMake(10, -55, 300, 30);
    }
    labelCoins.text = [NSString stringWithFormat:@"%d",userData.coins];
}

- (void)cleanup{
    for (UIView *view in [_scrollView subviews]) {
        if ([view respondsToSelector:@selector(removeFromSuperview)]) {
            [view removeFromSuperview];
        }
    }
}

- (void)reload{ //totally reloads the page together with all the data
    [UIView animateWithDuration:0.5f animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f animations:^{
            self.view.alpha = 1;
            [self setDefaultValues];
            [self setDefaultUi];
            [self animate];
        }];
    }];
}

- (void)animate{
    [UIView animateWithDuration:0.5f animations:^{
        viewLabelContainer.frame = CGRectMake(10, -5, 300, 30);
    }];
}

#pragma mark - Delegates / Events/ Protocols
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    page = scrollView.contentOffset.x / scrollView.frame.size.width;
    NSString *setId = [[setIds objectAtIndex:page] objectForKey:@"set_id"];
    gameSettings.setId = [setId intValue];
    [DataManager sharedInstance].gameSettings = gameSettings;
    isAnimating = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    page = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    NSString *setId = [[setIds objectAtIndex:page] objectForKey:@"set_id"];
    gameSettings.setId = [setId intValue];
    [DataManager sharedInstance].gameSettings = gameSettings;
    isAnimating = NO;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%d",buttonIndex);
    switch (buttonIndex) {
        case 0:
            //Cancelled;
            break;
        case 1:
            [self processBuyPackage];
            break;
        default:
            break;
    }
}

@end
