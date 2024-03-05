# maximum likelihood method by fitdistr
library(MASS)
n <- 10000
x <- rexp(n, rate = 3.8)
hist(x, prob=TRUE)
fitdistr(x, "exponential")
curve(dexp(x, 3.819932), add = TRUE)
# > fitdistr(x, "exponential")
# rate   
# 3.83121147 
# (0.03831211)

# estimation of parameter by fitdistr
library(MASS)
?fitdistr
n <- 10000
x_norm <- rnorm(n, 3, 8)
x_poisson <- rpois(n, 3)
x_cauchy <- rcauchy(n, 2, 4)
fitdistr(x_norm, "normal")
fitdistr(x_poisson, "Poisson")
fitdistr(x_cauchy, "cauchy")
# > fitdistr(x_norm, "normal")
# mean          sd    
# 2.94968200   8.02943956 
# (0.08029440) (0.05677671)
# > fitdistr(x_poisson, "Poisson")
# lambda  
# 3.01470000 
# (0.01736289)
# > fitdistr(x_cauchy, "cauchy")
# location      scale   
# 1.95517690   3.95794184 
# (0.05593227) (0.05601549)


