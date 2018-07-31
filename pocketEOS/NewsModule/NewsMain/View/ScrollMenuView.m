//
//  ScrollMenuView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/5.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ScrollMenuView.h"

@interface ScrollMenuView()
@property(nonatomic , strong) UIScrollView *menuScrollView;
@property(nonatomic , strong) NSMutableArray *menuScrollViewBtnArray;
@property(nonatomic , strong) NSMutableArray *menuScrollViewBottomLineArray;
@end

@implementation ScrollMenuView

- (UIScrollView *)menuScrollView{
    if (!_menuScrollView) {
        _menuScrollView = [[UIScrollView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, MENUSCROLLVIEW_HEIGHT))];
        _menuScrollView.backgroundColor = [UIColor clearColor];
        _menuScrollView.showsVerticalScrollIndicator = NO;
        _menuScrollView.showsHorizontalScrollIndicator = NO;
        _menuScrollView.backgroundColor = HEXCOLOR(0xFFFFFF);
        if (@available(iOS 11.0, *)) {
            _menuScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _menuScrollView;
}
- (BaseSlimLineView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[BaseSlimLineView alloc] init];
    }
    return _bottomLineView;
}
- (NSMutableArray *)menuScrollViewBtnArray{
    if (!_menuScrollViewBtnArray) {
        _menuScrollViewBtnArray = [NSMutableArray array];
    }
    return _menuScrollViewBtnArray;
}

- (NSMutableArray *)menuScrollViewBottomLineArray{
    if (!_menuScrollViewBottomLineArray) {
        _menuScrollViewBottomLineArray = [[NSMutableArray alloc] init];
    }
    return _menuScrollViewBottomLineArray;
}

- (void)updateViewWithAssestsArray:(NSArray<Assest *> *)assestsArray{
    [self addSubview:self.menuScrollView];
    UIView *lastView;
    CGFloat totalWidth =0;
    for (int i = 0 ; i < assestsArray.count ; i++) {
        Assest *model = assestsArray[i];
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:15],
                                     NSForegroundColorAttributeName:HEXCOLOR(0x9B9B9B)
                                     };
        CGSize calculatedSize = [model.assetName boundingRectWithSize:CGSizeMake(100, MENUSCROLLVIEW_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
        
        CGFloat itemWidth = calculatedSize.width + MENUSCROLLVIEW_ITEM_WIDTH;
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake(lastView.right_sd , 0, itemWidth, MENUSCROLLVIEW_HEIGHT- MENUSCROLLVIEW_BOTTOM_LINE_HEIGHT);
        totalWidth += itemWidth;
        [btn setTitle:model.assetName forState:(UIControlStateNormal)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [btn setTitleColor:HEXCOLOR(0x9B9B9B) forState:(UIControlStateNormal)];
        [btn setTitleColor:HEXCOLOR(0x4F7DFE) forState:(UIControlStateSelected)];
        [btn setBackgroundColor:HEXCOLOR(0xFFFFFF)];
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(menuScrollViewItemBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_menuScrollView addSubview:btn];
        [self.menuScrollViewBtnArray addObject:btn];
        
        UIView *bottomLineView = [[UIView alloc] init];
        bottomLineView.tag = btn.tag;
        [_menuScrollView addSubview:bottomLineView];
        
        bottomLineView.sd_layout.centerXEqualToView(btn).widthIs(calculatedSize.width).heightIs(MENUSCROLLVIEW_BOTTOM_LINE_HEIGHT).bottomSpaceToView(_menuScrollView, 0);
        [self.menuScrollViewBottomLineArray addObject:bottomLineView];
        
        // defalut select item 0
        if (i == 0) {
            btn.selected = YES;
            bottomLineView.backgroundColor = HEXCOLOR(0x4F7DFE);
        }
        
        lastView = btn;
    }
    _menuScrollView.contentSize = CGSizeMake(totalWidth, MENUSCROLLVIEW_HEIGHT);
    
    [self addSubview:self.bottomLineView];
    self.bottomLineView.sd_layout.leftSpaceToView(self, 0).bottomSpaceToView(self, 0).rightSpaceToView(self, 0).heightIs(1);
}

- (void)menuScrollViewItemBtnClick:(UIButton *)sender{
    for (UIButton *btn in self.menuScrollViewBtnArray) {
        if ([btn isEqual:sender]) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    for (UIView *lineView in self.menuScrollViewBottomLineArray) {
        if (lineView.tag == sender.tag) {
            lineView.backgroundColor = HEXCOLOR(0x4F7DFE);
        }else{
            lineView.backgroundColor = [UIColor clearColor];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuScrollViewItemBtnDidClick:)]) {
        [self.delegate menuScrollViewItemBtnDidClick:sender];
    }
}

@end
