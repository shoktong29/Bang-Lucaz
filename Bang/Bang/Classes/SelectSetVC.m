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


- (void)viewDidLoad{
    gameSettings = [[DataManager sharedInstance]gameSettings];
    setIds = [FMDBAccess getSetIds];
    gameSettings.setId = [[[setIds objectAtIndex:0] objectForKey:@"set_id"] intValue];
    userData = [FMDBAccess loadUserData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setDefaultUi];
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

#pragma mark - UI STUFF
- (void)setDefaultUi{
    [self cleanup];
    float kScrollObjHeight = 200;
    float kScrollObjWidth = 220;
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
    for (i = 0; i < setIds.count; i++)
    {
        NSDictionary *temp = [setIds objectAtIndex:i];
        NSString *imageName = [temp objectForKey:@"image_name"];
        UIImage *image = [UIImage imageNamed:imageName];
        image.accessibilityHint = [temp objectForKey:@"set_id"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.contentMode =  UIViewContentModeScaleAspectFill| UIViewContentModeCenter;
        
        CGRect rect = imageView.frame;
        rect.origin.x = kScrollObjWidth *i;
        rect.size.height = kScrollObjHeight;
        rect.size.width = kScrollObjWidth;
        imageView.frame = rect;
        [_scrollView addSubview:imageView];
    }
    [_scrollView setContentSize:CGSizeMake((setIds.count * kScrollObjWidth), [_scrollView bounds].size.height)];
    
    //topLabel
    if (!viewLabelContainer) {
        viewLabelContainer = [[UIView alloc]init];
        viewLabelContainer.frame = CGRectMake(10, -5, 300, 30);
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
    labelCoins.text = [NSString stringWithFormat:@"%d",userData.coins];
}

- (void)cleanup{
    for (UIView *view in [_scrollView subviews]) {
        if ([view respondsToSelector:@selector(removeFromSuperview)]) {
            [view removeFromSuperview];
        }
    }
}

#pragma mark - Delegates / Events/ Protocols
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    page = scrollView.contentOffset.x / scrollView.frame.size.width;
    gameSettings.setId = [[[setIds objectAtIndex:page] objectForKey:@"set_id"] intValue];
    [DataManager sharedInstance].gameSettings = gameSettings;
    isAnimating = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    page = scrollView.contentOffset.x / scrollView.frame.size.width;
    gameSettings.setId = [[[setIds objectAtIndex:page] objectForKey:@"set_id"] intValue];
    [DataManager sharedInstance].gameSettings = gameSettings;
    isAnimating = NO;
}

@end
