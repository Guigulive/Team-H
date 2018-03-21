#!/usr/bin/python
class O(object):
    pass

class A(O):
    pass

class B(O):
    pass

class C(O):
    pass

class K1(B,A):
    pass

class K2(C,A):
    pass

class Z(K2,K1):
    pass

print Z.__mro__

# 验证结果
#ted@MacBook-Pro  ~/Python  python mro.py
#(<class '__main__.Z'>, <class '__main__.K2'>, <class '__main__.C'>,
#<class '__main__.K1'>, <class '__main__.B'>, <class '__main__.A'>,
#<class '__main__.O'>, <type 'object'>)
