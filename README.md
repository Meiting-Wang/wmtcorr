# Stata 新命令：wmtcorr——相关系数矩阵的输出

> 作者：王美庭  
> Email: wangmeiting92@gmail.com

## 更新记录

- 2020年6月23日：消除了eststo对输出结果的影响

## 摘要

本文主要介绍了个人编写的可将相关系数矩阵输出至 Stata 界面、Word 以及 LaTeX 的`wmtcorr`命令。

## 目录

- **摘要**
- **一、引言**
- **二、命令的安装**
- **三、语法与选项**
- **四、实例**
- **五、输出效果展示**

## 一、引言

本文介绍的`wmtcorr`的命令，可以将相关系数矩阵输出至 Stata 界面、Word 的 .rtf 文件和 LaTeX 的.tex 文件。基于`esttab`内核，`wmtcorr`不仅具有了`esttab`的优点，同时也简化了书写语法。

本文阐述的`wmtcorr`命令，和已经或即将推出`wmtsum`、`wmttest`、`wmtreg`和`wmtmat`命令，都可以通过`append`选项成为一个整体，将输出结果集中于一个 Word 或 LaTeX 文件中。关于以上系列命令更多的优点，可参阅[「Stata 新命令：wmtsum——描述性统计表格的输出」](https://mp.weixin.qq.com/s/oLgXf0KTgoePOnN1mJUllA)。

## 二、命令的安装

`wmtcorr`命令以及本人其他命令的代码都将托管于 GitHub 上，以使得同学们可以随时下载安装这些命令。

首先你需要有`github`命令，如果没有，可参照[「Stata 新命令：wmtsum——描述性统计表格的输出」](https://mp.weixin.qq.com/s/oLgXf0KTgoePOnN1mJUllA)进行安装。

然后你就可以运行以下命令安装最新的`wmtcorr`命令及其帮助文件了：

```stata
github install Meiting-Wang/wmtcorr
```

当然，你也可以`github search`一下，也能找到`wmtcorr`命令安装的入口：

```stata
github search wmtcorr
```

或许，你想一下子找到`wmtsum`、`wmttest`、`wmtcorr`、`wmtreg`以及`wmtmat`所有命令在 GitHub 的安装入口，那么你可以：

```stata
github search wmt
```

## 三、语法与选项

**命令语法**：

```stata
wmtcorr [varlist] [if] [in] [weight] [using filename] [, options]
```

> - `varlist`: 仅可以输入数值型变量，若为空，则自动导入内存中所有数值型变量
> - `weight`: 可以选择 fweight、aweight、iweight 和 pweight，默认为空
> - `using`: 可以将结果输出至 Word（ .rtf 文件）和 LaTeX（ .tex 文件）

**选项（options）**：

- 一般选项
  - `b(fmt)`：设置相关系数的数值格式
  - `p(fmt)`：额外报告 P 值，以及设置 P 值的数值格式
  - `title()`：设置表格标题，默认为`Correlation coefficient matrix`
  - `staraux`：在 P 值上标注星号（`* p<0.1, ** p<0.05, *** p<0.01`）
  - `nostar`：不报告星号
  - `corr`：表示报告的相关系数与`corr`命令的默认输出结果一致（在计算相关系数前会先去除包含缺漏值的观察值）
  - `pwcorr`：表示报告的相关系数与`pwcorr`命令的默认输出结果一致（在计算相关系数前不会先删除包含缺漏值的观察值）
  - `replace`：将结果输出至 Word 或 LaTeX 时，替换已有的文件
  - `append`：将结果输出至 Word 或 LaTeX 时，可附加在已经存在的文件中
- LaTeX 专有选项
  - `alignment()`：设置 LaTeX 表格的列对齐格式，可输入`math`或`dot`，`math`设置列格式为居中对齐的数学格式（自动添加宏包`booktabs`和`array`），`dot`表示小数点对齐的数学格式（自动添加宏包`booktabs`、`array`和`dcolumn`）。默认为`math`
  - `page()`：可添加用户额外需要的宏包

> - `corr`与`pwcorr`选项至多存在一个，默认为`corr`
> - 以上其中的一些选项可以缩写，详情可以在安装完命令后`help wmtcorr`

## 四、实例

```stata
* 相关系数矩阵输出实例
sysuse auto.dta, clear
wmtcorr //输出所有数值变量的相关系数矩阵
wmtcorr price foreign length rep78 //输出特定变量的相关系数矩阵
wmtcorr price foreign length rep78, b(4) //设置相关系数的数值格式
wmtcorr price foreign length rep78, b(4) p(%9.3f) //报告p值并设定p值的数值格式
wmtcorr price foreign length rep78, b(4) p(%9.3f) staraux //将星号标注在p值上
wmtcorr price foreign length rep78, b(4) p(%9.3f) nostar //不标注星号
wmtcorr price foreign length rep78, b(4) p(%9.3f) pwcorr //以pwcorr的方式报告相关系数矩阵
wmtcorr price foreign length rep78, ti(this is a title) //设置表格标题
wmtcorr price foreign length rep78 using Myfile.rtf, replace //将结果输出至 Word
wmtcorr price foreign length rep78 using Myfile.tex, replace //将结果输出与 LaTeX
wmtcorr price foreign length rep78 using Myfile.tex, replace a(dot) //将 LaTeX 列表格格式设置为小数点对齐
```

> 以上所有实例都可以在`help wmtcorr`中直接运行。
> ![image](https://user-images.githubusercontent.com/42256486/81492156-3e074600-92c8-11ea-98dc-00352c4e4c40.png)

## 五、输出效果展示

- **Stata**

```stata
wmtcorr price foreign length rep78
```

```stata
Correlation coefficient matrix
--------------------------------------------------------------
               price      foreign       length        rep78
--------------------------------------------------------------
price          1.000
foreign       -0.017        1.000
length         0.442***    -0.611***     1.000
rep78          0.007        0.592***    -0.361***     1.000
--------------------------------------------------------------
* p<0.1, ** p<0.05, *** p<0.01
```

```stata
wmtcorr price foreign length rep78, p
```

```stata
Correlation coefficient matrix
--------------------------------------------------------------
               price      foreign       length        rep78
--------------------------------------------------------------
price          1.000

foreign       -0.017        1.000
             (0.887)
length         0.442***    -0.611***     1.000
             (0.000)      (0.000)
rep78          0.007        0.592***    -0.361***     1.000
             (0.957)      (0.000)      (0.002)
--------------------------------------------------------------
p-values in parentheses
* p<0.1, ** p<0.05, *** p<0.01
```

- **Word**

```stata
wmtcorr price foreign length rep78 using Myfile.rtf, replace
```

![image](https://user-images.githubusercontent.com/42256486/81492162-4495bd80-92c8-11ea-9c4e-789105b08ef7.png)

- **LaTeX**

```stata
wmtcorr price foreign length rep78 using Myfile.tex, replace
```

![image](https://user-images.githubusercontent.com/42256486/81492165-48294480-92c8-11ea-8b16-7b9b17f1cd0d.png)

```stata
wmtcorr price foreign length rep78 using Myfile.tex, replace a(dot)
```

![image](https://user-images.githubusercontent.com/42256486/81492166-4c556200-92c8-11ea-8f55-da4ec04862f7.png)


> 在将结果输出至 Word 或 LaTeX 时，Stata 界面上也会呈现对应的结果，以方便查看。
