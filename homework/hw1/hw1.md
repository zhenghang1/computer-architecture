## <p align="center">作业1</p>

### 一、思考题

![e38a2d17a55629b734167955340df52](C:\Users\15989845233\Desktop\e38a2d17a55629b734167955340df52.jpg)

![2fdba7bfaf62ca3d34cf9f8e0029da3](C:\Users\15989845233\Desktop\2fdba7bfaf62ca3d34cf9f8e0029da3.jpg)





### 二、实践题

result：

![result](C:\Users\15989845233\AppData\Roaming\Typora\typora-user-images\image-20220305101813727.png "result")



codes:

+ allOddBits：

~~~c
int allOddBits(int x) {
	int s = 0x00000055;
	int y = s | (s << 8) | (s << 16) | (s << 24);
	int r = y | x;
	return !(r ^ (~0));
}
~~~

+ isLessOrEqual：

~~~c
int isLessOrEqual(int x, int y) {
//your codes here
        int x1=(x>>31)&0x1;
        int y1=(y>>31)&0x1;
        int nepo=x1&(~y1);
        int pone=(~x1)&y1;
        int diff=(~x+1)+y;
        int d=(diff>>31)&0x1;
        return nepo|(!pone&!d);
}
~~~

+ logicalNeg：

~~~c
int logicalNeg(int x) {
//your codes here
return ((x | (~x +1)) >> 31) + 1;
}
~~~

+ floatScale2：

~~~c
unsigned floatScale2(unsigned uf) {
	//your codes here
	unsigned sign = (uf >> 31) & 0x1;
	unsigned exp = (uf >> 23) & 0x000000FF;
	unsigned frac = ((0x0000007F << 16) | (0x000000FF << 8) | (0x000000FF)) & uf;
	if (exp == 0xFF)return uf;
	if (exp == 0)return (sign << 31) | (exp << 23) | (frac << 1);
	return (sign << 31) | ((++exp) << 23) | frac;
}
~~~

+ floatFloat2Int：

~~~c
int floatFloat2Int(unsigned uf) {
	//your codes here
	unsigned sign = (uf >> 31) & 0x1;
	unsigned exp = (uf >> 23) & 0x000000FF;
	unsigned frac = ((0x0000007F << 16) | (0x000000FF << 8) | (0x000000FF)) & uf;
	int E = exp - 127;
	if (E < 0)return 0;
	else if (E >= 31)return 0x80000000;
	else {
		frac = frac | (1 << 23);
		if (E > 23)frac <<= (E - 23);
		else frac >>= (23 - E);
		if (sign)return -frac;
		else return frac;
	}
}
~~~

