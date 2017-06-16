//
//  STPickerDate.m
//  STPickerView
//
//  Created by https://github.com/STShenZhaoliang/STPickerView on 16/2/16.
//  Copyright © 2016年 shentian. All rights reserved.
//

#import "STPickerDate.h"
#import "NSCalendar+ST.h"
#define screenWith  [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
@interface STPickerDate()<UIPickerViewDataSource, UIPickerViewDelegate>
/** 1.年 */
@property (nonatomic, assign)NSInteger year;
/** 2.月 */
@property (nonatomic, assign)NSInteger month;
/** 3.日 */
@property (nonatomic, assign)NSInteger day;
/** 4.时 */
@property (nonatomic, assign)NSInteger hour;
/** 5.分 */
@property (nonatomic, assign)NSInteger minute;
/** 6.秒 */
//@property (nonatomic, assign)NSInteger minute;


@end

@implementation STPickerDate

#pragma mark - --- init 视图初始化 ---

- (void)setupUI {
    
    
    
    self.title = @"请选择日期";
    
    _yearLeast = 1900;
    _yearSum   = 200;
    _heightPickerComponent = 28;
    
    _year  = [NSCalendar currentYear];
    _month = [NSCalendar currentMonth];
    _day   = [NSCalendar currentDay];
    _hour   = [NSCalendar currentHour];
    _minute   = [NSCalendar currentMinute];

    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
    
    [self.pickerView selectRow:(_year - _yearLeast) inComponent:0 animated:NO];

    if(self.rows > 1){
        [self.pickerView selectRow:(_month-1) inComponent:1 animated:NO];
     }
    if(self.rows > 2){
        [self.pickerView selectRow:(_day-1) inComponent:2 animated:NO];
    }
    if (self.rows > 3) {
          [self.pickerView selectRow:(_hour) inComponent:3 animated:NO];
    }
    if (self.rows > 4) {
        [self.pickerView selectRow:(_minute) inComponent:4 animated:NO];
    }

}

#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.rows;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
 
    switch (component) {
            case 0:
        {
            return self.yearSum;
        }
            break;
            case 1:
        {
            return 12;
        }
            break;
            case 2:
        {
            NSInteger yearSelected = [pickerView selectedRowInComponent:0] + self.yearLeast;
            NSInteger monthSelected = [pickerView selectedRowInComponent:1] + 1;
            return  [NSCalendar getDaysWithYear:yearSelected month:monthSelected];
        }
            break;
            case 3:
        {
            return 24;
        }
            break;
            case 4:
        {
            return 60;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return self.heightPickerComponent;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(screenWith*component/6.0, 0,screenWith/6.0, 30)];
    label.font=[UIFont systemFontOfSize:15.0];
    label.tag=component*100+row;
    label.textAlignment=NSTextAlignmentCenter;
    switch (component) {
            case 0:
        {
            label.frame=CGRectMake(5, 0,screenWith/4.0, 30);
            label.text=[NSString stringWithFormat:@"%ld年",(long)(_yearLeast + row)];
        }
            break;
            case 1:
        {
            label.frame=CGRectMake(screenWith/4.0, 0, screenWith/8.0, 30);
            label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
        }
            break;
            case 2:
        {
            label.frame=CGRectMake(screenWith*3/8, 0, screenWith/8.0, 30);
            label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
        }
            break;
            case 3:
        {
            label.textAlignment=NSTextAlignmentRight;
            label.text=[NSString stringWithFormat:@"%ld时",(long)row];
        }
            break;
            case 4:
        {
            label.textAlignment=NSTextAlignmentRight;
            label.text=[NSString stringWithFormat:@"%ld分",(long)row];
        }
            break;
            case 5:
        {
            label.textAlignment=NSTextAlignmentRight;
            label.frame=CGRectMake(screenWith*component/6.0, 0, screenWith/6.0-5, 30);
            label.text=[NSString stringWithFormat:@"%ld秒",(long)row];
        }
            break;
            
        default:
            break;
    }
    return label;

}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
            case 0:
            if (self.rows > 1){
                [pickerView reloadComponent:1];
             }
            if (self.rows >2){
                 [pickerView reloadComponent:2];
            }
            break;
            case 1:
            if (self.rows > 2){
                [pickerView reloadComponent:2];
            }
        default:
            break;
    }
    
    [self reloadData];
}


#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
    if ([self.delegate respondsToSelector:@selector(pickerDate:year:month:day:hour:minute:)]) {
         [self.delegate pickerDate:self year:self.year month:self.month day:self.day hour:self.hour minute:self.minute];
    }
    
    NSString * selectTime =[NSString stringWithFormat:@"%ld.%.2ld.%.2ld %.2ld:%.2ld",self.year,self.month,self.day,self.hour ,self.minute];
    
    if (_pickerDate5Block) {
        _pickerDate5Block(self.year,self.month,self.day,self.hour,self.minute,selectTime);
    }
    if (_pickerDate4Block) {
        _pickerDate4Block(self.year,self.month,self.day,self.hour,selectTime);
    }
    if (_pickerDate3Block) {
        
        selectTime =[NSString stringWithFormat:@"%ld.%.2ld.%.2ld %.2ld:%.2ld",self.year,self.month,self.day,self.hour,self.minute];
        _pickerDate3Block(self.year,self.month,self.day,selectTime);
    }
    if (_pickerDate3EndBlock) {
        
        selectTime =[NSString stringWithFormat:@"%ld.%.2ld.%.2ld %.2d:%.2d",self.year,self.month,self.day,23,00];
        _pickerDate3EndBlock(self.year,self.month,self.day,selectTime);
    }
    if (_pickerDateAndRowBlock){
        selectTime =[NSString stringWithFormat:@"%ld.%.2ld.%.2ld %.2ld:%.2ld",self.year,self.month,self.day,self.hour,self.minute];
        _pickerDateAndRowBlock(self.year,self.month,self.day,self.rows,selectTime);
    }
    
    
    
    
    if (_pickerDate1Block) {
        _pickerDate1Block(self.year);
    }
    DeLog(@"-----  %@",selectTime);
    [super selectedOk];
}

#pragma mark - --- private methods 私有方法 ---

- (void)reloadData
{
    self.year  = [self.pickerView selectedRowInComponent:0] + self.yearLeast;

    if (self.rows > 1) {
        self.month = [self.pickerView selectedRowInComponent:1] + 1;
    }
    if (self.rows > 2) {
        self.day   = [self.pickerView selectedRowInComponent:2] + 1;
    }
    if (self.rows > 3) {
        self.hour   = [self.pickerView selectedRowInComponent:3] + 1;
    }
    if (self.rows > 4) {
        self.minute   = [self.pickerView selectedRowInComponent:4] + 1;
    }

}

#pragma mark - --- setters 属性 ---

- (void)setYearLeast:(NSInteger)yearLeast
{
    _yearLeast = yearLeast;
}

- (void)setYearSum:(NSInteger)yearSum
{
    _yearSum = yearSum;
}
#pragma mark - --- getters 属性 ---


@end


