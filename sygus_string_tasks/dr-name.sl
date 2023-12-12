(set-logic SLIA)
(synth-fun f ((name String)) String
 ((Start String (ntString))
  (ntString String (
	  name
	  " " "." "Dr."
					(str.++ ntString ntString)
					(str.replace ntString ntString ntString)
					(str.at ntString ntInt)
					(int.to.str ntInt)
					(str.substr ntString ntInt ntInt)
				   ))
  (ntInt Int (

	  0 1 2
			  (+ ntInt ntInt)
			  (- ntInt ntInt)
			  (str.len ntString)
			  (str.to.int ntString)
			  (str.indexof ntString ntString ntInt)
			 ))
  (ntBool Bool (

	  true false
				(= ntInt ntInt)
				(str.prefixof ntString ntString)
				(str.suffixof ntString ntString)
				(str.contains ntString ntString)
			   ))
  ))
(constraint (= (f "Nancy FreeHafer") "Dr. Nancy"))
(constraint (= (f "Andrew Cencici") "Dr. Andrew"))
(constraint (= (f "Jan Kotas") "Dr. Jan"))
(constraint (= (f "Mariya Sergienko") "Dr. Mariya"))

(check-synth)
(define-fun f_1 ((name String)) String (str.++ (str.substr "Dr." 0 2) (str.++ "." (str.++ " " (str.substr name 0 (str.indexof name " " 0))))))
