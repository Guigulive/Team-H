## 硅谷live以太坊智能合约 第二课作业
这里是同学提交作业的目录

### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
- 如何优化calculateRunway这个函数来减少gas的消耗？
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化


----------
### 答案

1 加入10个员工后调用calculateRunwei的gas消耗如下所示：

employee count | transaction cost | execution cost 
- | :-: | -: 
1	| 22966 gas |  	1694 gas
2	| 23747 gas | 	2475 gas
3	| 24528 gas | 	3256 gas
4	| 25309 gas | 	4037 gas
5	| 26090 gas | 	4818 gas
6	| 26871 gas | 	5599 gas
7	| 27652 gas | 	6380 gas
8	| 28433 gas | 	7161 gas
9	| 29214 gas | 	7942 gas
10	| 29995 gas | 	8723 gas

每增加一个新的employee，gas消耗也随之上升，这是因为for循环中的运算量越来越大。

2 calculateRunway的优化
把totalSalary定义为一个成员变量，每次增加、删除及更新员工信息时修改totalSalary的数值，cacllateRunway的实现简化为：

    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }

