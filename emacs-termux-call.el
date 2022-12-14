;;; emacs-termux-call.el --- Emacs Telephony call on Android

;; Copyright (C) 2022 Iason SK

;; Author: Jason SK <jason.skk98[at]gmail[dot]com>
;; Keywords: telephony, android.
;; URL: https://github.com/JasonSKK/emacs-termux-call

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
;; You should have received copies of the GNU General Public License and
;; the GNU Lesser General Public License along with this program.  If
;; not, see https://www.gnu.org/licenses/.

;; ;;; Commentary:
;; This program provides a simple configuration for making telephony phone
;; calls from withing Emacs running on an android phone.  The call is made
;; through a mini-buffer prompt where the contacts are shown.
;; It is dependant on termux-call: https://github.com/lahloug/termux_call

;;; Code:
;; specify a path for your contacts file, add (setq contacts_file /path/to/contacts_file) to your init

(setq contacts_file nil)

;; load contacts file
(defun loadup-file (file)
  (with-temp-buffer
    (insert-file-contents file)
    (buffer-substring-no-properties
     (point-min)
     (point-max))))

;; contacts, make call
(defun emacs-termux-call (arg)
  (interactive
   (if contacts_file ;; if contacts_file exists
       ;;(file-exists-p "./contacts.txt") ;; file exists just read it -- prompt to select contact -- REMOVED
       (list
        (completing-read ;; prompt
         "Choose contact: " (split-string
                             (loadup-file contacts_file) "\n" t)))
     (setq contacts_file (read-file-name ;; if nil => prompt for string input contacts file path
                         "contacts file path: "))
     (display-warning :warning "Consider adding (setq contacts_file /path/to/contacts_file) to your init file") ;; display warning for setq initialisation
     (list
      (completing-read ;; complete process with temporary setq
       "Choose contact: " (split-string
                           (loadup-file contacts_file) "\n" t)))
     ))
  (shell-command (concat "termux-call " (prin1-to-string arg) ))) ;; make termux call

;; setup contacts file -- for google contacts csv format
(defun emacs-termux-call-setup-contacts (&optional in)
  (interactive
   (list (let ((output-file (read-file-name "Select file to save contacts: " "~/"))) ;; select input contacts file -- prompt
           (shell-command ;; get contacts + extract
            (concat "termux-call -h | grep -o -P '(?<={).*(?=})' | tr , '\n' > " output-file)
            ;; old version using google contacts
            ;;(concat "cat "
                    ;;(prin1-to-string input-file) " | cut -d \, -f 1 >> "
                    ;;(prin1-to-string output-file) " && cat "
                    ;;(prin1-to-string output-file))
            (message (concat "Contacts exported to: " output-file " Do M-x emacs-termux-call")))
           (setq contacts_file output-file) ;; set contacts_file as the output file -- for access from emacs-termux-call
           ))
   ))


(provide 'emacs-termux-call)
;;; emacs-termux-call.el ends here
