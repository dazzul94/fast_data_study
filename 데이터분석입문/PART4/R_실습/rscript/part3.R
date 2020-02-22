# --------------------------------------------#
# Fast campus X 임경덕
# 데이터 분석 입문 올인원 패키지 Online
    
# 중학교 수학으로 이해하는 통계와 데이터 분석 #
# ------------------------------------------- #


  ### 스크립트 실행 ########
  # Windows에서는 Ctrl+Enter
  # mac에서는  Command+Enter 
  

  ## 주제 : 두 변수의 관계
  
  


# Chapter 2 ---------------------------------------------------------------
# 두 범주형 변수의 관계
  
  
  # 데이터 불러오기
  TWO_CATE = read.csv('data/TWO_CATE.csv', fileEncoding='UTF-8')
  TWO_CATE


  
    
  # 한 변수를 선택하고 table( ) 함수로 요약하기
  TWO_CATE$GENDER
  table(TWO_CATE$GENDER)
  

  TWO_CATE$AGE
  table(TWO_CATE$AGE)


  
  
  # table( ) 함수로 교차표 만들기
  table(TWO_CATE$GENDER, TWO_CATE$AGE)
  
  table_TWO = table(TWO_CATE$GENDER, TWO_CATE$AGE)

    
  
  
  # heatmap( ) 함수로 열지도 그리기
  heatmap(table_TWO)
  
  heatmap(table_TWO, 
        Rowv=NA, Colv=NA, revC=TRUE, scale='none', col=colorRampPalette(c('ivory','red'))(100))



  
  
    # 조금 큰 교차표 불러와서 열지도 그리기
    AGE_CITY = as.matrix(read.csv('data/agecity.csv', fileEncoding='UTF-8', row.names=1))
    AGE_CITY

    heatmap(AGE_CITY, 
            Rowv=NA, Colv=NA, revC=TRUE, scale='none', col=colorRampPalette(c('ivory','red'))(100))



  
    
  # prop.table( ) 함수로 행 백분율, 열 백분율 계산하기
  prop.table(table_TWO)
  prop.table(table_TWO, 1)
  prop.table(table_TWO, 2)
    
    ## 아무것도 없으면 전체, 1은 행, 2는 열 백분율 계산
  
  



    # 인구의 행 백분율과 열 백분율
    prop.table(AGE_CITY, 1)
    prop.table(AGE_CITY, 2)

    heatmap(prop.table(AGE_CITY, 1), 
            Rowv=NA, Colv=NA, scale='none', col=colorRampPalette(c('ivory','red'))(100))

    heatmap(prop.table(AGE_CITY, 2), 
            Rowv=NA, Colv=NA, scale='none', col=colorRampPalette(c('ivory','red'))(100))





    
    
    
    
    
    
    
    
# Chapter 3 ---------------------------------------------------------------
# 두 수치형 변수의 관계

    
  # 데이터 불러오기
  TWO_CONT = read.csv('data/TWO_CONT.csv', fileEncoding='UTF-8')
  TWO_CONT
    

  
  # plot( ) 함수로 산점도 그리기 
  plot(TWO_CONT$HOUR, TWO_CONT$SCORE)
  plot(TWO_CONT)
    
    ## 순서대로 x축, y축 변수를 넣거나 데이터를 넣어 산점도 생성 
  
  
  plot(TWO_CONT, pch=16, col='dodgerblue')
  
    ## 옵션을 활용해서 점모양(pch)이나 색깔(col) 변환 가능
    
  
  
  # abline( )을 활용한 보조선 추가 
  mean(TWO_CONT$HOUR)
  mean(TWO_CONT$SCORE)

  abline(v=mean(TWO_CONT$HOUR), lty=2)
  abline(h=mean(TWO_CONT$SCORE),lty=2)
  
    ## 'v' 옵션으로 산점도에 수직선 추가 가능
    ## 'h' 옵션으로 산점도에 수평선 추가 가능 
    ## 선모양(lty)을 옵션으로 지정 가능
  
  
  
  
  # cov( ), cor( ) 함수를 활용한 공분산, 상관계수 계산
  cov(TWO_CONT$HOUR, TWO_CONT$SCORE)
  cor(TWO_CONT$HOUR, TWO_CONT$SCORE)




  
# Chapter 4 ---------------------------------------------------------------
# 한 범주형 변수와 한 수치형 변수의 관계

  # 데이터 불러오기
  TWO_VAR1 = read.csv('data/TWO_VAR1.csv', fileEncoding='UTF-8')
  TWO_VAR1

  
  
  
  # aggregate( ) 함수를 활용한 그룹별(조건부) 평균 계산 
  aggregate(SCORE ~ CITY, data=TWO_VAR1, mean)
    
    ## aggregate(수치형변수~범주형변수, data=데이터이름, 계산할함수)
  
  

  
  # 또다른 데이터 불러오기
  TWO_VAR2 = read.csv('data/TWO_VAR2.csv', fileEncoding='UTF-8')
  TWO_VAR2

  
  
  # aggregate( ) 함수를 활용한 그룹별(조건부) 평균 계산 
  aggregate(SCORE ~ METHOD, data=TWO_VAR2, mean)




  
  # 예제 데이터 불러오기
  CITY_COUNT = read.csv('data/city_count.csv', fileEncoding='UTF-8')
  CITY_COUNT
  
  
  nrow(CITY_COUNT)
  
  
  
  head(CITY_COUNT, n=5)
  tail(CITY_COUNT, n=5)
    ## head( ), tail( ) 함수로 첫, 마지막 n개 관측치 확인가능
  
  
  
    
  # 그룹별 평균 계산하기
  aggregate(COUNT ~ CITY, data=CITY_COUNT, mean)
  
  
  


  # boxplot( ) 함수로 그룹별 상자그림 그리기
  boxplot(COUNT ~ CITY, data=CITY_COUNT)





  
  # cut( ) 함수로 수치형 변수를 구간화 하기 
  breaks = c(0,75,85,100)

    ## 구간 경계값 지정
  
  
  SCORE_GRP = cut(TWO_VAR2$SCORE, breaks=breaks)
    
    ## cut(수치형변수, breaks=구간경계값)
    
  
  
  # 구간화된 수치형 변수로 교차표 만들고 열지도 그리기
  table(SCORE_GRP, TWO_VAR2$METHOD)

  heatmap(table(SCORE_GRP, TWO_VAR2$METHOD), 
          Rowv=NA, Colv=NA, scale='none', col=colorRampPalette(c('ivory','red'))(100))


    
  
# End of script