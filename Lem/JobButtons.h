//
//  JobButtons.h
//  Lem
//
//  Created by Justin Fletcher on 7/10/14.
//  Copyright 2014 Justin Fletcher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "JHudNode.h"



@interface JobButton : CCSprite {
    int type;
}

@property(nonatomic)int type;

+(id)JobButtonWithType:(int)t;
-(id)initWithType:(int)t;

@end


@interface JobButtons : JHudNode {
    int selectedJob;
    NSMutableArray *_jobButtons;
    
    int nextButtonY;
    int buttonX;
}

@property(nonatomic)int selectedJob;
@property(nonatomic, retain)NSMutableArray *_jobButtons;

+(id)jobButtonsWithButtons:(NSMutableArray*)jobButtonConstants;
-(id)initWithButtons:(NSMutableArray*)jobButtonConstants;

+(JobButtons*)getJobButtons;


@end
