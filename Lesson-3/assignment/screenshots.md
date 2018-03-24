# Screenshots of Function Execution

## Owner Operations
0. Create contract Pyaroll.
1. Add 10000 ether to the contract:
```
addFund();
```
![addFund](./screenshots/01_addFund.png)

2. Add employee2:
```
addEmployee("0x14723a09acff6d2a60dcdf7aa4aff308fddc160c", 1);
```
![addEmployee](./screenshots/02_addEmployee.png)

3. Add employee3:
```
addEmployee("0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db", 2);
```
![addEmployee](./screenshots/03_addEmployee.png)

4. Update employee3 salary:
```
updateEmployeeSalary("0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db", 4);
```
![updateEmployeeSalary](./screenshots/04_updateEmployeeSalary.png)

5. Remove employee2:
```
removeEmployee("0x14723a09acff6d2a60dcdf7aa4aff308fddc160c");
```
![removeEmployee](./screenshots/05_removeEmployee.png)

6. Calculate runway:
```
calculateRunway();
```
![calculateRunway](./screenshots/06_calculateRunway.png)

7. Check if the contract has enough fund:
```
hasEnoughFund();
```
![hasEnoughFund](./screenshots/07_hasEnoughFund.png)

## Employee Operations
8. Employee2 (leave-office employee) gets severance pay:
```
getSeverancePay();
```
![getSeverancePay](./screenshots/08_getSeverancePay.png)

9. Employee3 changes his payment address:
```
changePaymentAddress("0x583031d1113ad414f02576bd6afabfb302140225");
```
![changePaymentAddress](./screenshots/09_changePaymentAddress.png)

10. Employee3 gets paid using the new payment address:
```
getPaid();
```
![getPaid](./screenshots/10_getPaid.png)

## Owner Operation Continued
11. Owner transfers contract ownership to employee3:
```
transferOwnership("0x583031d1113ad414f02576bd6afabfb302140225");
```
![transferOwnership](./screenshots/11_transferOwnership.png)
