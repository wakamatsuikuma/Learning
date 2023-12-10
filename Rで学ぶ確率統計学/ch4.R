
# cauchy distribution
x <- rcauchy(1000)
hist(x)

# monte carlo method
x <- runif(10000, 0, 1)
y <- runif(10000, 0, 2)
plot(x, y, col = ifelse( (x^2+(y-1)^2<=1)&((x-2)^2+y^2<=4), "black", "white"), pch = 20, asp = 1)
# area calculating
1 * 2 * sum((x^2+(y-1)^2<=1)&((x-2)^2+y^2<=4)) / 10000

# exponential distribution and CLT
x <- rexp(1000*3,rate=5)
xm3 <- matrix(x,nrow=1000,ncol=3)
z3 <- apply(xm3,1,mean)
hist(z3, prob=TRUE, xlim=c(0,0.60), ylim=c(0,5))
par(new=TRUE)
plot(function(x)dnorm(x,mean=mean(z3),sd=sd(z3)), 
     xlim=c(0,0.60),ylim=c(0,5))