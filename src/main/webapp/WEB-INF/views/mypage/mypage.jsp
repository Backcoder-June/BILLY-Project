<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>BILLY | 마이페이지</title>
    <link rel="shortcut icon" type="image/x-icon" href="${path}/pictures/Billycon.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
    <link rel="stylesheet" href="${path}/css/header.css">
    <link rel="stylesheet" href="${path}/css/mypage.css">
    <script src="${path}/js/jquery-3.6.0.min.js"></script>

    <script>
        $(document).ready(function () {
            let zzimlink = '${zzimListLink}';
            if (zzimlink == "1") {
                myPageTitle.removeClass('show');
                myPageTitle.eq(3).addClass('show');
                myPageInnerBox.addClass('close');
                myPageInnerBox.eq(3).removeClass('close');
            }
        });
    </script>

</head>

<body>
    <div class="main-container">
        <!-- header-section -->
        <jsp:include page="/WEB-INF/views/header.jsp">
            <jsp:param value="false" name="mypage" />
        </jsp:include>
        <!-- content-section -->
        <div class="background">
            <p>My page</p> 
         </div>
        <div class="content-container">

            <div class="mypage-container">
                <div class="mypage-box-title-box">
                    <div class="mypage-title show mt-3">My 정보</div>
                    <div class="mypage-title">My 등록물품</div>
                    <div class="mypage-title">My 커뮤니티 </div>
                    <div class="mypage-title">My 찜리스트</div>
                </div>
                <div class="mypage-container-inner-box">
                    <p class="myproduct-box-title"><span style="color:orange;">${member.name }</span>회원님의 페이지</p>
                    <table class="mypage-info">
                        <tr style="background-color : rgb(243, 243, 243);">
                            <td style="width : 25%;">아이디</td>
                            <td> ${member.userid }</td>
                        </tr>
                        <tr>
                            <td>이름</td>
                            <td> ${member.name }</td>
                        </tr>

                        <tr>
                            <td>전화번호</td>
                            <td> ${member.phone }</td>
                        </tr>
                        <tr>
                            <td>이메일</td>
                            <td> ${member.email }</td>
                        </tr>
                        <tr>
                            <td>주소</td>
                            <td> ${member.address }</td>
                        </tr>
                    </table>
                    <div class="mypage-info-button-box mt-1">
                        <input class="mypage-info-button" type="button"
                            onclick="location.href='mypageModify?userid=${sessionid}'" value="수정하기">
                        <!-- <input class="mypage-info-button" type="button" onclick="location.href='delete'" value="회원탈퇴"> -->
                        <input class="mypage-info-button" type="button" onclick="location.href='passwordModify'"
                            value="비밀번호 변경">
                        <input class="mypage-info-button" type="button" onclick="location.href='delete'" value="회원탈퇴">
                    </div>
                </div>

                <div class="mypage-container-inner-box close">

                    <p class="myproduct-box-title">내가 등록한 물품</p>
                    <form class="myproduct-box" name="myproduct" action="myProduct" method="get">


                        <c:forEach items="${allmyboard}" var="board" varStatus="vs">
                            <div class="myproduct-box-item">
                                <fmt:parseDate value="${board.createdAt}" var="uploadDate" pattern="yyyy-MM-dd" />


                                <div class="close" id="boardid${vs.index}">${board.id}</div>
                                <div class="myproduct-item-img"><a href="/product/${board.id}"><img
                                            src="/upload/${board.img1}" width=200 height=200></a>
                                </div>
                                <div class="myproduct-item-title"><a href="/product/${board.id}">${board.title}</a>
                                </div>
                                <div class="myproduct-item-date">${board.createdAt}</div>
                            </div>
                        </c:forEach>

                    </form>

                    <script>
                        function back() {
                            history.back();
                        }
                    </script>
                </div>


                <div class="mypage-container-inner-box close">

                    <p class="myproduct-box-title">커뮤니티 작성글</p>
                    <form class="myproduct-box" name="mywrite" method="get">
                        <table class="myproduct-box-table">
                            <tr class="myproduct-box-table-title">
                                <th style="width : 10%; border-right:2px solid rgb(224, 224, 224)">번호</th>
                                <th style="width : 45%; border-right:2px solid rgb(224, 224, 224)">제목</th>
                                <th style="width : 45%">날짜</th>
                            </tr>
                            <tr class="myproduct-box-table-title2">
                                <th colspan="3"></th>
                            
                            </tr>
                            <tbody>
                                <c:forEach items="${allmyboard2}" var="board2" varStatus="vs">
                                    <fmt:parseDate value="${board2.writingtime}" var="uploadDate"
                                        pattern="yyyy-MM-dd" />
                                    <tr class="mypage-mywrite">
                                        <th style="font-size : 0.8rem;" id="boardid${vs.index}">${board2.seq}</th>
                                        <th><a href="/boarddetail?seq=${board2.seq}">${board2.title}</a></th>
                                        <th style="font-size : 0.8rem;">${board2.writingtime}</th>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </form>

                    <script>
                        function back() {
                            history.back();
                        }
                    </script>
                </div>

                <div class="mypage-container-inner-box close">
                    <p class="myproduct-box-title">찜 리스트</p>
                    <table class="myproduct-zzim-box">
                        <tr class="myproduct-box-table-title">
                            <th style="width : 10%; border-right:2px solid rgb(224, 224, 224)">번호</th>
                            <th style="border-right:2px solid rgb(224, 224, 224)">제목</th>
                            <th>날짜</th>
                        </tr>
                        <tr class="myproduct-box-table-title2">
                            <th colspan="3"></th>
                        
                        </tr>

                        <tbody>
                            <c:forEach items="${zzimList}" var="board" varStatus="vs">
                                <fmt:parseDate value="${board.createdAt}" var="uploadDate" pattern="yyyy-MM-dd" />
                                <tr class="myproduct-zzim-item">
                                    <th style="width:5%" id="zzimid${vs.index}">${board.id}</th>
                                    <th style="width:55%;"><img src="/upload/${board.img1}"
                                            width=40 height=40><a href="/product/${board.id}">${board.title}</a></th>
                                    <th style="width:30%">${board.createdAt}</th>
                                    <th style="width:10%"><span class="product-item-zzim" id="zzimSpan${board.id}"><img
                                                src='/pictures/zzim-on.png' width=30 height=30
                                                style='cursor:pointer'></span></th>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>


             
       	    </div>
        </div>
    </div>



    <script>
        let myPageTitle = $('.mypage-title');
        let myPageInnerBox = $('.mypage-container-inner-box');

        for (let i = 0; i < myPageTitle.length; i++) {
            myPageTitle.eq(i).on('click', function () {
                myPageTitle.removeClass('show');
            myPageTitle.eq(i).addClass('show');
                myPageInnerBox.addClass('close');
                myPageInnerBox.eq(i).removeClass('close');
            });
        }


        // 찜 기능
        let zzimlength = '${zzimlength}';
        for (var i = 0; i < zzimlength; i++) {
            (function (i) {
                let eachProductId = $("#zzimid" + i).html();
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
                        data: { 'productseq': intProductId, 'memberid': sessionId },   //sessionId Header에 defined.

                        success: function (resp) {

                            if (resp.result == 0) {
                                $("#zzimSpan" + intProductId).html("<img src='/pictures/zzim-on.png' width=30 height=30 style='cursor:pointer'>")
                                // 찜 작동 시, 해당물품 장바구니에 출력 
                                //    $("#zzimProducts").prepend("<a href='/product/" + resp.id + "'><span id='spanId"+ resp.id +"'><img src='/upload/"+ resp.img1 +"' width=50 height=50 style='cursor:pointer'>" + resp.title+"</span></a>");
                            }
                            else if (resp.result == 1) {
                                $("#zzimSpan" + intProductId).html("<img src='/pictures/zzim-off.png' width=30 height=30 style='cursor:pointer'>")
                                // 찜 취소 시, 해당물품 장바구니에서 제거
                                //    $("#spanId" + resp.id).remove();
                            }

                        } // success 
                    }); // ajax 
                }); // 찜 onclick
            })(i); // for - ajax 용 function
        } // for 




    </script>


    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"
        integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3"
        crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.min.js"
        integrity="sha384-7VPbUDkoPSGFnVtYi0QogXtr74QeVeeIs99Qfg5YCF+TidwNdjvaKZX19NZ/e6oz"
        crossorigin="anonymous"></script>
</body>

</html>