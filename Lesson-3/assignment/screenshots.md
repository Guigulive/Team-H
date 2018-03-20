# Screenshots of Function Execution

## Owner Operations
0. Create contract Pyaroll.
1. Add 10000 ether to the contract:
```
addFund();
```
![addFund](/screenshots/01.png)

2. Add employee2:
```
addEmployee("0x14723a09acff6d2a60dcdf7aa4aff308fddc160c", 1);
```
![addEmployee](./screenshots/01.png)

3. Add employee3:
```
addEmployee("0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db", 2);
```
![addEmployee](/screenshots/03 addEmployee.png)

4. Update employee3 salary:
```
updateEmployeeSalary("0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db", 4);
```
![updateEmployeeSalary](/screenshots/04 updateEmployeeSalary.png)

5. Remove employee2:
```
removeEmployee("0x14723a09acff6d2a60dcdf7aa4aff308fddc160c");
```
![removeEmployee](/screenshots/05 removeEmployee.png)

6. Calculate runway:
```
calculateRunway();
```
![calculateRunway](/screenshots/06 calculateRunway.png)

7. Check if the contract has enough fund:
```
hasEnoughFund();
```
![hasEnoughFund](/screenshots/07 hasEnoughFund.png)

## Employee Operations
8. Employee2 (leave-office employee) gets severance pay:
```
getSeverancePay();
```
![getSeverancePay](/screenshots/08 getSeverancePay.png)

9. Employee3 changes his payment address:
```
changePaymentAddress("0x583031d1113ad414f02576bd6afabfb302140225");
```
![changePaymentAddress](/screenshots/09 changePaymentAddress.png)

10. Employee3 gets paid using the new payment address:
```
getPaid();
```
![getPaid](/screenshots/10 getPaid.png)
