#  python 常用方法

[如何在python中实现远程导入模块](https://www.sohu.com/a/278137679_575744)

## 1文件操作

### 1:获取项目路径
```
import os
path = os.getcwd()
```

### 2:判断文件是否存在
```
import os
os.path.exists(test_file.txt)
```

### 3判断文件夹是否存在
```
import os
os.path.exists(test_dir)
```

# 2.运行时
### 1 通过字符串调用函数或方法
#### 1 eval()
```
func_list = ["foo","bar"]
for func in func_list:
    eval(func)()
```
#### 2 locals()和globals()
```
for func in func_list:
    locals()[func]()
```
```
for func in func_list:
    globals()[func]()
```

#### 3 getattr()
```
import foo
getattr(foo, 'bar')()
```
 返回 Foo 类的属性
```
class Foo:
    def do_foo(self):
        ...

    def do_bar(self):
        ...

f = getattr(foo_instance, 'do_' + opname)
f()
``` 

