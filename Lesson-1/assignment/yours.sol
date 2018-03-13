pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;
    address owner;
    uint salary = 1 ether;
    address employee;
    uint lastPayday = now;

    function Payroll () {
        owner = msg.sender;
    }
    
    function updateEmployee(address e) {
        require(msg.sender == owner);
        employee = e;
    }
    
    function updateSalary(uint s) {
        require(msg.sender == owner);
        salary = s * 1 ether;
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
