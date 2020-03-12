(use-package prescient
  :config
  (prescient-persist-mode +1))

(use-package selectrum-prescient)

(use-package selectrum
  :after
  (orderless consult selectrum-prescient)
  :config
  (selectrum-mode +1)
  (selectrum-prescient-mode +1)
  :custom
  (selectrum-max-window-height 20)
  (selectrum-prescient-enable-filtering nil) ; orderless
  (orderless-skip-highlighting (lambda () selectrum-is-active)))
