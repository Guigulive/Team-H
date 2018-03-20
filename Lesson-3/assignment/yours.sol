pragma solidity ^0.4.18;

import "./SafeMath.sol";
import "./Ownable.sol";
import "./PullPayment.sol";

contract Payroll is Ownable, PullPayment {

    using SafeMath for uint;

    uint constant PAYMENT_DURATION = 10 seconds;

    struct Employee {
        address id;
        uint salary;
        uint lastPaymentSettlementDate; // the last payment settlement date
    }
    mapping(address => Employee) employees;
    uint public _totalSalary;

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
     * @dev Throws if new salary is the same as the original one.
     * @param employeeId The id of the employee.
     * @param newSalary The new salary.
     */
    modifier change_salary(address employeeId, uint newSalary) {
        require(newSalary != employees[employeeId].salary);
        _;
    }

    /**
     * @dev Throws if payment address is the same as the original one. Tranfer
     * all payment of the original address to the new address.
     * @param newEmployeeId The new payment address of the employee.
     */
    modifier change_payment_address(address newEmployeeId) {
        require(msg.sender != newEmployeeId);
        _;
        employees[msg.sender].id = newEmployeeId;
        employees[newEmployeeId] = employees[msg.sender];
        delete employees[msg.sender];
        uint payment = payments[msg.sender];
        delete payments[msg.sender];
        asyncSend(newEmployeeId, payment);
    }

    /**
     * @dev Throws if an employee is not in the payment list.
     * @param employeeId The id of the employee.
     */
    modifier in_payment_list(address employeeId) {
        require(payments[employeeId] > 0);
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
        change_salary(employeeId, newSalary)
    {
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
        change_payment_address(newEmployeeId)
    {
        // function realization is moved into the modifier.
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
    function calculateRunway() public returns (uint) {
        return address(this).balance.div(_totalSalary);
    }

    /**
     * @dev Allows checking if the contract has enough fund.
     */
    function hasEnoughFund() public returns (bool) {
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
        in_payment_list(msg.sender)
    {
        withdrawPayments();
    }
}
