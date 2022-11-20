<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<!DOCTYPE html>
	<html>
	
	<head>
		<meta charset="UTF-8">
		<title>회원탈퇴</title>
		<link rel="shortcut icon" type="image/x-icon" href="${path}/pictures/Billycon.png">
		<script src="js/jquery-3.6.0.min.js"></script>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet"
			integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
		<link rel="stylesheet" href="${path}/css/mypage.css">
		<script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>
		<script type="text/javascript" src="http://code.jquery.com/jquery-latest.js"></script>
		<script type="text/javascript">
			$(document).ready(function () {
			})
	
		</script>
	</head>
	
	<body>
	
					<img src="${path}/pictures/bg.png" style="position:absolute; margin-bottom:-10rem;">
					<div style="margin:auto;text-align:center; position:relative">
					<form class="mypage-delete-box" action="deletemember" method="post" id="deleteForm" name="deleteForm">
					<p class="mypage-delete-title" style="color : red">회원ID :  ${sessionid}</p>
						
	
						<div style="width : 100%">
							<p class="lead"> 회원탈퇴를 진행하시려면 <br>비밀번호를 입력해주세요.</p>
							<div class="form-group">
								<input class="delete-pw" type="password" id="pw" name="pw" placeholder=" 비밀번호" />
							</div>
							<div class="form-group">
								<input class="delete-pw" type="password" id="pw2" name="pw2" placeholder=" 비밀번호 확인" />
							</div>
							<div class="delete-button-box">
							<input type="button" id="delete" name="delete" value="회원탈퇴" onclick="deletebtn()" />
							<input type="button" onclick="back()" value="취소" />
							</div>
	
						</div>
					</form>
					</div>
	
				<script>
					function back() {
						history.back();
					}
	
					function deletebtn() {
						if ($("#pw").val() == "") {
							alert("비밀번호를 입력해주세요");
							$("#pw").focus();
							return false
						}
	
						if ($("#pw2").val() == "") {
							alert("비밀번호 확인을 입력해주세요");
							$("#pw2").focus();
							return false
						}
	
						if ($("#pw").val() != $("#pw2").val()) {
							alert("비밀번호가 일치하지 않습니다.");
							$("#pw").focus();
							return false;
						}
						$("#deleteForm").submit();
						alert("탈퇴되셨습니다.")
					}
				</script>
	
	
	</body>
	
	</html>