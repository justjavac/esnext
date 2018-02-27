title: 正则表达式反向(lookbehind)断言
---

“正则表达式反向断言” 提案 [proposal-regexp-lookbehind](https://github.com/tc39/proposal-regexp-lookbehind) 由 Gorkem Yakin, Nozomu Katō, Daniel Ehrenberg 负责，目前已经进入 stage 4，预计会是 ES9(ES2018) 的一部分。

## 1. 概述

断言(Assertion)是一个对当前匹配位置之前或之后的字符的测试， 它不会实际消耗任何字符，所以断言也被称为“非消耗性匹配”或“非获取匹配”。

正则表达式的断言一共有 4 种形式：

- `(?=pattern)` 零宽正向肯定断言(zero-width positive lookahead assertion) 
- `(?!pattern)` 零宽正向否定断言(zero-width negative lookahead assertion) 
- `(?<=pattern)` 零宽反向肯定断言(zero-width positive lookbehind assertion) 
- `(?<!pattern)` 零宽反向否定断言(zero-width negative lookbehind assertion) 

这里面的 pattern 是一个正则表达式。

lookahead 和 lookbehind 通过被翻译为：

- 正向 负向
- 前向 后向
- 正向 反向
- 前瞻 后瞻
- ……

本文档使用“正向”、“反向”。

## 2. Lookahead assertions 正向断言

在当前的 JavaScript 正则表达式版本中，只支持正向断言。

正向断言的意思是：当前位置后面的字符串应该满足断言，但是并不捕获，仅此而已。

举个例子：

```js
const regex = /just(?=java)/;
```

这个正则表达式可以匹配 `"justjava"`，但是正则表达式匹配到的字符串不包含 `"java"`。（这个正则表达式可以匹配 `"justjavac"` 中的 `"just"`，注意，匹配的结果是 `just`，并不是 `"justjavac"`）

```js
const match1 = regex.exec('justjavac');
console.log(match1[0]);   // 结果是 just
```

但是如果这个字符串没有包含 `"java"`，那么这个正则表达式无法成功匹配：

```js
const match2 = regex.exec('justphp');
console.log(match2);      // null
```

如果使用否定断言则正好相反:

```js
const regex = /just(?!java)/;

const match1 = regex.exec('justjavac');
console.log(match1);    // null

const match2 = regex.exec('justphp');
console.log(match2[0]); // 结果是 just
```

## 3. 反向断言

反向断言和正向断言的行为一样，只是方向相反。

反向肯定断言使用语法 `(?<=...)`。

比如我们想获取所有的人民币金额，但是不获取其它货币（比如美元）：

```js
const regex = /(?<=￥)\d+(\.\d*)?/;
regex.test('￥1.9');     // true
regex.test('$1.2');      // false
```

反向否定断言使用语法 `(?<!...)`，和肯定断言正好相反：

```js
const regex = /(?<!￥)\d+(\.\d*)?/;
regex.test('￥1.9');     // false???
regex.test('$1.2');      // true
```

在上面的例子中，`regex.test('￥1.9')` 的结果是 `true`，并不是我们认为的 `false`。

这不是反向断言的一个例外，而是这段代码的一个小 bug。

```js
const regex = /(?<!￥)\d+(\.\d*)?/;
regex.exec('￥1.9');
// ["9", undefined, index: 3, input: "￥1.9", groups: undefined]
```

这段正则表达式匹配到了 `'￥1.9'` 里面的 `9`。因为 `9` 前面是 `.` 而不是 `￥`，完全符合反向否定断言规则。

## 4. 组合

多个断言(任意顺序)可以同时出现。 

比如 `(?<=\d{3})(?<!999)foo` 匹配前面有三个数字但不是 `999` 的字符串 `foo`。

```js
const regex = /(?<=\d{3})(?<!999)foo/;
regex.test('123foo');    // true
regex.test('1239foo');   // true
regex.test('12399foo');  // true
regex.test('123999foo'); // false
```

注意，每个断言独立应用到对目标字符串该点的匹配。首先它会检查前面的三位都是数字，然后检查这三位不是 `999`。 这个模式不能匹配 `foo` 前面有三位数字然后紧跟 3 位非 `999` 共 6 个字符的字符串，比如， 它不匹配 `123abcfoo`。 匹配 `123abcfoo` 这个字符串的模式可以是 `(?<=\d{3}...)(?<!999)foo`。

```js
const regex = /(?<=\d{3}...)(?<!999)foo/;
regex.test('123abcfoo');    // true
```

这种情况下，第一个断言查看(当前匹配点)前面的 6 个字符，检查前三个是数字， 然后第二个断言检查(当前匹配点)前三个字符不是 `999`。

断言可以以任意复杂度嵌套。

比如 `(?<=(?<!foo)bar)baz` 匹配前面有 `bar` 但是 `bar` 前面没有 `foo` 的 `baz`。 

另外一个模式 `(?<=\d{3}...(?<!999))foo` 则匹配前面有三个数字字符紧跟 3 个不是 `999` 的任意字符的 `foo`。

## 5. 细节

### 5.1 从右向左的贪婪匹配

如果组中有贪婪匹配的子模式，则在反向断言中的捕获组将具有不同的值。

当在反向断言中，右侧的组将捕获大多数字符，而不是左侧的组。

当模式 `/(?<=(\d+)(\d+))$/` 匹配 `1053` 时，第 1 个组捕获 `'1'`，第 2 个组捕获 `'053'`。

当普通模式 `/^(\d+)(\d+)/` 匹配 `1053` 时，第 1 个组捕获 `'105'`，第 2 个组捕获 `'3'`。

### 5.2 捕获组的索引

在反向断言匹配中，组的次序是从左到右的。

当模式 `/(?<=(\d+)(\d+))$/` 匹配 `1053` 时，`match[1]` 是 `"1"`，`match[2]` 是 `"053"`。

### 5.3 引用捕获组

只有当捕获组被执行后，我们才能对他进行引用。

例如在正则表达式 `/(?<=(.)\1)/` 中，`\1` 的值始终是空字符串，正确的写法是 `/(?<=\1(.))/`。

## 6 实现

- [V8](https://bugs.chromium.org/p/v8/issues/detail?id=4545), shipping in Chrome 62
- [XS](https://github.com/Moddable-OpenSource/moddable/blob/public/xs/sources/xsre.c), in [January 17, 2018 update](http://blog.moddable.tech/blog/january-17-2017-big-update-to-moddable-sdk/)