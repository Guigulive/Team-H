pragma solidity ^0.4.14;

import './Ownable.sol';
contract Payroll is Ownable{
	struct Employee{
		address id;
		uint salary;
		uint lastPayday;
	}
    uint constant payDuration = 10 seconds;
    uint totalSalary;
    address owner;
    mapping(address =>Employee) public employees;


    /*function Payroll() {
        owner = msg.sender;
    }    
    
    modifier onlyOwner{
        require(msg.sender==owner);
        _;
    }Ownable have this function*/  
    
    modifier employeeExist(address employeeid){
        var employee=employees[employeeid];
        assert(employee.id!=0x0);
        _;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    
    function addEmployee(address employeeid,uint salary) onlyOwner{
    	//require(msg.sender==owner);
        var employee=employees[employeeid];
        assert(employee.id==0x0);
        
        totalSalary+=salary * 1 ether;
    	employees[employeeid]=Employee(employeeid,salary*1 ether,now);
    }

    function removeEmployee(address employeeid) onlyOwner employeeExist(employeeid){
        //require(msg.sender==owner);
        var employee=employees[employeeid];
        //assert(employee.id!=0x0);
        _partialPaid(employee);
        totalSalary-=employees[employeeid].salary;
        delete employees[employeeid];
    }
    
    function updateEmployee(address employeeid, uint salary) onlyOwner employeeExist(employeeid){
        //require(msg.sender == owner);
        var employee=employees[employeeid];
        //assert(employee.id!=0x0);
        _partialPaid(employee);
        totalSalary-=employees[employeeid].salary;
        employees[employeeid].salary=salary * 1 ether;
        
        employees[employeeid].lastPayday=now;
        totalSalary+=employees[employeeid].salary;
       
    }
    
    function changePaymentAddress(address employeeid, address new_id) onlyOwner employeeExist(employeeid){
        var employee=employees[employeeid];
        _partialPaid(employee);
        employee.id=new_id;
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
    
    function checkEmployee(address employeeid) returns (uint salary ,uint lastPayday){
        var employee= employees[employeeid];
        //return (employee.salary,employee.lastPayday);
        salary=employee.salary;
        lastPayday=employee.lastPayday;
    }
    
    function getPaid() employeeExist(msg.sender) {
        var employee=employees[msg.sender];
        //assert(employee.id!=0x0);
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
