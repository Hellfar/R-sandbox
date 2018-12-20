#!/usr/bin/env Rscript

require(grDevices)
require(graphics)

if (!require("optparse", quietly = TRUE)) {
	install.packages("optparse", repos="http://cran.rstudio.com/")
	if (!library("optparse")) {
    stop("Couldn't load 'optparse'.")
  }
}

parser <- OptionParser()
parser <- add_option(parser, c("-v", "--verbose"), action="store_true",
                default=FALSE, help="Print extra output [default]")
parser <- add_option(parser, c("-d", "--driver"),
                default="x11", help="Output in a choosen driver instead")
parser <- add_option(parser, c("-i", "--ifile"),
                default="stdin", help="File to plot")
parser <- add_option(parser, c("-o", "--ofile"),
                default="Rplots", help="Plot to file")
# parser <- add_option(parser, c("-t", "--type"),
#                 default="l", help="Type of plot (p -> points, l -> lines, o -> overplotted points and lines, b-c -> points (empty if \"c\") joined by lines), s-S -> stair steps, h -> histogram-like vertical lines, n -> does not produce any points or lines")
parser <- add_option(parser, c("--xlab"),
                default="x", help="Define label for absciss")
parser <- add_option(parser, c("--ylab"),
                default="y", help="Define label for ordinate")
parser <- add_option(parser, c("-c", "--col"),
                default="black", help="Define color")
options <- parse_args(parser)

if (options$driver == "")
  options$driver = "pdf"

if (options$driver == "x11") {
  x11()
} else {
  # if (options$verbose)
  #   write(str(get(options$driver)), stdout())
  # dev.copy(match.fun(options$driver), options$ofile)
  match.fun(options$driver)(options$ofile)
}

if (options$verbose)
  write(str(options), stdout())

numbers <- read.table(file=options$ifile)
numbers <- structure(unlist(numbers, use.names = FALSE), .Dim = c(nrow(numbers), ncol(numbers)))

# numbers <- scan(file=options$ifile, quiet=TRUE)
if (options$verbose) {
  write(paste("Length: ", length(numbers)), stdout())
  write("Array:", stdout())
  # write(numbers, stdout())
  dput(numbers)
}

if (length(numbers) > 0)
  filled.contour(numbers, color.palette = rainbow)

if (options$driver == "x11") {
  while (!is.null(dev.list())) Sys.sleep(1)
} else {
  dev.off()
}
