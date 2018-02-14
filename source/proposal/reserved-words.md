title: 保留字
---

保留字（Reserved Words）是 JavaScript 预留的一些标识符名（IdentifierName），保留字不能用作变量、函数名、和对象名。

在 ES 规范中，保留字定义如下：

```
ReservedWord ::
    Keyword
    FutureReservedWord
    NullLiteral
    BooleanLiteral
```

保留字包括：关键字、未来保留字、Null 字面量，布尔字面量。

**Null 字面量**只有 1 个值：`null`。

**布尔字面量**包括 2 个值：`true` 和 `false`。

**未来保留字**被用作未来语言特性扩展时可能会使用到的关键字，因此保留。

## ES6(ES2015) 关键字

ES6(ES2015) 的**关键字**有 33 个：

```js
break
do
in
typeof
case
else
instanceof
var
catch
export
new
void
class
extends
return
while
const
finally
super
with
continue
for
switch
yield
debugger
function
this	
default
if
throw	
delete
import
try
```

未来保留字有 2 个：

```js
enum
await
```

当下列 tokens 出现在严格模式代码 (strict mode code )里，将被当成是未来保留字(FutureReservedWords)：

```js
implements
package
protected	
interface
private
public	
```

在某些特定上下文中，`yield` 可以被赋予标识符的语义。

以下代码都是正确的：

```js
var yield = 0;
let yield = 0;
const yield = 0;
function yield(){};
```

在严格模式代码中，`let` 和 `static` 通过静态语义（static semantic）限制，而不是词法语法分析（lexical grammar）作为保留关键字处理。

```js
function foo() {
    'use strict';
    var let = 0;    // SyntaxError: Unexpected strict mode reserved word
    var if = 0;     // SyntaxError: Unexpected token if
    var enum = 0;   // SyntaxError: Unexpected reserved word

    let let = 0;    // SyntaxError: Unexpected strict mode reserved word
    let if = 0;     // SyntaxError: Unexpected strict mode reserved word
    let enum = 0;   // SyntaxError: Unexpected strict mode reserved word

    function let(){}   // SyntaxError: Unexpected strict mode reserved word
    function if(){}    // SyntaxError: Unexpected token if
    function enum(){}  // SyntaxError: Unexpected reserved word
}

function foo() {
    var let = 0;    // let 值为 0
    var if = 0;     // SyntaxError: Unexpected token if
    var enum = 0;   // SyntaxError: Unexpected reserved word

    let let = 0;    // SyntaxError: let is disallowed as a lexically bound name
    let if = 0;     // SyntaxError: Unexpected token if
    let enum = 0;   // SyntaxError: Unexpected reserved word

    function let(){}   // 正常
    function if(){}    // SyntaxError: Unexpected token if
    function enum(){}  // SyntaxError: Unexpected reserved word
}
```

## ES7(ES2016) 关键字

ES7 没有新增保留字。

## ES8(ES2017) 关键字

`await` 从未来保留字(FutureReservedWords)变成了关键字。语义和 `yield` 一样。

以下代码都是正确的：

```js
var await = 0;
let await = 0;
const await = 0;
function await(){};
```

## 其它

ES7(ES2016) 新增了[异步函数](./ecmascript-asyncawait.html)，但是在现行规范里面，`async` 并不是关键字(???)。但是从代码表现的行为来看，`async` 也类似与 `await` 和 `yield`。

没有进入关键字的还有 `get` 和 `set`。