//
//  ZLProductCell.m
//  THE VOW
//
//  Created by libs on 14-4-11.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLProductCell.h"

@implementation ZLProductCell

//-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        HSStretchableImageView *imvbg=[[HSStretchableImageView alloc] initWithFrame:self.bounds];
        //imvBackground.image=[UIImage imageNamed:@"cellbgbro.png"];
        imvbg.image=[UIImage imageNamed:@"cell_bg_gray.png"];
        [imvbg stretchImage];
        self.backgroundView=imvbg;
        [imvbg release];
        
        HSStretchableImageView *imvbgselected=[[HSStretchableImageView alloc] initWithFrame:self.bounds];
        //imvBackground.image=[UIImage imageNamed:@"cellbgbro.png"];
        imvbgselected.image=[UIImage imageNamed:@"cell_bg_sel.png"];
        [imvbgselected stretchImage];
        self.selectedBackgroundView=imvbgselected;
        [imvbgselected release];
        
        locationLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, self.frame.size.width-10, 40.0)] autorelease];
        locationLabel.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_MIDDLE_FONT_SIZE];
        locationLabel.textColor=[UIColor whiteColor];
        locationLabel.backgroundColor=[UIColor clearColor];
        //locationLabel.font = [UIFont boldSystemFontOfSize:16.0];
        [self.contentView addSubview:locationLabel];
        
        dateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10.0, 42.0, 240.0, 14.0)] autorelease];
        dateLabel.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_SMALL_FONT_SIZE];
        //dateLabel.font = [UIFont systemFontOfSize:12.0];
        dateLabel.textColor=[UIColor whiteColor];
        dateLabel.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:dateLabel];
        
        magnitudeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(250.0, 32.0, 170.0, 29.0)] autorelease];
        //magnitudeLabel.font = [UIFont boldSystemFontOfSize:24.0];
        magnitudeLabel.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_BIG_FONT_SIZE];
        magnitudeLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        magnitudeLabel.textColor=[UIColor whiteColor];
        magnitudeLabel.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:magnitudeLabel];
        
        magnitudeImage = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"5.0.png"]] autorelease];
        CGRect imageFrame = magnitudeImage.frame;
        imageFrame.origin = CGPointMake(240.0, 8.0);
        //imageFrame.size = CGSizeMake(imageFrame.size.width, imageFrame.size.height);
		//imageFrame.size = CGSizeMake(imageFrame.size.width - 8.0, imageFrame.size.height - 8.0); // skring the image a little to fit
        magnitudeImage.frame = imageFrame;
        magnitudeImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:magnitudeImage];
        
        ////////////

       /*
        btnBuy=[HSStretchableButton buttonWithType:UIButtonTypeCustom];
        [btnBuy setBackgroundImage:[UIImage imageNamed:@"buttonGreen.png"] forState:UIControlStateNormal];
        btnBuy.frame=CGRectMake(225,35,60,30);
        [btnBuy stretchImage];
        [btnBuy setTitle:NSLocalizedString(@"Get It",nil) forState:UIControlStateNormal];
        btnBuy.titleLabel.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_SMALL_FONT_SIZE];
        [btnBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:btnBuy];
        [btnBuy addTarget:self action:@selector(onTapBuyProduct) forControlEvents:UIControlEventTouchUpInside];
        */
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setCellData:(Earthquake *)cellData
{
    ZLTRACE(@"location:%@__",cellData.location);
    self.productObject=cellData;
    locationLabel.text =  cellData.location;
    dateLabel.text = [NSString stringWithFormat:@"%@", [self.cellDelegate earthquakeCellFormatterDate:cellData.date]];
    magnitudeLabel.text = [NSString stringWithFormat:@"%.1f", [cellData.magnitude floatValue]];
    magnitudeImage.image = [self.cellDelegate earthquakeCellImageForMagnitude:[cellData.magnitude floatValue]];//[self imageForMagnitude:[cellData.magnitude floatValue]];
}

-(void)onTapBuyProduct
{
    [self.cellDelegate onTapBuyOneOfCell:self];
}
@end
