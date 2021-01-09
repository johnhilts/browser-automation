(defmacro dynamic-parenscript (script)
  "macro to facilitate using parenscript \"dynamically\" when connected to Nyxt from EMACS"
  (let ((string (string (gensym))))
    (list
     'progn
     `(define-parenscript ,(read-from-string string) ()
         "parenscript generated on the fly"
         ,(read-from-string script))

     `(define-command ,(read-from-string (concatenate 'string "wrapper-for-" string)) ()
       "wrapper command"
       (,(read-from-string string)))
     ` (,(read-from-string (concatenate 'string "wrapper-for-" string))))))
