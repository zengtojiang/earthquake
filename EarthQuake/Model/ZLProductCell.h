//
//  ZLProductCell.h
//  THE VOW
//
//  Created by libs on 14-4-11.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSStretchableImageView.h"
#import "HSStretchableButton.h"
#import "Earthquake.h"

@protocol ZLProductCellDelegate;
@interface ZLProductCell : UICollectionViewCell
{
    UILabel         *locationLabel;//名字
    UILabel         *dateLabel;//标价
    UILabel         *magnitudeLabel;//描述
    UIImageView     *magnitudeImage;
   // HSStretchableButton        *btnBuy;
}
@property(nonatomic,assign)id<ZLProductCellDelegate> cellDelegate;
@property(nonatomic,assign)Earthquake *productObject;

-(void)setCellData:(Earthquake *)cellData;

@end

@protocol ZLProductCellDelegate <NSObject>

-(UIImage *)earthquakeCellImageForMagnitude:(float)magnitude;

-(NSString *)earthquakeCellFormatterDate:(NSDate *)date;

@optional
-(void)onTapBuyOneOfCell:(ZLProductCell *)cell;




@end