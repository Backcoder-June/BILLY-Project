<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>BILLY</title>
<link rel="shortcut icon" type="image/x-icon" href="${path}/pictures/Billycon.png">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet"
    integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
<link rel="stylesheet" href="${path}/css/header.css">
<link rel="stylesheet" href="${path}/css/product.css">
<script src="${path}/js/jquery-3.6.0.min.js"></script>

<script>
$(document).ready(function () {
    let sessionId = '${sessionScope.sessionid}';
    let productlength = '${productlength}';
    let scrollCount = 0;
    let searchType = '${searchType}';
    let orderType = '${orderType}';
    let search = '${search}';
    let searchLankingList = '${searchLankingList}';
    let region = '${region}';
    let distanceKm = '${distanceKm}';

    let regionOption = '${regionOption}';
    
    if(searchType == 4){
    var smartTitle = '${smartSearchDTO.smartTitle}';
    var smartRegion = '${smartSearchDTO.smartRegion}';
    var smartStartDate = '${smartSearchDTO.smartStartDate}';
    var smartEndDate = '${smartSearchDTO.smartEndDate}';
    var smartPriceMin = '${smartSearchDTO.smartPriceMin}';
    var smartPriceMax = '${smartSearchDTO.smartPriceMax}';
    }
        
        


    if (searchType == '4') {
        // 스마트 검색 가격 입력 없을 시, 빈값으로 유지
    if (smartPriceMin == 0) { smartPriceMin = ''; }
    if (smartPriceMax == 100000000) { smartPriceMax = ''; }
        // 스마트 검색 입력값 유지해서 표기 
        $("#smartTitle").val(smartTitle);
        $("#smartStartDate").val(smartStartDate);
        $("#smartEndDate").val(smartEndDate);
        $("#smartPriceMin").val(smartPriceMin);
        $("#smartPriceMax").val(smartPriceMax);


        // 지역 검색조건 유지
        if (regionOption == "1") {
            $("#allRegion").attr("selected", "selected");
        } else if (regionOption == "2") {
            $("#myRegion").attr("selected", "selected");
        } else if (regionOption == "3") {
            $("#nearRegion").attr("selected", "selected");
        } else if (regionOption == "4") {
            $("#farRegion").attr("selected", "selected");
        } else if (regionOption == "5") {
            $("#searchRegion").attr("selected", "selected");
            $("#zzimList").html("<input type='text' name='smartRegion' value='" + smartRegion + "'>");
        }
    }

    // nav바 검색어 유지
    if (search != "") {
        $("#search").val(search);
    }


    // 최신순, 가격순, 조회순 선택 시 css 적용
    if (orderType == 1) {
        $(".orderOne").attr("style", "font-weight:800; color:rgb(255,133,133)");
        $(".orderOne2").attr("style", "font-weight:700; color: black");
    }
    if (orderType == 2) {
        $(".orderTwo").attr("style", "font-weight:800; color:rgb(255,133,133)");
        $(".orderTwo2").attr("style", "font-weight:700; color: black");
    }
    if (orderType == 3) {
        $(".orderThree").attr("style", "font-weight:800; color:rgb(255,133,133)");
        $(".orderThree2").attr("style", "font-weight:700; color: black");
    }
    if (orderType == 4) {
        $(".orderFour").attr("style", "font-weight:800; color:rgb(255,133,133)");
        $(".orderFour2").attr("style", "font-weight:700; color: black");
    }



// 스크롤로 물건 가져오기 
$(window).scroll(function () {
var scrollHeight = $(window).scrollTop() + $(window).height();
var documentHeight = $(document).height();
if (scrollHeight == documentHeight) {   // || scrollY > (scrollCount+1) * 2400
    // 스크롤 수 => limit 시작 index로 가져옴 
    scrollCount++;

    let list = [];

    $.ajax({
        type: "POST",
        url: "/allproduct/ajax/" + searchType + "/" + orderType,
        dataType: "json",
        data: {
            'scrollCount': scrollCount,
            'search': search,
            'smartTitle': smartTitle,
            'smartRegion': smartRegion,
            'smartStartDate': smartStartDate,
            'smartEndDate': smartEndDate,
            'distanceKm': distanceKm,
            'smartPriceMin': smartPriceMin,
            'smartPriceMax': smartPriceMax
        },

        success: function (resp) {
            list = resp;

            // javascript each 반복문 돌려서 => forEach문과 같은기능을 하도록 만듬. 
            // list 는 scrollCount 를 이용해서 limit 으로 조회한 12개의 list 
            $.each(list, function (i, product) {
                //렌탈중 표시 	
                if (product.reservedNow == 1) {
                    var reservedNowImg = "렌탈중"
                }
                if (product.reservedNow == 0) {
                    var reservedNowImg = ""
                }
                // 찜 표시 
                if (product.zzim == 0) {
                    var zzim = "<img src='/pictures/zzim-off.png' width=30 height=30 style='cursor:pointer'>";

                }
                if (product.zzim == 1) {
                    var zzim = "<img src='/pictures/zzim-on.png' width=30 height=30 style='cursor:pointer'>";
                }

                // 가격 1000단위 format (regEx)
                let formatPrice = product.price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');

                // 날짜 몇일전으로 설정 
                let uploadDate = new Date(product.createdAt);
                let todayDateString = new Date().toISOString().substring(0,10);
                let todayDate = new Date(todayDateString);
                
                let dateDiff = Math.abs((todayDate.getTime() - uploadDate.getTime())/(1000 * 60 * 60 *24));
                let dateDiffShow = dateDiff + '일전';

                if (dateDiffShow == '0일전') {
                    dateDiffShow = '오늘';
                }

                // append 로 붙이기	
                $("#appendScroll").append(
                    '<div class="product-box-item" >'
                    + '<div id="product-item-img' + product.id + '" class="product-item-img">'
                    + '</div>'
                    + '<span class="reserved" style=color:red>' + reservedNowImg + '</span>'
                    + '<div class="product-item-title"> <a href="/product/' + product.id + '">' + product.title + '</a></div>'
                    + '<div class="product-item-date">' + dateDiffShow + '</div>'
                    + '<div class="product-item-location"><img src="${path}/pictures/location.png" alt="">' + product.boardRegion + '</div>'
                    + '<div class="product-item-price">1일가격 : ' + formatPrice + '원</div>'
                    + '<div class="product-item-owner" style="display:none">' + product.userId + '</div>'
                    + '<span class="product-item-zzim" id="zzimSpan' + product.id + '">' + zzim + '</span>'
                    + '</div>'
                ); //append 

                // img 가져오기 
                if (product.img1 != "") {
                    $("#product-item-img" + product.id).html('<a href="/product/' + product.id + '"><img alt="사진이 없어요" width=100% height=60% src="/upload/' + product.img1 + '"></a>');
                }

                // append 한 품목에도 찜 효과 적용     
                $("#zzimSpan" + product.id).on("click", function (e) {
                    if (sessionId == "") {
                        alert("로그인이 필요합니다.");
                        return false;
                    }

                    $.ajax({
                        type: "POST",
                        url: "/product/zzim",
                        dataType: "json",
                        data: { 'productseq': product.id, 'memberid': sessionId },

                        success: function (resp) {

                            if (resp.result == 0) {
                                $("#zzimSpan" + product.id).html("<img src='/pictures/zzim-on.png' width=30 height=30 style='cursor:pointer'>")
                                // 찜 작동 시, 해당물품 장바구니에 출력 
                                //   $("#zzimProducts").prepend("<a href='/product/" + resp.id + "'><span class=zzim-product-title id='spanId"+ resp.id +"'><img src='/upload/"+ resp.img1 +"' width=40 height=40 style='cursor:pointer'><span>" + resp.title+"</span></span></a>");
                                $("#zzimProducts").prepend("<div class=zzim-product2" + resp.id + "><a href=/product/" + resp.id + "><span class=zzim-product-title id='spanId" + resp.id + "'><img src='/upload/" + resp.img1 + "' width=40 height=40 style='cursor:pointer'><span>" + resp.title + "</span></span></a></div>");
                            }
                            else if (resp.result == 1) {
                                $("#zzimSpan" + product.id).html("<img src='/pictures/zzim-off.png' width=30 height=30 style='cursor:pointer'>")
                                // 찜 취소 시, 해당물품 장바구니에서 제거
                                //$("#spanId" + resp.id).remove();
                                $("#spanId" + resp.id).closest('div').remove();
                            }

                        } // success 
                    }); // inner ajax 
                }); // 찜 onclick

            }); //each 

        } // success 
    }); // outer ajax 
} //스크롤 if 
}); // scroll 



    // 스마트검색 지역선택 
    $("#regionSelect").on("change", function () {
        var oneSelect = document.getElementById("regionSelect");
        // option value 가져오기
        var Regionvalue = oneSelect.options[document.getElementById("regionSelect").selectedIndex].value;

        if (Regionvalue == '동네 검색') {
            $("#zzimList").html("<input id='regionSearch' type='text' name='smartRegion'>");
            $("#regionSearch").focus();
        } else if (Regionvalue == '모든 동네') {
            $("#zzimList").html("<input type='hidden' name='smartRegion' value=''>");
        } else if (Regionvalue == '내 동네') {
            if (sessionId == "") { alert("로그인이 필요합니다."); return false; }
            $("#zzimList").html("<input type='hidden' name='smartRegion' value='${region}'>");
        } else if (Regionvalue == '가까운 동네') {
            if (sessionId == "") { alert("로그인이 필요합니다."); return false; }
            $("#zzimList").html("<input type='hidden' name='distanceKm' value='5'>");
        } else if (Regionvalue == '먼 동네') {
            if (sessionId == "") { alert("로그인이 필요합니다."); return false; }
            $("#zzimList").html("<input type='hidden' name='distanceKm' value='15'>");
        }
    });

    // 스마트검색 날짜 제한 (아예 입력하지 않거나, 둘다 입력하거나만 가능)
    $("#smartStartDate").on("change", function () {
        $("#smartEndDate").attr("required", "required");
    });

    $("#smartEndDate").on("change", function () {
        $("#smartStartDate").attr("required", "required");
    });




    // 물품등록시 로그인 필요
    $("#register").on("click", function (e) {
        if (sessionId == "") {
            e.preventDefault();
            alert("로그인이 필요합니다.");
        }
    });


    // 찜 기능
    for (var i = 0; i < productlength; i++) {
        (function (i) {
            let eachProductId = $("#productid" + i).html();
            let intProductId = parseInt(eachProductId);

            $("#zzimSpan" + intProductId).on("click", function (e) {
                if (sessionId == "") {
                    alert("로그인이 필요합니다.");
                    return false;
                }

                $.ajax({
                    type: "POST",
                    url: "/product/zzim",
                    dataType: "json",
                    data: { 'productseq': intProductId, 'memberid': sessionId },

                    success: function (resp) {
                    	if (resp.img1 == '') {
                    		resp.img1 = 'noimg.png';
                    	}

                        if (resp.result == 0) {
                            $("#zzimSpan" + intProductId).html("<img src='/pictures/zzim-on.png' width=30 height=30 style='cursor:pointer'>")
                            // 찜 작동 시, 해당물품 장바구니에 출력 
                            $("#zzimProducts").prepend("<div class=zzim-product2" + resp.id + "><a href=/product/" + resp.id + "><span class=zzim-product-title id='spanId" + resp.id + "'><img src='/upload/" + resp.img1 + "' width=40 height=40 style='cursor:pointer'><span>" + resp.title + "</span></span></a></div>");
                        }
                        else if (resp.result == 1) {
                            $("#zzimSpan" + intProductId).html("<img src='/pictures/zzim-off.png' width=30 height=30 style='cursor:pointer'>")
                            // 찜 취소 시, 해당물품 장바구니에서 제거
                            $("#spanId" + resp.id).closest('div').remove();
                        }

                    } // success 
                }); // ajax 
            }); // 찜 onclick
        })(i); // for - ajax 용 function
    } // for 
}); // onload 
    </script>
</head>

<body>
    <div class="main-container">
        <!-- header-section -->
        <jsp:include page="/WEB-INF/views/header.jsp"></jsp:include>
        <!-- content-section -->
        <div class="background-bg">

            <div id="carouselExampleIndicators" class="carousel slide carousel-box" data-bs-ride="carousel">
                <div class="carousel-indicators">
                    <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="0"
                        class="active" aria-current="true" aria-label="Slide 1"></button>
                    <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="1"
                        aria-label="Slide 2"></button>
                    <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="2"
                        aria-label="Slide 3"></button>
                </div>
                <div class="carousel-inner carousel-box2">
                    <div class="carousel-item active" id="carousel-box3">
                        <img id="carousel-box4" src="${path}/pictures/bg1.png">
                    </div>
                    <div class="carousel-item" id="carousel-box3">
                        <img id="carousel-box4" src="${path}/pictures/bg2f1.png">
                    </div>
                   <%--  <div class="carousel-item " id="carousel-box3">
                        <img id="carousel-box4" src="${path}/pictures/bg3.png">
                    </div> --%>
                </div>
                <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleIndicators"
                    data-bs-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Previous</span>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleIndicators"
                    data-bs-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Next</span>
                </button>
            </div>

        </div>
        <div class="content-container">

            <div class="allproduct-container">

                <!-- 스마트 검색 -->
				<form class="smart-search-box mb-4" action="/smartSearch"
					method="post">
					<table class="smartSearchBox-Table">
						<tr>
							<td>키워드</td>
						</tr>
						<tr>
							<th><input id="smartTitle" type="text" name="smartTitle"
								placeholder="검색"></th>
						</tr>
						<tr>
							<td>가격</td>
						</tr>
						<tr>
							<th><input id="smartPriceMin" type="number"
								name="smartPriceMin" placeholder="최소가격(₩)" step="500"></th>
						</tr>
						<tr>
							<th><input type="number" name="smartPriceMax"
								id="smartPriceMax" placeholder="최대가격(₩)" step="500"></th>
						</tr>
						<tr>
							<td>날짜</td>
						</tr>
						<tr>
							<th><span style="font-weight: 500;">이날부터 </span> <input
								id="smartStartDate" type="date" name="smartStartDate"
								style="width: 275px;"></th>
						</tr>
						<tr>
							<th><span style="font-weight: 500;">이날까지 </span> <input
								id="smartEndDate" type="date" name="smartEndDate"
								style="width: 275px;"></th>
						</tr>
						<tr>
							<td>동네</td>
						</tr>
						<tr>
							<th><select id="regionSelect">
									<option id="allRegion">모든 동네</option>
									<option id="myRegion">내 동네</option>
									<option id="nearRegion">가까운 동네</option>
									<option id="farRegion">먼 동네</option>
									<option id="searchRegion">동네 검색</option>
							</select> <span id="zzimList"><input class="smart-keyword"
									type="hidden" id="smartRegion" name="smartRegion" value=""></span>
							</th>
						</tr>
						<tr>
							<th><input class="smart-search-button" type="submit"
								value="검색"></th>
						</tr>
					</table>
				</form>

				<!-- 찜상품 띄우기 -->
                <div class="zzimproduct-list-container">

                    <div class="zzimproduct-list-box">
                        <p class="zzim-title" id="zzimListLink">BILLY 리스트<a class="zzim-link"
                                href="/mypage?zzimListLink=1">🧡</a></p>
                        <div id="zzimProducts" class="zzim-product">
                            <c:forEach items="${zzimProducts}" var="zzimProduct" varStatus="status">
                                <div class="zzim-product2">
                                    <a href="/product/${zzimProduct.id}">
                                        <span class="zzim-product-title" id="spanId${zzimProduct.id}">
                                            <img src='/upload/${zzimProduct.img1}' height=40 width=40>
                                            <span>${zzimProduct.title }</span>
                                        </span>
                                    </a>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <div class="allproduct-search-box">
                    <a class="product-register" id="register" href="/registerProduct">물품 등록</a>

                </div>

                <!-- allproduct-product-box -->
                <div class="allproduct-product-box" id="appendScroll">
                    <div class="allproduct-item-array">
                        <c:if test="${searchType==1 }">
                            <a class="product-array-button" href="/allproduct/1/1"><span class="orderOne">✔ </span><span
                                    class="orderOne2">최신순</span> </a>
                            <a class="product-array-button" href="/allproduct/1/2"><span class="orderTwo">✔ </span><span
                                    class="orderTwo2">낮은 가격순</span></a>
                            <a class="product-array-button" href="/allproduct/1/3"><span class="orderThree">✔
                                </span><span class="orderThree2">높은 가격순</span> </a>
                            <a class="product-array-button" href="/allproduct/1/4"><span class="orderFour">✔
                                </span><span class="orderFour2">인기순</span> </a>
                        </c:if>
                        <c:if test="${searchType==2 }">
                            <a class="product-array-button" href="/allproduct/2/1?search=${search}"><span
                                    class="orderOne">✔ 최신순</span></a>
                            <a class="product-array-button" href="/allproduct/2/2?search=${search}"><span
                                    class="orderTwo">✔ 낮은 가격순</span></a>
                            <a class="product-array-button" href="/allproduct/2/3?search=${search}"><span
                                    class="orderThree">✔ 높은 가격순</span></a>
                            <a class="product-array-button" href="/allproduct/2/4?search=${search}"><span
                                    class="orderFour">✔ 인기순</span></a>
                        </c:if>
                        <c:if test="${searchType==3 }">
                            <a class="product-array-button" href="/allproduct/3/1"><span class="orderOne">✔
                                    최신순</span></a>
                            <a class="product-array-button" href="/allproduct/3/2"><span class="orderTwo">✔ 낮은
                                    가격순</span></a>
                            <a class="product-array-button" href="/allproduct/3/3"><span class="orderThree">✔ 높은
                                    가격순</span></a>
                            <a class="product-array-button" href="/allproduct/3/4"><span class="orderFour">✔
                                    인기순</span></a>
                        </c:if>

                    </div>

                    <c:forEach items="${allproduct}" var="product" varStatus="vs">
                        <div class="product-box-item">

                            <!-- 예약중 표시 -->
                            <c:if test="${product.reservedNow==1 }">
                                <c:set var="reservedNowImg" value="렌탈중" />
                            </c:if>
                            <c:if test="${product.reservedNow==0 }">
                                <c:set var="reservedNowImg" value="" />
                            </c:if>


                            <!-- 가격 포맷 -->
                            <fmt:formatNumber var="priceFormat" value="${product.price}" pattern="#,###" />

                            <!-- 날짜 몇일 전으로 변환 -->
                            <fmt:parseDate value="${product.createdAt}" var="uploadDate" pattern="yyyy-MM-dd" />

                            <c:set var="current" value="<%=new java.util.Date()%>" />
                            <fmt:formatDate value="${current}" pattern="yyyy-MM-dd" var="currentForm" />
                            <fmt:parseDate value="${currentForm}" var="now" pattern="yyyy-MM-dd" />

                            <fmt:parseNumber value="${ (now.time - uploadDate.time)/(1000*60*60*24)}" integerOnly="true"
                                var="dateDiff"></fmt:parseNumber>

                            <c:set var="dateDiffShow" value="${dateDiff}일전" />

                            <c:if test="${dateDiffShow == '0일전'}">
                                <c:set var="dateDiffShow" value="오늘" />
                            </c:if>

                            <!-- 찜 표시 -->
                            <c:if test="${product.zzim == '0'}">
                                <c:set var="zzim"
                                    value="<img src='/pictures/zzim-off.png' width=30 height=30 style='cursor:pointer'>" />
                            </c:if>

                            <c:if test="${product.zzim == '1'}">
                                <c:set var="zzim"
                                    value="<img src='/pictures/zzim-on.png' width=30 height=30 style='cursor:pointer'>" />
                            </c:if>

                            <!-- 대표 이미지 -->
                            <c:if test="${!empty product.img1}">
                                <div class="product-item-img">
                                    <a href="/product/${product.id}">
                                        <img width=100% height=60% src="/upload/${product.img1}"></a>
                                </div>
                            </c:if>

                            <c:if test="${empty product.img1}">
                                <div class="product-item-img">
                                    <a href="/product/${product.id}">
                                        <img alt="사진이 없어요" width=100% height=60% src="/pictures/noimg.png"></a>
                                </div>
                            </c:if>

                           
                            <div class="product-item-title"> <a href="/product/${product.id}"> 
                            <span class="reserved" style=color:red;>${reservedNowImg} </span> &nbsp; ${product.title}</a>
                            </div>
                            <div class="product-item-date">${dateDiffShow}</div>
                            <div class="product-item-num" id="productid${vs.index}" style="display:none">${product.id}
                            </div>

                            <div class="product-item-location"> <img src="${path}/pictures/location.png"
                                    alt="">${product.boardRegion} </div>
                            <div class="product-item-price">1일가격 : ${priceFormat}원</div>
                            <div class="product-item-owner close">${product.userId}</div>
                            <span class="product-item-zzim" id="zzimSpan${product.id}">${zzim}</span>
                        </div>

                    </c:forEach>

                </div>

            </div>
            <div class="mobile-allproduct-container">
                <div class="mobile-allproduct-product-box" id="appendScroll">
                    <div class="mobile-allproduct-item-array">
                        <c:if test="${searchType==1 }">
                            <a class="product-array-button" href="/allproduct/1/1"><span class="orderOne">✔ </span><span class="orderOne2">최신순</span> </a>
                            <a class="product-array-button" href="/allproduct/1/2"><span class="orderTwo">✔ </span><span class="orderTwo2">낮은 가격순</span></a> 
                            <a class="product-array-button" href="/allproduct/1/3"><span class="orderThree">✔ </span><span class="orderThree2">높은 가격순</span> </a>
                            <a class="product-array-button" href="/allproduct/1/4"><span class="orderFour">✔ </span><span class="orderFour2">인기순</span> </a>
                            </c:if>
                            <c:if test="${searchType==2 }">
                            <a class="product-array-button" href="/allproduct/2/1?search=${search}"><span class="orderOne">✔ 최신순</span></a> 
                            <a class="product-array-button" href="/allproduct/2/2?search=${search}"><span class="orderTwo">✔ 낮은 가격순</span></a>
                            <a class="product-array-button" href="/allproduct/2/3?search=${search}"><span class="orderThree">✔ 높은 가격순</span></a>
                            <a class="product-array-button"href="/allproduct/2/4?search=${search}"><span class="orderFour">✔ 인기순</span></a>
                            </c:if>
                            <c:if test="${searchType==3 }">
                            <a class="product-array-button" href="/allproduct/3/1"><span class="orderOne">✔ 최신순</span></a>
                            <a class="product-array-button" href="/allproduct/3/2"><span class="orderTwo">✔ 낮은 가격순</span></a>
                            <a class="product-array-button" href="/allproduct/3/3"><span class="orderThree">✔ 높은 가격순</span></a>
                            <a class="product-array-button" href="/allproduct/3/4"><span class="orderFour">✔ 인기순</span></a>
                            </c:if>
                            
                    </div>

                    <c:forEach items="${allproduct}" var="product" varStatus="vs">
                        <div class="mobile-product-box-item">

                            <!-- 예약중 표시 -->
                            <c:if test="${product.reservedNow==1 }">
                                <c:set var="reservedNowImg" value="렌탈중" />
                            </c:if>
                            <c:if test="${product.reservedNow==0 }">
                                <c:set var="reservedNowImg" value="" />
                            </c:if>


                            <!-- 가격 포맷 -->
                            <fmt:formatNumber var="priceFormat" value="${product.price}" pattern="#,###" />

                            <!-- 날짜 몇일 전으로 변환 -->
                            <fmt:parseDate value="${product.createdAt}" var="uploadDate" pattern="yyyy-MM-dd" />

                            <c:set var="current" value="<%=new java.util.Date()%>" />
                            <fmt:formatDate value="${current}" pattern="yyyy-MM-dd" var="currentForm" />
                            <fmt:parseDate value="${currentForm}" var="now" pattern="yyyy-MM-dd" />

                            <fmt:parseNumber value="${ (now.time - uploadDate.time)/(1000*60*60*24)}" integerOnly="true"
                                var="dateDiff"></fmt:parseNumber>

                            <c:set var="dateDiffShow" value="${dateDiff}일전" />

                            <c:if test="${dateDiffShow == '0일전'}">
                                <c:set var="dateDiffShow" value="오늘" />
                            </c:if>

                            <!-- 찜 표시 -->
                            <c:if test="${product.zzim == '0'}">
                                <c:set var="zzim"
                                    value="<img src='/pictures/zzim-off.png' width=30 height=30 style='cursor:pointer'>" />
                            </c:if>

                            <c:if test="${product.zzim == '1'}">
                                <c:set var="zzim"
                                    value="<img src='/pictures/zzim-on.png' width=30 height=30 style='cursor:pointer'>" />
                            </c:if>

                            <!-- 대표 이미지 -->
                            <c:if test="${!empty product.img1}">
                                <div class="mobile-product-item-img">
                                    <a href="/product/${product.id}">
                                        <img  src="/upload/${product.img1}"></a>
                                </div>
                            </c:if>

                            <c:if test="${empty product.img1}">
                                <div class="mobile-product-item-img">
                                    <a href="/product/${product.id}">
                                        <img alt="사진이 없어요"  src="/pictures/noimg.png"></a>
                                </div>
                            </c:if>

                            <span class="mobile-reserved">${reservedNowImg} </span>
                            <div class="mobile-product-item-title"> <a href="/product/${product.id}">
                                    ${product.title}</a></div>
                            <div class="mobile-product-item-date">${dateDiffShow}</div>
                            <div class="mobile-product-item-num" id="productid${vs.index}" style="display:none">
                                ${product.id}</div>

                            <div class="mobile-product-item-location"> <img src="${path}/pictures/location.png"
                                    alt="">${product.boardRegion} </div>
                            <div class="mobile-product-item-price">1일가격 : ${priceFormat}원</div>
                            <div class="mobile-product-item-owner close">${product.userId}</div>
                            <span class="mobile-product-item-zzim" id="zzimSpan${product.id}">${zzim}</span>
                        </div>

                    </c:forEach>

                </div>
            </div>

        </div>
    </div>

    <script>
        let arrayButton = $('.product-array-button');

        arrayButton.eq(0).on('click', function (event) {
            arrayButton[0].style.color = "red";
        })
    </script>


    <script src="${path}/js/allproduct.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"
        integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3"
        crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.min.js"
        integrity="sha384-7VPbUDkoPSGFnVtYi0QogXtr74QeVeeIs99Qfg5YCF+TidwNdjvaKZX19NZ/e6oz"
        crossorigin="anonymous"></script>
</body>

</html>