pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";

contract Payroll is Ownable {
    
    using SafeMath for uint;
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    uint totalSalary;
    
    mapping(address => Employee) public employees;
    
    modifier existsEmployee(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    modifier addEmployeeModifier(address employeeId, uint salary, uint lastPayday) {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        employees[employeeId] = Employee(employeeId, salary, lastPayday);
        _;
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner addEmployeeModifier(employeeId, salary * 1 ether, now) {
        //require(msg.sender == owner);
        //var employee = employees[employeeId];
        //assert(employee.id == 0x0);
        //employees[employeeId] = Employee(employeeId, salary * 1 ether, now);
        totalSalary = totalSalary.add(salary * 1 ether);
    }
    
    function removeEmployee(address employeeId) onlyOwner existsEmployee(employeeId){
        //require(msg.sender == owner);
        var employee = employees[employeeId];
        var salary = employee.salary;
        //assert(employee.id != 0x0);
        _partialPaid(employee);
        delete employees[employeeId];
        totalSalary = totalSalary.sub(salary);
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner existsEmployee(employeeId) {
        //require(msg.sender == owner);
        var employee = employees[employeeId];
        //assert(employee.id != 0x0);
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        employees[employeeId].salary = salary * 1 ether;
        employees[employeeId].lastPayday = now;
        totalSalary = totalSalary.add(salary * 1 ether); 
    }
    
    function changePaymentAddress(address employeeId, address employeeNewId) onlyOwner existsEmployee(employeeId) addEmployeeModifier(employeeNewId, employees[employeeId].salary, employees[employeeId].lastPayday)  {
        //var employee = employees[employeeId];
        //employees[employeeNewId] = Employee(employeeNewId, employee.salary, employee.lastPayday);
        delete employees[employeeId];
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
    
    function checkEmployee(address employeeId) existsEmployee(employeeId) returns (uint salary, uint lastPayday){
        var employee = employees[employeeId];
        return(employee.salary, employee.lastPayday);
    }

    function getPaid() existsEmployee(msg.sender) {
        var employee = employees[msg.sender];
        //assert(employee.id != 0x0);
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}