## Proyecto
# Giancarlo Dente 15-10395

movies <- read.delim("movie-profits.txt")

## 1. Realizar un  analisis descriptivo de los datos

sd(movies$US.Gross...M.)
sd(movies$Budget...M.)
sd(movies$Run.Time..min.)
sd(movies$Critic.Score..Rotten.Tomatoes.)

# US Gross ($M)
# graficos
hist(movies$US.Gross...M., main = "Recaudacion en millones de dolares", 
     ylab = "Frecuencia", xlab = "Recaudacion ($M)", col = "green")

boxplot(movies$US.Gross...M., main = "Recaudacion en millones de dolares", 
        ylab = "Recaudacion ($M)", col="green")

# resumen estadistico
boxplot.stats(movies$US.Gross...M.)
summary(movies$US.Gross...M.)
hist(movies$US.Gross...M., plot=F)


# Budget ($M)
# graficos 
hist(movies$Budget...M., main="Presupuesto de las peliculas", ylab="Frecuencia",
     xlab="Presupuesto ($M)", col="blue")

boxplot(movies$Budget...M., main="Presupuesto de las peliculas",
        ylab="Presupuesto ($M)", col="blue")

# resumen estadistico
boxplot.stats(movies$Budget...M.)
summary(movies$Budget...M.)
hist(movies$Budget...M., plot=F)


# Run Time (min)
# graficos 
hist(movies$Run.Time..min., main="Tiempo de duracion de las peliculas", 
     ylab="Frecuencia", xlab="duracion (min)", col="yellow")

boxplot(movies$Run.Time..min., main="Tiempo de duracion de las peliculas",
        ylab="duracion (min)", col="yellow")

# resumen estadistico
summary(movies$Run.Time..min.)
boxplot.stats(movies$Run.Time..min.)
hist(movies$Run.Time..min., plot=F)


# Critic Score (Rotten Tomatoes) 
# graficos
hist(movies$Critic.Score..Rotten.Tomatoes., main="Puntuacion de las peliculas", 
     ylab="Frecuencia", xlab="Puntuacion", col="red")

boxplot(movies$Critic.Score..Rotten.Tomatoes., main="Puntuacion de las peliculas", 
        ylab="Puntuacion", col="red")

# resumen estadistico
summary(movies$Critic.Score..Rotten.Tomatoes)
boxplot.stats(movies$Critic.Score..Rotten.Tomatoes.)
hist(movies$Critic.Score..Rotten.Tomatoes, plot=F)


# 2.Realice un intervalo de confianza del 97% para la media de cada variable en estudio.

t.test(movies$US.Gross...M., conf.level = 0.97)$conf.int
t.test(movies$Budget...M., conf.level = 0.97)$conf.int
t.test(movies$Run.Time..min., conf.level = 0.97)$conf.int
t.test(movies$Critic.Score..Rotten.Tomatoes., conf.level = 0.97)$conf.int

# 3.Pruebe, a un nivel de 0.05, que el promedio de la puntuación de la crítica es superior 
# a 50.
m <- length(movies$Critic.Score..Rotten.Tomatoes.)
 # Estadistico de prueba
Z <- (mean(movies$Critic.Score..Rotten.Tomatoes.) - 50) / (sd(movies$Critic.Score..Rotten.Tomatoes.)/sqrt(m))
 # Region de rechazo
qnorm(0.05, lower.tail = F)
 # p-valor
pvalor <- pnorm(Z, lower.tail = F)
pvalor

# Alternativamente,
t.test(movies$Critic.Score..Rotten.Tomatoes., alternative="greater", mu=50)

# 4. Realizar una prueba de bondad de ajuste para determinar si la variable US Gross tiene 
# distribucion normal.
# Ho: Los datos tienen dist normal
# Ha: Los datos no tienen dist normal
hist(movies$US.Gross...M., plot=F)

r <- 2
fi <- c(313, 151, 71, 31, 14, 12, 10, 7)
k <- length(fi)
n <- sum(fi)
mi <- c(25, 75, 125, 175, 225, 275, 350, 600) # marca de las clases

# estimacion de los parametros
library(MASS)
fitdistr(movies$US.Gross...M., "normal")

# probabilidad de cada categoria
pi <- pnorm(c(50,100,150,200,250,300,400,800), 75.819769, 82.575467) - pnorm(c(0,50,100,150,200,250,300,400), 75.819769, 82.575467)
pi

# Estadistico de prueba
chi2_obs <- sum( (fi - n*pi)**2 / (n*pi) )
chi2_obs

# region de rechazo
chi2_alpha <- qchisq(0.05, k-1-r, lower.tail = F)
chi2_alpha

# P valor
p_valor <- pchisq(chi2_obs, k-1-r, lower.tail = F)
p_valor

# 5.Realizar un grafico de dispersion y una matriz de correlacion de las variables.
movies2 <- subset(movies, select=-c(Year,Movie))
# grafico de dispersion
pairs(movies2)
# matriz de correlacion
cor(movies2)

# 6.Estudie si la correlacion entre la recaudacion y el presupuesto de las peliculas es positiva
# Comprobacion
Sxx = sum((movies$US.Gross...M.-mean(movies$US.Gross...M.))**2)
Syy = sum((movies$Budget...M.-mean(movies$Budget...M.))**2)
Sxy = sum((movies$US.Gross...M.-mean(movies$US.Gross...M.))*(movies$Budget...M.-mean(movies$Budget...M.)))

# estimador de maxima verosimilitud de ro 
r = Sxy / sqrt(Sxx*Syy)
r

# 7.Haga un muestreo para dividir los datos en dos subconjuntos, uno con 80 % y 20 % de los datos
movies_sub80 <- movies2[1:487,]
movies_sub20 <- movies2[488:609,]

# 8. Con el subconjunto del 80 % de los datos, halle un modelo lineal que explique mejor la variable 
# US Gross, e incluya todas las pruebas necesarias para llegar a este modelo, asi como un analisis de
# residuos del modelo final.

# Comenzamos haciendo el modelo completo
m1 = lm(movies_sub80$US.Gross...M.~ movies_sub80$Budget...M. + movies_sub80$Run.Time..min. + movies_sub80$Critic.Score..Rotten.Tomatoes.)
summary(m1) # tiene todas sus variables significativas, nos quedamos con este modelo 

par(mfrow=c(2,2))
plot(m1) # vemos que el dato 366 da algunos problemas, volvemos a realizar el ajuste
# quitando este valor 

movie_ajus = movies_sub80[-366,]
m2 = lm(movie_ajus$US.Gross...M. ~ movie_ajus$Budget...M. + movie_ajus$Run.Time..min. + movie_ajus$Critic.Score..Rotten.Tomatoes.)
summary(m2)

plot(m2) # Finalmente, el modelo que mejor se ajusta es :
# US Gross ~ Budget + Run.time + Critic.score 

# 9.Con los datos del 20 % restante, haga una predicción de la variable US Gross (con el 
# mejor modelo en general) y haga un resumen estadístico de los residuos de predicción 
# (valor observado vs. predicción del modelo) para concluir con relación al poder 
# predictivo del modelo.

# Comenzamos haciendo el modelo completo
m3 = lm(movies_sub20$US.Gross...M. ~ movies_sub20$Budget...M. + movies_sub20$Run.Time..min. + movies_sub20$Critic.Score..Rotten.Tomatoes.)
summary(m3) # eliminamos Run.time 

m4 = lm(movies_sub20$US.Gross...M. ~ movies_sub20$Budget...M. + movies_sub20$Critic.Score..Rotten.Tomatoes.)
summary(m4) # eliminamos el intercepto

m5 = lm(movies_sub20$US.Gross...M. ~ movies_sub20$Budget...M. + movies_sub20$Critic.Score..Rotten.Tomatoes. -1)
summary(m5)

plot(m5) # el dato 61 crea problemas lo quitamos realizamos de nuevo el ajuste

movie_ajus2 = movies_sub20[-61,]
m6 = lm(movie_ajus2$US.Gross...M. ~ movie_ajus2$Budget...M. + movie_ajus2$Run.Time..min. + movie_ajus2$Critic.Score..Rotten.Tomatoes.)
summary(m6) # eliminamos el intercepto

m7 = lm(movie_ajus2$US.Gross...M. ~ movie_ajus2$Budget...M. + movie_ajus2$Run.Time..min. + movie_ajus2$Critic.Score..Rotten.Tomatoes. -1)
summary(m7) # eliminamos Run.time

m8 = lm(movie_ajus2$US.Gross...M. ~ movie_ajus2$Budget...M. + movie_ajus2$Critic.Score..Rotten.Tomatoes. -1)
summary(m8)

plot(m8) # el modelo que mejor se ajusta es:
# US.Gross ~ Budget + Critic.score - 1

# prediccion
predict(m8, movie_ajus2, interval="confidence")


# 10. Haga analisis de varianza para estudiar si US Gross, Budget, Run Time y 
# Critic Score, tienen promedios iguales segun el año de la pelicula.

movies$Year

# US.Gross
USGross_2008 = subset(movies, Year==2008, select=US.Gross...M.)
USGross_2009 = subset(movies, Year==2009, select=US.Gross...M.)
USGross_2010 = subset(movies, Year==2010, select=US.Gross...M.)
USGross_2011 = subset(movies, Year==2011, select=US.Gross...M.)
USGross_2012 = subset(movies, Year==2012, select=US.Gross...M.)

dat = c(USGross_2008$US.Gross...M., USGross_2009$US.Gross...M., USGross_2010$US.Gross...M., USGross_2011$US.Gross...M., USGross_2012$US.Gross...M.)
fac = c(replicate(length(USGross_2008$US.Gross...M.), "2008"), replicate(length(USGross_2009$US.Gross...M.),"2009"), replicate(length(USGross_2010$US.Gross...M.),"2010"), 
        replicate(length(USGross_2011$US.Gross...M.),"2011"), replicate(length(USGross_2012$US.Gross...M.),"2012")  )
fact = factor(fac)

tapply(dat, fact, mean)

par(mfrow=c(1,1))
    
boxplot(dat ~ fact, main="Recaudacion segun el año de la pelicula", xlab="Años",
        ylab="Recaudacion ($M)", col="light blue", col.main="light blue")

mod.lm = lm(dat ~ fact)
anova(mod.lm)

# Budget 
Budget_2008 = subset(movies, Year==2008, select=Budget...M.)
Budget_2009 = subset(movies, Year==2009, select=Budget...M.)
Budget_2010 = subset(movies, Year==2010, select=Budget...M.)
Budget_2011 = subset(movies, Year==2011, select=Budget...M.)
Budget_2012 = subset(movies, Year==2012, select=Budget...M.)

dat1 = c(Budget_2008$Budget...M., Budget_2009$Budget...M., Budget_2010$Budget...M., Budget_2011$Budget...M., Budget_2012$Budget...M.)
fac1 = c(replicate(length(Budget_2008$Budget...M.), "2008"), replicate(length(Budget_2009$Budget...M.),"2009"), replicate(length(Budget_2010$Budget...M.),"2010"), 
        replicate(length(Budget_2011$Budget...M.),"2011"), replicate(length(Budget_2012$Budget...M.),"2012")  )
fact1 = factor(fac1)

tapply(dat1, fact1, mean)

boxplot(dat1 ~ fact1, main="Presupuesto segun el año de la pelicula", xlab="Años",
        ylab="Presupuesto ($M)", col="light blue", col.main="light blue")

mod.lm1 = lm(dat1 ~ fact1)
anova(mod.lm1)

# Run Time
Time_2008 = subset(movies, Year==2008, select=Run.Time..min.)
Time_2009 = subset(movies, Year==2009, select=Run.Time..min.)
Time_2010 = subset(movies, Year==2010, select=Run.Time..min.)
Time_2011 = subset(movies, Year==2011, select=Run.Time..min.)
Time_2012 = subset(movies, Year==2012, select=Run.Time..min.)

dat2 = c(Time_2008$Run.Time..min., Time_2009$Run.Time..min., Time_2010$Run.Time..min., Time_2011$Run.Time..min., Time_2012$Run.Time..min.)
fac2 = c(replicate(length(Time_2008$Run.Time..min.), "2008"), replicate(length(Time_2009$Run.Time..min.),"2009"), replicate(length(Time_2010$Run.Time..min.),"2010"), 
         replicate(length(Time_2011$Run.Time..min.),"2011"), replicate(length(Time_2012$Run.Time..min.),"2012")  )
fact2 = factor(fac2)

tapply(dat2, fact2, mean)

boxplot(dat2 ~ fact2, main="Tiempo de duracion segun el año de la pelicula", xlab="Años",
        ylab="Duracion (min)", col="light blue", col.main="light blue")

mod.lm2 = lm(dat2 ~ fact2)
anova(mod.lm2)

# Critic Score
Score_2008 = subset(movies, Year==2008, select=Critic.Score..Rotten.Tomatoes.)
Score_2009 = subset(movies, Year==2009, select=Critic.Score..Rotten.Tomatoes.)
Score_2010 = subset(movies, Year==2010, select=Critic.Score..Rotten.Tomatoes.)
Score_2011 = subset(movies, Year==2011, select=Critic.Score..Rotten.Tomatoes.)
Score_2012 = subset(movies, Year==2012, select=Critic.Score..Rotten.Tomatoes.)

dat3 = c(Score_2008$Critic.Score..Rotten.Tomatoes., Score_2009$Critic.Score..Rotten.Tomatoes., Score_2010$Critic.Score..Rotten.Tomatoes., Score_2011$Critic.Score..Rotten.Tomatoes., Score_2012$Critic.Score..Rotten.Tomatoes.)
fac3 = c(replicate(length(Score_2008$Critic.Score..Rotten.Tomatoes.), "2008"), replicate(length(Score_2009$Critic.Score..Rotten.Tomatoes.),"2009"), replicate(length(Score_2010$Critic.Score..Rotten.Tomatoes.),"2010"), 
         replicate(length(Score_2011$Critic.Score..Rotten.Tomatoes.),"2011"), replicate(length(Score_2012$Critic.Score..Rotten.Tomatoes.),"2012")  )
fact3 = factor(fac3)

tapply(dat3, fact3, mean)

boxplot(dat3 ~ fact3, main=" Puntuacion segun el año de la pelicula", xlab="Años",
        ylab="Puntuacion", col="light blue", col.main="light blue")

mod.lm3 = lm(dat3 ~ fact3)
anova(mod.lm3)
