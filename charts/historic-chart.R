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
parser <- add_option(parser, c("-t", "--type"),
                default="l", help="Type of plot (p -> points, l -> lines, o -> overplotted points and lines, b-c -> points (empty if \"c\") joined by lines), s-S -> stair steps, h -> histogram-like vertical lines, n -> does not produce any points or lines")
parser <- add_option(parser, c("--xlab"),
                default="time", help="Define label for absciss")
parser <- add_option(parser, c("--ylab"),
                default="y", help="Define label for ordinate")
parser <- add_option(parser, c("-c", "--col"),
                default="black", help="Define color")
options <- parse_args(parser)

if (options$driver == "")
  options$driver = "pdf"

if (options$driver == "x11") {
  x11(title=options$ylab)
} else {
  # if (options$verbose)
  #   write(str(get(options$driver)), stdout())
  # dev.copy(match.fun(options$driver), options$ofile)
  match.fun(options$driver)(paste(options$ofile, options$driver, sep="."))
}

if (options$verbose)
  write(str(options), stdout())

store_line <- function(line) {
  # line <- unlist(strsplit(line, " "))
  c(line[1], as.numeric(as.POSIXct(line[1], format="%Y/%m/%d-%H:%M")), as.numeric(line[2]))
}

dat_matrix <- read.table(options$ifile)
# dput(dat_matrix)
dat <- apply(dat_matrix, 1, store_line)
# dput(dat)
dat <- dat[,order(dat[2,])]
colnames(dat) <- dat[1,]
# dat_matrix <- readLines(options$ifile)
# dat <- lapply(dat_matrix, store_line)
# dat <- as.data.frame(dat)
# dput(dat)
# numbers <- scan(file=options$ifile, quiet=TRUE)
if (options$verbose) {
  write(paste("Length: ", length(dat)), stdout())
  write("Array:", stdout())
  dput(dat)
}

xaxis_labs <- dat[1,]
x <- dat[2,]
y <- dat[3,]
if (length(y) > 0) {
  par(mar = c(7, 4, 4, 2) + 0.1)
  plot (x, y, type=options$type, xlab="", ylab=options$ylab, col=options$col, xaxt="n")
  axis(1, at=x, labels = FALSE)
  text(x, par("usr")[3] - 3, srt = 45, adj = 1, labels = xaxis_labs, xpd = TRUE)
  mtext(1, text=options$xlab, line=6)
  # axis(1, at=x, labels=xaxis_labs)
}

if (options$driver == "x11") {
  while (!is.null(dev.list())) Sys.sleep(1)
} else {
  dev.off()
}
