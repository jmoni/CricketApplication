//
//  StatsViewController.h
//  CricketApplication
//
//  Created by Rob Lloyd on 10/08/2012.
//  Copyright (c) 2012 JMoni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatsViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *playerEditTextBox;
@property (strong, nonatomic) IBOutlet UINavigationItem *NavBar;
@property (strong, nonatomic) IBOutlet UISwitch *CaptainSlider;
@property (strong, nonatomic) IBOutlet UISwitch *ViceCaptainSlider;
@property (strong, nonatomic) IBOutlet UISwitch *WicketKeeperSlider;
@property (strong, nonatomic) IBOutlet UILabel *ballsLabel;
@property (strong, nonatomic) IBOutlet UILabel *runsLabel;
@property (strong, nonatomic) IBOutlet UILabel *wayOutLabel;

- (IBAction)textFieldReturn:(id)sender;
- (IBAction)backgroundTouched:(id)sender;
- (IBAction)deletePlayer:(id)sender;
@end