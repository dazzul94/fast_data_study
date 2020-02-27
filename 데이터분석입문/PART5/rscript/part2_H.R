# ----------------------------------------------#
# Fast campus X 임경덕
# 데이터 분석 입문 올인원 패키지 Online
    
# 고등학교 수학으로 이해하는 통계와 데이터 분석 #
# --------------------------------------------- #


  # Windows에서는 Ctrl+Enter
  # mac에서는  Command+Enter 
  # -> 명령어가 한 줄씩 실행됩니다. 




# Chapter1 ----------------------------------------------------------------
# 모집단과 표본

  # sample( )을 활용한 표본 추출하기
  1:45

  sample(1:45, 6)
    ## 45개 숫자 중 6개를 랜덤으로 선택
  
  sample(1:45, 6, replace=TRUE)
    ## replace=TRUE : 복원추출

  
  
  # 전체 평균과 표본 평균 비교하기
  mean(1:45)
  mean( sample(1:45,6) )
  
  
  
  

# Chapter2/3 ----------------------------------------------------------------
# 통계 검정
  
  
########## 두 수치형 변수의 상관계수에 대한 검정 
  
  # 데이터 불러오기
  TWO_CONT = read.csv('data/TWO_CONT.csv', fileEncoding='UTF-8')
  TWO_CONT
  
  
  # 산점도 그리기 
  plot(TWO_CONT, pch=16, col='dodgerblue')
    abline(v=mean(TWO_CONT$HOUR), lty=2)
    abline(h=mean(TWO_CONT$SCORE),lty=2)
    
    
  # 상관계수 계산하기
  cor(TWO_CONT$HOUR, TWO_CONT$SCORE)
  
  
  # 관측치를 랜덤으로 짝지어 상관계수 계산하기
  random_x = sample(TWO_CONT$HOUR, 9)
  random_y = sample(TWO_CONT$SCORE, 9)
  random_x
  random_y

  plot(random_x, random_y, pch=16, col='dodgerblue')  
  cor(random_x, random_y)
  
  
  
  # 상관계수에 대한 t값 계산하기
  cor(TWO_CONT$HOUR, TWO_CONT$SCORE)
  
  r_xy = cor(TWO_CONT$HOUR, TWO_CONT$SCORE)
  r_xy
  
  n = nrow(TWO_CONT)
  n
  
  t_value = sqrt(n-2) * r_xy / sqrt(1-r_xy^2)
  t_value    

  
  
  # 유의확률 계산
  pt(t_value, (n-2))
    ## 98.2%
  

  
  # cor.test( )의 활용
  cor.test(TWO_CONT$HOUR, TWO_CONT$SCORE)
  
  
  
  # 아빠키-아들키의 상관계수 검정하기
  heights = read.csv('data/heights.csv')
  
  plot(heights, pch=16, col='#3377BB77')
    abline(v=mean(heights$father), lty=2)
    abline(h=mean(heights$son),lty=2)
    
  
  cor(heights$father, heights$son)
  
  cor.test(heights$father, heights$son)
  
  
  
  
  
########## 두 범주형 변수의 교차표에 대한 독립성 검정 

  # 데이터 불러오기
  raw = read.csv('data/raw.csv')
  head(raw)
  nrow(raw)
  
  
  # 교차표 만들고 열지도 그리기
  table_raw = table(raw$PROD, raw$AGE)
  table_raw
  
  heatmap(table_raw,
          Rowv=NA, Colv=NA, scale='none', col=colorRampPalette(c('ivory','red'))(100), revC = TRUE)

  
  
  # chisq.text( )를 활용해 독립성 검정하기
  chisq.test(table_raw)  
  
  
  
########## 한 수치형 변수와 한 범주형 변수의 
########## 그룹별 평균에 대한 검정 
  
  
  # 데이터 불러오기
  team_score = read.csv('data/TEAM_SCORE.csv')
  team_score

  
  
  # 그룹별 평균 계산하고 상자그림 그리기
  aggregate(SCORE ~ TEAM, data=team_score, mean)

  boxplot(SCORE ~ TEAM, data=team_score)    
  
  
  
  # aov( )로 분산분석 실행하고 결과보기
  result = aov(SCORE ~ TEAM, data=team_score)
  summary(result)
  
  
  
# End of script