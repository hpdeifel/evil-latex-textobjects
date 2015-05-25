;;; evil-latex-textobjects-tests.el --- tests for evil-latex-textobjects -*- lexical-binding: t -*-

;; Copyright (C) 2015 Hans-Peter Deifel

;; Author: Hans-Peter Deifel <hpd@hpdeifel.de>

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Code:

(require 'ert)
(require 'evil-latex-textobjects)

(defun evil-latex-textobjects-on-str (string keys)
  "Insert string in tmp buffer, execute keys and return the result"
  (let ((win (selected-window)))
   (unwind-protect
       (with-temp-buffer
         (set-window-buffer win (current-buffer) t)
         (turn-on-evil-mode)
         (turn-on-evil-latex-textobjects)
         (insert string)
         (goto-char (point-min))
         (execute-kbd-macro keys)
         (buffer-string))
     (set-window-buffer win (current-buffer) t))))

;;; dollar
(ert-deftest evil-latex-textobjects-di$ ()
  (should (equal (evil-latex-textobjects-on-str "$foo$" "di$")
                 "$$"))
  (should (equal (evil-latex-textobjects-on-str " $ foo $" "f$lci$bar")
                 " $bar$")))

(ert-deftest evil-latex-textobjects-da$ ()
  (should (equal (evil-latex-textobjects-on-str "$foo$" "da$")
                 ""))
  (should (equal (evil-latex-textobjects-on-str " $ foo $" "f$lda$")
                 "")))

;;; display math
(ert-deftest evil-latex-textobjects-dimath ()
  (should (equal (evil-latex-textobjects-on-str " \\[foo\\] " "llldi\\")
                 " \\[\\] ")))

(ert-deftest evil-latex-textobjects-damath ()
  (should (equal (evil-latex-textobjects-on-str " \\[foo\\] " "lllda\\")
                 "  ")))

;;; macro
(ert-deftest evil-latex-textobjects-dimacro ()
  (should (equal (evil-latex-textobjects-on-str " \\foo{bar} " "llldim")
                 " \\foo{} ")))

(ert-deftest evil-latex-textobjects-damacro ()
  (should (equal (evil-latex-textobjects-on-str " \\foo{bar} " "llldam")
                 "  ")))

;;; environment
(ert-deftest evil-latex-textobjects-dienv ()
  (should (equal (evil-latex-textobjects-on-str
                  " \\begin{foo}\n  bar\n\\end{foo} " "jdie")
                 " \\begin{foo}\\end{foo} ")))

(ert-deftest evil-latex-textobjects-daenv ()
  (should (equal (evil-latex-textobjects-on-str
                  " \\begin{foo}\n  bar\n\\end{foo} " "jdae")
                 "  ")))

;;; end
