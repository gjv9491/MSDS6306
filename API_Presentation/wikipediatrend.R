install.packages("wikipediatrend")
library(wikipediatrend)
library(ggplot2)
wp <- wp_trend(page = c("Fever","Fieber"), 
               from = "2013-08-01", 
               to   = "2015-12-31", 
               lang = c("en","de"))

ggplot(wp,aes(x=date, y=count, group=title) )+
  stat_smooth(aes(colour=title))+
  geom_point(aes(colour = title))
 
  # geom_line(aes(colour = page))
