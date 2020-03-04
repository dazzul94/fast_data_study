library(openxlsx)

compet = read.xlsx('data/역대경쟁률.xlsx')
head(compet)

# hist(compet$커트라인)
# boxplot(compet$커트라인)

plot(compet$경쟁률, compet$커트라인점수, pch=16, col='#3377BB77')
abline(v=mean(compet$경쟁률), lty=2)
abline(h=mean(compet$커트라인점수),lty=2)

which.min(compet$경쟁률)
compet[7, ]
# 경쟁률이 낮을수록 커트라인은 낮고 
# 경쟁률이 높을수록 커트라인이 높다.

lm_compet = lm(커트라인점수 ~ 경쟁률, data=compet)
summary(lm_compet)

# Adjusted R-squared:  0.7098 

# 2020 예측 커트라인은 
# 0.37578 * 18.7 + 334.17416 = 341.201246