<%@page import="connectus.board.BoardDTO" %>
    <%@page import="java.util.List" %>
        <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
            <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
    <link rel="stylesheet" href="${path}/css/header.css">
    <link rel="stylesheet" href="${path}/css/list.css">
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>
    
    <script src="${path}/js/jquery-3.6.0.min.js"></script>
    <title>BILLY</title>
    <link rel="shortcut icon" type="image/x-icon" href="${path}/pictures/Billycon.png">
    <script>
  

        //검색 조건 유지 
        $(document).ready(function () {
        	let boardsearch = '${boardsearch}';
        	let searchOption = '${searchOption}';
			let option = '${option}';
         	let sessionId = '${sessionScope.sessionid}'; 	

        	
        if(option=='search'){	
        	if(searchOption == '전체'){
        		$("#searchByAll").attr("selected", "selected");
        	}else if(searchOption == 'title'){
        		$("#searchByTitle").attr("selected", "selected");
        	}else if(searchOption == 'writer'){
        		$("#searchByWriter").attr("selected", "selected");
        	}
        	
        	$("#boardsearch").val(boardsearch);
        }	

        
            
         	$("#community").on('click', function (e) { 
                if (sessionId == "") {
                	e.preventDefault();
                    alert("로그인이 필요합니다.");
       				 }
            }); // community on click
                 

            $("#myRegionBoard").on('click', function (e) {
            	  if (sessionId == "") {
                  	e.preventDefault();
                      alert("로그인이 필요합니다.");
         		    }
            }); // search on click                  
            
        }); //onload 
    </script>

</head>

<body>
    <div class="main-container">
        <!-- header-section -->
        <jsp:include page="/WEB-INF/views/header.jsp">
            <jsp:param value="false" name="mypage" />
        </jsp:include>
        <!-- content-section -->
        <div class="content-container">
            <!-- 본문 -->
            <div class="list-container">
                <p class="mb-5 list-title"><a class="list-title" href="/boardList">커뮤니티</a></p>
                   <!-- 검색 -->
                <form action="boardSearch" class="list-search-form">
                    <select class="list-search-form-select" name="searchOption" id="searchOption">
                        <option id = "searchByAll">전체</option>
                        <option id = "searchByTitle">제목</option>
                        <option id = "searchByWriter">작성자</option>
                    </select>
                    <input class="list-search-form-input" style="width:300px; " type="text" name="boardsearch" id="boardsearch">
                    <input class="list-search-form-button" type="submit" value="검색">
        		<a class="list-search-form-write-button" id="community" href="boardwrite">글쓰기</a>
                </form>
                
                    <div class="list-clean-box">
                        <a href="boardList">전체</a>
                        <a href="myRegionboardList" id="myRegionBoard">내 동네</a>
                    </div>
                    <div class="list-table mt-1 mb-3">
                <table id="tableboard" style="width : 100%">
                    <tr class="list-table-title">
                  
                        <td  style="width : 10%" >번호</td>
                        <td style="width : 15%" ></td>
                        <td >제목</td>
                        <td style="width : 10%">동네</td>
                        <td style="width : 10%">작성자</td>
                        <td style="width : 10%">작성시간</td>
                
                    </tr>
                    
                    
                    <c:forEach items="${boardlst }" var="board">

                        <tr class="list-list">

                            <td>${board.seq }</td>
                            <c:if test="${empty board.img }">
                            <td><img width=100 height=100
                                src="/pictures/noimg.png"></td>
							</c:if>
                            <c:if test="${!empty board.img }">
                            <td><img width=100 height=100
                                src="/upload/${board.img }"></td>
							</c:if>
                            <td><a href="boarddetail?seq=${board.seq }">${board.title }</a>
                            </td>
                            <td>${board.region }</td>
                            <td>${board.writer }</td>
                            <fmt:parseDate value="${board.writingtime}" var="now" pattern="yyyy-MM-dd" />
                            <fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="currentForm" />
                            <td>${currentForm }</td>
             
             				
                        </tr>
                    </c:forEach>
                </table>
                 </div>
                 
              
        		
        		
                <div class="mt-2 pagingNum">
            <span id="pagingPrevious" style="cursor:pointer">◁</span>
            <% int totalPage = (Integer)request.getAttribute("totalPage");
            if(request.getAttribute("option").equals("normal")){
				for(int i = 1; i<=totalPage; i++){ %>
			 <a href="boardList?page=<%=i%>" id="pagingNum<%=i%>" style="display:none;" ><%=i%></a> 
			<%}
			}else if(request.getAttribute("option").equals("search")){
				for(int i = 1; i<=totalPage; i++){ %>
				<a id="pagingNum<%=i%>" href="boardSearch?page=<%=i%>&searchOption=<%=request.getAttribute("searchOption")%>&boardsearch=<%=request.getAttribute("boardsearch")%>" ><%=i%></a>
			<%} 
			}%>
			<span id="pagingNext" style="cursor:pointer">▷</span>
                </div>
            </div>
        </div>
    </div>

<script>
// 페이징 Next, Previous 처리 
var pagingNum = ${page};
let totalPage = ${totalPage};
let pagingSkip = 5;

function paging(){
	for(var i = pagingNum; i< pagingNum + pagingSkip; i++ ){
	$("#pagingNum" + i).attr("style", "display:inline");
	}
	pagingSkipButtonRemover();
	$("#pagingNum" + pagingNum).attr("style", "background-color: orange;");
}

function pagingSkipButtonRemover(){
	if(pagingNum <= 1){
		$("#pagingPrevious").attr("style", "display:none");
	}
	if(pagingNum > 1){
		$("#pagingPrevious").attr("style", "display:inline; cursor:pointer;");
	}
	
	if(pagingNum + pagingSkip > totalPage){
		$("#pagingNext").attr("style", "display:none");
	}
	if(pagingNum + pagingSkip <= totalPage){
		$("#pagingNext").attr("style", "display:inline; cursor:pointer;");
	}
}


$("#pagingNext").on("click", function(){
	for(var i = pagingNum; i< pagingNum + pagingSkip; i++ ){
		$("#pagingNum" + i).attr("style", "display:none");
		}
	pagingNum = pagingNum + pagingSkip; 
	paging();
	pagingSkipButtonRemover();

});

$("#pagingPrevious").on("click", function(){
	for(var i = pagingNum; i< pagingNum + pagingSkip; i++ ){
		$("#pagingNum" + i).attr("style", "display:none");
		}
	pagingNum = pagingNum - pagingSkip; 
	paging();
	$("#pagingNum" + pagingNum).attr("style", "background-color: white;");
	pagingSkipButtonRemover();
});

// 페이징 최초 실행 
paging();







</script>   
                <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"
                    integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3"
                    crossorigin="anonymous"></script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.min.js"
                    integrity="sha384-7VPbUDkoPSGFnVtYi0QogXtr74QeVeeIs99Qfg5YCF+TidwNdjvaKZX19NZ/e6oz"
                    crossorigin="anonymous"></script>
</body>

</html>