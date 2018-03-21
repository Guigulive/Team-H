## Lesson 3 作业结果
### 第一题：完成今天所开发的合约产品化内容，使用Remix调用每一个函数，提交函数调用截图
### 第二题：增加 changePaymentAddress 函数，更改员工的薪水支付地址，思考一下能否使用modifier整合某个功能
### 第三题（加分题）：自学C3 Linearization, 求以下 contract Z 的继承线
```
contract O
contract A is O
contract B is O
contract C is O
contract K1 is A, B
contract K2 is A, C
contract Z is K1, K2

//计算过程
L(O) := [O]
L(A) := [A] + merge(L(O), [O])
      = [A] + merge([O], [O])
      = [A, O]
      
L(B) := [B, O]//计算过程类似L(A)
L(C) := [C, O]//计算过程类似L(A)

L(K1) := [K1] + merge(L(B), L(A), [B, A])
       = [K1] + merge([B, O], [A, O], [B, A])
       //一个序列的第一个元素，是其他序列中的第一个元素，或不在其他序列出现，符合条件是B
       = [K1, B] + merge([O], [A, O], [A])
       = [K1, B, A] + merge([O], [O])
       = [K1, B, A, O]
       
 L(K2) := [K2, C, A, O]//计算过程类似L(K1)
 
 L(Z) := [Z] + merge(L(K2), L(K1), [K2, K1])
       = [Z] + merge([K2, C, A, O], [K1, B, A, O], [K2, K1])
       = [Z, K2] + merge([C, A, O], [K1, B, A, O], [K1])
       = [Z, K2, C] + merge([A, O], [K1, B, A, O], [K1])
       = [Z, K2, C, K1] + merge([A, O], [B, A, O])
       = [Z, K2, C, K1, B] + merge([A, O], [A, O])
       = [Z, K2, C, K1, B, A] + merge([O], [O])
       = [Z, K2, C, K1, B, A, O]
       
//遍历执行merge操作的序列，如果一个序列的第一个元素，是其他序列中的第一个元素，或不在其他序列出
//现，则从所有执行merge操作序列中删除这个元素，合并到当前的mro中。
//merge操作后的序列，继续执行merge操作，直到merge操作的序列为空。
```

