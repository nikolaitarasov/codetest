//
//  Customer.h
//  codetest
//
//  Created by Nikolai Tarasov on 9/17/16.
//  Copyright © 2016 Nikolai Tarasov. All rights reserved.
//

#import <Foundation/Foundation.h>

@import FirebaseDatabase;

@interface Customer : NSObject

@property(strong,nonatomic) NSString* customerKey;
@property(strong,nonatomic) NSString* firstName;
@property(strong,nonatomic) NSString* lastName;
@property(strong,nonatomic) NSString* dateOfBirth;
@property(strong,nonatomic) NSString* zipcode;

-(id) initWithCustomerKey:(NSString*) customerKey andDictionary:(NSDictionary*) customersDictionary;

@end
