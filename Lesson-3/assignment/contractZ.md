L(0) = [0]

L(A) = [A] + merge(L(0), [0])
      = [A] + merge([0],[0])
      = [A,0]

L(B) = [B,0]

L(C) = [C,0]

L(K1) = [K1] + merge(L[B],L[A],[B,A])
      = [K1] + merge([B,0],[A,0],[B,A])
      = [K1, B] + merge([0],[A,0],[A])
      = [K1, B, A] + merge([0],[0])
      = [K1, B, A, 0]

L(K2) = [K2] + merge(L[C],L[A],[C,A])
      = [K2] + merge([C,0],[A,0],[C,A])
      = [K2, C] + merge([0],[A,0],[A])
      = [K2, C, A] + merge([0],[0])
      = [K2, C, A, 0]

L(Z)  = [Z] + merge(L[K2],L[K1],[K2,K1])
      = [Z] + merge([K2,C,A,0],[K1,B,A,0],[K2,K1])
      = [Z, K2] + merge([C,A,0],[K1,B,A,0],[K1])
      = [Z, K2, C] + merge([A,0],[K1,B,A,0],[K1])
      = [Z, K2, C, K1] + merge([A,0],[B,A,0])
      = [Z, K2, C, K1, B] + merge([A,0],[A,0])
      = [Z, K2, C, K1, B, A] + merge([0],[0])
      = [Z, K2, C, K1, B, A, 0]