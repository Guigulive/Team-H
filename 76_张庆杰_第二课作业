pragma solidity ^0.4.14;

contract Payrool{
    // 定义结构体
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;// 支付频率
    address owner;// 合约创建者
    Employee[] employees;// c初始化员工结构体
    uint totalSalary = 0;
    
    // 初始化函数
    function Payrool(){
        owner = msg.sender;
    }
    
    // 支付剩余薪酬
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    // 查找员工是否已存在
    function _findEmployee(address employeeId) private returns (Employee, uint){
        for (uint i = 0; i < employees.length; i++){
            if (employees[i].id == employeeId){
                return (employees[i], i);
            }
        }
    }
    
    // 增加员工
    function addEmployee(address employeeId, uint salary){
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        
        employees.push(Employee(employeeId, salary * 1 ether, now));
        totalSalary += salary * 1 ether;
    }
    
    // 删除员工
    function removeEmployee(address employeeId){
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        
        _partialPaid(employee);
        delete employees[index];
        totalSalary -= employee.salary * 1 ether;
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }
    
    // 更新员工信息
    function updateEmployee(address employeeId, uint salary){
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        
        _partialPaid(employee);
        totalSalary -= employee.salary * 1 ether;
        employees[index].salary = salary * 1 ether;
        totalSalary += salary * 1 ether;
        employees[index].lastPayday = now;
    }
    
    // 公司帐户充值
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    // 查询公司账号余额
    function getFund() returns (uint){
        return this.balance;
    }
    
    // 计算还可以发放薪酬几次
    function calculateRunway() returns (uint){
        return this.balance / totalSalary;
    }
    
    // 是否够支付薪酬
    function hasEnoughFund() returns (bool){
        return calculateRunway() > 0;
    }
    
    // 支付
    function getPaid(){
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employees[index].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
