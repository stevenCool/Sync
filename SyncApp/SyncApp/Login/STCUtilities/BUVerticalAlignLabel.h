//
//  BUVerticalAlignLabel.h
//  QMGLegend
//
//  Created by Xue Yan on 11-10-10.
//  Copyright 2011年 ShootingChance. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum VerticalAlignment {
    VerticalAlignmentTop,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface BUVerticalAlignLabel : UILabel {
@private
    VerticalAlignment verticalAlignment_;
}

@property (nonatomic, assign) VerticalAlignment verticalAlignment;

@end
