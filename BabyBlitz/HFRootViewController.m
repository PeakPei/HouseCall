//
//  HFRootViewController.m
//  BabyBlitz
//
//  Created by Harrison Ferrone on 10/12/14.
//  Copyright (c) 2014 nexTIER Games. All rights reserved.
//

#import "HFRootViewController.h"

@interface HFRootViewController ()
@property (weak, nonatomic) IBOutlet UILabel *rootPhoneLinkLabel;
@property (strong, nonatomic) IBOutlet UIView *rootMainView;
@property (weak, nonatomic) IBOutlet UITextView *rootTextView;
@property (weak, nonatomic) IBOutlet UILabel *rootWebLinkLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rootImageView;

@end

@implementation HFRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.rootImageView.image = [UIImage imageNamed:@"RootScreen"];
    self.rootImageView.alpha = 0.5;

    self.rootTextView.text = @"HouseCall is a promotional touch-based game developed exclusively for Weissbluth Pediatrics.\n\n We are now offering house calls for our young patients, and we are the only practice in Chicago extending this service.\n\n Help us bring our doctors to your home!";
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(self.rootWebLinkLabel.frame, [[[event allTouches] anyObject] locationInView:self.rootMainView]))
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.weissbluthpediatrics.com"]];
    }

    if (CGRectContainsPoint(self.rootPhoneLinkLabel.frame, [[[event allTouches] anyObject] locationInView:self.rootMainView]))
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:312-202-0300"]];
    }
}

-(NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait) | (UIInterfaceOrientationMaskPortraitUpsideDown);
}

@end
