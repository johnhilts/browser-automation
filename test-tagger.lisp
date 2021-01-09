(defparameter *test-tagger-buffer*
;; Create a buffer and set focus on it
;; For timing reasons, it works better to have a buffer already created when running the test.
;; Creating a buffer at the beginning of the test won't create it fast enough for the next commands.
;; I should probably try doing some kind of sleep.
  (make-buffer-focus :url "http://192.168.1.18:5070/info"))

(defun test-tagger ()
  "test the tagger web app"
  (with-current-buffer *test-tagger-buffer*
;;    (reload-current-buffer) ; this won't work because of timing issues
    (dynamic-parenscript
     "
(progn
 (defun filter-by-tag ()
     (let ((first-tag (ps:@ (ps:chain document (query-selector-all \"a\")) 0)))
    (ps:chain first-tag (click))))

 (let* ((note-field-id \"note-content\")
       (tags-field-id \"tags-content\")
       (filter-field-id \"info-filter-text\")
       (add-button-id \"info-add-btn\")
       (dt (new -date))
       (note-field (ps:chain document (get-element-by-id note-field-id)))
       (tags-field (ps:chain document (get-element-by-id tags-field-id)))
       (add-button (ps:chain document (get-element-by-id add-button-id)))
       (note-value (concatenate 'string
         \"The current time is: \" 
         (ps:chain dt (get-full-year)) \"/\"
         (+ (ps:chain dt (get-month)) 1) \"/\"
         (ps:chain dt (get-day)) \" \"
         (ps:chain dt (get-hours)) \":\"
         (ps:chain dt (get-minutes)) \":\"
         (ps:chain dt (get-seconds)) \":\"
         (ps:chain dt (get-milliseconds))))
       (tags-value (max 100 (random 1000))))
  (setf (ps:@ note-field value) note-value)
  (setf (ps:@ tags-field value) tags-value)
  (ps:chain add-button (click))
  (set-timeout filter-by-tag 1000)
  t))
")
    *test-tagger-buffer*))

