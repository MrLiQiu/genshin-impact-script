# 动作模组

动作模组可以为每个角色独立设置自定义的战斗循环。

通过在`config.ini`中设置`tactic`来使用这一模组。同时，它取代了之前的`type-cbt`。

## 快速开始

首先，看几个例子：

```ini
[fischl]
tactic = a, 100, a, 100, t, t

[hu_tao]
tactic = a, @e, A, 150, j; a, e

klee]
tactic = a, A

[zhongli]
tactic = a, E
```

动作模组由如下的单元构成：

- `@e` 元素战技生效阶段
- `a`/`A` 普通攻击/蓄力攻击
- `e`/`E` 点按/长按元素战技
- `j` 跳跃
- `s` 冲刺
- `t` 瞄准
- 数字，代表延时，单位为`ms`

不同的动作单元间用半角逗号`,`分隔，不同的动作组之间使用半角分号`;`分隔。

那么回到最开始的几个例子，在菲谢尔的例子中，她的逻辑被设置为：

- 普通攻击
- 等待`100 ms`
- 普通攻击
- 等待`100 ms`
- 瞄准（开始）
- 瞄准（结束）

长按`鼠标左键`即会开始循环这个动作。

对于胡桃来说，她的逻辑较为复杂，分为两部分：

- 当元素战技生效时，循环使用蓄力攻击后接跳跃
- 当元素战技不生效时，循环使用普通攻击，并在元素战技就绪时使用元素战技

`@e`是一个特殊的标记，只有当元素战技生效时，才会继续向后执行；否则将跳到下一个动作组。

剩下的两个例子则都比较简单：可莉会使用普通攻击后接重击的循环，钟离则是在上盾后不断普通攻击。

## 推荐动作

```ini
[fischl]
tactic = a, 100, a, 100, t, t

[hu_tao]
tactic = a, @e, A, 150, j; e, a

[klee]
tactic = a, A

[zhongli]
tactic = a, E
```

上述动作并不代表它们是最优解，如果你有更好的循环，欢迎在`issue`中提出。

对于大部分角色来说，以下设置也会很有用：

```ini
tactic = a, e
```