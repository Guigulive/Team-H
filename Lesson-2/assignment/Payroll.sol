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
    Employee[] employees;

    function Payroll() public {
        owner = msg.sender;
        self = this;
    }
    
    
    function _payementSalary (Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        assert(self.balance > payment && payment > 0);
        employee.id.transfer(payment);
    }
    
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for(uint i = 0; i < employees.length; i++) {
            if(employees[i].id == employeeId) {
                return(employees[i] , i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) public{
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId); 
        assert(employee.id == 0x0);
        
        employees.push(Employee(employeeId, salary * 1 ether, now));
    }
    
    function removeEmployee(address employeeId)  {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _payementSalary(employee);
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId); 
        assert(employee.id != 0x0);
        _payementSalary(employee);
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;
    }
    
    function addFund() public payable returns (uint) {
        return self.balance;
    }
    
    function calculateRunway()   returns (uint) {
        uint totalSalary = 0;
       for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
        assert(totalSalary > 0);
        return self.balance / totalSalary;
    }
    
    function hasEnoughFund()   returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid()  {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
         
        uint nextPayday = employees[index].lastPayday + payDuration;
        assert(nextPayday < now);
        
        employees[index].lastPayday = nextPayday;
        employees[index].id.transfer(employees[index].salary);
    }
    
   
}
