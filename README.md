# Mathemadically

An open-ended, interactive math sandbox inspired by Alan's Animation vs. Math

# Plan

The game will have two modes. Challenge mode, and Sandbox mode.

All I have to do is build the Challenge mode. Making Sandbox after that is as simple as removing the win condition.

In the Challenge mode the user has to obtain/create a specific function, value, formula, or graph. As usual it gets harder and harder as levels go.

# Mechanic

The core of this game is the mechanic. There's nothing else to make. No art, no audio, all that matters is the mechanic, and maybe some SFX polish in the end.

# Objects

The building block of this World of just an ArrayList of Objects. But for it to make sense and for it to be playable,  math is objects. They're alsoit needs to be able to resolve them. Long strings of Values should be able to resolve into a singular NetValue, and if those Values lie on the sides of some operand, the operand should be able to operate on those NetValues instead of the indivisial Values the very next to it. 

## Value

A singular symbol that posesses a value, like 1, pi, e, 8, x, etc will be called a Value. This class inherits the Object class.

### Constant

A value that is constant will also be named Constant. This class inherits the Value class.

### Variable

Variables can also exist, they also inherit the Value class.

## Operator

An Operator is any symbol representing an arithmetic operation. =, +, -, /, etc all are Operators. An Operator must have the right amount of operands, which it can check to its left and right.

## Function

Anything that performs a mathematical Function on a given set of inputs is called a Function, for example sin(), cos(), etc. A Value can be dragged inside a Function. Clicking a Function resolves it to a Constant if the input is a Constant. Otherwise the Function will draw a graph.  

# Resolution

The World contains just an ArrayList of Objects. But for it to make sense and for it to be playable, it needs to be able to resolve them. Long strings of Values should be able to resolve into a singular NetValue, and if those Values lie on the sides of some operand, the operand should be able to operate on those NetValues instead of the indivisial Values the very next to it. 

This 'Values to NetValue' resolution is performed by starting in a direction from an edge value (a value that is either at the end, or right next to an Operator). The direction is from the edge inwards, or from the Operator towards the Values. The Value sends a signal to its immediate left Value, and the signal propagates, and each Value's value is added to a buffer. When the buffer is ready, basic mathematical operations are performed to resolve it and solve it. We will call this an Island of Values. An Island always has a NetValue. An Island is a Variable only if any of the Values inside are a Variable. In that case, the whole Island can be called a Variable. It will still resolve into a NetValue but will demand a set of values as input. This will be useful when graphing Islands. 

# Interaction

# Rendering

# Player Objectives
