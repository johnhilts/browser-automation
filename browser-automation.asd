;;;; browser-automation.asd
;;;; (asdf:load-system "jfh-browser-automation")

#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
                                       (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(push #p"/home/john/code/lisp/source/util-lib/testing/jfh-testing/" asdf:*central-registry*)
(push #p"/home/john/code/lisp/browser-automation/" asdf:*central-registry*)
(asdf:load-system "jfh-testing")

(asdf:defsystem #:jfh-browser-automation
  :description "Use nyxt for browser automation to conduct e2e tests"
  :author "John Hilts <johnhilts@gmail.com>"
  :license  "MIT"
  :version "0.0.1"
  :serial t
  :depends-on (#:jfh-testing)
  :components ((:file "package")
               (:file "test-tagger")))
