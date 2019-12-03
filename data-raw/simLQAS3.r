#
# Close graphic devices and clear the workspace
#
graphics.off()
rm(list = ls())
gc()

#
# Filename for probbaility of classification plot
#
plotFileName <- "Nayapara_RC.png"

#
# Simulation parameters
#
LOW           <- 60       # Lower triage threshold (%)
HIGH          <- 90       # Upper triage threshold (%)
N             <- 26       # Sample size
POP           <- 192      # Population size (use 50,000 for "infinite")
RUNS          <- 50       # Simulation runs at each proportion
FINE          <- 1        # Granularity of simulated proportions (%)
SMOOTHER.SPAN <- 1 / 50   # Span for LOWESS smoother for PC plots
SHOW.PROGRESS <- TRUE     # Show detailed progress in console window
PROP.LOWER    <- 0        # Start simulations at this proportion (%)
PROP.UPPER    <- 100      # Stop simulations at this proportion (%)

#
# Other parameters (calculated from above)
#
D.LOWER <- floor(N * (LOW / 100))
D.UPPER <- floor(N * (HIGH / 100))

#
# Functions
#
make.data <- function(proportion, pop = POP)
  {
  d <- round(pop * (proportion / 100))
  case <- c(rep(1, d), rep(0, pop - d))
  id <- 1:length(case)
  result <- data.frame(cbind(id, case))
  return(result)
  }

lqas.run <- function(data, n = N, d = c(D.LOWER, D.UPPER))
  {
  survey.data <- data.frame(data[sample(x = 1:nrow(data), size = n, replace = FALSE), ])
  d.run <- sum(survey.data$case)
  result <- list(d = d.run, outcome = 1)
  if (d.run > d[1])
      {
      result <- list(d = d.run, outcome = 2)
      }
    if (d.run > d[2])
      {
      result <- list(d = d.run, outcome = 3)
      }
  return(result)
  }

lqas.simul <- function(runs = RUNS)
  {
  result <- data.frame()
  for(proportion in seq(from = PROP.LOWER, to = PROP.UPPER, by = FINE))
    {
    if(SHOW.PROGRESS)
      {
      cat("Running simulations for proportion := ", proportion, "%\n", sep = "")
      }
    test.data <- make.data(proportion)
    for(i in 1:runs)
      {
      test.run <- cbind(data.frame(lqas.run(data = test.data)), proportion)
      result <- rbind(result, test.run)
      }
    }
  return(result)
  }

#
# Simulations
#
x.00 <- lqas.simul(); x.01 <- lqas.simul(); x.02 <- lqas.simul(); x.03 <- lqas.simul()
x.04 <- lqas.simul(); x.05 <- lqas.simul(); x.06 <- lqas.simul(); x.07 <- lqas.simul()
x.08 <- lqas.simul(); x.09 <- lqas.simul(); x.10 <- lqas.simul(); x.11 <- lqas.simul()
x.12 <- lqas.simul(); x.13 <- lqas.simul(); x.14 <- lqas.simul(); x.15 <- lqas.simul()
x.16 <- lqas.simul(); x.17 <- lqas.simul(); x.18 <- lqas.simul(); x.19 <- lqas.simul()
x <- rbind(x.00, x.01, x.02, x.03, x.04, x.05, x.06, x.07, x.08, x.09, x.10, x.11, x.12, x.13, x.14, x.15, x.16, x.17, x.18, x.19)

#
# Probability of classification plot
#
p <- vector(mode = "numeric", length = 0)
p.low <- vector(mode = "numeric", length = 0)
p.moderate <- vector(mode = "numeric", length = 0)
p.high <- vector(mode = "numeric", length = 0)
for (i in unique(x$proportion))
  {
  y <- subset(x, proportion == i)
  n <- nrow(y)
  n.low <- length(y$outcome[y$outcome == 1])
  n.moderate <- length(y$outcome[y$outcome == 2])
  n.high <- length(y$outcome[y$outcome == 3])
  p <- c(p, i)
  p.low <- c(p.low, n.low / n)
  p.moderate <- c(p.moderate, n.moderate / n)
  p.high <- c(p.high, n.high / n)
  }
quartz(height = 6.5, width = 6.5, pointsize = 10)
plot(c(PROP.LOWER, PROP.UPPER),
     c(0, 1),
     pch = "",
     xlab = "Indicator Proportion (%)",
     ylab = "Probability of Classification",
     frame.plot = FALSE,
     xlim = c(PROP.LOWER, PROP.UPPER),
     ylim = c(0, 1))
points(p, p.low, pch = 6, cex= 0.5, col = "gray")
points(p, p.moderate, pch = 5, cex= 0.5, col = "gray")
points(p, p.high, pch = 2, cex= 0.5, col = "gray")
lines(lowess(p, p.low, f = SMOOTHER.SPAN), col = "red", lwd = 2)
lines(lowess(p, p.moderate, f = SMOOTHER.SPAN), col = "orange", lwd = 2)
lines(lowess(p, p.high, f = SMOOTHER.SPAN), col = "green", lwd = 2)
abline(v = LOW, lty = 3); abline(v = HIGH, lty = 3)
legend(x = 20,
       y = 0.45,
       legend = c("Low", "Moderate", "High"),
       cex = 0.8,
       lty = c(1, 1, 1),
       lwd = c(2, 2, 2),
       col = c("red", "orange", "green"),
       bg = "white",
       xjust = 1,
       yjust = 0,
       bty = "n")
#
# Save PC plot
#
dev2bitmap(file = plotFileName, type = "png256", height = 6.5, width = 6.5, res = 600, pointsize = 10)

#
# Confusion matrix
#
x$true <- cut(x$p, breaks = c(0, LOW, HIGH, 100), labels = c(1, 2, 3))
cm <- table(x$true, x$outcome)
#
# Summaries
#
correct <- diag(cm)
denominators <- apply(cm, 1, sum)
correct.proportion.by.group <- correct / denominators
names(correct.proportion.by.group) <- c("Low", "Medium", "High")
correct.proportion.overall <- sum(correct) / sum(denominators)
gross.misclass <- (cm[1, 3] + cm[3, 1]) / sum(denominators)
cat("                    Low : ", round(correct.proportion.by.group["Low"], 4), "\n",
    "               Moderate : ", round(correct.proportion.by.group["Medium"], 4), "\n",
    "                   High : ", round(correct.proportion.by.group["High"], 4), "\n",
    "                Overall : ", round(correct.proportion.overall, 4), "\n",
    "Gross misclassification : ", round(gross.misclass, 4), "\n\n", sep = "")
(cm)
sum(cm)
