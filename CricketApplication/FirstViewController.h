//
//  FirstViewController.h
//  CricketApplication
//
//  Created by Rob Lloyd on 30/07/2012.
//  Copyright (c) 2012 JMoni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UIActionSheetDelegate>{
    UITextField *homeTeamEntered;
    UITextField *awayTeamEntered;
    IBOutlet UIDatePicker *myPicker;
}

@property (strong, nonatomic) IBOutlet UITextField *homeTeamEntered;
@property (strong, nonatomic) IBOutlet UITextField *awayTeamEntered;
@property (strong, nonatomic) IBOutlet UIButton *dateButton;
@property (strong, nonatomic) IBOutlet UILabel *dateText;
@property (nonatomic, retain) UIDatePicker *myPicker;


- (IBAction) showActionSheet: (id) sender;

@end