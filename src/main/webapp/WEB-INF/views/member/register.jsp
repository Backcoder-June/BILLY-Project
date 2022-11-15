<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>JOIN</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT"
	crossorigin="anonymous">
<link rel="stylesheet" href="${path}/css/header.css">
<link rel="stylesheet" href="${path}/css/login.css">
<link rel="stylesheet" href="${path}/css/table.css">
<script src="${path}/js/jquery-3.6.0.min.js"></script>
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=74ad1a98ca11a868e151320c03495af6&libraries=services"></script>
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=1aaf3b3947461833899b50f6dead3eee"></script>
</head>
<body>

	<div class="main-container">
		<jsp:include page="/WEB-INF/views/header.jsp"></jsp:include>
		<div class="login-container2">
			<div class="signup-box-title">
				<span>품앗이 장터 회원가입</span>
			</div>

			<form name="form" action="register" method="post"
				class="signup-container2">
				<table class="type09">
					<tr>
						<th>아이디</th>
						<td><input type="text" name="userid" id="userid"
							placeholder="아이디를 입력해 주세요." required>
							<button class="signup-check-button" type="button" id="id-btn"
								value="중복확인" onclick="idcheck()">중복확인</button> <span
							id="id_check"></span></td>
					</tr>
					<tr>
						<th>비밀번호</th>
						<td><input type=password name="pw" id="pw"
							placeholder="비밀번호를 입력해 주세요." required oninput="pwcheck()"> <span
							id="pw_check"></span></td>
					</tr>
					<tr>
						<th>비밀번호 확인</th>
						<td><input type=password name="pw2" id="pw2"
							placeholder="비밀번호를 한번 더 입력해 주세요." required oninput="pw2check()">
							<span id="pw2_check"></span></td>
					</tr>

					<tr>
						<th>이름</th>
						<td><input type=text name="name" id="name" placeholder="이름을 입력해 주세요."
							required oninput="namecheck()"> <span id="name_check"></span>
						</td>
					</tr>
					<tr>
						<th>이메일</th>
						<td><input type=text name="email" id="email" placeholder="이메일을 입력해 주세요."
							required oninput="emailcheck()"> <span id="email_check"></span>

						</td>
					</tr>
					<tr>
						<th>연락처</th>
						<td><input type=text name="phone" id="phone"
							placeholder="전화번호를 (-)제외하고 입력해 주세요." required oninput="phonecheck()">
							<span id="phone_check"></span></td>
					</tr>

					<tr>
						<th rowspan="4">주소</th>
						<td><input class="adrinput" type="text" id="sample6_postcode"
							placeholder="우편번호" required readonly>
							<button class="signup-check-button" type="button"
								onclick="sample6_execDaumPostcode()" value="주소찾기">주소찾기</button>

						</td>
					</tr>
					<tr>
						<td><input class="adrinput" type="text" id="sample6_address"
							placeholder="주소" required readonly></td>
					</tr>
					<tr>
						<td><input class="adrinput" type="text"
							id="sample6_detailAddress" placeholder="상세주소"></td>
					</tr>
					<tr>
						<td><input class="adrinput" type="text"
							id="sample6_extraAddress" required name="region" placeholder="동네" readonly>

						</td>
					</tr>

					<tr>
						<td colspan="2">
							<button type=submit class="signup-button" id="signup_btn"
								name="signup_btn" onclick="check()" disabled>회원가입</button>
						</td>
					</tr>
				</table>
				<input type="hidden" id="address" name="address"> <input
					type="hidden" id="coords" name="coords">
			</form>

		</div>
	</div>

	<div class="register-map" id="map" style="width: 450px; height: 275px; right: -55%; top: -43%; border: solid 3px silver; display: none;"></div>

	<script>
		let userid = $('#userid');
		let pw = $('#pw');
		let pw2 = $('#pw2');
		let phone = $('#phone');
		let email = $('#email');
		let name = $('#name');
		let btn = $('#signup_btn');


		let id_check = false;
		let pw_check = false;
		let pw2_check = false;
		let phone_check = false;
		let email_check = false;
		let name_check = false;

		let address = "";

	
		function idcheck() {
			var userid = $('#userid').val();
			
			var regId = /^[A-Za-z0-9]{6,20}$/;
			if (userid == '') {
				$('#id_check').text("아이디를 입력해주세요");
				$('#id_check').css("color", "red");
				id_check = false;
				btn.attr('disabled', true);
			} else {
				$.ajax({
					url: "idCheck",
					type: 'post',
					data: { userid: userid },
					success: function (data) {
						if (data == 'true') {
							$('#id_check').text("이미 가입된 아이디입니다");
							$('#id_check').css("color", "red");
							id_check = false;
							btn.attr('disabled', true);
						} else {
							if (!regId.test(userid)) {
								$('#id_check').text("영문과 숫자 6~20자 이내로 입력해 주세요.");
								$('#id_check').css("color", "red");
								id_check = false;
								btn.attr('disabled', true);
							} else {
								$('#id_check').text("✅사용 가능한 아이디입니다");
								$('#id_check').css("color", "rgb(116,232,0)");
								id_check = true;
							/* 	if (id_check == true && pw_check == true && pw2_check == true && phone_check == true && email_check == true && name_check == true) {
									btn.attr('disabled', false); 
								}*/
							}
						}
					}
				}); //ajax
			}
		} // idCheck

		function pwcheck() {
			var pw = $('#pw').val();

			if (pw == '') {
				$('#pw_check').text("패스워드를 입력해 주세요.");
				$('#pw_check').css("color", "red");
				pw_check = false;
				btn.attr('disabled', true);
			} else if (pw.length < 8 || pw.length > 17) {
				$('#pw_check').text("패스워드 길이는 8자이상 16자이하 입니다");
				$('#pw_check').css("color", "red");
				pw_check = false;
				btn.attr('disabled', true);
			} else if (pw.search(/\s/) != -1) {
				$('#pw_check').text("패스워드는 공백을 포함할 수 없습니다");
				$('#pw_check').css("color", "red");
				pw_check = false;
				btn.attr('disabled', true);
			} else {
				$('#pw_check').text("✅패스워드 사용가능");
				$('#pw_check').css("color", "rgb(116,232,0)");
				pw_check = true;
				/* if (id_check == true && pw_check == true && pw2_check == true && phone_check == true && email_check == true && name_check == true) {
					btn.attr('disabled', false);
				} */
			}
		}

		function pw2check() {
			if($('#pw').val() != ''){
			pwcheck();
			}
			var pw2 = $('#pw2').val();
			var pw = $('#pw').val();
			if (pw2 == '') {
				$('#pw2_check').text("패스워드확인을 입력해 주세요.");
				$('#pw2_check').css("color", "red");
				pw2_check = false;
				btn.attr('disabled', true);
			} else if (pw2 == pw) {
				$('#pw2_check').text("✅패스워드가 일치합니다.");
				$('#pw2_check').css("color", "rgb(116,232,0)");
				
				pw2_check = true;
				/* if (id_check == true && pw_check == true && pw2_check == true && phone_check == true && email_check == true && name_check == true) {
					btn.attr('disabled', false);
				} */
			} else {
				$('#pw2_check').text("패스워드가 일치하지 않습니다.");
				$('#pw2_check').css("color", "red");
				pw2_check = false;
				btn.attr('disabled', true);

			}
		}

		function phonecheck() {
			var phone = $('#phone').val();
			var regTel = /^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})[0-9]{3,4}[0-9]{4}$/;

			if (phone == '') {
				$('#phone_check').text("전화번호를 입력해 주세요.");
				$('#phone_check').css("color", "red");
				phone_check = false;
				btn.attr('disabled', true);
			} else if (!regTel.test(phone)) {
				$('#phone_check').text("올바른 전화번호를 입력해 주세요.. ex)01012345678");
				$('#phone_check').css("color", "red");
				phone_check = false;
				btn.attr('disabled', true);
			} else {
				console.log("asd");
				$.ajax({
					url: "phoneCheck",
					type: 'post',
					data: { phone: phone },
					success: function (data) {
						if (data == 'true') {
							$('#phone_check').text("이미 사용중인 번호 입니다");
							$('#phone_check').css("color", "red");
							phone_check = false;
							btn.attr('disabled', true);
						} else {
							$('#phone_check').text("✅사용가능한 번호 입니다");
							$('#phone_check').css("color", "rgb(116,232,0)");
							phone_check = true;
							if (id_check == true && pw_check == true && pw2_check == true && phone_check == true && email_check == true && name_check == true) {
								btn.attr('disabled', false);
							}
						}
					}
				});
			}
		}

		function emailcheck() {
			var email = $('#email').val();
//			var regEmail= /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z]).@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z]).[a-zA-Z]{2,3}$/;
			var regEmail= /^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/;
			
			if (email == '') {
				$('#email_check').text("이메일을 입력해 주세요.");
				$('#email_check').css("color", "red");
				email_check = false;
				btn.attr('disabled', true);
			}else {
				if (regEmail.test(email)) {
				$('#email_check').text("✅사용가능한 이메일입니다.");
				$('#email_check').css("color", "rgb(116,232,0)");
				email_check = true;
				/* if (id_check == true && pw_check == true && pw2_check == true && phone_check == true && email_check == true && name_check == true) {
					btn.attr('disabled', false);
				} */
				}else{
					$('#email_check').text("정확한 이메일 주소를 입력해 주세요.");
					$('#email_check').css("color", "red");
					
				}
			}

		}


		function namecheck() {
			var name = $('#name').val();
			if (name == '') {
				$('#name_check').text("이름을 입력해 주세요.");
				$('#name_check').css("color", "red");
				name_check = false;
				btn.attr('disabled', true);
			} else {
				name_check = true;
				$('#name_check').text("✅");
				
				/* if (id_check == true && pw_check == true && pw2_check == true && phone_check == true && email_check == true && name_check == true) {
					btn.attr('disabled', false);
				} */
			}

		}



		function sample6_execDaumPostcode() {
			new daum.Postcode({
				oncomplete: function (data) {
					// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
					console.log(data)
					// 각 주소의 노출 규칙에 따라 주소를 조합한다.
					// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
					var addr = ''; // 주소 변수
					var detailAddr = ''; //상세주소
					var extraAddr = ''; // 참고항목 변수
					var add = addr + detailAddr;

					//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
						addr = data.roadAddress;

					// 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
						// 법정동명이 있을 경우 추가한다. (법정리는 제외)
						// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
						if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
							extraAddr += data.bname;
						}
						// 건물명이 있고, 공동주택일 경우 추가한다.
						if (data.buildingName !== '' && data.apartment === 'Y') {
							extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
						}
						// 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
						if (extraAddr !== '') {
							extraAddr = extraAddr;
						}
						// 조합된 참고항목을 해당 필드에 넣는다.
						document.getElementById("sample6_extraAddress").value = extraAddr;

						// 동 이름이 아닐 때, region input에 전체 주소를 넣은 후 후처리 
						if (extraAddr == ''){
							let numIndex = '';
							let spaceIndex = '';
							var pattern = /\s/;
							 for(var i = 0; i < addr.length; i++){
								if(!isNaN(addr.charAt(i)) && !addr.charAt(i).match(pattern)){
									numIndex = i;
									break;
								}
							}
							 
							 for(var j = 0; j < numIndex-1; j++){
								 if(!isNaN(addr.charAt(j))){
									 spaceIndex = j; 
								 }
							 }	
							
							
							document.getElementById("sample6_extraAddress").value = addr.substring(spaceIndex+1,numIndex-1);
							
						}
					

					// 우편번호와 주소 정보를 해당 필드에 넣는다.
					document.getElementById('sample6_postcode').value = data.zonecode;
					document.getElementById("sample6_address").value = addr;
					adress = addr;
					KakaoGeocoder();
					locationarea();
					// 커서를 상세주소 필드로 이동한다.

					document.getElementById("sample6_detailAddress").focus();
					document.getElementById("sample6_detailAddress").value = detailAddr;
					$("#address").val(addr);
					
				}
			}).open();


		}

		
		function check(){
			if($("#address").val()==''){
				btn.attr('disabled', true);
				alert("주소를 입력해 주세요.")
			}else{
			alert("품앗이장터 회원가입이 완료되었습니다.")
			}
		}



		/*
		function check(){
			var fm = document.form;
			
			if(fm.id.value == ""){
				alert("아이디를 입력해 주세요.");
				document.form.id.focus();
				return;
			}
			if(fm.pw.value == ""){
				alert("비밀번호를 입력해 주세요.");
				document.form.pw.focus();
				return;
			}	
			if(fm.pw2.value == ""){
				alert("비밀번호를 입력해 주세요.");
				document.form.pw.focus();
				return;
			}
			if(fm.name.value == ""){
				alert("이름을 입력해 주세요.");
				document.form.name.focus();
				return;
			}
			if(fm.phone.value == ""){
				alert("전화번호를 입력해 주세요. ('-'는 제외)");
				document.form.phone.focus();
				return;
			}
			if(fm.email.value == ""){
				alert("이메일을 입력해 주세요.");
				document.form.email.focus();
				return;
			}
			if(fm.address.value == ""){
				alert("주소를 입력해 주세요.");
				document.form.address.focus();
				return;
			}
			alert("성공적으로 가입되셨습니다.")
		}
		*/
		

		function KakaoGeocoder() {
			
			// 주소-좌표 변환 객체를 생성합니다
			var geocoder = new kakao.maps.services.Geocoder();

			// 주소로 좌표를 검색합니다
			geocoder.addressSearch(adress, function (result, status) {

				// 정상적으로 검색이 완료됐으면 
				if (status === kakao.maps.services.Status.OK) {

					var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
					$("#coords").val(coords);
		/* console.log(coords); */			
					  
			var strCoords = coords.toString(); 
	        var registerX = strCoords.substring(1, strCoords.indexOf(','));
	        var registerY = strCoords.substring(strCoords.indexOf(',')+2, strCoords.length-1);
        	locationarea(registerX, registerY); 
					
				}
			}); // addressSearch     
		}
		
		
		
<%-- 		<%@include file="/WEB-INF/views/maps/keywordList.jsp"%> - --%>
		 function locationarea(registerX, registerY){
			
			var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
		    mapOption = { 
		        center: new kakao.maps.LatLng(Number(registerX), Number(registerY)), // 지도의 중심좌표
		        level: 3 // 지도의 확대 레벨
		    };

		var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
	
		// 마커가 표시될 위치입니다 
		var markerPosition  = new kakao.maps.LatLng(Number(registerX), Number(registerY)); 

		// 마커를 생성합니다
		var marker = new kakao.maps.Marker({
		    position: markerPosition
		});

		// 마커가 지도 위에 표시되도록 설정합니다
		marker.setMap(map);
		mapContainer.style.display = "block";
		

		// 아래 코드는 지도 위의 마커를 제거하는 코드입니다
		// marker.setMap(null);    
		} 
		 

	</script>

	<script
		src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"
		integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3"
		crossorigin="anonymous"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.min.js"
		integrity="sha384-7VPbUDkoPSGFnVtYi0QogXtr74QeVeeIs99Qfg5YCF+TidwNdjvaKZX19NZ/e6oz"
		crossorigin="anonymous"></script>
</body>

</html>