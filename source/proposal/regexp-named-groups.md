title: 正则表达式命名捕获组
---

ECMAScript 提案“正则表达式命名捕获组” [proposal-regexp-named-groups](https://github.com/tc39/proposal-regexp-named-groups) 由 Gorkem Yakin, Daniel Ehrenberg 负责，目前已经进入 stage 4，将会是 ES9(ES2018) 的一部分。

## 1. 什么是捕获组

捕获组就是把正则表达式中子表达式匹配的内容，保存到内存中以数字编号或显式命名的组里，方便后面引用。而且，这种引用既可以是在正则表达式内部，也可以是在正则表达式外部。

捕获组有两种形式，一种是普通捕获组，另一种是命名捕获组。

目前 JavaScript 只支持数字形式的普通捕获组，而这个提案就是为了给 JavaScript 增加命名捕获组。

## 2. 捕获组编号规则

编号规则指的是以数字为捕获组进行编号的规则，编号为 0 的捕获组，指的是正则表达式整体。

```js
const regex = /(\d{4})-(\d{2})-(\d{2})/;
const matchers = regex.exec('2015-01-02');
matchers[0];    // 2015-01-02
matchers[1];    // 2015
matchers[2];    // 01
matchers[3];    // 02
```

## 3. 存在的缺点

使用数字捕获组的一个缺点是对于引用不太直观，以上面的例子，我们很难分清楚哪个组代表的是年，哪个组代表的是月。而且当我们交互了年和月的值时，使用捕获组引用的代码都需要更改。

而命名捕获组就是为了解决这个问题。

## 4. 命名捕获组

命名捕获组可以使用 `(?<name>...)` 语法给每个组起一个名字。

因此，用来匹配日期的正则表达式可以写为：

```js
/(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})/
```

每个捕获组的名字必须唯一。否则会抛出异常：

```js
/(?<foo>\d)-(?<foo>\d)/;
// SyntaxError: Invalid regular expression: /(?<foo>\d)-(?<foo>\d)/: Duplicate capture group name
```

捕获组的名字必须符合 JavaScript 的命名规范：

```js
/(?<666>\d)-(?<bar>\d)/;
// SyntaxError: Invalid regular expression: /(?<666>\d)-(?<bar>\d)/: Invalid capture group name
```

命名捕获组可以通过匹配结果的 `groups` 属性访问。

```js
let re = /(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})/;
let result = re.exec('2015-01-02');

result.groups.year === '2015';
result.groups.month === '01';
result.groups.day === '02';

result[0] === '2015-01-02';
result[1] === '2015';
result[2] === '01';
result[3] === '02';
```

如果使用解构赋值，还可以这样写：

```js
let re = /^(?<one>.*):(?<two>.*)$/;
let {groups: {one, two}} = re.exec('foo:bar');
console.log(`one: ${one}, two: ${two}`);  // 输出 one: foo, two: bar
```

## 5. 反向引用

当需要在正则表达式里面引用命名捕获组时，使用 `\k<name>` 语法。

例如：

```js
let duplicate = /^(?<half>.*).\k<half>$/;
duplicate.test('a*b'); // false
duplicate.test('a*a'); // true
```

如果引用一个不存在的命名捕获组时，会抛出异常：

```js
/^(?<foo>.*).\k<bar>$/;
// SyntaxError: Invalid regular expression: /^(?<foo>.*).\k<bar>$/: Invalid named capture referenced
```

命名捕获组也可以和普通数字捕获组一起使用：

```js
let triplicate = /^(?<part>.*).\k<part>.\1$/;
triplicate.test('a*a*a'); // true
triplicate.test('a*a*b'); // false
```

## 6. 替换

命名捕获组也可以在 `String.prototype.replace` 函数中引用。使用 `$<name>` 语法。

```js
let re = /(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})/;
let result = '2015-01-02'.replace(re, '$<day>/$<month>/$<year>');

result === '02/01/2015';
```

`String.prototype.replace` 第 2 个参数可以接受一个函数。这时 命名捕获组的引用会作为 `groups` 参数传递进去。

第 2 个参数的函数签名是 `function (matched, capture1, ..., captureN, position, S, groups)`。

```js
let re = /(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})/;

let result = '2015-01-02'.replace(re, (...args) => {
  let {day, month, year} = args[args.length - 1];
  return `${day}/${month}/${year}`;
});

result === '02/01/2015'
```

## 7. 命名捕获组未匹配

如果一个可选的命名捕获组没有匹配时，在匹配结果中，此命名组依然存在，值是 `undefined`。

```js
let re = /^(?<optional>\d+)?$/
const matchers = re.exec('');

matchers[0] === '';
matchers.groups.optional === undefined;
```

`(?<optional>\d+)?` 最后面的 `?` 表示匹配前面的模式 0 次或 1 次。

如果捕获组不是可选的，匹配结果是 `null`。

```js
let re = /^(?<foo>\d+)$/
const matchers = re.exec('');

matchers === null;
matchers.groups.foo;    // TypeError: Cannot read property 'groups' of null
```

## 8. 向下兼容

`/(?<name>)/` 和 `/\k<foo>/` 只有在命名捕获组中才有意义。如果正则表达式没有命名捕获组，那么 `/\k<foo>/` 仅仅是字符串字面量`"k<foo>"` 而已。

```js
/\k<foo>/.test('k<foo>');   // true
```

## 9. 实现

- [V8](https://bugs.chromium.org/p/v8/issues/detail?id=5437), shipping in Chrome 64
- [XS](https://github.com/Moddable-OpenSource/moddable/blob/public/xs/sources/xsre.c), in [January 17, 2018 update](http://blog.moddable.tech/blog/january-17-2017-big-update-to-moddable-sdk/)
- Transpiler ([Babel plugin](https://github.com/DmitrySoshnikov/babel-plugin-transform-modern-regexp#named-capturing-groups))
- [Safari](https://developer.apple.com/safari/technology-preview/release-notes/) beginning in Safari Technology Preview 40
