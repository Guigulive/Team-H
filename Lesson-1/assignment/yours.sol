pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint laborCost; // the sum of all employee salaries

    struct Employee {
        uint salary;
        uint lastPayday;
    }

    mapping (address => Employee) _employee; // map from employee address to his wage info

    function Payroll() {
        owner = msg.sender;
    }

    // A function to create a new employee
    function createEmployee(address e, uint s) {
        require(msg.sender == owner);
        require(!existingEmployee(e));
        uint salary = s * 1 ether;
        Employee memory newEmployee = Employee(salary, now);
        _employee[e] = newEmployee;
        laborCost += salary;
    }

    // A function to update an existing employee's salary
    function updateEmployeeSalary(address e, uint s) {
        require(msg.sender == owner);
        require(existingEmployee(e));
        uint newSalary = s * 1 ether;
        laborCost += newSalary - _employee[e].salary;
        _employee[e].salary = newSalary;
    }

    // A function to update an existing employee's address
    function updateEmployeeAddress(address oldAddress, address newAddress) {
        require(msg.sender == owner);
        require(existingEmployee(oldAddress));
        _employee[newAddress] = _employee[oldAddress];
        delete _employee[oldAddress];
    }

    function addFund() payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        return this.balance / laborCost;
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    // A function to allow an employee to get paid
    function getPaid() {
        address e = msg.sender;
        require(existingEmployee(e));
        uint nextPayday = _employee[e].lastPayday + payDuration;
        assert(nextPayday < now);
        _employee[e].lastPayday = nextPayday;
        e.transfer(_employee[e].salary);
    }

    // Check if an employee exists
    function existingEmployee(address e) returns (bool) {
        return _employee[e].salary > 0;
    }

    // Get laborCost
    function getLaborCost() returns (uint) {
        require(msg.sender == owner);
        return laborCost/1 ether;
    }

    // Get caller employee's current salary
    function getSalary() returns (uint) {
        return _employee[msg.sender].salary;
    }
}
