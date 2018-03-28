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
    uint totalEmployee;
    address[] employeeList;

    mapping(address => Employee) public employees;

    function Payroll() public {
        self = this;
    }

    function changePaymentAddress (address fromEmployeeId, address toEmployeeId) employeeExit(fromEmployeeId) employeeNoExit(toEmployeeId) public {
        var employeePre = employees[fromEmployeeId];
        employees[toEmployeeId] = Employee(toEmployeeId, employeePre.salary, employeePre.lastPayday);
        delete employees[fromEmployeeId];
    }

    //settlement one employee's salary
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration);
        assert(self.balance > payment && payment > 0);
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner employeeNoExit(employeeId) public{
        uint salaryWei = salary.mul(1 ether);
        totalSalary = totalSalary.add(salaryWei);
        employees[employeeId] = Employee(employeeId, salaryWei, now);
        totalEmployee = totalEmployee.add(1);
        employeeList.push(employeeId);
    }

    function removeEmployee(address employeeId) onlyOwner employeeExit(employeeId) public {
        _partialPaid(employees[employeeId]);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        delete employees[employeeId];
        totalEmployee = totalEmployee.sub(1);
        uint index = getEmployeeIndex(employeeId);
        if(index >= 0 ){
          delete employeeList[index];
          uint tailIndex = employeeList.length.sub(1);
          employeeList[index] = employeeList[tailIndex];
          employeeList.length = employeeList.length.sub(1);
        }
    }

    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExit(employeeId) public {
        _partialPaid(employees[employeeId]);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        uint salaryWei = salary.mul(1 ether);
        totalSalary = totalSalary.add(salaryWei);
        employees[employeeId].salary = salaryWei;
        employees[employeeId].lastPayday = now;
    }

    function checkEmployee(uint index) public view returns (address employeeId, uint salary, uint lastPayday) {
        require(index < employeeList.length);
        employeeId = employeeList[index];
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }

    /* function checkEmployee(address employeeId) employeeExit(employeeId) public view returns (uint salary, uint lastPayday) {
        salary = employees[employeeId].salary;
        lastPayday = employees[employeeId].lastPayday;
    } */

    function addFund() public payable returns (uint) {
        return self.balance;
    }

    function calculateRunway() public view returns (uint) {
        //assert(totalSalary > 0);
        if(totalSalary == 0)return 0;
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

    function getEmployeeIndex(address employeeId) private view returns (uint) {
      for(uint i = 0; i < employeeList.length; i++) {
           if(employeeList[i] == employeeId) {
               return i;
           }
       }
    }

    modifier employeeExit(address employeeId) {
        assert(employees[employeeId].id != 0x0);
        _;
    }

    modifier employeeNoExit(address employeeId) {
        assert(employees[employeeId].id == 0x0);
        _;
    }

    modifier employeeDelete(address employeeId) {
        _;
        delete employees[employeeId];
    }

    function getInfo() public view returns (uint balance, uint runway, uint employeeCount) {
        balance = this.balance;
        runway = calculateRunway();
        employeeCount = totalEmployee;
    }

    function getEmployeeList() public view returns (address[]) {
      return employeeList;
    }
}
