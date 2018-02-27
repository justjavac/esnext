title: 正则表达式 s/dotAll 模式
---

“正则表达式的 `s` (dotAll) flag” 提案 [proposal-regexp-dotall-flag](https://github.com/tc39/proposal-regexp-dotall-flag) 由 Mathias Bynens 负责，目前已经进入 stage 4，并将成为 ES9(ES2018) 的一部分。

## 1. 概述

在 JavaScript 正则表达式中 `.` 用来匹配任何单个字符。但是有 2 个例外：

### 1.1 多字节 emoji 字符

```js
let regex = /^.$/;
regex.test('😀');   // false
```

我们可以通过设置 `u` 标志来解决，`u` 的含义是 unicode：

```js
let regex = /^.$/u;
regex.test('😀');   // true
```

### 1.2 行终结符(line terminator characters)

行终结符包含：

- U+000A LINE FEED (LF) (`\n`) - 换行
- U+000D CARRIAGE RETURN (CR) (`\r`) - 回车
- U+2028 LINE SEPARATOR - 行分隔符
- U+2029 PARAGRAPH SEPARATOR - 段分隔符

还有一些其它字符，也可以作为一行的开始：

- U+000B VERTICAL TAB (`\v`)
- U+000C FORM FEED (`\f`)
- U+0085 NEXT LINE

目前 JavaScript 正则表达式的 `.` 可以匹配其中的一部分：

```js
let regex = /./;

regex.test('\n');       // false
regex.test('\r');       // false
regex.test('\u{2028}'); // false
regex.test('\u{2029}'); // false

regex.test('\v');       // true
regex.test('\f');       // true
regex.test('\u{0085}'); // true
```

在正则表达式中，用于表示字符串开头和字符串结尾的元字符是 `^` 和 `$`, 因此一个变通的方式是使用 `^` 来匹配。

```js
/foo.bar/.test('foo\nbar');     // false
/foo[^]bar/.test('foo\nbar');   // true
```

或者使用 `\s` 来匹配空白字符：

```js
/foo.bar/.test('foo\nbar');     // false
/foo[\s]bar/.test('foo\nbar');   // true
```

## 2. 增加 s/dotAll 标志

在最新的 ECMAScript 规范中，为 JavaScript 的正则表达式增加了一个新的标志 `s` 用来表示 dotAll。以使 `.` 可以匹配任意字符。

```js
/foo.bar/s.test('foo\nbar');    // true
```

High-level API

```js
const re = /foo.bar/s;  //  等价于 const re = new RegExp('foo.bar', 's');
re.test('foo\nbar');    // true
re.dotAll;      // true
re.flags;       // "s"
```

## 3. 命名由来

既然是为了实现 dotAll 功能，为什么不命名为 `d` 或者 `a`。因为在其它语言的正则表达式实现中，已经使用 `s` 标志了：

- Java 使用 `Pattern.DOTALL`
- C# 和 VB 使用 `RegexOptions.Singleline`
- Python 同时支持 `re.DOTALL` 和 `re.S`

在支持正则表达式使用 flag 的语言如 Perl、PHP 也使用 `s` 作为标志。

`s` 的含义是 singleline 和 dotAll。

singleline(单行)对应的是 multiline(多行)。

`m` 标志用于指定多行输入字符串应该被视为多个行。如果使用 `m` 标志，`^` 和 `$` 匹配的开始或结束是字符串中的每一行，而不是整个字符串的开始或结束。

```js
/^java/.test('just\njava\n');   // false
/^java/m.test('just\njava\n');  // true
```

- `m` 标志只影响 `^` 和 `$`
- `s` 标志只影响 `.`

目前在 JavaScript 正则表示中所有修饰符的含义：

- g → global
- i → ignoreCase
- m → multiline
- y → sticky
- u → unicode
- s → dotAll

## 4. 实现

- [V8](https://bugs.chromium.org/p/v8/issues/detail?id=6172) - Chrome 62
- [JavaScriptCore](https://bugs.webkit.org/show_bug.cgi?id=172634) - [Safari Technology Preview 39a](https://developer.apple.com/safari/technology-preview/release-notes/)
- [XS](https://github.com/Moddable-OpenSource/moddable/blob/public/xs/sources/xsre.c), shipping in Moddable as of [the January 17, 2018 update](http://blog.moddable.tech/blog/january-17-2017-big-update-to-moddable-sdk/)
- [regexpu (transpiler)](https://github.com/mathiasbynens/regexpu) with the `{ dotAllFlag: true }` option enabled
  - [online demo](https://mothereff.in/regexpu#input=const+regex+%3D+/foo.bar/s%3B%0Aconsole.log%28%0A++regex.test%28%27foo%5Cnbar%27%29%0A%29%3B%0A//+%E2%86%92+true&dotAllFlag=1)
  - [Babel plugin](https://github.com/mathiasbynens/babel-plugin-transform-dotall-regex)
- [Compat-transpiler of RegExp Tree](https://github.com/dmitrysoshnikov/regexp-tree#using-compat-transpiler-api)
  - [Babel plugin](https://github.com/dmitrysoshnikov/babel-plugin-transform-modern-regexp)
