
pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    address owner;
    Employee[] employees;
    
    uint totalSalary = 0;

    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        if (employee.id != 0x0) {
            uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
            employee.id.transfer(payment);
        }
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for(uint i=0;i<employees.length;i++){
            if(employees[i].id == employeeId){
                return (employees[i],i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        
        var (employee,i) = _findEmployee(employeeId);
        assert(employee.id==0x0);
        totalSalary += salary * 1 ether;
        employees.push(Employee(employeeId,salary * 1 ether,now));
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        
        var (employee,i) = _findEmployee(employeeId);
        assert(employee.id!=0x0);
        totalSalary -= employees[i].salary;
        delete employees[i];
        employees[i] = employees[employees.length-1];
        employees.length--;
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        
        var (employee,i) = _findEmployee(employeeId);
        assert(employee.id!=0x0);
        _partialPaid(employee);
        totalSalary -= employees[i].salary;
        employees[i].salary = salary * 1 ether;
        totalSalary += employees[i].salary;
        employees[i].lastPayday = now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        var (employee,i) = _findEmployee(msg.sender);
        assert(employee.id!=0x0);

        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employees[i].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
