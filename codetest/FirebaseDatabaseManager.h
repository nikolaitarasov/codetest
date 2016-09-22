//
//  FirebaseDatabaseManager.h
//  codetest
//
//  Created by Nikolai Tarasov on 9/15/16.
//  Copyright © 2016 Nikolai Tarasov. All rights reserved.
//

#import <Foundation/Foundation.h>

@import FirebaseDatabase;

@interface FirebaseDatabaseManager : NSObject

+(FIRDatabaseReference*) sharedReference;

@end
