(define-parenscript enter-search-text ()
  "this shows text input on a page with a text field"
  (let ((search-textbox (ps:chain document (query-selector "input"))))
    (setf (ps:@ search-textbox value) "nyxt browser examples")))

(define-command enter-search-text-command ()
  "Command wrapper for parenscript"
   (enter-search-text))

(dynamic-parenscript "(alert \"test 123\")")

(dynamic-parenscript "
  (let ((search-textbox (ps:chain document (query-selector \"input\"))))
    (setf (ps:@ search-textbox value) \"nyxt browser examples\"))
")
