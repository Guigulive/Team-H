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
    uint totalEmployee;
    address[] employeeList;
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

    function _findEmployee(address employeeId) private returns (uint) {
        
        for(uint i = 0; i < employeeList.length; i++) {
            if (employeeList[i] == employeeId) {
                return i;
            }
        }
        
    }

    function addEmployee(address employeeId, uint salary) onlyOwner addEmployeeModifier(employeeId, salary * 1 ether, now) {
        //require(msg.sender == owner);
        //var employee = employees[employeeId];
        //assert(employee.id == 0x0);
        //employees[employeeId] = Employee(employeeId, salary * 1 ether, now);
        totalSalary = totalSalary.add(salary * 1 ether);
        totalEmployee = totalEmployee.add(1);
        employeeList.push(employeeId);
    }
    
    function removeEmployee(address employeeId) onlyOwner existsEmployee(employeeId){
        //require(msg.sender == owner);
        var employee = employees[employeeId];
        var salary = employee.salary;
        //assert(employee.id != 0x0);
        _partialPaid(employee);
        delete employees[employeeId];
        totalSalary = totalSalary.sub(salary);
        totalEmployee = totalEmployee.sub(1);
        var index = _findEmployee(employeeId);
        delete employeeList[index];
        employeeList[index] = employeeList[employeeList.length.sub(1)];
        employeeList.length = employeeList.length.sub(1);
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
        employeeList.push(employeeNewId);
        var index = _findEmployee(employeeId);
        delete employeeList[index];
        employeeList[index] = employeeList[employeeList.length.sub(1)];
        employeeList.length = employeeList.length.sub(1);
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
    
    function checkEmployee(uint index) returns (address employeeId, uint salary, uint lastPayday){
        employeeId = employeeList[index];
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }

    function getPaid() existsEmployee(msg.sender) {
        var employee = employees[msg.sender];
        //assert(employee.id != 0x0);
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }

    function checkInfo() returns (uint balance, uint runway, uint employeeCount) {
        balance = this.balance;
        employeeCount = totalEmployee;
        if (totalSalary > 0) {
            runway = calculateRunway();
        }
    }
}