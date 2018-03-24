/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

/**
* payroll with modifier
*/

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable{
    using SafeMath for uint;
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    uint totalSalary = 0;

    mapping(address => Employee) employees;
    
    modifier employeeExist(address employeeId){
        var employee =  employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }

    modifier partialPaid(address employeeId){
        var employee =  employees[employeeId];
        assert(employee.id != 0x0);
        _partialPaid(employee);
        _;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary
                .mul(now.sub(employee.lastPayday))
                .div(payDuration);
                
        employee.id.transfer(payment);
    }
    
    function addEmployee(address employeeId, uint salary) onlyOwner{
        var employee  =  employees[employeeId];
        assert(employee.id == 0x0);

        totalSalary = totalSalary.add(salary * 1 ether);
        employees[employeeId] = Employee(employeeId, salary * 1 ether, now);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId){
        var employee =  employees[employeeId];

        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId){

        var employee =  employees[employeeId];
        _partialPaid(employee);

        employees[employeeId].salary = salary * 1 ether;
        employees[employeeId].lastPayday = now;

    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance.div(totalSalary);
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() employeeExist(msg.sender){
        var employee = employees[msg.sender];

        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);

        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
    
    function changePaymentAddress(address employeeId, address newEmployeeId) onlyOwner partialPaid(employeeId){
		var employee =  employees[employeeId];

        employees[newEmployeeId] = Employee(newEmployeeId, employee.salary * 1 ether, now);
        delete employees[employeeId];
    }
}
