title: 非转义序列的模板字符串
---

这个 ECMAScript 提案 “[Template Literal Revision](https://tc39.github.io/proposal-template-literal-revision/)” 由 Tim Disney 负责，目前已经进入 stage 4，本提案是 ECMAScript 2018(ES9) 的一部分。该提案让我们使用模板字符串的标签函数语法更加的自由。

## 1. 标签函数 Tagged templates

标签使您可以用函数解析模板字符串。标签函数的第一个参数包含一个字符串值的数组。其余的参数与表达式相关。最后，你的函数可以返回处理好的的字符串（或者它可以返回完全不同的东西）。

```js
function foo(str) {
    return str[0].toUpperCase();
}

foo`justjavac`; // 输出 JUSTJAVAC
foo`Xyz`; // 输出 XYZ
```

## 2. `String.raw()`

`String.raw()` 是一个模板字符串的标签函数，它的作用类似于 Python 中的字符串前缀 r 和 C# 中的字符串前缀 @，是用来获取一个模板字符串的**原始字面量值**的。

语法：

```js
String.raw(callSite, ...substitutions)
String.raw`templateString`
```

`String.raw()` 是唯一一个内置的模板字符串标签函数。

```js
var str = String.raw`Hi\n${2+3}!`;
// "Hi\n5!"

str.length;
// 字符串长度为 6

str.split('').join(',');
// 分隔字符串
// 结果是："H,i,\,n,5,!"
```

## 3. 原始字符串

在标签函数的第一个参数中，存在一个特殊的属性 `raw`，我们可以通过它来访问模板字符串的原始字符串，而不经过特殊字符的替换。

```js
function foo(str) {
    console.log(str);
    return str[0].toUpperCase();
}

foo`justjavac`;

// 控制台输出
["justjavac", raw: ["justjavac"]]

foo`just\\java\\c`;
// 控制台输出
["just\java\c", raw: ["just\\java\\c"]]
```

## 4. 带标签函数的转义序列

自 ES2016 起，带标签的模版字面量遵守以下转义序列的规则：

- Unicode字符以"\u"开头，例如 `\u00A9`
- Unicode码位用"\u{}"表示，例如 `\u{2F804}`
- 十六进制以"\x"开头，例如 `\xA9`
- 八进制以"\"和数字开头，例如 `\251`

对于每一个 ECMAScript 语法，解析器都会去查找有效的转义序列，对于无效的转义序列，直接抛出 `SyntaxError`：

```js
String.raw`\`;
Uncaught SyntaxError: Unterminated template literal
```

## 5. ES2018 关于非法转义序列的修订

带标签函数的模版字符串应该允许嵌套支持常见转义序列的语言（例如 [DSLs](https://en.wikipedia.org/wiki/Domain-specific_language)、[LaTeX](https://en.wikipedia.org/wiki/LaTeX)）。

因此 ECMAScript 2018 标准移除了对 ECMAScript 在带标签的模版字符串中转义序列的语法限制。

```js
function tag(strs) {
  strs[0] === undefined
  strs.raw[0] === "\\unicode and \\u{55}";
}

// 在标签函数中使用
tag`\unicode and \u{55}`; // 结果是 undefined

// 不在标签函数中使用
let bad = `bad escape sequence: \unicode`;
// throws early error：SyntaxError: Invalid Unicode escape sequence
```

## 6. 实现

- [V8](https://bugs.chromium.org/p/v8/issues/detail?id=5546) - Chrome 62
- [SpiderMonkey](https://bugzilla.mozilla.org/show_bug.cgi?id=1317375) - Firefox 53
- [JavaScriptCore](https://bugs.webkit.org/show_bug.cgi?id=166871) - 版本未知
- [ChakraCore](https://github.com/Microsoft/ChakraCore/issues/2344) - 开发中
- [Babel](https://github.com/babel/babel/issues/4798) - 7.x

## 7. 相关链接：

- https://github.com/tc39/proposal-template-literal-revision
- https://tc39.github.io/proposal-template-literal-revision/
- https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/template_strings
