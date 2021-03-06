% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/te_class.R
\name{coef.transfer_entropy}
\alias{coef.transfer_entropy}
\title{Extract the Coefficient Matrix from a transfer_entropy}
\usage{
\method{coef}{transfer_entropy}(object, ...)
}
\arguments{
\item{object}{a transfer_entropy}

\item{...}{additional arguments, currently not in use}
}
\value{
a Matrix containing the coefficients
}
\description{
Extract the Coefficient Matrix from a transfer_entropy
}
\examples{
set.seed(1234567890)
n <- 500
x <- rep(0, n + 1)
y <- rep(0, n + 1)

for (i in seq(n)) {
  x[i + 1] <- 0.2 * x[i] + rnorm(1, 0, 2)
  y[i + 1] <- x[i] + rnorm(1, 0, 2)
}

x <- x[-1]
y <- y[-1]

te_result <- transfer_entropy(x, y, nboot = 100)
coef(te_result)
}
