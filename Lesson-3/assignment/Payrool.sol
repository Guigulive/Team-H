pragma solidity ^0.4.14;
contract Payroll {
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    address owner;
    address self;
    uint totalSalary;
    mapping(address => Employee) public employees;

    function Payroll() public {
        owner = msg.sender;
        self = this;
    }
    
    function changePaymentAddress (address fromEmployeeId, address toEmployeeId) employeeChange(fromEmployeeId, toEmployeeId) public {
        employees[toEmployeeId] = Employee(toEmployeeId, employees[fromEmployeeId].salary, employees[fromEmployeeId].lastPayday);
    }
    
    //settlement one employee's salary
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        assert(self.balance > payment && payment > 0);
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner public{
        assert(employees[employeeId].id == 0x0);
        totalSalary += salary * 1 ether;
        employees[employeeId] = Employee(employeeId, salary * 1 ether, now);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExit(employeeId) public {
        _partialPaid(employees[employeeId]);
        totalSalary -= employees[employeeId].salary;
        delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExit(employeeId) public {
        _partialPaid(employees[employeeId]);
        totalSalary -= employees[employeeId].salary;
        totalSalary += salary * 1 ether;
        employees[employeeId].salary = salary * 1 ether;
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
        return self.balance / totalSalary;
    }
    
    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() employeeExit(msg.sender) public {
        uint nextPayday = employees[msg.sender].lastPayday + payDuration;
        assert(nextPayday < now);
        
        employees[msg.sender].lastPayday = nextPayday;
        employees[msg.sender].id.transfer(employees[msg.sender].salary);
    }
    
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
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
