## 硅谷live以太坊智能合约 第二课作业
这里是同学提交作业的目录

### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？

remix打不开啦，消耗数字没法看到。 答案大概是：肯定会变化，因为for循环每次都会计算，第一课讲过只要有计算就会消耗gae.

- 如何优化calculateRunway这个函数来减少gas的消耗？
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化

在Payroll_edit.sol合约里有修改，遍历多少次就会增加多少gas消耗，如果放在crud（增删改查）函数里修改totalSalary的数值就不会出现gas消耗了;
