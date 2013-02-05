//
//  HTListViewDelegate.h
//  HTListView
//
//  Created by Hai Trieu on 11/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HTListViewDelegate <NSObject>

@optional

-(void)processResponse:(NSString*)responseString;

@end
