#!/usr/bin/env Rscript

x11()

var <- seq(0, 255, length=60)
empty = seq(0, 0, length=60)
full = seq(255, 255, length=60)

red <- c(var, full, rev(var), empty, empty, empty)
green <- c(empty, var, full, full, rev(var), empty)
blue <- c(empty, empty, empty, var, full, rev(var))

plot(1:360, 1:360, type="n")
lines(1:360, red, type="l", col="red")
lines(1:360, green, type="l", col="green")
lines(1:360, blue, type="l", col="blue")

while (!is.null(dev.list())) Sys.sleep(1)
