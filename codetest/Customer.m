//
//  Customer.m
//  codetest
//
//  Created by Nikolai Tarasov on 9/17/16.
//  Copyright © 2016 Nikolai Tarasov. All rights reserved.
//

#import "Customer.h"
#import "FirebaseDatabaseManager.h"

@import FirebaseDatabase;

@implementation Customer

-(id) initWithCustomerKey:(NSString*) customerKey andDictionary:(NSDictionary*) customersDictionary {
    self = [super init];
    
    if (self) {
        _customerKey = customerKey;
        _firstName = [customersDictionary valueForKey:@"firstName"];
        _lastName = [customersDictionary valueForKey:@"lastName"];
        _dateOfBirth = [customersDictionary valueForKey:@"dateOfBirth"];
        _zipcode = [customersDictionary valueForKey:@"zipcode"];
    }
    return self;
}


@end
