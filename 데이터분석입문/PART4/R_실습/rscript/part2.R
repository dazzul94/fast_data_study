# --------------------------------------------#
# Fast campus X 임경덕
# 데이터 분석 입문 올인원 패키지 Online
    
# 중학교 수학으로 이해하는 통계와 데이터 분석 #
# ------------------------------------------- #


  ### 스크립트 실행 ########
  # Windows에서는 Ctrl+Enter
  # mac에서는  Command+Enter 
  


  ## 주제 : 한 변수의 요약



# Chapter 2 ---------------------------------------------------------------
# 한 범주형 변수의 요약 
  

  # 한 범주형 변수 만들기
  GENDER = c('남','여','여','남','여','여','여','남','남')
  GENDER = factor(GENDER)


  
  # levels( )로 수준 확인하기
  levels(GENDER)

  
  
  # table( )로 빈도표 만들기
  t_GENDER = table(GENDER)
  t_GENDER


  

  # 관측치 개수를 세어 상대빈도 계산하기  
  length(GENDER)
  sum( t_GENDER )
    
  t_GENDER/length(GENDER)

  
  
  # prop.table( ) 함수로 상대빈도 계산하기
  prop.table( t_GENDER )



  
  # barplot( ) 함수로 막대그래프 그리기
  t_GENDER
  barplot(t_GENDER)
  

  
  
  # pie( ) 함수로 원 그래프 그리기   
  pie(t_GENDER)


  
  



  
  
  
# Chapter 3 & 4 ---------------------------------------------------------------
# 한 수치형 변수의 요약 

  
  # 데이터 만들기 
  SCORE = c(60, 78, 83, 74, 100, 80, 90, 85, 70)



  
  # sort( ) 함수로 관측치 정렬하기
  sort(SCORE)
  sort(SCORE, decreasing = TRUE)

    ## decreasing=TRUE 옵션을 활용해서 내림차순으로 정렬 가능 
  
  
  
  
  # 최솟값, 최댓값, 중앙값 계산하기
  min(SCORE)
  max(SCORE)
  median(SCORE)
  
    ## min( ), max( ), median( ) 함수를 활용
  
  
  
  
  # quantile( ) 함수로 다양한 분위수 계산하기 
  quantile(SCORE, 0.25)
    ## Q1(25%)를 계산  
  
    ## 다양한 분위수 계산방법 활용
    ?quantile

  quantile(SCORE, 0.25, type = 5)
  
  
  quantile(SCORE, 0.75, type = 5)


  
  
  
  
  # summary( ) 함수를 활용한 다섯숫자요약
  summary(SCORE)
    
    ## 평균을 포함한 6개 숫자 확인 가능 
  
  
  
  
  
  # boxplot( ) 함수를 활용한 상자그림 그리기
  boxplot(SCORE)

  
  
  # hist( ) 함수를 활용한 히스토그램 그리기
  hist(SCORE)
  
  hist(SCORE, breaks=seq(50,100,10), right=TRUE)
    ## breaks 옵션으로 구간 지정 가능
    


  
  # 평균과 분산, 표준편차 계산
  mean(SCORE)
  var(SCORE)
  sd(SCORE)
    ## mean( ), var( ), sd( ) 함수 활용
  
  
  
  
  

# Chapter 5 ---------------------------------------------------------------
# 상대적인 값으로의 변환
  
  
  # 최솟값과 최댓값을 활용한 min-max 변환
  min_S = min(SCORE)
  max_S = max(SCORE)
  min_S
  max_S
  

  max_S - min_S
    ## 전체 구간의 길이 계산 

  
  SCORE
  (SCORE - min_S)
  (SCORE - min_S)/(max_S - min_S)
    ## 각 관측치의 상대적인 위치 확인 가능 
  

  
  
  
  
  # 평균과 표준편차를 활용한 표준화
  mean_S = mean(SCORE)
  sd_S   = sd(SCORE)
    ## 평균과 표준편차의 계산
  mean_S
  sd_S
  
  
  SCORE
  SCORE- mean_S
  (SCORE - mean_S)/sd_S
    ## 표준점수 계산 가능

  
  
  # scale( ) 함수를 활용한 표준화
  scale(SCORE)

  
  
# End of script