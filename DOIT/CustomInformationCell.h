//
//  CustomInformationCell.h
//  DOIT
//
//  Created by AppDev on 11-12-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomInformationCell : UITableViewCell{
    IBOutlet UILabel* informationTitle;
    IBOutlet UILabel* informationSummary;
    IBOutlet UIImageView* informationImg;
    NSMutableData *_data;
}

@property(nonatomic, retain) IBOutlet UILabel* informationTitle;
@property(nonatomic, retain) IBOutlet UILabel* informationSummary;
@property(nonatomic, retain) IBOutlet UIImageView* informationImg;
@property(nonatomic, retain) NSMutableData *data;

-(void) setCell:(NSString*)url title:(NSString*)title summary:(NSString*)summary;

@end
