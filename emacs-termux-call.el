;;; emacs-termux-call.el --- Make a telephone call from Emacs running on an Android mobile phone

;;; Commentary:

;; Author: Jason SK <jason.skk98[at]gmail[dot]com>

;; Copyright (C) 2022 Iason SK

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

;; ;;; Commentary:
;; It is dependant on termux-call https://github.com/lahloug/termux_call

;;; Code:
;; specify a path for your contacts file, add the next line to your init
;; (setq contacts_file /path/to/contacts_file)

;; load contacts file
(defun loadup-file (file)
  (with-temp-buffer
    (insert-file-contents file)
    (buffer-substring-no-properties
     (point-min)
     (point-max))))

;; prompt to mini-buffer + show contacts
(defun emacs-termux-call (arg)
  (interactive
   (if contacts_file ;; if variable not nil
       ;;(file-exists-p "./contacts.txt") ;; file exists just read it -- prompt to select contact -- REMOVED
       (list
        (completing-read ;; prompt
         "Choose contact: " (split-string
                             (loadup-file contacts_file) "\n" t)))
     (setq contacts_file (read-string ;; if nil => prompt for string input contacts file path
                         "contacts file path: " ))
     (display-warning :warning "Consider adding (setq contacts_file /path/to/contacts_file) to your load path, either providing a contacts file'") ;; display warning for setq initialisation
     (list
      (completing-read ;; complete process with temporary setq
       "Choose contact: " (split-string
                           (loadup-file contacts_file) "\n" t)))
     ))
  (shell-command (concat "termux-call " (prin1-to-string arg) ))) ;; make termux call

(provide 'emacs-termux-call)
;;; emacs-termux-call.el ends here
