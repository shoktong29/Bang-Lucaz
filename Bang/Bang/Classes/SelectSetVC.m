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
}


- (void)viewDidLoad{
    gameSettings = [[DataManager sharedInstance]gameSettings];
    gameSettings.setId = 1;
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

- (void)setDefaultUi{
    NSArray *kill = [FMDBAccess getSetIds];
    
    float kScrollObjHeight = 100;
    float kScrollObjWidth = 240;
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
	for (i = 0; i < kill.count; i++)
	{
        NSDictionary *temp = [kill objectAtIndex:i];
		NSString *imageName = [temp objectForKey:@"image_name"];
		UIImage *image = [UIImage imageNamed:imageName];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeCenter;
		
		CGRect rect = imageView.frame;
        rect.origin.x = kScrollObjWidth *i;
		rect.size.height = kScrollObjHeight;
		rect.size.width = kScrollObjWidth;
		imageView.frame = rect;
		[_scrollView addSubview:imageView];
	}
	[_scrollView setContentSize:CGSizeMake((kill.count * kScrollObjWidth), [_scrollView bounds].size.height)];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    gameSettings.setId = page+1; //+1 because setid starts at 1;
    [DataManager sharedInstance].gameSettings = gameSettings;
}
@end
