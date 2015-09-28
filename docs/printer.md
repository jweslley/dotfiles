# Command-line printing and options

## Printing file

    lp filename
    lpr filename

## Choosing a printer: printing to a specific printer

    lp -d printer filename
    lpr -P printer filename

## Printing multiple copies

    lp -n num-copies filename
    lpr -#num-copies filename

## Printing the output of a program

    program | lp
    program | lp -d printer
    program | lpr
    program | lpr -P printer

## List of available printers

    lpstat -p -d

  * `-p` option specifies that you want to see a list of printers
  * `-d` option reports the current default printer or class

## Setting the default printer

    lpoptions -d printer

## Canceling a print job

    cancel job-id
    lprm job-id


### Reference:

* [Command-Line Printing and Options](http://www.cups.org/documentation.php/options.html)
