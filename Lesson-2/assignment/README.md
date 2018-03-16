## 硅谷live以太坊智能合约 第二课作业
### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中

- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？


- 如何优化calculateRunway这个函数来减少gas的消耗？
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化

### 第二课：课后作业解答
* **智能合约代码：**[Payroll.sol](https://github.com/xiongwei-git/Team-H/blob/74-%E7%86%8A%E4%BC%9F/Lesson-2/assignment/Payroll.sol)
* **gas变化记录**
    
    | add index | gas cost |
    | --- | --- |
    | 0 | 23211 |
    | 1 | 23981 |
    | 2 | 24751 |
    | 3 | 25521 |
    | 4 | 26291 |
    | 5 | 27061 |
    | 6 | 27831 |
    | 7 | 28601 |
    | 8 | 29371 |
    | 9 | 30141 |
    
    Gas消耗有变化，因为每次新增员工之后，调用calculateRunway这个函数，for循环都要增加一次运算，而Gas也正好是逐步增加770 Wei的。
    
* **calculateRunway函数优化**
    
    [Payroll_Optimize.sol](https://github.com/xiongwei-git/Team-H/blob/74-%E7%86%8A%E4%BC%9F/Lesson-2/assignment/Payroll_Optimize.sol)
    定义一个storage变量totalSalary，在新增、修改或者删除员工时，将对应的员工salary统计到totalSalary中。取代calculateRunway函数中的for循环，这样可以将预算的复杂度从O(n²)降低至O(n)。


