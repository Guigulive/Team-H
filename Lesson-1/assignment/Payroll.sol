pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    address self;
    uint salary;
    address employee;
    uint lastPayday;

    function Payroll() public{
        owner = msg.sender;
        self = this;
    }
    
    function updateEmployee(address e, uint s) public{
        require(msg.sender == owner);
        
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        
        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
    }
    
    function addFund() payable public returns (uint) {
        return self.balance;
    }
    
    function calculateRunway() public view returns (uint) {
        return self.balance / salary;
    }
    
    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() public{
        require(msg.sender == employee);
        
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
    
    //replace now employee to new one
    function replaceEmployee (address addr) public {
        require(msg.sender == owner);
        if (isValidAddr(addr)) {
            settlementSalary();
            employee = addr;
            lastPayday = now;
        }
    }
    
    //adjust salary to new one
    function adjustSalary(uint s) public {
        require(msg.sender == owner);
        settlementSalary();
        salary = s * 1 ether;
    }
    
    //check the validitvalidity of address
    function isValidAddr(address addr) public pure returns (bool) {
        return 0x0 != addr;
    }
    
    //settlement one employee's salary
    function settlementSalary () private {
        require(msg.sender == owner);
        if(isValidAddr(employee)) {
            //need to pay
            uint payment = salary * getSalaryNum();
            assert(self.balance > payment && payment > 0);
            employee.transfer(payment);
            employee = 0x00;
            lastPayday = now;
        }
        
    }
    
    //get the salary num need to settlement
    function getSalaryNum () private view returns (uint) {
        uint num = (now - lastPayday) / payDuration;
        return num;
    }
    
    //get the balance
    function getBalance() public view returns  (uint) {
        return self.balance /1 ether;
    }
    
    //get the owner
    function getOwner() public view returns (address) {
        return owner;
    }
    
    //get the employee
    function getEmployee() public view returns (address) {
        return employee;
    }
    
}