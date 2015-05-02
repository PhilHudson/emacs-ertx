;;; ertx.el --- Extra useful testing functions for EmacsLisp. -*- lexical-binding: t -*-

;; Copyright (C) 2014  Nic Ferrier

;; Author: Nic Ferrier <nferrier@ferrier.me.uk>
;; Keywords: lisp
;; Version: 0.0.2
;; Url: https://github.com/nicferrier/emacs-ertx

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

;; There are a few glaring ommisions from `ert', most notably,
;; re-running the last test you did and running this test, that I'm
;; looking at right now.

;; ertx provides both of those.  Install it, enable the mode in an
;; elisp file:

;;  M-x ertx-mode

;; and then use: 

;;  C-c t -- to jump to run a test when you are in it's definition
;;  C-c . -- to re-run the last test

;; You can customize these key bindings.

;; A useful thing to do is to add ertx to the emacs-lisp hook so it's
;; always available in your emacs-lisp buffers:

;;  (add-hook 'emacs-lisp-mode-hook 'ertx-mode)

;; You might even want to customize that so you always have it
;; available.


;;; Code:

(require 'ert)

;;;###autoload
(defun ertx-this-defun ()
  "Run the tests for the ERT test where point rests."
  (interactive)
  (save-excursion
    (save-match-data
      (beginning-of-defun)
      (if (looking-at "(ert-deftest[ \t]\\([^ (]+\\)")
          (let* ((test-name (match-string-no-properties 1)))
            (unless (equal test-name (car ert--selector-history))
              (push test-name ert--selector-history))
            (ert test-name))
          (error "Not in an ert test?")))))

;;;###autoload
(defun ertx-run-last ()
  "Re-run the last test that you ran."
  (interactive)
  (ert (car ert--selector-history)))

(defgroup ertx nil "ERT extensions" :prefix "ertx")

(defcustom ertx-this-defun-key (kbd "C-c t")
  "Key binding for `ertx-this-defun'."
  :group 'ertx
  :tag "Key to run test under point"
  :type '(key-sequence))
  
(defcustom ertx-run-last-key (kbd "C-c .")
  "Key binding for `ertx-run-last'."
  :group 'ertx
  :tag "Key to run last test again"
  :type '(key-sequence)
  
;;;###autoload
(define-minor-mode ertx-mode 
    "Enable extra ert features like \"run this test\"."
  :lighter " ertx"
  :keymap (let ((ertx-map (make-sparse-keymap)))
            (define-key ertx-map (kbd "C-c t") 'ertx-this-defun)
            (define-key ertx-map (kbd "C-c .") 'ertx-run-last)
            ertx-map))

(provide 'ertx)

;;; ertx.el ends here
