install.packages("tidyverse")
library(tidyverse)
library(ggplot2)
library(readr)
library(maps)
library(viridis)
install.packages("coronavirus")
library(coronavirus)
world <- map_data("world")
view(coronavirus)


mybreaks <- c(1, 20, 100, 1000, 50000)

datacov <- coronavirus %>% 
  pivot_wider(names_from = type, values_from = cases)



ggplot() +
  geom_polygon(data = world, aes(x=long, y = lat, group = group), fill="grey", alpha=0.3) +
  geom_point(data=datacov, aes(x=long, y=lat,size=datacov$death, color=datacov$death),stroke=F, alpha=0.7) +
  scale_size_continuous(name="Cases", trans="log", range=c(1,7),breaks=mybreaks, labels = c("1-19", "20-99", "100-999", "1,000-49,999", "50,000+")) +
  scale_alpha_continuous(name="Cases", trans="log", range=c(0.1, 0.9),breaks=mybreaks) +
  scale_color_viridis_c(option="inferno",name="Cases", trans="log",breaks=mybreaks, labels = c("1-19", "20-99", "100-999", "1,000-49,999", "50,000+")) +
  theme_void() + 
  guides( colour = guide_legend()) +
  labs(caption = "Coronavir�s� Vaka Say�lar� ") +
  theme(
    legend.position = "bottom",
    text = element_text(color = "#22211d"),
    plot.background = element_rect(fill = "#ffffff", color = NA), 
    panel.background = element_rect(fill = "#ffffff", color = NA), 
    legend.background = element_rect(fill = "#ffffff", color = NA)
  )



library(dplyr)
library(ggplot2)
library(scales)
library(readr)
library(gganimate)
library(reshape2)
library(tidyr)
library(zoo)

#Kullanacag�m�z k�t�phaneleri cag�rd�ktan sonra datay� cekiyoruz.

Coronavirus_Data <- read_csv("https://covid.ourworldindata.org/data/ecdc/total_cases.csv")
Coronavirus_Data <- data.frame(Coronavirus_Data)

##Her �lkenin kendine ait sutunu var bu genis sutunlar yerine uzun tablo yap�s�n� kullan�yoruz.
Coronavirus_DataMelt <- melt(Coronavirus_Data, id ="date")

## Eksik verilere sahip baz� sutunlar var bu verileri yaklas�k olarak tahmin edebiliriz. 
Coronavirus_DataMelt$value <-  zoo::na.approx(Coronavirus_DataMelt$value)

##Grafik cizdirelim.
CdataPlot <- Coronavirus_DataMelt%>% 
  dplyr:: filter(variable %in% c( 'World','China', 'United.States', 'Turkey'))

Plot1 <- ggplot( data= CdataPlot, aes(x= date, y= value, colour= variable) )
Plot1 <- Plot1 + geom_point(show.legend = FALSE)
Plot1 <- Plot1 + geom_line(show.legend = FALSE , aes(x = date, y= value))
Plot1 <- Plot1 + theme_bw()
Plot1 <- Plot1 + transition_reveal(date)
Plot1 <- Plot1 + scale_color_brewer(palette = "Dark2")

##y ekseninde b�y�k say�lar�n dogru sekilde bicimlendirdigimizi g�rmemizi saglar
Plot1 <- Plot1 + scale_y_continuous(breaks = pretty_breaks(), labels = comma)

Plot1 <- Plot1 + facet_wrap(~variable)
Plot1 <- Plot1 + labs(title = "Coronavirus Cases")
Plot1 <- Plot1 + labs (subtitle = 'Frame {frame} of {nframes} ')
Plot1 <- Plot1 + labs ( x= "Date", y= 'Cases')

Plot1
options(scipen = 100000000)
breaks_vec= c(1,10,100,10000,100000,1000000,10000000)

Plot1 <- ggplot( data= CdataPlot, aes(x= date, y= value, colour= variable) )
Plot1 <- Plot1 + geom_point(show.legend = FALSE)
Plot1 <- Plot1 + geom_line(show.legend = TRUE , aes(x = date, y= value))
Plot1 <- Plot1 + theme_bw()
Plot1 <- Plot1 + transition_reveal(date)
Plot1 <- Plot1 + scale_color_brewer(palette = "Dark2")
Plot1 <- Plot1 + scale_y_continuous(trans = log_trans(), breaks= breaks_vec)

Plot1 <- Plot1 + labs(title = "Coronavirus Cases")
Plot1 <- Plot1 + labs (subtitle = 'Frame {frame} of {nframes} ')
Plot1 <- Plot1 + labs ( x= "Date", y= 'Cases')

Plot1
