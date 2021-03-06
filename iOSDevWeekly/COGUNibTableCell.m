//
//  COGUNibTableCell.m
//  iOSDevWeekly
//
//  Created by Colin Günther on 14.08.12.
//  Copyright (c) 2012 Cogun. All rights reserved.
//

#import "COGUNibTableCell.h"

#import "NSArray+COGUAdditions.h"


@implementation COGUNibTableCell

+ (id)createCell;
{
    COGUNibTableCell* cell = [[NSBundle mainBundle] loadNibNamed:[self reuseIdentifier] owner:nil options:nil][0];

    [cell nibTableCellDidInitialize];

    return cell;
}


+ (NSString*)reuseIdentifier;
{
    return NSStringFromClass(self);
}


+ (CGFloat)preferredCellHeight;
{
    CGFloat preferredCellHeight = [[self createCell] frame].size.height;
    return preferredCellHeight;
}


- (void)nibTableCellDidInitialize;
{
}

@end
