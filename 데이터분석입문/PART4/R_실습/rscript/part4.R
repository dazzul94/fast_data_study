# --------------------------------------------#
# Fast campus X 임경덕
# 데이터 분석 입문 올인원 패키지 Online
    
# 중학교 수학으로 이해하는 통계와 데이터 분석 #
# ------------------------------------------- #


  ### 스크립트 실행 ########
  # Windows에서는 Ctrl+Enter
  # mac에서는  Command+Enter 
  

  ## 주제 : 선형 회귀 



##1 회귀 계수의 계산과 활용

  # 데이터 불러오기
  TWO_CONT = read.csv('data/TWO_CONT.csv', fileEncoding='UTF-8')
  TWO_CONT

  
  
  
  # 산점도와 보조선 그리기 
  plot(TWO_CONT, pch=16, col='dodgerblue')
    abline(v=mean(TWO_CONT$HOUR), lty=2)
    abline(h=mean(TWO_CONT$SCORE),lty=2)

    
    
    
  # 상관계수를 활용해서 상관계수 계산하기  
  r_xy = cor(TWO_CONT$HOUR, TWO_CONT$SCORE)
  r_xy

  
  sd_x = sd(TWO_CONT$HOUR)
  sd_y = sd(TWO_CONT$SCORE)


  b1 = r_xy/sd_x*sd_y
  b1


  b0 = mean(TWO_CONT$SCORE) - b1*mean(TWO_CONT$HOUR)
  b0

  
  
  # abline( ) 함수로 추세선 추가하기 
  abline(a=b0, b=b1, col='dodgerblue', lwd=2)

    ## a=b0(y절편), b=b1(기울기) 옵션으로 직선 추가 가능
    ## 직선의 두께(lwd) 조정 가능


  
  
  
##2 아빠키-아들키 예제 살펴보기
  
  # 데이터 불러오기
  heights = read.csv('data/heights.csv')
  head(heights)
  
  plot(heights, pch=16, col='#3377BB77')
    abline(v=mean(heights$father), lty=2)
    abline(h=mean(heights$son),lty=2)
    
    ## HEX코드와 alpha값을 활용해서 색깔과 투명도 지정 가능

    
  
    
  # 회귀 계수 계산하기 
    
  # 상관계수를 활용해서 상관계수 계산하기
  r_fs = cor(heights$father, heights$son)
  r_fs

  # 아빠키와 아들키의 표준편차를 계산하기기
  sd_f = sd(heights$father)
  sd_s = sd(heights$son)
  
  
  b1 = r_fs/sd_f*sd_s
  b1
  
  
  b0 = mean(heights$son) - b1*mean(heights$father)
  b0


  abline(a=b0, b=b1, col='dodgerblue', lwd=2)


  # 회귀계수를 활용한 예측
  b0 + b1*170 # 아빠키가 170일 때 
  b0 + b1*180 # 아빠키가 180일 때



  
# End of script