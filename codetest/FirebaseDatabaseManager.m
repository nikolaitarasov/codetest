//
//  FirebaseDatabaseManager.m
//  codetest
//
//  Created by Nikolai Tarasov on 9/15/16.
//  Copyright © 2016 Nikolai Tarasov. All rights reserved.
//

#import "FirebaseDatabaseManager.h"

@import FirebaseDatabase;

@implementation FirebaseDatabaseManager

+(FIRDatabaseReference*) sharedReference {
    static FIRDatabaseReference* databaseRef = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        databaseRef = [[FIRDatabase database] reference];
    });
    return databaseRef;
}

@end
