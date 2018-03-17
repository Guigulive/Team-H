/*作业请提交在这个目录下*/
/**
*  随着employee的数目增长，gas消耗量上升，且在首次计算时，execution cost 明显较高
*  优化思路：将salary总和缓存起来，不必每次都去计算，优化前后的gas消耗如下
* 优化前：
* emplyee: 1
* transaction cost 	22966 gas 
* execution cost 	1694 gas
* 
* emplyee: 5
* transaction cost 	26090 gas 
* execution cost 	4818 gas
* 
* emplyee: 10
* transaction cost 	28008 gas 
* execution cost 	9504 gas
* 
* 
* 优化后：
* emplyee: 1
*  transaction cost 	22382 gas 
*  execution cost 	1110 gas
* 
*  emplyee: 5
*  transaction cost 	22382 gas 
*  execution cost 	1110 gas
* 
*  emplyee: 10
*  transaction cost 	46326 gas 
*  execution cost 	25054 gas 
*/

pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    // total salary
    uint totalSalaryCache;

    address owner;
    Employee[] employees;

    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for(uint idx=0; idx<employees.length; idx++){
            if(employees[idx].id==employeeId){
                return (employees[idx], idx);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender==owner);
        var (employee, idx) = _findEmployee(employeeId);
        assert(employee.id==0x0);
        employees.push(Employee(employeeId, salary * 1 ether, now));
        clearCache();
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender==owner);
        var (employee, idx) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        delete employees[idx];
        employees[idx] = employees[employees.length - 1];
        employees.length--;
        clearCache();
    }
    
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        uint totalSalary;
        for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
        totalSalaryCache = totalSalary;
       
        return this.balance / totalSalary;
    }
    
    // calculateRunway with cache
    function calculateRunwayWithCache() returns (uint) {
        uint totalSalary;
        if(totalSalaryCache != 0x0){
            totalSalary = totalSalaryCache;
        }else{
            for (uint i = 0; i < employees.length; i++) {
                totalSalary += employees[i].salary;
            }
            totalSalaryCache = totalSalary;
        }
       
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        uint enough = calculateRunway();
        assert(enough > 0x0);
    }
    
    
    function countEmplyees() returns (uint){
        return employees.length;
    }
    
    function clearCache(){
        delete totalSalaryCache;
    }
}
