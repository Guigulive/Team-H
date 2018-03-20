pragma solidity ^0.4.14;
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

    address self;
    uint totalSalary;
    mapping(address => Employee) public employees;

    function Payroll() public {
        self = this;
    }
    
    function changePaymentAddress (address fromEmployeeId, address toEmployeeId) employeeChange(fromEmployeeId, toEmployeeId) public {
        employees[toEmployeeId] = Employee(toEmployeeId, employees[fromEmployeeId].salary, employees[fromEmployeeId].lastPayday);
    }
    
    //settlement one employee's salary
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration);
        assert(self.balance > payment && payment > 0);
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner public{
        assert(employees[employeeId].id == 0x0);
        uint salaryWei = salary.mul(1 ether);
        totalSalary = totalSalary.add(salaryWei);
        employees[employeeId] = Employee(employeeId, salaryWei, now);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExit(employeeId) public {
        _partialPaid(employees[employeeId]);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExit(employeeId) public {
        _partialPaid(employees[employeeId]);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        uint salaryWei = salary.mul(1 ether);
        totalSalary = totalSalary.add(salaryWei);
        employees[employeeId].salary = salaryWei;
        employees[employeeId].lastPayday = now;
    }
    
    function checkEmployee(address employeeId) employeeExit(employeeId) public view returns (uint salary, uint lastPayday) {
        salary = employees[employeeId].salary;
        lastPayday = employees[employeeId].lastPayday;
    }
    
    function addFund() public payable returns (uint) {
        return self.balance;
    }
    
    function calculateRunway() public view returns (uint) {
        assert(totalSalary > 0);
        return self.balance.div(totalSalary);
    }
    
    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() employeeExit(msg.sender) public {
        uint nextPayday = employees[msg.sender].lastPayday.add(payDuration);
        assert(nextPayday < now);
        
        employees[msg.sender].lastPayday = nextPayday;
        employees[msg.sender].id.transfer(employees[msg.sender].salary);
    }
    
    modifier employeeExit(address employeeId) {
        assert(employees[employeeId].id != 0x0);
        _;
    }
    
    modifier employeeChange(address fromEmployeeId, address toEmployeeId) {
        require(fromEmployeeId != toEmployeeId);
        assert(employees[fromEmployeeId].id != 0x0);
        assert(employees[toEmployeeId].id == 0x0);
        _;
        delete employees[fromEmployeeId];
    }
    
}