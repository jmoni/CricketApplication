//
//  DatabaseController.h
//  CricketApplication
//
//  Created by Miranda Aperghis on 06/08/2012.
//  Copyright (c) 2012 JMoni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface DatabaseController : UITabBarController{
    UIBarButtonItem *saveButton;
    NSString		*writableDBPath;
    sqlite3         *cricketDB;
}
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;

- (IBAction)saveData:(id)sender;

@end
