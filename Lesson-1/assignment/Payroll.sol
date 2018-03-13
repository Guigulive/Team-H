pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;ß
    uint salary;
    address employee;
    uint lastPayday;

    function Payroll() {
        owner = msg.sender;
    }
    
    function updateEmployee(address e, uint s) {
        require(msg.sender == owner);
        
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        
        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
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
    
    //replace now employee to new one
    function replaceEmployee (address addr) public returns (bool) {
        require(msg.sender == owner);
        if (isValidAddr(addr)) {
            //settlementSalary();
            employee = addr;
            lastPayday = now;
            return true;
        }
        return false;
    }
    
    //adjust salary to new one
    function adjustSalary(uint s) public {
        require(msg.sender == owner);
        //do the employer need to settlement salary first?
        //settlementSalary();
        salary = s * 1 ether;
    }
    
    //check the validitvalidity of address
    function isValidAddr(address addr) public pure returns (bool) {
        return 0x0 != addr;
    }
    
    //settlement one employee's salary
    function settlementSalary () public {
        require(msg.sender == owner && isValidAddr(employee));
        //need to pay
        uint payment = salary * getSalaryNum();
        assert(this.balance > payment);
        employee.transfer(payment);
        employee = 0x00;
        lastPayday = now;
    }
    
    //get the salary num need to settlement
    function getSalaryNum () public view returns (uint) {
        uint num = (now - lastPayday) / payDuration;
        return num;
    }
    
    //get the balance
    function getBalance() public view returns  (uint) {
        return this.balance /1 ether;
    }
    
    //get the owner
    function getOwner() public view returns (address) {
        return owner;
    }
    
    //get the employee
    function getEmployee() public view returns (address) {
        return employee;
    }
    
    //get the paid, must called by employee
    function getMyPaid() payable public{
        require(msg.sender == employee);
        
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
    
}
