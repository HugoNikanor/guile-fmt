# Guile FMT

    (let ((name "Hugo"))
      (fmt "Hello ${name}"))
	;; => "Hello Hugo"

---

Adds support to Guile for format strings with inline variables.
Does so by translating from that to the built in format.

    "Hello ${name}" => ("Hello ~a" name)

Should be easy to port to other schemes that have a peg parsing library.

## TODO

### Records types
Support for record fields. So that if a record is defined as

    (define-record-type person
	  (make-person name age)
	  person?
	  (name get-name)
	  (age get-age))

Then `fmt` should be able to be called as:

    (let ((person (make-person "Hugo" 100)))
      (fmt "Hello ${person.name}, you are ${person.age} years old"))
