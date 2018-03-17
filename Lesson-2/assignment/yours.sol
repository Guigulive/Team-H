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

    uint newTotalSalary;

    address[10] newEmployeeAddresses = [
        0x14723a09acff6d2a60dcdf7aa4aff308fddc160c,
        0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db,
        0x583031d1113ad414f02576bd6afabfb302140225,
        0xdd870fa1b7c4700f2bd7f44238821c26f7392148,
        0x6e5a224af373f316f020d46f99fbf3716ecfa03d,
        0x213e7907d993780a17a5fd32dfd898c10c652529,
        0x62faa9886c73773cec3cd00b92bbbbb1fe480805,
        0xd1ab5bc9645ddf7cca787411c0c87c23a0746ba7,
        0x79bb6606ee7b42175bf1e2e4c732ae8211647013,
        0xb697af549e7e9db56d6b744b2dd37811fc2ff54f
    ];

    function Payroll() {
        owner = msg.sender;
    }

    function _partialPaid(Employee employee) private {
        uint workingdays = now - employee.lastPayday;
        if (workingdays != 0) {
            employee.id.transfer(workingdays*employee.salary/payDuration);
        }
    }

    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i=0; i<employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
    }

    // quickly add a new employee
    function quicklyAddEmployee() {
        addEmployee(newEmployeeAddresses[employees.length],1);
    }

    function _hasEmployee(address employeeId) private returns (bool) {
        var (employee, index) = _findEmployee(employeeId);
        return (employee.id != 0x0);
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        //require(_hasEmployee(employeeId));
        employees.push(Employee(employeeId, salary*1 ether, now));
        newTotalSalary += salary*1 ether;
    }

    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        require(employee.id != 0x0);
        _partialPaid(employee);
        delete employees[index];
        employees[index] = employees[employees.length-1];
        employees.length -= 1;
        newTotalSalary -= employee.salary;
    }

    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);

        // which is better?
        // require(employee.id != 0x0);
        if (employee.id == 0x0) {
            revert();
        }

        if (employee.id != employeeId) {
            employees[index].id = employeeId;
        }
        // No changes are needed if the salary is not changed.
        uint salaryDifference = salary*1 ether - employees[index].salary;
        if(salaryDifference != 0) {
            _partialPaid(employee);
            employees[index].lastPayday = now;
            newTotalSalary += salaryDifference;
        }
    }

    function addFund() payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        uint totalSalary = 0;
        for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
        return this.balance / totalSalary;
    }

    // Optimized version of runway calculation
    function newCalculateRunway() returns (uint) {
        return this.balance / newTotalSalary;
    }

    function hasEnoughFund() returns (bool) {
        return (calculateRunway() > 0);
    }

    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        require(employee.id != 0x0);
        employee.id.transfer(employee.salary*1 ether);
        employees[index].lastPayday = now;
    }
}
