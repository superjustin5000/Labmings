//
//  JobButtons.m
//  Lem
//
//  Created by Justin Fletcher on 7/10/14.
//  Copyright 2014 Justin Fletcher. All rights reserved.
//

#import "JobButtons.h"

@implementation JobButton

@synthesize type;

+(id)JobButtonWithType:(int)t {
    return [[self alloc] initWithType:t];
}

-(id)initWithType:(int)t {
    NSString *fileName = @"";
    switch (t) {
        case kJobPassiveParachute:
            fileName = @"ui_jobParachute.png";
            break;
            
        case kJobPassiveClimber:
            fileName = @"ui_jobClimber.png";
            break;
            
        case kJobBlocker:
            fileName = @"ui_jobBlocker.png";
            break;
            
        case kJobDigger:
            fileName = @"ui_jobDigger.png";
            break;
            
        case kJobDiggerDown:
            fileName = @"ui_jobDiggerDown.png";
            break;
            
        case kJobBuilder:
            fileName = @"ui_jobBuilder.png";
            break;
            
        case kJobTimeTraveler:
            fileName = @"ui_jobTimeTraveler.png";
            break;
            
        case kJobFlashLight:
            fileName = @"ui_jobFlashLight.png";
            break;
            
            
        case kJobBomber:
            fileName = @"ui_jobBomber.png";
            
        default:
            NSLog(@"not a valid job button was assigned when creating job buttons");
            break;
    }
    
    self = [super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:fileName]];
    
    type = t;
    
    
    
    
    
    
    
    
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;
    
    self.exclusiveTouch = NO;
    self.claimsUserInteraction = NO;
    
    
    
    return self;
}


-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    if (![GameState sharedGameState].paused) {
    
        [JobButtons getJobButtons].selectedJob = type;
        
        for (JobButton *j in [JobButtons getJobButtons]._jobButtons) {
            j.opacity = 0.5;
        }
        
        self.opacity = 1;
        
    }
    
}



@end









static JobButtons *jobButtons;

@implementation JobButtons


@synthesize selectedJob;
@synthesize _jobButtons;

+(JobButtons*)getJobButtons {
    if (!jobButtons)
        return NULL;
    return jobButtons;
}

+(id)jobButtonsWithButtons:(NSMutableArray *)jobButtonConstants {
    return [[self alloc] initWithButtons:jobButtonConstants];
}

-(id)initWithButtons:(NSMutableArray *)jobButtonConstants {
    self = [super init];
    
    
    
    
    selectedJob = kJobNone;
    
    nextButtonY = gs.winSize.height - 40;
    buttonX = 40;
    
    _jobButtons = [[NSMutableArray alloc] init];
    
    for (NSNumber *n in jobButtonConstants) {
        
        int i = [n intValue];
        
        [self addJobButtonWithType:i];
        
    }
    
    
    jobButtons = self;
    
    return self;
}


-(void)addJobButtonWithType:(int)type {
    
    JobButton *j = [JobButton JobButtonWithType:type];
    j.anchorPoint = ccp(0,1);
    j.position = ccp(buttonX, nextButtonY);
    j.opacity = 0.5;
    
    nextButtonY = nextButtonY - j.contentSize.height - 40;
    
    [hud addChild:j];
    
    [_jobButtons addObject:j];
    
    //NSLog(@"addingObject");
    
}


@end



