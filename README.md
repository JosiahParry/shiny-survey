Shiny Survey
================
josiah parry
2020-12-08

This repository contains a barebones example of a shiny application that
collects data and stores it. There are two different implementations of
this one using a SQLite database and the other using {pins}.

The application writes to the database / pins when the submit button is
pressed. Within the shiny code, `line 66` indicates the
`observeEvent()`. The reactive expression within that function call
contains all the code necessary for writing the information.

The SQLite approach requires [persistent
storage](https://support.rstudio.com/hc/en-us/articles/360007981134-Persistent-Storage-on-RStudio-Connect)
on the RStudio Connect server. Whereas the pin does not. {pins} however
has to read in the entire dataset into memory before writing agian. So
just be sure that your survey is a manageable size (keep it under
100mb\!).
