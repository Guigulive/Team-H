pragma solidity ^0.4.18;

import "./SafeMath.sol";
import "./Ownable.sol";
import "./PullPayment.sol";

/**
 * @title Payroll
 * @dev Base contract supporting: adding fund, adding employees, removing
 * employees, updating employee salary, calculating runway, checking if balance
 * is enough, transferring contract ownership, allowing employee to get paid,
 * allowing leave-office employee to get severance pay.
 */
contract Payroll is Ownable, PullPayment {

    using SafeMath for uint;

    uint constant PAYMENT_DURATION = 10 seconds;

    struct Employee {
        address id;
        uint salary;
        uint lastPaymentSettlementDate; // the last payment settlement date
    }
    address[] employeeList;
    uint TotalEmployee;
    mapping(address => Employee) public employees;
    uint private _totalSalary;

    /**
     * @dev Throws if an employee doesn't exist.
     * @param employeeId The employee id to be checked.
     */
    modifier employee_exist(address employeeId) {
        require(employees[employeeId].id != 0x0);
        _;
    }

    /**
     * @dev Throws if an employee exists.
     * @param employeeId The employee id to be checked.
     */
    modifier employee_does_not_exist(address employeeId) {
        require(employees[employeeId].id == 0x0);
        _;
    }

    /**
     * @dev Allows caller to settle the current payment of an employee.
     * @param employeeId The id of the employee.
     */
    function _settlePayment(address employeeId) private {
        Employee storage employee = employees[employeeId];
        uint workingdays = now.sub(employee.lastPaymentSettlementDate);
        if (workingdays > 0) {
            asyncSend(
                employee.id,
                workingdays.mul(employee.salary).div(PAYMENT_DURATION)
            );
            employee.lastPaymentSettlementDate = now;
        }
    }

    /**
     * @dev Allows caller to check the info of an employee.
     * @param index The index of the employee in employeeList.
     */
    function checkEmployee(uint index)
        public
        view 
        returns 
        (
            address employeeId, 
            uint salary, 
            uint lastPayday
        ) 
    {
        employeeId = employeeList[index];
        Employee storage employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPaymentSettlementDate;
    }

    /**
     * @dev Allows owner to add an employee.
     * @param employeeId The id of the employee.
     * @param salary The salary of the employee.
     */
    function addEmployee(address employeeId, uint salary)
        public
        onlyOwner
        employee_does_not_exist(employeeId)
    {
        employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);
        _totalSalary = _totalSalary.add(employees[employeeId].salary);
        employeeList.push(employeeId);
        TotalEmployee = TotalEmployee.add(1);
    }

    /**
     * @dev Allows owner to remove an employee.
     * @param employeeId The id of the employee.
     */
    function removeEmployee(address employeeId)
        public
        onlyOwner
        employee_exist(employeeId)
    {
        _settlePayment(employeeId);
        _totalSalary = _totalSalary.sub(employees[employeeId].salary);
        delete employees[employeeId];
        TotalEmployee = TotalEmployee.sub(1);
    }

    /**
     * @dev Allows owner to change the salary of an employee.
     * @param employeeId The id of the employee.
     * @param newSalary The new salary of the employee.
     */
    function updateEmployeeSalary(address employeeId, uint newSalary)
        public
        onlyOwner
        employee_exist(employeeId)
    {
        require(newSalary != employees[employeeId].salary);
        _settlePayment(employeeId); // Settle old-rate salary payment
        _totalSalary = _totalSalary.add(newSalary).sub(employees[employeeId].salary);
        employees[employeeId].salary = newSalary;
    }

    /**
     * @dev Allows an employee to transferring his payment address.
     * @param newEmployeeId The id of the employee.
     */
    function changePaymentAddress(address newEmployeeId)
        public
        employee_exist(msg.sender)
    {
        require(msg.sender != newEmployeeId);
        employees[msg.sender].id = newEmployeeId;
        employees[newEmployeeId] = employees[msg.sender];
        delete employees[msg.sender];
        uint payment = payments[msg.sender];
        delete payments[msg.sender];
        asyncSend(newEmployeeId, payment);
    }

    /**
     * @dev Allows adding funds/balance to the contract.
     */
    function addFund() public payable returns (uint) {
        return address(this).balance;
    }

    /**
     * @dev Allows calculating the runway of total salary.
     */
    function calculateRunway() public view returns (uint) {
        return address(this).balance.div(_totalSalary);
    }

    /**
     * @dev Allows checking if the contract has enough fund.
     */
    function hasEnoughFund() public view returns (bool) {
        return (calculateRunway() > 0);
    }

    /**
     * @dev Allows employee to get paid.
     */
    function getPaid() public employee_exist(msg.sender) {
        _settlePayment(msg.sender);
        withdrawPayments();
    }

    /**
     * @dev Allows left-office employee to get severance pay.
     */
    function getSeverancePay()
        public
        employee_does_not_exist(msg.sender)
    {
        require(payments[msg.sender] > 0);
        withdrawPayments();
    }
}
