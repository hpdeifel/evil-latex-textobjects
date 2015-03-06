;;; evil-latex-textobjects.el --- LaTeX text objects for evil

;; Copyright (C) 2015  Hans-Peter Deifel

;; Author: Hans-Peter Deifel <hpd@hpdeifel.de>
;; Keywords: tex, wp, convenience

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

(require 'evil)

(evil-define-text-object evil-latex-textobjects-inner-dollar (count &optional beg end type)
  "Select inner dollar"
  :extend-selection nil
  (evil-select-quote ?$ beg end type count nil))

(evil-define-text-object evil-latex-textobjects-a-dollar (count &optional beg end type)
  "Select a dollar"
  :extend-selection t
  (evil-select-quote ?$ beg end type count t))

(evil-define-text-object evil-latex-textobjects-inner-math (count &optional beg end type)
  "Select innter \\[ \\] or \\( \\)."
  :extend-selection nil
  (evil-select-paren "\\\\\\[\\|\\\\(" "\\\\)\\|\\\\\\]" beg end type count nil))

(evil-define-text-object evil-latex-textobjects-a-math (count &optional beg end type)
  "Select a \\[ \\] or \\( \\)."
  :extend-selection nil
  (evil-select-paren "\\\\\\[\\|\\\\(" "\\\\)\\|\\\\\\]" beg end type count t))

(defun evil-latex-textobjects-macro-beginning ()
  "Return (start . end) of the macro-beginning to the left of point.

If no enclosing macro is found, return nil.
For example for \macro{foo|bar} it returns the start and end of \"\macro{\""
  (let ((beg (TeX-find-macro-start)))
    (when beg
      (save-excursion
        (goto-char beg)
        (forward-char)                  ; backslash
        (skip-chars-forward "A-Za-z@*") ; macro-name
        (when (looking-at "{\\|\\[")
          (forward-char))                ; opening brace
        (cons beg (point))))))

(defun evil-latex-textobjects-macro-end ()
  "Return (start . end) of the end of the enclosing macro.

If no such macro can be found, return nil"
  (let ((end (TeX-find-macro-end)))
    (when end
      (save-excursion
        (goto-char end)
        (when (looking-back "}\\|\\]")
          (backward-char))               ; closing brace
        (cons (point) end)))))

;; TODO Support visual selection
;; TODO Support count

(evil-define-text-object evil-latex-textobjects-a-macro (count &optional beg end type)
  "Select a TeX macro"
  :extend-selection nil
  (let ((beg (evil-latex-textobjects-macro-beginning))
        (end (evil-latex-textobjects-macro-end)))
    (if (and beg end)
        (list (car beg) (cdr end))
      (error "No enclosing macro found"))))

(evil-define-text-object evil-latex-textobjects-inner-macro (count &optional beg end type)
  "Select inner TeX macro"
  :extend-selection nil
  (let ((beg (evil-latex-textobjects-macro-beginning))
        (end (evil-latex-textobjects-macro-end)))
    (cond
     ((or (null beg) (null end))
      (error "No enclosing macro found"))
     ((= (cdr beg) (car end))           ; macro has no content
      (list (1+ (car beg))              ; return macro boundaries excluding \
            (cdr beg)))
     (t (list (cdr beg) (car end))))))

;; TODO Support environments

;; TODO Add minor mode and don't use the global maps
(define-key evil-inner-text-objects-map "$" 'evil-latex-textobjects-inner-dollar)
(define-key evil-outer-text-objects-map "$" 'evil-latex-textobjects-a-dollar)
(define-key evil-inner-text-objects-map "\\" 'evil-latex-textobjects-inner-math)
(define-key evil-outer-text-objects-map "\\" 'evil-latex-textobjects-a-math)
(define-key evil-outer-text-objects-map "m" 'evil-latex-textobjects-a-macro)
(define-key evil-inner-text-objects-map "m" 'evil-latex-textobjects-inner-macro)

(provide 'evil-latex-textobjects)

;; evil-latex-textobjects.el ends here
