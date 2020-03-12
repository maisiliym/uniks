(use-package affe
  :after (consult)
  :config
  (defun affe-orderless-regexp-compiler (input _type)
    (setq input (orderless-pattern-compiler input))
    (cons input (lambda (str) (orderless--highlight input str))))
  (setq affe-regexp-compiler #'affe-orderless-regexp-compiler))

(use-package consult
  :custom
  (consult-preview-key (kbd "M-.")))

(use-package consult-flycheck)

(use-package consult-ghq
  :after (consult)
  :custom
  (consult-ghq-find-function #'consult-find)
  (consult-ghq-grep-function #'consult-grep))

(use-package embark)

(use-package marginalia
  :config (marginalia-mode))

(use-package orderless
  :config
  (defun flex-if-twiddle (pattern _index _total)
    (when (string-suffix-p "~" pattern)
      `(orderless-flex . ,(substring pattern 0 -1))))
  (defun without-if-bang (pattern _index _total)
    (cond
     ((equal "!" pattern)
      '(orderless-literal . ""))
     ((string-prefix-p "!" pattern)
      `(orderless-without-literal . ,(substring pattern 1)))))
  :custom
  (completion-styles '(orderless))
  (orderless-style-dispatchers
   '(flex-if-twiddle without-if-bang))
  (orderless-matching-styles '(orderless-regexp)))
