//
//  LookAroundSpaceCell.m
//  wowo
//
//  Created by Donal on 13-7-20.
//  Copyright (c) 2013年 Donal. All rights reserved.
//

#import "LookAroundSpaceCell.h"
#import "Tool.h"

@interface CompositeSubviewBasedApplicationCellContentView : UIView
{
    LookAroundSpaceCell *_cell;
    BOOL _highlighted;
}

@end

@implementation CompositeSubviewBasedApplicationCellContentView

- (id)initWithFrame:(CGRect)frame cell:(LookAroundSpaceCell *)cell
{
    
    if (self = [super initWithFrame:frame])
    {
        _cell = cell;
        
        self.opaque = YES;
        self.backgroundColor = _cell.backgroundColor;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    _highlighted ? [[UIColor whiteColor] set] : [[UIColor blackColor] set];
    [_cell.name drawInRect:CGRectMake(78.0, 20.0, 120.0, 21.0) withFont:[UIFont systemFontOfSize:17.0]];
    
    _highlighted ? [[UIColor whiteColor] set] : [[UIColor colorWithRed:118.0/255.0 green:118.0/255.0 blue:118.0/255.0 alpha:1.0] set];
    [_cell.memberCount drawAtPoint:CGPointMake(78.0, 45.0) withFont:[UIFont boldSystemFontOfSize:13.0]];

    float i = [Tool getTextViewWitdthWithUIFont:[UIFont boldSystemFontOfSize:13.0] andText:[NSString stringWithFormat:@"成员数:%@", [_cell.space objectForKey:@"memberCount"]]];
    _highlighted ? [[UIColor whiteColor] set] : [[UIColor colorWithRed:118.0/255.0 green:118.0/255.0 blue:118.0/255.0 alpha:1.0] set];
    [_cell.activeCount drawAtPoint:CGPointMake(98.0+i, 45.0) withFont:[UIFont boldSystemFontOfSize:13.0]];
    
//    [_cell.seperateImage drawAtPoint:CGPointMake(0, rect.size.height-1)];
    
}

- (void)setHighlighted:(BOOL)highlighted
{
    _highlighted = highlighted;
    [self setNeedsDisplay];
}

- (BOOL)isHighlighted
{
    return _highlighted;
}

@end

#pragma mark -

@implementation LookAroundSpaceCell

@synthesize useDarkBackground, icon, iconCover, name, memberCount, activeCount,seperateImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        cellContentView = [[CompositeSubviewBasedApplicationCellContentView alloc] initWithFrame:CGRectInset(self.contentView.bounds, 0.0, 1.0) cell:self];
        cellContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        cellContentView.contentMode = UIViewContentModeRedraw;
        [self.contentView addSubview:cellContentView];
        
        icon = [[UIImageView alloc] initWithFrame:CGRectMake(14, 11, 53, 53)];
        [icon setContentMode:UIViewContentModeScaleAspectFill];
        [icon setClipsToBounds:YES];
        [self.contentView addSubview:icon];
        
        iconCover = [[UIImageView alloc] initWithFrame:CGRectMake(14, 11, 53, 53)];
        [iconCover setContentMode:UIViewContentModeScaleAspectFill];
        [iconCover setClipsToBounds:YES];
        [iconCover setImage:[UIImage imageNamed:@"spaceCoverBackground.png"]];
        [self.contentView addSubview:iconCover];
        
        seperateImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divider.png"]];
        [seperateImage setFrame:CGRectMake(0, 77, 320, 2)];
        [self.contentView addSubview:seperateImage];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [UIView setAnimationsEnabled:NO];
    CGSize contentSize = cellContentView.bounds.size;
    cellContentView.contentStretch = CGRectMake(225.0 / contentSize.width, 0.0, (contentSize.width - 260.0) / contentSize.width, 1.0);
    
    [UIView setAnimationsEnabled:YES];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    cellContentView.backgroundColor = backgroundColor;
}

@end
