(define-parenscript test-tagger-ps ()
  "register this parenscript with Nyxt"
  
  (defmacro with-delay-of (timeout-in-ms call-back &rest body)
    (let ((function-name (gensym "call-back-wrapper")))
      `(let ((,function-name #'(lambda ()
				 (,call-back)
				 ,@body)))
	 (set-timeout ,function-name ,timeout-in-ms))))
  
  (defun filter-by-tag ()
    "use filter field in the UI to filter by a tag"
    (let ((first-tag (ps:@ (ps:chain document (query-selector-all "#tag-list-body a")) 0)))
      (ps:chain first-tag (click))))
  
  (defun can-add-note-and-tag ()
    "fill in text for the note and tag and add it
(still need to validate, though!)"
    (let* ((note-field-id "note-content")
	   (tags-field-id "tags-content")
	   (filter-field-id "info-filter-text")
	   (add-button-id "info-add-btn")
	   (dt (new -date))
	   (note-field (ps:chain document (get-element-by-id note-field-id)))
	   (tags-field (ps:chain document (get-element-by-id tags-field-id)))
	   (add-button (ps:chain document (get-element-by-id add-button-id)))
	   (note-value (concatenate 'string
				    "The current time is: " #\Newline
				    (ps:chain dt (get-full-year)) "/"
				    (+ (ps:chain dt (get-month)) 1) "/"
				    (ps:chain dt (get-day)) " "
				    (ps:chain dt (get-hours)) ":"
				    (ps:chain dt (get-minutes)) ":"
				    (ps:chain dt (get-seconds)) ":"
				    (ps:chain dt (get-milliseconds))))
	   (tags-value (max 100 (random 1000))))
      (setf (ps:@ note-field value) note-value)
      (setf (ps:@ tags-field value) tags-value)
      (ps:chain add-button (click))
      (with-delay-of 1000 filter-by-tag
	(with-delay-of 1000 #'(lambda ()
				(let ((note (ps:@ (ps:chain document (query-selector "#note-list-body label")) inner-text)))
				  (if (string= note note-value)
				      (ps:chain console (log "display value matches input"))
				      (ps:chain console (log "display value DOES NOT match input!!")))))
	  t)
	t)
      t)
    t)
  (can-add-note-and-tag))

(define-command wrapper-for-test-tagger-ps ()
  "wrapper command that can be invoked to run parenscript"
  (test-tagger-ps))

(defun test-tagger ()
  "test the tagger web app"
  ;;    (reload-current-buffer) ; this won't work because of timing issues
  (let ((test-tagger-buffer (make-buffer :url "http://192.168.1.18:5070/info" :title "Info List")))
    (sleep 0.3) ;; this might only work after having loaded the same URL at least once ...
    (set-current-buffer test-tagger-buffer)
    (open-inspector)
    (wrapper-for-test-tagger-ps)
    test-tagger-buffer))


