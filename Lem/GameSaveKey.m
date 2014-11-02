//
//  GameSaveKey.m
//  ThisShipWillSelfDestruct
//
//  Created by Justin Fletcher on 6/27/12.
//  Copyright 2012 Justin Fletcher. All rights reserved.
//

#import "GameSaveKey.h"


@implementation GameSaveKey

@synthesize name, dataType;
@synthesize intValue;
@synthesize floatValue;
@synthesize doubleValue;
@synthesize boolValue;
@synthesize object;


+(id)keyWithInt:(int)keyInt andName:(NSString *)keyName {
    return [[self alloc] initWithInt:keyInt andName:keyName];
}
+(id)keyWithFloat:(float)keyFloat andName:(NSString *)keyName {
    return [[self alloc] initWithFloat:keyFloat andName:keyName];
}
+(id)keyWithDouble:(double)keyDouble andName:(NSString *)keyName {
    return [[self alloc] initWithDouble:keyDouble andName:keyName];
}
+(id)keyWithBool:(BOOL)keyBool andName:(NSString *)keyName {
    return [[self alloc] initWithBool:keyBool andName:keyName];
}
+(id)keyWithObject:(id)keyObject andName:(NSString *)keyName {
    return [[self alloc] initWithObject:keyObject andName:keyName];
}



-(id)initWithName:(NSString *)keyName andDataType:(NSString *)keyDataType {
    if ((self = [super init])) {
        name = keyName;
        dataType = keyDataType;
    }
    return self;
}



-(id)initWithInt:(int)keyInt andName:(NSString *)keyName {
    intValue = keyInt;
    return [self initWithName:keyName andDataType:@"int"];
}
-(id)initWithFloat:(float)keyFloat andName:(NSString *)keyName {
    floatValue = keyFloat;
    return [self initWithName:keyName andDataType:@"float"];
}
-(id)initWithDouble:(double)keyDouble andName:(NSString *)keyName {
    doubleValue = keyDouble;
    return [self initWithName:keyName andDataType:@"double"];
}
-(id)initWithBool:(BOOL)keyBool andName:(NSString *)keyName {
    boolValue = keyBool;
    return [self initWithName:keyName andDataType:@"bool"];
}
-(id)initWithObject:(id)keyObject andName:(NSString *)keyName {
    object = keyObject;
    return [self initWithName:keyName andDataType:@"object"];
}




-(void)updateInt:(int)value {
    intValue = value;
}
-(void)updateFloat:(float)value {
    floatValue = value;
}
-(void)updateDouble:(double)value {
    doubleValue = value;
}
-(void)updateBool:(BOOL)value {
    boolValue = value;
}
-(void)updateObject:(id)value {
    object = value;
}


-(void)resetValues {
    intValue = 0;
    floatValue = 0.0f;
    doubleValue = 0.0;
    boolValue = NO;
    object = NULL;
}


@end
