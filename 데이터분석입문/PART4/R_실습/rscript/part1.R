# --------------------------------------------#
# Fast campus X 임경덕
# 데이터 분석 입문 올인원 패키지 Online
    
# 중학교 수학으로 이해하는 통계와 데이터 분석 #
# ------------------------------------------- #


  # Windows에서는 Ctrl+Enter
  # mac에서는  Command+Enter 
  # -> 명령어가 한 줄씩 실행됩니다. 


  ## 주제 : 몇가지 기본적인 R 명령어






##1 숫자와 글자

  10
  9.9
  10+9.9
  10*9.9
  

  'fastcampus'
  "fastcampus"
  '패스트캠퍼스'
  
  fast

  

    ## 숫자는 그대로 입력하지만, 글자는 따옴표를 붙여서 입력


  
  
  
  
  
  
  
  
##2 숫자와 글자의 나열
  
  # c( ) 함수의 활용
  c(1, 3, 6, 10)
  c('서울', '부산', '대구', '광주')

    ## c( ) 함수 안에서 값 사이에 콤마(,)를 넣어 나열 가능
  
  
  
  
  # 콜론(:) 연산자를 활용한 정수 수열 
  1:10
  
  2011:2020

    ## 콜론 앞 숫자부터 뒷 숫자까지 1씩 커지는 정수 수열 생성
  
  
  
  # seq( ) 함수를 활용한 등차 수열
  seq(from=0, to=100, by=20)
  seq(0, 100, 20)
    
    ## from부터 to까지 by간격으로 등차 수열 생성
  
  
  
  

    
  
  
  
  
  
  
##3 '='을 활용한 값 저장
  
  x = 1:10
  y = c('데이터', '분석', '올인원')
  
  x
  y

    
    ## 무엇이든 '=' 앞에 저장할 이름을 지정해서 저장 가능
  
  
  
  
  

  
##4 factor( ) 함수로 범주형 변수 형식으로 변환
  
  # character 형식과 factor 형식
  city = c('서울', '부산', '서울', '서울', '부산')
  city
  
  class(city)
    ## class( ) : 형식을 확인하는 함수
  
  
  CITY = factor(city)
  CITY
  
  class(CITY)
    

  ###### levels: 범주형 변수의 수준을 의미 
  # levels( ) 함수를 활용한 수준 확인
  levels(CITY)
  
  
  
  
  

  
  
##5 read.csv( ) 함수로 csv 파일 불러오기
  
  read.csv('test.csv')
  
  test_csv = read.csv('test.csv')
  test_csv # 값을 가지고 있을 수 있다. 활용을 하기 위해 가지고 있어야 한다.
  
  
  
  # nrow( ), ncol( ) 함수로 관측치, 변수 개수 확인하기
  nrow(test_csv) # 불러온 데이터의 관측치 수
  ncol(test_csv) # 불러온 데이터의 변수 개수
  
  
  
  
  # names( ) 함수로 변수이름 확인하기
  names(test_csv)
  
  
  
  
  # '$'를 활용해서 변수 선택하기
  test_csv$age
  
  
  
  
  
# End of script