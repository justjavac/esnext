title: JavaScript、TC39、ECMAScript 以及 es20xx
---

## ECMAScript

ECMAScript 是由 ECMA-262 标准化的脚本语言的名称。

由于 JavaScript® ECMA-262 无法使用 JavaScript 这个名字，因此在指定规范的使用使用了 ECMAScript。

从 2009 年发布的 ES5 到 2015 年发布的 ES6 共经历了 6 年，语言的变化非常大，引入了很多新的语法和特性。为了避免剧烈的变动，从 ES7(2016) 开始，版本发布会变得更加频繁，每次的变动也更小。每年会发布一个新版本，其中包含所有已经完成的特性。

## TC39

TC39 指的是技术委员会（Technical Committee）第 39 号。委员会负责改进 ECMAScript 编程语言并编写规范。会议的每一项决议必须大部分人赞同，并且没有人强烈反对才可以通过。对规范进行修改的一般过程如下。

## Stage

每一项新特性，要最终纳入 ECMAScript 规范中，TC39 拟定了一个处理过程，称为 TC39 process。其中共包含 5 个阶段，Stage 0 ~ Stage 4。

TC39 遵循的原则是：分阶段加入不同的语言特性。一旦提案成熟，TC39 会根据提案中的变动来更新规范。直到最近，TC39 依然依赖基于 Microsoft Word 的比较传统的工作流程。但 ES3 出来之后，为了使其达到规范，总共花了十年时间，几乎没有任何改变。之后，ES6 又花了四年才能实现。

自 ES6 出来之后，他们精简了提案的修订过程，以满足现代化开发的需求。新流程使用 HTML 的超集来格式化提案。他们使用 GitHub pull requests，这有助于增加社区的参与，并且提出的提案数量也增加了。这个规范现在是一个 living standard，这意味着提案会更快，而且我们也不用等待新版本的规范出来。

新流程涉及五个不同的 Stage。一个提案越成熟，越有可能最终将其纳入规范。

### Stage 0: strawman

任何尚未提交作为正式提案的讨论、想法变更或者补充都被认为是第 0 阶段的“稻草人（strawman）”提案。

任何 TC39 成员，或者注册为 TC39 贡献者的会员，都可以提交 Stage 0 的提案。

### Stage 1: proposal

该阶段产生一个正式的提案。

- 确定一个带头人来负责该提案，带头人(或者联合带头人)必须是 TC39 的成员。
- 描述清楚要解决的问题，解决方案中必须包含例子，API(high level AP) 以及关于相关的语义和算法。
- 潜在问题也应该指出来，例如与其他特性的关系，实现它所面临的挑战。
- polyfill 和 demo 也是必要的。

### Stage 2: draft

Stage 2 的提案应提供规范初稿。

此时，语言的实现者开始观察 runtime 的具体实现是否合理。该实现可以使用 polyfill 的方式，以便使代码可在 runtime 中的行为负责规范的定义。javascript 引擎的实现为提案提供了原生支持。或者可以 Babel 这样的编译时编译器来支持。

本草案与最终标准中包含的特性不会有太大差别。草案之后，原则上只接受增量修改。

- 草案中包含新增特性语法和语义的，尽可能的完善的形式说明，允许包含一些待办事项或者占位符。
- 必须包含 2 个实验性的具体实现，其中一个可以是用转译器实现的，例如 Babel。

### Stage 3: candidate

Stage 3 提案是建议的候选提案。在这个高级阶段，规范的编辑人员和评审人员必须在最终规范上签字。

Stage 3 的提案不会有太大的改变，在对外发布之前只是修正一些问题。

- 规范文档必须是完整的，评审人和 ECMAScript 的编辑要在规范上签字。
- 至少要有 2 个符合规范的具体实现。

### Stage 4: finished

最后，当规范的实现至少通过两个验收测试时，提案进入 Stage 4。

进入 Stage 4 的提案将包含在 ECMAScript 的下一个修订版中。

- 通过 Test 262 的验收测试。
- 有 2 个通过测试的实现，以获取使用过程中的重要实践经验。
- ECMAScript 的编辑必须规范上的签字。

## 规格修订和调度

TC39 打算每年七月向 ECMA 大会提交一份规范批准。以下是生成新规格修订的大致时间表：

- 2月1日：候选草案被生成。
- 2月-3月：60 天时间进行投票决定草案的去留。
- 3月 TC39 会议：第 4 阶段的提案被纳入，最终的语义被批准，从 master 新建一个 spec 的分支版本。只有编辑性的改变才能被接受。
- 4月-6月：ECMA CC 和 ECMA GA 审查期。
- 7月：由 ECMA 大会批准新标准

## 参考资料

- [The TC39 Process](https://tc39.github.io/process-document/)
- [TC39，ECMAScript 和 JavaScript 的未来](https://segmentfault.com/a/1190000010008098)
- [Status, process, and documents for ECMA262](https://tc39.github.io/ecma262/)
- [Official ECMAScript Conformance Test Suite](https://github.com/tc39/test262)
