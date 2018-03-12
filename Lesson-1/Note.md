## The Note of the Lecture
### 边听边记
1. **版本声明**
    版本声明代码格式如下：

    ```
    pragma solidity ^0.4.0;
    ```
    这段代码的声明表示，源文件不会被0.4.0以下版本的编译器编译。当然同时也不会被0.5.0以上版本的编译器起作用（这是由`^`符号来决定的）。
    
    0.4.0 ~ 0.4.9 这些版本支持上面代码声明的源码编译，这样处理的好处是，如果0.4.0编译器有问题，可以随时修复bug，将其调整为0.4.1。

    *老董解释*：智能合约程序代码以指定语言版本来开始，目的方便开源社区内部互动和基于程序本身演进，而非技术本身方面考虑。
    
2. **contract关键字**
    类似面向对象中的`class`，作为智能合约程序中的一个封装单位。

3. **constant关键字** 
    在C++中constant用于变量修饰时，表明这个变量不能被修改；用于指针修饰时，表明指针的指向对象不能被修改；用于方法修饰时，表明这个方法不会对对象造成改变。
    
    *老董解释*：目前的solidity版本中，constant没有实际用途，只是一个视觉上的警示作用，编译器不会对方法中的代码做任何检查，即使是方法中的代码块对对象做了修改。
    
4. **returns (type)返回类型**
    告诉编译器该方法的返回数据的类型。
    
5. **gas关键字**
    gas、gas limit和gas price。回顾：[以太坊交易相关笔记](https://blog.tedxiong.com/Ethereum_Note.html)
    

### 问题整理
1. 无论创建智能合约还是调用智能合约的方法，transaction detail都包含两项gas cost，transaction cost 和 execution cost，字面意思是交易消耗和执行消耗，这两项分别代表什么呢？  
    答：

2.
    
### 边角料
1. Solidity 英 [sə'lɪdɪtɪ] 美 [sə'lɪdəti] n. 坚硬，坚固；体积；固体性

### 全部源码
```
pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary;
    address employee;
    uint lastPayday;

    function Payroll() {
        owner = msg.sender;
    }
    
    function updateEmployee(address e, uint s) {
        require(msg.sender == owner);
        
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        
        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        require(msg.sender == employee);
        
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}
```



