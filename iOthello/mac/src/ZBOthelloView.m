/* vim: set expandtab tabstop=4 shiftwidth=4 foldmethod=marker: */
// +------------------------------------------------------------------------+
// | iOthello - Othello for Mac and iPhone                                  |
// +------------------------------------------------------------------------+
// | Copyright (c) 2007 Zack Bartel                                         |
// +------------------------------------------------------------------------+
// | This program is free software; you can redistribute it and/or          |
// | modify it under the terms of the GNU General Public License            | 
// | as published by the Free Software Foundation; either version 2         | 
// | of the License, or (at your option) any later version.                 |
// |                                                                        |
// | This program is distributed in the hope that it will be useful,        |
// | but WITHOUT ANY WARRANTY; without even the implied warranty of         |
// | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          |
// | GNU General Public License for more details.                           |
// |                                                                        |
// | You should have received a copy of the GNU General Public License      |
// | along with this program; if not, write to the Free Software            |
// | Foundation, Inc., 59 Temple Place - Suite 330,                         |
// | Boston, MA  02111-1307, USA.                                           |
// +------------------------------------------------------------------------+
// | Author: Zack Bartel <zack@bartel.com>                                  |
// +------------------------------------------------------------------------+ 


#import "ZBOthelloView.h"
#import "ZBOthelloCell.h"
#import "ZBOthelloController.h"


@implementation ZBOthelloView

- (id)initWithFrame:(NSRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        board = [[ZBOthelloBoard alloc] initWithRect:CGRectMake(
                                                        frame.origin.x,
                                                        frame.origin.y,
                                                        frame.size.width,
                                                        frame.size.height)
                                        Dimension: 8];
        [self initImages];
    }
    return self;
}

- (void)awakeFromNib
{
    [controller setBoard: board];
}

- (void)drawRect:(NSRect)r 
{
    int i;
    int j;
    CGRect rect = CGRectMake(r.origin.x, r.origin.y, r.size.width, r.size.height);
    float cellWidth = rect.size.width/DIMENSION;
    float cellHeight = rect.size.height/DIMENSION;
    float black[4] = {0, 0, 0, 1};
    
    CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];

    CGContextDrawImage(ctx, rect, backImage);
    
    int dimension = [board dimension];
    
    for (i = 0; i < dimension; i++)
    {
        for (j = 0; j < dimension; j++)
        {
            [self renderCell: [board cellAtX: i Y:j]];
        }
    }
//Draw Board
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetFillColor(ctx, black);

    for ( i = 0; i < dimension; i++ ) 
    {
        //Vertical
        CGContextBeginPath(ctx);      
        CGContextMoveToPoint(ctx, i * cellWidth, 0);
        CGContextAddLineToPoint(ctx, i * cellWidth, rect.size.height);
        CGContextClosePath(ctx);
        CGContextDrawPath(ctx, kCGPathFillStroke);
        //Horizontal
        CGContextBeginPath(ctx);      
        CGContextMoveToPoint(ctx, 0, (i * cellHeight));
        CGContextAddLineToPoint(ctx, rect.size.width, (i * cellHeight) );
        CGContextClosePath(ctx);
        CGContextDrawPath(ctx, kCGPathFillStroke);
    }

}

- (void)mouseDown:(NSEvent *)event
{
    NSRect rect = [self frame];
    
    int dimension = [board dimension];
    
    NSPoint point = [event locationInWindow];
   
    int cellWidth = (int)rect.size.width/dimension;
    int cellHeight = (int)rect.size.height/dimension;
    
    int x = (int)point.x / cellWidth;
    int y = (int)point.y / cellHeight;
    
    [controller cellClicked: [board cellAtX: x Y: y]];
    
    [self setNeedsDisplay: YES];
    
}

- (void)renderCell:(ZBOthelloCell *)cell
{
    CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];

    if ([cell owner] == Black)
    {
        CGContextDrawImage(ctx, [cell rect], blackImage);
    }
    else if ([cell owner] == White)
    {
        CGContextDrawImage(ctx, [cell rect], whiteImage);
    }
}


- (void) initImages
{

    CFStringRef path;
    CFURLRef url;
    CGDataProviderRef provider;
    NSString *p;

    //Background
    p = [[NSBundle mainBundle] pathForResource: @"background" ofType: @"jpg"];

    path = CFStringCreateWithCString(NULL, 
                                [p cStringUsingEncoding: NSASCIIStringEncoding], 
                                kCFStringEncodingUTF8);

    url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, 0);
    provider = CGDataProviderCreateWithURL(url);

    CFRelease(path);
    CFRelease(url);

    backImage = CGImageCreateWithJPEGDataProvider(provider, NULL, true, kCGRenderingIntentDefault);

    CGDataProviderRelease(provider);

    //White image
    p = [[NSBundle mainBundle] pathForResource: @"white" ofType: @"png"];
    path = CFStringCreateWithCString(NULL, 
                                [p cStringUsingEncoding: NSASCIIStringEncoding], 
                                kCFStringEncodingUTF8);

    url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, 0);
    provider = CGDataProviderCreateWithURL(url);

    CFRelease(path);
    CFRelease(url);
    whiteImage = CGImageCreateWithPNGDataProvider(provider, NULL, true, kCGRenderingIntentDefault);
    
    CGDataProviderRelease(provider);

    //Black image
    p = [[NSBundle mainBundle] pathForResource: @"black" ofType: @"png"];
    path = CFStringCreateWithCString(NULL, 
                                [p cStringUsingEncoding: NSASCIIStringEncoding], 
                                kCFStringEncodingUTF8);

    url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, 0);
    provider = CGDataProviderCreateWithURL(url);

    CFRelease(path);
    CFRelease(url);
    blackImage = CGImageCreateWithPNGDataProvider(provider, NULL, true, kCGRenderingIntentDefault);
    
    CGDataProviderRelease(provider);
}

- (ZBOthelloBoard *)board
{
    return board;
}

@end
