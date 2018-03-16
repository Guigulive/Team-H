## The Note of the Lecture
> 课程地址：[第2课：《智能合约设计进阶-多员工薪酬系统》](http://pc-shop.xiaoe-tech.com/appBbtPFWyR9948/video_details?id=v_5aa77ce416403_yy5SR8uY)
> 讲师：Frank

### 边听边记
1. **工资计算问题**
    上一节课我结算工资的计算方式有问题，不应该先算应支付月数，容易造成月数为零的情况，
    
    ```
    //有问题的的计算方式  如果duration 为30，
    // now - lastPayday < 30 ,就会出问题
    function getSalaryNum () private view returns (uint) {
        uint num = (now - lastPayday) / payDuration;
        return num;
    }
    
    //正确的计算方式
    uint payment = salary * (now - lastPayday) / payDuration;
    ```
    
2. **assert 和 require**
    assert: 使用在程序运行时，查看是否存在数据错误
    require: 检测程序在输入时的参数是否满足要求
    
3. **array**
    * 固定数据
    * 动态数组
    * 成员
        * length
        * push 只存在动态数组中
 
4. **struct**
5. **delete**
6. **function 返回多个result** 
7. **var**
8. **可视度**
    public, private, pure, view
    
9. **Data Location**
    * storage
    * memory
    * calldata
    * 强制
        * 状态变量：storage
        * function输入参数：calldata
        
    * 默认
        * function返回参数：memory

10. **赋值规则**
    * 如果把storage变量A复制给存放在memory的变量B，就是在memory中拷贝一个相同的变量Ⓐ，然后把指向Ⓐ的指针赋值给B。如果修改B变量的话，Ⓐ变量会变化，而A变量则不受影响。
    * 无法将memory变量赋值给本地的storage变量，只能通过状态变量来改变storege变量。
    


