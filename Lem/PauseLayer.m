//
//  PauseLayer.m
//  Lem
//
//  Created by Justin Fletcher on 7/13/14.
//  Copyright 2014 Justin Fletcher. All rights reserved.
//

#import "PauseLayer.h"


@implementation ExitButton


@end



@implementation RestartButton

-(id)initWithTexture:(CCTexture *)texture rect:(CGRect)rect {
    self = [super initWithTexture:texture rect:rect];
    
    
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;
    
    self.exclusiveTouch = NO;
    self.claimsUserInteraction = NO;
    
    
    return self;
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [[GameState sharedGameState].gameLevel restartLevel];
}

@end



@implementation ResumeButton

-(id)initWithTexture:(CCTexture *)texture rect:(CGRect)rect {
    self = [super initWithTexture:texture rect:rect];
    
    
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;
    
    self.exclusiveTouch = NO;
    self.claimsUserInteraction = NO;
    
    
    return self;
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [[GameState sharedGameState].gameLevel unpauseLevel];
}

@end




@implementation PauseLayer

-(id)init {
    self = [super initWithColor:[CCColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    
    RestartButton *restart = [RestartButton spriteWithImageNamed:@"restartButton.png"];
    restart.position = ccp([GameState sharedGameState].winSize.width/2 - 100, [GameState sharedGameState].winSize.height/2);
    [self addChild:restart];
    
    
    ResumeButton *resume = [ResumeButton spriteWithImageNamed:@"resumeButton.png"];
    resume.position = ccp([GameState sharedGameState].winSize.width/2 + 100, [GameState sharedGameState].winSize.height/2);
    [self addChild:resume];
    
    
    
    return self;
}


@end
