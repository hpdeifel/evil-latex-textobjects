LaTeX text objects for evil
===========================

This package provides additional text objects for emacs' evil-mode
specifically tailored to editing latex source code.

Installation
------------

To use this package, add the following to your emacs init file:

```
(add-to-list 'load-path "/path/to/package")
(require 'evil-latex-textobjects)
(add-hook 'LaTeX-mode-hook 'turn-on-evil-latex-textobjects-mode)
```

Usage
-----

The following additional text objects are available:

| Key | Description                         |
| --- | ----------------------------------- |
| $   | Inline math, delimited by $$        |
| \\  | Display math, delimited by \\[ \\]  |
| m   | TeX macro \\foo{}                   |
| e   | LaTeX environment \\begin{} \\end{} |

All text objects come in *inner* and *outer* variants. For example, to
delete the the whole surrounding environment, type <kbd>dae</kbd>. To
delete only the part between `begin` and `end`, type <kbd>die</kbd>.

The text objects
----------------

### Inline math ($) ###

```
 outer
,-----,
$ foo $
 `---'
 inner
```

### Display math (\\) ###

```
  outer
,-------,
\[ foo \]
  `---'
  inner
```

### TeX macro (m) ###

```
    outer
,-----------,
\macro{ foo }
       `---'
       inner 
```

### LaTeX environment (e) ###

```
        outer
,-----------------------,
\begin{env} foo \end{env}
           `---'
           inner
```
