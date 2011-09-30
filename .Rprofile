require(stringr)
require(ggplot2)
require(RColorBrewer)

options("width"=160)      # wide display with multiple monitors
options("digits.secs"=3)  # show sub-second time stamps

# my preferred mirrors
options(repos=c("http://cran-r.c3sl.ufpr.br/","http://cran.fiocruz.br/"))

# aliases
s <- base::summary;
h <- utils::head;
n <- base::names;
cd <- setwd;
pwd <- getwd;

Sys.setenv(R_HISTSIZE='100000')
.Last <- function () {
  if (!any(commandArgs() == '--no-readline') && interactive()) {
    require(utils)
    try(savehistory('~/.Rhistory'))
  }
}
