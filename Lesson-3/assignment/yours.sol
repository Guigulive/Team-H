pragma solidity ^0.4.18;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable{
    
    using SafeMath for uint;
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    uint constant payDuration = 5 seconds;
    uint private totalSalary = 0;
    address owner;
    mapping(address => Employee) public employees;
    
    // 员工是否存在
    modifier employeeExists(address employeeId){
        var employee = employees[employeeId];
        require(employee.id != 0x0);
        _;
    }
    
    // 删除员工
    modifier deleteEmployee(address employeeId){
        _;
        delete employees[employeeId];
    }
    
    // 支付剩余薪酬
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration);
        employees[employee.id].lastPayday = now;
        employee.id.transfer(payment);
    }
    
    // 添加员工
    function addEmployee(address employeeId, uint salary) public onlyOwner{
        var employee = employees[employeeId];
        if (employee.id == 0x0) {
            employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);
            totalSalary = totalSalary.add(employees[employeeId].salary);
        }
    }
    
    // 移除员工
    function removeEmployee(address employeeId) public onlyOwner employeeExists(employeeId) deleteEmployee(employeeId){
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
    }
    
    // 更新员工
    function updateEmployee(address employeeId, uint salary) public onlyOwner employeeExists(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);
        uint newSalary = salary.mul(1 ether);
        totalSalary = totalSalary.sub(employee.salary).add(newSalary);
        employee.salary = newSalary;
    }
    
    // 更新支付地址
    function changePaymentAddress(address newAddress) public employeeExists(msg.sender) deleteEmployee(msg.sender){
        var employee = employees[msg.sender];
        employee.id = newAddress;
        employees[newAddress] = employee;
    }
    
    // 添加金额
    function addFund() payable public returns (uint) {
        return this.balance;
    }
    
    // 计算剩余支付次数
    function calculateRunway() public view returns (uint) {
        return this.balance.div(totalSalary);
    }
    
    // 是否还能支付
    function hasEnoughFund() public returns (bool) {
        return calculateRunway() > 0;
    }
    
    // 支付
    function getPaid() public employeeExists(msg.sender){
        var employee = employees[msg.sender];
        uint nextPayday = employee.lastPayday.add(payDuration);
        if(nextPayday > now){
            revert();
        }
        employees[msg.sender].lastPayday = now;
        employee.id.transfer(employee.salary);
    }
}

// 1、总共9个函数，调用截图如本文件夹函数名称对应的png文件
// 2、增加 changePaymentAddress 函数，使用modifier整合在 deleteEmployee 函数中
