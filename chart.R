#!/usr/bin/env Rscript

if (!require("optparse", quietly = TRUE)) {
	install.packages("optparse", repos="http://cran.rstudio.com/")
	if (!library("optparse")) {
    stop("Couldn't load 'optparse'.")
  }
}

parser <- OptionParser()
parser <- add_option(parser, c("-v", "--verbose"), action="store_true",
                default=FALSE, help="Print extra output [default]")
parser <- add_option(parser, c("--o_pdf"),
                default=FALSE, help="Output in pdf instead")
parser <- add_option(parser, c("-f", "--ifile"),
                default="stdin", help="File to plot")
parser <- add_option(parser, c("-t", "--type"),
                default="l", help="Type of plot (p -> points, l -> lines, o -> overplotted points and lines, b-c -> points (empty if \"c\") joined by lines), s-S -> stair steps, h -> histogram-like vertical lines, n -> does not produce any points or lines")
parser <- add_option(parser, c("--xlab"),
                default="x", help="Define label for absciss")
parser <- add_option(parser, c("--ylab"),
                default="y", help="Define label for ordinate")
parser <- add_option(parser, c("-c", "--col"),
                default="black", help="Define color")
options <- parse_args(parser)

if (!(options$o_pdf))
  x11()

if (options$verbose)
  write(str(options), stdout())

y <- scan(file=options$ifile, quiet=TRUE)
if (options$verbose) {
  write(paste("Length: ", length(y)), stdout())
  write("Array:", stdout())
  write(str(y), stdout())
}

if (length(y) > 0)
  plot (0:(length(y) - 1), y, type=options$type, xlab=options$xlab, ylab=options$ylab, col=options$col)

while (!is.null(dev.list())) Sys.sleep(1)
