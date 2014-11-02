//
//  GameSaveKey.h
//  ThisShipWillSelfDestruct
//
//  Created by Justin Fletcher on 6/27/12.
//  Copyright 2012 Justin Fletcher. All rights reserved.
//

#ifndef __GAMESAVEKEY_H__
#define __GAMESAVEKEY_H__

#import <Foundation/Foundation.h>

@interface GameSaveKey : NSObject {
    NSString *name;
    NSString *dataType;
    int intValue;
    float floatValue;
    double doubleValue;
    BOOL boolValue;
    id object;
}

@property(nonatomic, readonly)NSString *name;
@property(nonatomic, readonly)NSString *dataType;
@property(nonatomic, readonly)int intValue;
@property(nonatomic, readonly)float floatValue;
@property(nonatomic, readonly)double doubleValue;
@property(nonatomic, readonly)BOOL boolValue;
@property(nonatomic, readonly)id object;


+(id)keyWithInt:(int)keyInt andName:(NSString*)keyName;
+(id)keyWithFloat:(float)keyFloat andName:(NSString*)keyName;
+(id)keyWithDouble:(double)keyDouble andName:(NSString*)keyName;
+(id)keyWithBool:(BOOL)keyBool andName:(NSString*)keyName;
+(id)keyWithObject:(id)keyObject andName:(NSString*)keyName;

-(id)initWithInt:(int)keyInt andName:(NSString*)keyName;
-(id)initWithFloat:(float)keyFloat andName:(NSString*)keyName;
-(id)initWithDouble:(double)keyDouble andName:(NSString*)keyName;
-(id)initWithBool:(BOOL)keyBool andName:(NSString*)keyName;
-(id)initWithObject:(id)keyObject andName:(NSString*)keyName;

-(id)initWithName:(NSString*)keyName andDataType:(NSString*)keyDataType;

-(void)updateInt:(int)value;
-(void)updateFloat:(float)value;
-(void)updateDouble:(double)value;
-(void)updateBool:(BOOL)value;
-(void)updateObject:(id)value;

-(void)resetValues;

@end


#endif
