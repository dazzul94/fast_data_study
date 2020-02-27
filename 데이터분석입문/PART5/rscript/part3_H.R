# ----------------------------------------------#
# Fast campus X 임경덕
# 데이터 분석 입문 올인원 패키지 Online
    
# 고등학교 수학으로 이해하는 통계와 데이터 분석 #
# --------------------------------------------- #


  # Windows에서는 Ctrl+Enter
  # mac에서는  Command+Enter 
  # -> 명령어가 한 줄씩 실행됩니다. 



# Chapter2 ----------------------------------------------------------------
# 조건부 평균과 조건부 확률

  # 데이터 만들기
  SCORES = data.frame(
    국어점수 = c(60,70,74,78,80,83,85,90,95,100), 
    수학점수 = c(75,70,60,85,100,84,94,70,90,92))

  SCORES



  # subset( )을 활용한 부분 데이터 생성하기 
  MATH_GOOD = subset(SCORES, 수학점수>=80)
  MATH_GOOD
  
  
  # 논리연산으로 조건부 확률 계산하기
  mean(MATH_GOOD$국어점수>=90)
  
  
  # 변수만으로 조건부 평균 계산하기 
  mean(MATH_GOOD$국어점수)

  
  
  MATH_BAD = subset(SCORES, 수학점수<80)
  MATH_BAD
  
  mean(MATH_BAD$국어점수>=90)
  mean(MATH_BAD$국어점수)

  

  
  
      
# Chapter3 ----------------------------------------------------------------
# 회귀모형
  
  # 데이터 불러오기
  heights = read.csv('data/heights.csv')
  head(heights)
  
  plot(heights$father, heights$son, pch=16, col='#3377BB77')
    abline(v=mean(heights$father), lty=2)
    abline(h=mean(heights$son),lty=2)
    
  
  
  # lm( )을 활용해 회귀모형 적합하기
  lm_heights = lm(son ~ father, data=heights)
  summary(lm_heights)

  
  
####### 매출 데이터로 다중 회귀모형 적합하기
  
  # 데이터 불러오기
  sales = read.csv('data/sales.csv')
  
  head(sales)
  nrow(sales)  
  
  
  # price와 sales의 산점도 그리기
  plot(sales$price, sales$sales, pch=16, col='#3377BB77')

  # advert와 sales의 산점도 그리기
  plot(sales$advert, sales$sales, pch=16, col='#3377BB77')
  
  
  
  # lm( )으로 회귀모형 적합하기
  lm_sales = lm(sales ~ price+advert, data=sales)
  summary(lm_sales)
  
    ## sales = 118.9136 -7.9079*sales +1.8626*advert
    ## 결정 계수 = 0.4483
  
  
  

  
# Chapter5 ----------------------------------------------------------------
# 의사결정 나무 모형
  
  
  # install.packages( )로 패키지 설치하기
  install.packages(c('rpart','rpart.plot'))
  library(rpart)
  library(rpart.plot)
  
  
  # 데이터 살펴보기
  head(sales)
  
  
  # rpart( )으로 의사결정나무 모형 적합하기
  tree_sales = rpart(sales ~ price+advert, data=sales)
  tree_sales
  
  
  # rpart.plot( )으로 모형 시각화하기
  rpart.plot(tree_sales, cex=1)
  
  

    
####### 의사결정 나무모형으로 합격률 설명하기

  # 데이터 살펴보기
    # load('data/admission.RData')
  head(admission)
    ## admit : 합격여부
    ## gre   : 시험점수
    ## gpa   : 대학교 평균 평점
    ## rank  : 대학교 등급
  
  nrow(admission)
    
  
  # 의사결정나무 모형적합하고 시각화하기
  tree_admit = rpart(admit ~ gre+gpa+rank, data=admission)
  tree_admit
  
  rpart.plot(tree_admit, cex=1)

  
    
# End of script  