1. 加入十个员工，每个员工的薪水都是1ETH 每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
The execution cost trend after adding 10 employees:
1: 1694gas
2: 2475gas
3: 3256gas
4: 4037gas
5: 4818gas
6: 5599gas
7: 6380gas
8: 7161gas
9: 7942gas
10: 8723gas
The gas keeps increasing because every time we need to read data from storage and sum up the salary for every employee in the array to get the total salary. The number of emplyee increased so the job in that for loop becomes costly.

2. Optimize the function calculateRunway
Use a globle parameter totalSalary to record the total salary. Similary we could do something to find the employee to avoid using for loop. After the optimization, the new gas fee remins 852 no matter how many emplyee is added.
