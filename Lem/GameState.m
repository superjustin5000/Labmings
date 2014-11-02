//
//  gameState.m
//
//  Created by Justin Fletcher on 6/27/12.
//  Copyright 2012 Justin Fletcher. All rights reserved.
//

#import "GameState.h"


@implementation GameState

@synthesize gameScene, gameLevel;

/////SAVED



///// NOT SAVED
@synthesize gameFont;
@synthesize winSize;
@synthesize FPSwanted, gameDelta;
@synthesize gameSpeed;
@synthesize paused;


@synthesize player, playerPos, playerRect;
@synthesize _jSprites;
@synthesize _bullets, _attacks, _enemies, _otherShooters;
@synthesize _lems;

- (id)init
{
	if (( self = [super init] ))
	{
        
        FPSwanted = 60.0f;
        gameDelta = 1/FPSwanted;
        gameSpeed = 1.0f;
        gameFont = @"Volter (Goldfish)";
        winSize = [[CCDirector sharedDirector] viewSize];
        paused = NO;
        
        
        _jSprites = [[NSMutableArray alloc] init];
        
        _enemies = [[NSMutableArray alloc] init];
        _bullets = [[NSMutableArray alloc] init];
        _attacks = [[NSMutableArray alloc] init];
        _otherShooters = [[NSMutableArray alloc] init];
        
        _lems = [[NSMutableArray alloc] init];
        
        
	}
	return self;
	
}




+(GameState *)sharedGameState {
	
	static GameState *sharedGameState;
	@synchronized(self) {
		if (!sharedGameState) {
			sharedGameState = [[GameState alloc] init];
		}
	}
	return sharedGameState;
	
}







///override get player method from synthesize player.










-(int)randomNumberFrom:(int)from To:(int)to {
    int newTo = to + 1;
    int range = newTo - from;
    int random = (arc4random() % range) + from;
    return random;
}


-(float)random0to1withDeviation:(float)deviation {  ////// returns a random between 0 and 1 plus the deviaton.
	
	float randomNum = (random() / (float)0x7fffffff ) + deviation;
	
	return randomNum;
	
}





-(CGRect)rectByFlippingRect:(CGRect)r OverXAxis:(int)x {
    int newX = x - ( ( r.origin.x + r.size.width ) - x );
    return CGRectMake(newX, r.origin.y, r.size.width, r.size.height);
}




//////////////////// ---------------- A N I M A T I O N . F R A M E S




-(NSMutableArray *)framesWithFrameName:(NSString *)framename fromFrame:(int)fromF toFrame:(int)toF { ///creates an array of sprite frames for an animation with no reverse frames added.
    
    return [self framesWithFrameName:framename fromFrame:fromF toFrame:toF andReverse:NO andAntiAlias:NO];
    
}

-(NSMutableArray *)framesWithFrameName:(NSString *)framename fromFrame:(int)fromF toFrame:(int)toF andAntiAlias:(BOOL)antialias {
    
    return [self framesWithFrameName:framename fromFrame:fromF toFrame:toF andReverse:NO andAntiAlias:antialias];
    
}

-(NSMutableArray *)framesWithFrameName:(NSString *)framename fromFrame:(int)fromF toFrame:(int)toF andReverse:(BOOL)reverse andAntiAlias:(BOOL)antialias { ///creates an array of sprite frames for an animation with an option to attach reverse frames at the end.
    
    return [self framesWithFrameName:framename fromFrame:fromF toFrame:toF andReverse:reverse andAntiAlias:antialias andAppendedString:NULL];
    
}



-(NSMutableArray *)framesWithFrameName:(NSString *)framename fromFrame:(int)fromF toFrame:(int)toF andReverse:(BOOL)reverse andAntiAlias:(BOOL)antialias andAppendedString:(NSString *)appended {
    
    //NSLog(@"adding %s", framename.UTF8String);
    
    NSMutableArray *_array = [NSMutableArray array];
    if (fromF <= toF) {
        for (int i=fromF; i<=toF; ++i) {
            
            NSString *newName = [framename stringByAppendingString:[NSString stringWithFormat:@"%d.png", i]];
            if (appended != NULL)
                newName = [framename stringByAppendingString:[NSString stringWithFormat:@"%d%@.png", i, appended]];
            if (!antialias) { [[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:newName].texture setAntialiased:false]; }
            [_array addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:newName]];
            
            
        }
        
        if (reverse) {
            
            for (int i=toF; i>=fromF; --i) {
                
                NSString *newName = [framename stringByAppendingString:[NSString stringWithFormat:@"%d.png", i]];
                if (appended != NULL)
                    newName = [framename stringByAppendingString:[NSString stringWithFormat:@"%d%@.png", i, appended]];
                if (!antialias) { [[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:newName].texture setAntialiased:false]; }
                [_array addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:newName]];
                
            }
            
        }
    }
    else {
        for (int i=fromF; i>=toF; --i) {
            
            NSString *newName = [framename stringByAppendingString:[NSString stringWithFormat:@"%d.png", i]];
            if (appended != NULL)
                newName = [framename stringByAppendingString:[NSString stringWithFormat:@"%d%@.png", i, appended]];
            if (!antialias) { [[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:newName].texture setAntialiased:false]; }
            [_array addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:newName]];
            
            
        }
        
        if (reverse) {
            
            for (int i=toF; i<=fromF; ++i) {
                
                NSString *newName = [framename stringByAppendingString:[NSString stringWithFormat:@"%d.png", i]];
                if (appended != NULL)
                    newName = [framename stringByAppendingString:[NSString stringWithFormat:@"%d%@.png", i, appended]];
                if (!antialias) { [[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:newName].texture setAntialiased:false]; }
                [_array addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:newName]];
                
            }
            
        }
    }
    
    return _array;
    
}








@end







