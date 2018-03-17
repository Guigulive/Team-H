pragma solidity ^0.4.14;

//原始的calculateRunway gas cost 记录，1694, 2475, 3256, 4037, 4818, 5599, 6380, 7161, 7942, 8723
//原因，每次增加一个employee，数组长度增加，循环一次都要消耗 gas
//优化方案，定义一个变量 totalSalary，在增加、删除、修改employee修改 totalSalary, calculateRunway不需要每次通过循环统计 totalSalary

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    uint totalSalary;

    address owner;
    Employee[] employees;

    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
  
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
        
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        
        for(uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
        
    }

    function addEmployee(address employeeId, uint salary) {

        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        employees.push(Employee(employeeId, salary * 1 ether, now));
        totalSalary += salary * 1 ether;
        
    }
    
    function removeEmployee(address employeeId) {
        
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
        totalSalary -= employee.salary;
        
    }
    
    function updateEmployee(address employeeId, uint salary) {
        
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        totalSalary -= employees[index].salary;
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;
        totalSalary += salary * 1 ether; 
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
       //uint totalSalary = 0;
       //for (uint i = 0; i < employees.length; i++) {
       //     totalSalary += employees[i].salary;
       // }
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        employees[index].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
        
    }
}
