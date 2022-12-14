<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="path" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<link rel="shortcut icon" type="image/x-icon" href="${path}/pictures/Billycon.png">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet"
		integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
	<script src="${path}/js/jquery-3.6.0.min.js"></script>
	<link rel="stylesheet" href="${path}/css/header.css">
	
	<script>
	let sessionId = '${sessionid}';
	
	
		$(document).ready(function () {
			$("#logoutchk").click(function (ev) {
				if (!confirm("로그아웃 하시겠습니까?")) {
					ev.preventDefault();
				} else { alert("로그아웃 되었습니다.") }
			});
			$("#deletechk").click(function (ev) {
				if (!confirm("회원탈퇴 하시겠습니까?")) {
					ev.preventDefault();
				} else { alert("회원탈퇴가 완료되었습니다.") }
			});
			
			
			// 채팅 알림
	if (sessionId != "") {
			getUnread();
			getInfiniteUnread(); 
		} 
			
	function getUnread() {
			$.ajax({
					url: "/chatUnreadAlert/ajax",
					type: "POST",
					data: JSON.stringify({
					sessionId: sessionId}) ,
					dataType: "json",
					contentType: "application/json",
					success: function(result) {
						if (result >= 1) {
							showUnread(result);
						} else {
							showUnread('');
						}
					} //success
				});  //ajax
			} // getUnread
			
	function getInfiniteUnread() {
			setInterval(() => {
					getUnread();}, 5000);
			}
			
	function showUnread(result) {
			$('#messageAlert').html(result);
			}
			
		});  //onload
	
		</script>
		
	<title>BILLY</title>
</head>

<body>
	<!--Header-->
	<header class="header-box">
		
		<div class="header-menu-logo-box">
			
			<span class="header-menu-title">
				<a href="/allproduct/1/1" >
				<img src="${path}/pictures/Billy.png" alt="">
				BILLY</a>
			</span>
		</div>
		<!-- navSearch -->
		<div class="header-search-box">
			<div class="input-group header-search-box-inner">
			<form action="/allproduct/2/1" class="header-search-box-inner2">
				<div class="search-input">
				<img src="/pictures/search2.png" alt="" width=40px; height=40px;>
				<input class="header-search-input" type="text" id="search" name="search" placeholder=" BILLY 에서 찾아보세요!">
		
				<button class="btn btn-outline-secondary header-search-button close" type="submit"
					id="button-addon2"></button>
				</div>

				<div class="rank-container" id="oneRank">

					<div class="rank-box">
						<c:forEach items="${searchLankingList}" var="searchString" varStatus="vs" begin="0">
						<a class="rank-item" href="/allproduct/2/1?search=${searchString}" ><span class="rank-item-num" style=color:orange>${vs.count}</span><span id="rank-item2">${searchString}</span> </a><br> 
						</c:forEach>

						</div>
					</div>
					<div class="rank-container2" id="oneRank">
						<div class="rank-box2 close">
							<p>실시간 검색어</p>
							<c:forEach items="${searchLankingList}" var="searchString" varStatus="vs" begin="0">
							<a class="rank-item" href="/allproduct/2/1?search=${searchString}" ><span class="rank-item-num"  style=color:orange>${vs.count}</span><span id="rank-item2">${searchString}</span>  </a><br> 
							</c:forEach>
	
					</div>
					</div>
					
			</form>
			
		</div>
		</div>
		
		<div class="header-sign-box">
			<% if(session.getAttribute("sessionid")==null) { %>
				<div>
					<a  class="manager-button"  href="/admin_memlist">관리자</a>
				</div>
				<a class="loginBtn" href="/login">로그인</a>
				<% } else { %>
    			<div class="header-notice">
    			<a href="/chatList"><img src="/pictures/notice.png" width="23">채팅 &nbsp; <span id="messageAlert" style="color:orange; font-weight:700;"></span></a>
    			</div>
					<div>
					<a  class="manager-button"  href="/admin_memlist">관리자</a>
					</div>
					<a href="/mypage" class="mypage">마이페이지</a>
					<a id="logoutchk" href="/logout">로그아웃</a>
					<% } %>
		</div>
	</header>         

	<!--모바일 헤더-->
	<div class="mobile-search-input close">
		<input class="mobile-header-search-input" type="text" id="search" name="search" placeholder="검색">

		<button class="btn btn-outline-secondary header-search-button close" type="submit"
			id="button-addon2"><img src="${path}/pictures/search.png" alt=""></button>
	</div>
	<header class="mobile-header-box">

		<div class="mobile-menu-button">
			<div><img src="${path}/pictures/menu-icon.png"></div>
			<div>메뉴</div>
		</div>
		<div class="mobile-search-button">
			<div><img src="${path}/pictures/search.png" alt=""></div>
			<div>검색</div>
		</div>
		<div>
			<div><img src="${path}/pictures/logo.png" alt=""></div>
			<div>홈</div>
		</div>
		<div>
			<div><img src="${path}/pictures/mobile-zzim.png" alt=""></div>
			<div>찜</div>
		</div>
		<div>
			<div><img src="${path}/pictures/on.png" alt=""></div>
			<div><a class="loginBtn" href="/login">로그인</a></div>
		</div>
	</header>         
	                                                                                                                                  
	<!--Navbar-->
	<nav class="nav-box">
		
		<div class="up">
			<img src="${path}/pictures/up.png" alt="">
		</div>
		<% if(session.getAttribute("sessionid")==null) { %>
			<div class="basic-menu-box">
				<div class="nav-menu-box">
					<span class="menu-icon"><a href="/allproduct/1/1"><img
								src="${path}/pictures/products.png" alt=""></a></span>
					<div class="menu-title close"><a href="/allproduct/1/1">전체 물품</a></div> 
				</div> 
				<div class="nav-menu-box">
					<span class="menu-icon"><a href="/login"><img                                                                                                                                                                                                                                                                                                                                                                                             
								src="${path}/pictures/neighbour.png" alt=""></a></span>
					<div class="menu-title close"><a href="/login">동네 물품</a></div>
				</div>
				<div class="nav-menu-box">

					<span class="menu-icon"><a href="/boardList"><img
								src="${path}/pictures/community.png" alt=""></a></span>
					<span class="menu-title close"><a href="/boardList">커뮤니티</a></span>
				</div>
				<div class="nav-menu-box">
					<span class="menu-icon"><a href="/login"><img src="${path}/pictures/chatting.png"
								alt=""></a></span>
					<span class="menu-title close"><a href="/login">채팅리스트</a></span>
				</div>
				<div class="nav-menu-box">
					<span class="menu-icon"><a href="/login"><img src="${path}/pictures/mypage2.png"
								alt=""></a></span>
					<span class="menu-title close"><a href="/login">마이페이지</a></span>
				</div>
				<div class="nav-menu-box">
					<span class="menu-icon"><a href="/reportregister"><img src="${path}/pictures/center.png"
								alt=""></a></span>
					<span class="menu-title close"><a href="/reportregister">고객센터</a></span>
				</div>
			</div>
			<% } else { %>
				<div class="basic-menu-box">
					<div class="nav-menu-box">
						<span class="menu-icon"><a href="/allproduct/1/1"><img
									src="${path}/pictures/products.png" alt=""></a></span>
						<div class="menu-title close"><a href="/allproduct/1/1">전체 물품</a></div>
					</div>
					<div class="nav-menu-box">
						<span class="menu-icon"><a href="/allproduct/3/1"><img
									src="${path}/pictures/neighbour.png" alt=""></a></span>
						<div class="menu-title close"><a href="/allproduct/3/1">동네 물품</a></div>
					</div>
					<div class="nav-menu-box">
						<span class="menu-icon"><a href="/boardList"><img
									src="${path}/pictures/community.png" alt=""></a></span>
						<span class="menu-title close"><a href="/boardList">커뮤니티</a></span>
					</div>
					<div class="nav-menu-box">
						<span class="menu-icon"><a href="/chatList"><img src="${path}/pictures/chatting.png"
									alt=""></a></span>
						<span class="menu-title close"><a href="/chatList">채팅리스트</a></span>
						
						
						
						
					</div>
					<div class="nav-menu-box">
						<span class="menu-icon"><a href="/mypage"><img src="${path}/pictures/mypage2.png"
									alt=""></a></span>
						<span class="menu-title close"><a href="/mypage">마이페이지</a></span>
					</div>
					<div class="nav-menu-box">
						<span class="menu-icon"><a href="/reportregister"><img src="${path}/pictures/center.png"
									alt=""></a></span>
						<span class="menu-title close"><a href="/reportregister">고객센터</a></span>
					</div>
				</div>
				<% } %>
	</nav>

	<script>
		// 메뉴바 생성
		let navmenu = document.querySelector('.nav-box');
		let menuTitle = document.querySelectorAll('.menu-title');

		navmenu.addEventListener('mouseover', function () {
			for (let i = 0; i < menuTitle.length; i++) {
				menuTitle[i].classList.add('open');
			}
		})
		
		navmenu.addEventListener('mouseout', function () {
			for (let j = 0; j < menuTitle.length; j++) {
				menuTitle[j].classList.remove('open');
			}
		})
	</script>

	<script>
	// 스크롤 up 
		document.querySelector('.up').addEventListener('click', function(){
			window.scrollTo(0,0);
		})

		// 관리자 id 
		if(sessionId != "admin1234"){
			document.querySelector('.manager-button').parentElement.remove();
		}


	// 실시간 검색어 
		let rankBox = document.querySelector('.rank-box');
		let rankBox2 = document.querySelector('.rank-box2');
		let rankContainer = document.querySelector('.rank-container');
		let rankContainer2 = document.querySelector('.rank-container2');

	let setTime=setTimeout(function(){
			for(let i = 1.5; i<15; i = i + 1.5){
		setTimeout(function(){
			rankBox.style.transform='translateY(-'+i+'rem)'
		}, 1000*i)
		}
		}, 500)


	let setInter = setInterval(function(){
			setTimeout(function(){
			for(let i = 0; i<15; i = i + 1.5){
		setTimeout(function(){
			rankBox.style.transform='translateY(-'+i+'rem';
		}, 1000*i)
		}
		}, 500)
		}, 1000*15);

		
		rankContainer2.addEventListener('mouseover', function(){
			rankBox2.classList.remove('close');
		})
		rankContainer2.addEventListener('mouseout', function(){
			rankBox2.classList.add('close');
		})

		// 모바일 크기 
	let mobileMenu = document.querySelector('.mobile-menu-button');
	let mobileSearch = document.querySelector('.mobile-search-button');
	let navBox = document.querySelector('.nav-box');
	let mobileSearchInput = document.querySelector('.mobile-search-input');

	mobileMenu.addEventListener('click', function(){
		mobileSearchInput.classList.remove('open');
		mobileSearchInput.classList.add('close');
		navBox.classList.toggle('open');
	})

	mobileSearch.addEventListener('click', function(){
		navBox.classList.remove('open');
		navBox.classList.add('close');
		mobileSearchInput.classList.toggle('close')
	})

	</script>


	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-u1OknCvxWvY5kfmNBILK2hRnQC3Pr17a+RTT6rIHI7NnikvbZlHgTPOOmMi466C8"
		crossorigin="anonymous"></script>
</body>

</html>