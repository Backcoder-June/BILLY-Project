<!-- <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>      -->
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>글쓰기</title>
	<link rel="shortcut icon" type="image/x-icon" href="${path}/pictures/Billycon.png">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet"
		integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
	<link rel="stylesheet" href="${path}/css/header.css">
	<link rel="stylesheet" href="${path}/css/list.css">
	<script src="${path}/js/jquery-3.6.0.min.js"></script>

	<script>


	</script>

</head>

<body>

	<div class="main-container">
		<!-- header-section -->
		<jsp:include page="/WEB-INF/views/header.jsp">
			<jsp:param value="false" name="mypage" />
		</jsp:include>
		<a href="/boardlist">리스트보기</a>
		<!-- content-section -->
		<div class="content-container">
		
			<div class="list-title" style="margin-left:1rem; margin-top: -3rem; margin-bottom: 1rem; border:none;width:70%;">커뮤니티</div>
		
		
			<!-- 본문 -->
			<div class="list-container">

				<form class="write-form" action="boardwrite" method="post" enctype="multipart/form-data">
					<input class="write-form-title mb-2" type=text name="title" placeholder="제목을 입력하세요" required>
					
					<textarea class="write-form-textarea"  rows=14 name="contents" placeholder="본문"></textarea>
					<input class="write-form-region mt-2 mb-2" type=text name="region" placeholder="동네" value="${region }" readonly>
					<input type=text name="writer" placeholder="Writer" value="${sessionid }" readonly style="display:none;">
					<label class="list-write-file-button" for="file1">파일선택</label>
					<input id="file1" type="file" name="file1" class="close">
					<p>사진은 *.png, *.jpeg만 가능합니다</p>
					<br>
					<input id="register" class="write-form-button" type=submit value="작성완료">
				</form>
			</div>
		</div>
	</div>

	<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"
		integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3"
		crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.min.js"
		integrity="sha384-7VPbUDkoPSGFnVtYi0QogXtr74QeVeeIs99Qfg5YCF+TidwNdjvaKZX19NZ/e6oz"
		crossorigin="anonymous"></script>
</body>

</html>