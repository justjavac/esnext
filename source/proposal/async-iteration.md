title: 异步迭代器
---

## 1. 概述

在 ECMAScript 2015(ES6) 中 JavaScript 引入了迭代器接口（iterator）用来遍历数据。迭代器对象知道如何每次访问集合中的一项， 并跟踪该序列中的当前位置。在  JavaScript 中迭代器是一个对象，它提供了一个 `next()` 方法，用来返回序列中的下一项。这个方法返回包含两个属性：`done` 和 `value`。

迭代器对象一旦被创建，就可以反复调用 `next()`。

```js
function makeIterator(array) {
  let nextIndex = 0;  // 初始索引

  // 返回一个迭代器对象，对象的属性是一个 next 方法
  return {
    next: function() {
      if (nextIndex < array.length) {
        // 当没有到达末尾时，返回当前值，并把索引加1
        return { value: array[nextIndex++], done: false };
      }

      // 到达末尾，done 属性为 true
      return {done: true};
    }
  };
}
```

一旦初始化，`next()` 方法可以用来依次访问对象中的键值：

```js
const it = makeIterator(['j', 'u', 's', 't']);
it.next().value;  // j
it.next().value;  // u
it.next().value;  // s
it.next().value;  // t
it.next().value;  // undefined
it.next().done;   // true
it.next().value;  // undefined
```

## 2. 可迭代对象

一个定义了**迭代行为**的对象，比如在 `for...of` 中循环了哪些值。为了实现可迭代，一个对象必须实现 `@@iterator` 方法，这意味着这个对象（或其原型链中的一个对象）必须具有带 `Symbol.iterator` 键的属性：

`String`，`Array`，`TypedArray`，`Map` 和 `Set` 都内置可迭代对象，因为它们的原型对象都有一个 `Symbol.iterator` 方法。

```js
const justjavac = {
  [Symbol.iterator]: () => {
    const items = [`j`, `u`, `s`, `t`, `j`, `a`, `v`, `a`, `c`];
    return {
      next: () => ({
        done: items.length === 0,
        value: items.shift()
      })
    }
  }
}
```

当我们定义了可迭代对象后，就可以在 `Array.from`、`for...of` 中使用这个对象：

```js
[...justjavac];
// ["j", "u", "s", "t", "j", "a", "v", "a", "c"]

Array.from(justjavac)
// ["j", "u", "s", "t", "j", "a", "v", "a", "c"]

new Set(justjavac);
// {"j", "u", "s", "t", "a", "v", "c"}

for (const item of justjavac) {
  console.log(item)
}
// j 
// u 
// s 
// t 
// j 
// a 
// v 
// a 
// c
```

## 3. 同步迭代

由于在迭代器方法返回时，序列中的下一个值和数据源的 "done" 状态必须已知，所以迭代器只适合于表示**同步**数据源。

虽然 JavaScript 程序员遇到的许多数据源是同步的（比如内存中的列表和其他数据结构），但是其他许多数据源却不是。例如，任何需要 I/O 访问的数据源通常都会使用基于事件的或流式异步 API 来表示。不幸的是，迭代器不能用来表示这样的数据源。

（即使是 promise 的迭代器也是不够的，因为它的 value 是异步的，但是迭代器需要同步确定 "done" 状态。）

为了给异步数据源提供通用的数据访问协议，我们引入了 `AsyncIterator` 接口，异步迭代语句（`for-await-of`）和异步生成器函数。

## 4. 异步迭代器

一个异步迭代器就像一个迭代器，除了它的 `next()` 方法返回一个 `{ value, done }` 的 promise。如上所述，我们必须返回迭代器结果的 promise，因为在迭代器方法返回时，迭代器的下一个值和“完成”状态可能未知。

我们修改一下之前的代码：

```diff
 const justjavac = {
-  [Symbol.iterator]: () => {
+  [Symbol.asyncIterator]: () => {
     const items = [`j`, `u`, `s`, `t`, `j`, `a`, `v`, `a`, `c`];
     return {
-      next: () => ({
+      next: () => Promise.resolve({
         done: items.length === 0,
         value: items.shift()
       })
     }
   }
 }
```

好的，我们现在有了一个异步迭代器，代码如下：

```js
const justjavac = {
  [Symbol.asyncIterator]: () => {
    const items = [`j`, `u`, `s`, `t`, `j`, `a`, `v`, `a`, `c`];
    return {
      next: () => Promise.resolve({
        done: items.length === 0,
        value: items.shift()
      })
    }
  }
}
```

我们可以使用如下代码进行遍历：

```js
for await (const item of justjavac) {
  console.log(item)
}
```

如果你遇到了 `SyntaxError: for await (... of ...) is only valid in async functions and async generators` 错误，那是因为 `for-await-of` 只能在 async 函数或者 async 生成器里面使用。

修改一下：

```js
(async function(){
  for await (const item of justjavac) {
    console.log(item)
  }
})();
```

## 5. 同步迭代器 vs 异步迭代器

### 5.1 Iterators

```js
// 迭代器
interface Iterator {
    next(value) : IteratorResult;
    [optional] throw(value) : IteratorResult;
    [optional] return(value) : IteratorResult;
}

// 迭代结果
interface IteratorResult {
    value : any;
    done : bool;
}
```

### 5.2 Async Iterators

```js
// 异步迭代器
interface AsyncIterator {
    next(value) : Promise<IteratorResult>;
    [optional] throw(value) : Promise<IteratorResult>;
    [optional] return(value) : Promise<IteratorResult>;
}

// 迭代结果
interface IteratorResult {
    value : any;
    done : bool;
}
```

## 6. 异步生成器函数

异步生成器函数与生成器函数类似，但有以下区别：

- 当被调用时，异步生成器函数返回一个对象，"async generator"，含有 3 个方法（`next`，`throw`，和`return`），每个方法都返回一个 Promise，Promise 返回 `{ value, done }`。而普通生成器函数并不返回 Promise，而是直接返回 `{ value, done }`。这会自动使返回的异步生成器对象具有异步迭代的功能。
- 允许使用 `await` 表达式和 `for-await-of` 语句。
- 修改了 `yield*` 的行为以支持异步迭代。

示例：

```js
async function* readLines(path) {
  let file = await fileOpen(path);

  try {
    while (!file.EOF) {
      yield await file.readLine();
    }
  } finally {
    await file.close();
  }
}
```

函数返回一个异步生成器（async generator）对象，可以用在 `for-await-of` 语句中。

## 7. 实现

- [Chakra](https://github.com/Microsoft/ChakraCore/issues/2720) - 暂未支持
- [JavaScriptCore](https://github.com/tc39/proposal-async-iteration/issues/63#issuecomment-330929480) - Safari Tech Preview 40
- [SpiderMonkey](https://github.com/tc39/proposal-async-iteration/issues/63#issuecomment-330978069) - Firefox 57
- [V8](https://blog.chromium.org/2017/10/chrome-63-beta-dynamic-module-imports_27.html) - Chrome 63

## Polyfills

Facebook 的 [Regenerator](https://github.com/facebook/regenerator) 项目为 `AsyncIterator` 接口提供了一个 polyfill，将异步生成器函数变成返回 `AsyncIterator` 的对象 ECMAScript 5 函数。Regenerator 还不支持 `for-await-of` 异步迭代语法。

[Babylon parser](https://github.com/babel/babel/tree/master/packages/babylon) 项目支持异步生成器函数和 `for- await-of` 语句（v6.8.0+）。你可以使用它的 [asyncGenerators 插件](https://github.com/babel/babel/tree/master/packages/babylon#plugins)。

```js
require("babylon").parse("code", {
  sourceType: "module",
  plugins: [
    "asyncGenerators"
  ]
});
```

另外，从 6.16.0 开始，异步迭代被包含在 Babel 的 [`"babel-plugin-transform-async-generator-functions"`](https://github.com/babel/babel/tree/master/packages/babel-plugin-transform-async-generator-functions) 下以及 [`babel-preset-stage-3`](http://babeljs.io/docs/plugins/preset-stage-3/)。

```js
require("babel-core").transform("code", {
  plugins: [
    "transform-async-generator-functions"
  ]
});
```
