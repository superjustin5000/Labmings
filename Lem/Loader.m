//
//  Loader.m
//  Lem
//
//  Created by Justin Fletcher on 7/7/14.
//  Copyright 2014 Justin Fletcher. All rights reserved.
//

#import "Loader.h"

#import "Menu.h"


@implementation Loader


-(id)init {
    self = [super init];
    
    double time = CACurrentMediaTime();
    NSLog(@"loading.....");
    
    
    ////load assets here.
    
    //CCSpriteFrame *playerTest = [CCSpriteFrame frameWithImageNamed:@"pplayer.png"];
    //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:playerTest name:@"pplayer.png"];
    
    
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"spritesheet_test.plist" textureFilename:@"spritesheet_test.png"];
    
    
    
    time = CACurrentMediaTime() - time;
    NSLog(@"finished loading - total time to load assets was approx : %f Seconds", time);
    
    
    return self;
}


-(CCScene*)startLevel {
    
    return [Menu scene];
    
}



@end
