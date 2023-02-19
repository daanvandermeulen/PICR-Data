library(dplyr)
library(rstatix)
library(ggplot2)
library(data.table)

Data = read.csv('C:\\Users\\ilana\\Desktop\\R_Lab\\Data\\Final_Data.csv')
Data = rename(Data, Speaker = X...Speaker)
Data$Is_Conflict_Fac = factor(Data$Is_Conflict)
Data_Nationality_Num = as.numeric(Data$Nationality)
cols = cbind('Year','Nationality','Tense', 'Is_Conflict', 'Hope_Wish', 'Hope_Expectations', 'Threat_Severity', 'Threat_Likelihood', 'Is_Conflict_Fac')
for (col in cols){Data[,col]= factor(Data[,col])}

Unit_per_Speech = read.csv('C:\\Users\\ilana\\Desktop\\R_Lab\\Data\\Units_per_Speech.csv')

Wish = as.data.table(aggregate(Hope_Wish~Year*Nationality*Speaker*Is_Conflict*Nationality_Num*Is_Conflict_Fac, Data, FUN=summary))
Wish = filter(Wish, Is_Conflict_Fac==1)
Wish$Units = Unit_per_Speech$Units.Per.Speech
Wish$Pos_Rel = Wish$Hope_Wish.1 / Wish$Units

Severe = as.data.table(aggregate(Threat_Severity~Year*Nationality*Speaker*Is_Conflict*Nationality_Num*Is_Conflict_Fac, Data, FUN=summary))
Severe = filter(Severe, Is_Conflict_Fac==1)
Severe$Units = Unit_per_Speech$Units.Per.Speech
Severe$Subtracted = Severe$Threat_Severity.1 - Severe$Threat_Severity.0
Severe$Sub_Rel = Severe$Subtracted / Severe$Units

Like = as.data.table(aggregate(Threat_Likelihood~Year*Nationality*Speaker*Is_Conflict*Nationality_Num*Is_Conflict_Fac, Data, FUN=summary))
Like = filter(Like, Is_Conflict_Fac==1)
Like$Units = Unit_per_Speech$Units.Per.Speech
Like$Subtracted = Like$Threat_Likelihood.1 - Like$Threat_Likelihood.0
Like$Sub_Rel = Like$Subtracted / Like$Units

Threat = Like$Sub_Rel + Severe$Sub_Rel
Hope = Wish$Pos_Rel

total = data.frame("Year" = Wish$Year, "Nationality" = Wish$Nationality, "Speaker" = Wish$Speaker, Hope, Threat)

#DESCRIPTIVE
ISR = filter(total, Nationality == 'ISR')
PAL = filter(total, Nationality == 'PAL')

mean(ISR$Hope)
sd(ISR$Hope)
mean(PAL$Hope)
sd(PAL$Hope)

mean(ISR$Threat)
sd(ISR$Threat)
mean(PAL$Threat)
sd(PAL$Threat)

#GRAPH PER YEAR

ggplot(data=total, aes(x=Year, y=Hope, group=Nationality, color=Nationality))+
  geom_point()+geom_line(data=total, aes(x=Year, y=Hope, group=Nationality))

ggplot(data=total, aes(x=Year, y=Threat, group=Nationality, color=Nationality))+
  geom_point()+geom_line(data=total, aes(x=Year, y=Threat, group=Nationality))


#ANALYSIS
wish = aov(Hope~ Nationality + Year , data = total)
Anova(wish, type = "III")
TukeyHSD(wish, "Nationality")
TukeyHSD(wish, "Year")

threat = aov(Threat~ Nationality + Year , data = total)
Anova(threat, type = "III")
TukeyHSD(threat, "Nationality")
TukeyHSD(threat, "Year")

#GRAPHS

graph_wish = ggplot(total, aes(y = Hope, x = Nationality))
graph_wish+ 
  stat_summary(fun = mean, geom = 'bar', color = 'black', fill = 'white')+
  stat_summary(fun.data = mean_se, geom = 'errorbar', width = .2)+
  ylim(0	,	0.234042553	)+
  geom_segment(x = 1, y = 0.12, xend = 2, yend = 0.12)+
  geom_text(x = 1.5, y = 0.15, label = '**', size = 5)+
  ylab('Wish for Peace')

graph_threat = ggplot(total, aes(y = Threat, x = Nationality))
graph_threat+ 
  stat_summary(fun = mean, geom = 'bar', color = 'black', fill = 'white')+
  stat_summary(fun.data = mean_se, geom = 'errorbar', width = .2)+
  ylim(-0.005	,	0.121951220	)+
  geom_segment(x = 1, y = 0.073, xend = 2, yend = 0.073)+
  geom_text(x = 1.5, y = 0.076, label = '*', size = 5)+
  ylab('Threat')
