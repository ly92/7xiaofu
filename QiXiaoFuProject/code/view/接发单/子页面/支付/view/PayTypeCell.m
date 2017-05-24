//
//  PayTypeCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "PayTypeCell.h"

@interface PayTypeCell()




@end


@implementation PayTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)zhifubaoCheckBtnAction:(UIButton *)btn {
    
    if(btn.selected) return;
    
    btn.selected = !btn.selected;
    _alipayCheckBtn.selected = btn.selected;
    _wechatPayCheckBtn_D.selected =!btn.selected;
    _wechatPayCheckBtn.selected =!btn.selected;
    
    if (_payTypeCellBlobk) {
        _payTypeCellBlobk(1);
    }
    

}


- (IBAction)weixinCheckBtnAction:( UIButton *)btn {
    
    if(btn.selected) return;

    
    btn.selected = !btn.selected;
    _wechatPayCheckBtn.selected = btn.selected;
    _alipayCheckBtn_D.selected =!btn.selected;
    _alipayCheckBtn.selected =!btn.selected;
    if (_payTypeCellBlobk) {
        _payTypeCellBlobk(2);
    }
    
}

- (void)changeBtnState:(CGFloat )price{

    if (price == 0) {
        _alipayCheckBtn_D.selected =NO;
        _alipayCheckBtn.selected =NO;
        _wechatPayCheckBtn_D.selected =NO;
        _wechatPayCheckBtn.selected =NO;
        _aliPayTitle.text = [NSString stringWithFormat:@"支付宝"];
        _wechatPayTitleLab.text = [NSString stringWithFormat:@"微信支付"];
    }else{
    
        if (_alipayCheckBtn_D.selected) {
             _aliPayTitle.text = [NSString stringWithFormat:@"支付宝(支付¥%.2f)",price];
            _wechatPayTitleLab.text = [NSString stringWithFormat:@"微信支付"];
        }else{
            _aliPayTitle.text = [NSString stringWithFormat:@"支付宝"];
            _wechatPayTitleLab.text = [NSString stringWithFormat:@"微信支付(支付¥%.2f)",price];
         }
    
    }

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
