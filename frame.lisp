(in-package #:content-viewer)

(defparameter *frame-url-host*
  "http://192.168.1.18:5051"
  "URL host so we can use fully qualified URLs")

;; pseudo code                                                                                                                                                                  
;; read from a file every N seconds and update browser URL                                                                                                                      
;; read-from-list-file                                                                                                                                                          
;; update browser URL                                                                                                                                                           
;; sleep N seconds                                                                                                                                                              
(defun set-current-url (host url)
  "wrapper for setting the current URL in a browser; accepts a string formatted as a fully qualified URL"
  (let ((url (format nil "~a~a" host (subseq url 1))))
    (format t "~&Next URL: ~a~%" url)
    (let ((buffer (current-buffer)))
      (setf
       (url buffer) (url url)
       (title buffer) "Photo Gallery")
      (reload-current-buffer)))
  t)

(defun get-next-url (url-list-file-name next-file-position)
  "read formatted file with list of URLs one line at a time; accepts a file location and the next line number; return a URL."
  (with-open-file (in url-list-file-name)
    (file-position in next-file-position)
    (let ((string (read-line in nil nil)))
      (values string (file-position in)))))

(defun orchestrator ()
  "this is the main part of the program"
  (do
   ((file-position 0)
    (eof))
   (eof)
    (multiple-value-bind (next-url next-file-position)
        (get-next-url "./photo-list.txt" file-position)
      (if next-url
          (progn
            (setf file-position next-file-position)
            (set-current-url *frame-url-host* next-url)
            (sleep 5))
          (setf eof t)))))
