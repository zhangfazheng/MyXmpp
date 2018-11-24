//
//  EquipmentTextFieldCell.m
//  OperationEquipment
//
//  Created by 张发政 on 2017/3/20.
//  Copyright © 2017年 cyberplus. All rights reserved.
//

#import "EquipmentTextFieldCell.h"
#import "Masonry.h"
#import "TileCellModel.h"
#import "NSObject+RACDescription.h"

@interface EquipmentTextFieldCell ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UITextField *valueTextField;
@property (nonatomic,strong) UILabel *uitsLable;
@end

@implementation EquipmentTextFieldCell

- (void)setupCell {
    //self.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)buildSubview {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.valueTextField];
    [self.contentView addSubview:self.uitsLable];
    
    WeakSelf
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.contentView).offset(18);
        
        //make.height.mas_equalTo(34);
        make.width.mas_equalTo(@80);
    }];
    
    [self.valueTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel.mas_right).offset(8);
        make.top.equalTo(weakSelf.contentView).offset(8);
        make.bottom.equalTo(weakSelf.contentView).offset(-8);
        make.height.mas_equalTo(@30).priorityHigh();
        //make.width.mas_equalTo(80);
        //make.right.equalTo(self.contentView).offset(-8);
    }];
    
    [self.uitsLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.titleLabel);
        make.height.equalTo(weakSelf.titleLabel);
        make.width.mas_equalTo(20);
        make.left.equalTo(weakSelf.valueTextField.mas_right).offset(8);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-16);
    }];
    
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(weakSelf);
        }];
    
    //给文本输入框添加编辑完后的事件
    [self.valueTextField addTarget:self action:@selector(editEndAction:) forControlEvents:UIControlEventEditingDidEnd];
    
}


//文本输入框添加编辑完后的行动
- (void)editEndAction:(UITextField *) sender{
    if ([self.textFieldCellDelgate respondsToSelector:@selector(editEndActionWithValue:andKey:andRow:)]) {
        //self.editEnfBlock(sender.text,self.strKey);
        
        [self.textFieldCellDelgate editEndActionWithValue:sender.text andKey:self.strKey andRow:self.indexPath.row];
    }
}

- (void)loadContent{
    if (self.dataAdapter.data) {
        
        TileCellModel *item  = self.dataAdapter.data;
        self.viewModel      = item.viewModel;
        
        self.titleLabel.text = item.tilleString;
        self.valueTextField.text = item.valueString ;
        self.textFieldCellDelgate = item.delgate;
        
        if (item.isRequired) {
            self.valueTextField.placeholder = @"必填";
        }else{
            self.valueTextField.placeholder = @"先填";
        }
        
        //如果信号关键字不为空通过kvc对信号进行绑定
        if (!isEmptyString(item.strKey)) {
            self.strKey = item.strKey;
            
        }
        //self.viewModel.insNameSignal= self.valueTextField.rac_textSignal;
        
        [self.valueTextField setKeyboardType:item.keyBordType];
        
        if (!isEmptyString(item.units)) {
            self.uitsLable.hidden=NO;
            self.uitsLable.text = item.units;
            
        }else{
            self.uitsLable.hidden=YES;
            //            WeakSelf
            //            [self.valueTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            //                make.left.equalTo(weakSelf.titleLabel.mas_right).offset(8);
            //                make.centerY.equalTo(weakSelf.titleLabel);
            //                make.height.mas_equalTo(@34);
            //                make.right.equalTo(weakSelf.contentView).offset(-44);
            //            }];
        }
       @weakify(self);
        //获取信号
        RACSignal *signal               = [[[[[RACSignal
                                               defer:^{
                                                   @strongify(self);
                                                   return [RACSignal return:self];
                                               }]
                                              concat:[self.valueTextField rac_signalForControlEvents:UIControlEventEditingDidEnd]]
                                             map:^(UITextField *x) {
                                                 return x.text;
                                             }]
                                            takeUntil:self.valueTextField.rac_willDeallocSignal]
                                           setNameWithFormat:@"%@ -rac_textEditingDidEndSignal",RACDescription(self.valueTextField)];
        
        self.viewModel.getValueSignal   = [[signal
                                            filter:^BOOL(NSString * value) {
                                                return !isEmptyString(value);
                                            }]
                                            map:^NSDictionary *(NSString * value) {
                                                return @{item.strKey:value};
                                            }];
        
        
    }
    
    
}

//懒加载控件
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[[UILabel alloc]init];
    }
    return _titleLabel;
}

- (UITextField *)valueTextField{
    if(!_valueTextField){
        _valueTextField=[[UITextField alloc]init];
        [_valueTextField setClearButtonMode:UITextFieldViewModeAlways];
        _valueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        //_valueTextField.textAlignment=NSTextAlignmentRight;
    }
    return _valueTextField;
}


- (UILabel *)uitsLable{
    if (!_uitsLable) {
        _uitsLable=[[UILabel alloc]init];
        _uitsLable.hidden=YES;
        _uitsLable.textAlignment=NSTextAlignmentRight;
    }
    return _uitsLable;
}
@end
