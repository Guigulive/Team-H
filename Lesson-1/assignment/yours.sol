pragma solidity ^0.4.14;  //编译器要求

//薪酬支付
contract Payment {  
    uint salaryAmount; //薪酬金额, 单位:ether
    address salaryAddress; //发放地址 
    uint constant payDuration = 5 seconds; //发送频率
    uint lastPayday = now; //最后发放时间 
    
    // 1 增加公司账户余额
    function addBalance() payable returns (uint){
        return this.balance;
    }
    
    // 2 设置员工地址, 填入需要加双引号
    function setAddress(address employeeAddress){
        salaryAddress = employeeAddress;
    }
    
    // 3 设置员工薪酬
    function setAmount(uint employeeAmount){
        salaryAmount = employeeAmount * 1 ether;
    }
    
    // 4 计算还剩发放次数
    function calculate() returns (uint){
        if(salaryAmount == 0){
            revert();
        }
        return this.balance/salaryAmount;
    }
    
    // 5 检测余额是否充足
    function hasEnough() returns (bool){
        return calculate() > 0;
    }
    
    // 6 支付
    function pay(){
        uint nextPayDay = lastPayday + payDuration;
        if(nextPayDay > now){
            revert();
        }
        
        if(salaryAmount == 0 || salaryAddress == 0x0){
            revert();
        }
        
        lastPayday = nextPayDay;
        salaryAddress.transfer(salaryAmount);
    }
    
    // 7 查询员工薪酬是否到账
    function getEmployeeBalance() payable returns (uint){
        return salaryAddress.balance;
    }
}
