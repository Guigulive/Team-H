## Smart Contract Development Homework-2

- 增加新员工可通过quicklyAddEmployee()函数实现
- 优化过的calculateRunway()函数名为newCalculateRunway()

## Gas costs of the original calculateRunway() function
| Number of Employees| Transaction Cost |	Execution Cost | Total Gas Cost |
| --- | --- | --- | --- |
| 01 | 22988 | 1716 | 24704 |
| 02 | 23769 | 2497 | 26266 |
| 03 | 24550 | 3278 | 27828 |
| 04 | 25331 | 4059 | 29390 |
| 05 | 26112 | 4840 | 30952 |
| 06 | 26893 | 5621 | 32514 |
| 07 | 27674 | 6402 | 34076 |
| 08 | 28455 | 7183 | 35638 |
| 09 | 29236 | 7964 | 37200 |
| 10 | 30017 | 8745 | 38762 |

每增加一个新员工，calculateRunway()消耗的gas就会增加1562。这是因为每次calculateRunway都要遍历当前的employees数组，随着数组长度增加，函数需要更多的gas来访问新的数组成员。

## Gas costs of the optimized calculateRunway() function

| Number of Employees| Transaction Cost |	Execution Cost | Total Gas Cost |
| --- | --- | --- | --- |
| 01 | 22168 | 896 | 23064 |
| 02 | 22168 | 896 | 23064 |
| 03 | 22168 | 896 | 23064 |
| 04 | 22168 | 896 | 23064 |
| 05 | 22168 | 896 | 23064 |
| 06 | 22168 | 896 | 23064 |
| 07 | 22168 | 896 | 23064 |
| 08 | 22168 | 896 | 23064 |
| 09 | 22168 | 896 | 23064 |
| 10 | 22168 | 896 | 23064 |

## newCalculateRunway()的优化是通过以下方式实现的：
- 增加新的全局变量newTotalSalary
- 在addEmployee(), removeEmployee(), updateEmployee()函数中更新newTotalSalary
