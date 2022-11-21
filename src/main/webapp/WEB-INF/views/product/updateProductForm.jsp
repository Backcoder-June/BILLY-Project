<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="path" value="${pageContext.request.contextPath}"/>    
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





//사진 업로드 취소
function delImg(_this){
	//기존 이미지 개수 
	var Imgcount = $("#count").html();

	 if(!confirm("이 사진을 지울까요?")){
		 return false; 
		} else{  
			$(_this).parent('span').remove();
			Imgcount--;
			$("#count").html(Imgcount);

		
		switch ($(_this).attr('src').substring(8)) {
	 	case $("#file1").val():
	 		 $("#file1").val("");
	 		// 순서 땡기기 
	 		$("#file1").val($("#file2").val());
	 		$("#file2").val($("#file3").val());
	 		$("#file3").val($("#file4").val());
	 		$("#file4").val($("#file5").val());
	 		$("#file5").val($("#file6").val());
	 		$("#file6").val("");
	 		
	 	    break;
	    case $("#file2").val():
	 		 $("#file2").val("");
	    	 $("#file2").val($("#file3").val());
 			 $("#file3").val($("#file4").val());
 			 $("#file4").val($("#file5").val());
 			 $("#file5").val($("#file6").val());
 		   	 $("#file6").val("");
	 	    break;
	 	case $("#file3").val():
	 		 $("#file3").val("");
			 $("#file3").val($("#file4").val());
		 	 $("#file4").val($("#file5").val());
		 	 $("#file5").val($("#file6").val());
		 	 $("#file6").val("");
	 	    break;
	 	case $("#file4").val():
	 		 $("#file4").val("");
		 	 $("#file4").val($("#file5").val());
		 	 $("#file5").val($("#file6").val());
		 	 $("#file6").val("");
	 	    break;
	 	case $("#file5").val():
	 		 $("#file5").val("");
		 	 $("#file5").val($("#file6").val());	
		 	 $("#file6").val("");
	 	    break;
	 	case $("#file6").val():
	 		 $("#file6").val("");
	 	    break;
		 	}//switch
		} //if
	} //delImg


$(document).ready(function(){	   
	
	$("#dayPrice").on("mouseover", function(){
		$("#priceInfo").attr("style","display:inline");
	});
	
	$("#dayPrice").on("mouseleave", function(){
		$("#priceInfo").attr("style","display:none");
	});
	
	
// 수정 확인 
  $("#updatebtn").on("click", function (e){
    if(!confirm("게시글을 수정하시겠습니까?")){
      e.preventDefault();
    }
  }); //on updatebutton

 
  var img1 = '${updateProduct.img1}'; 
  var img2 = '${updateProduct.img2}'; 
  var img3 = '${updateProduct.img3}'; 
  var img4 = '${updateProduct.img4}'; 
  var img5 = '${updateProduct.img5}'; 
  var img6 = '${updateProduct.img6}'; 
  var video = '${updateProduct.video}';
  
  // 기존 이미지 file 에 등록 
  if( img1 != ""){
	  $("#file1").val(img1); }
  if( img2 != ""){
	  $("#file2").val(img2); }
  if( img3 != ""){
	  $("#file3").val(img3); }
  if( img4 != ""){
	  $("#file4").val(img4); }
  if( img5 != ""){
	  $("#file5").val(img5); }
  if( img6 != ""){
	  $("#file6").val(img6); }
  
  // 기존 동영상 file 에 등록 
  if( video!="" ){
	  let onlyVideoName = video.substring(0,video.indexOf("(")) + video.substring(video.indexOf(")")+1) ;
	  $("#videoTitle").val(video);  
	  $("#newVideoTitle").val(onlyVideoName);  
	  $("#videoTitle").attr("style","display:none");
	  $("#newVideoTitle").attr("style", "display:unset");
  }
  
  // 새로운 동영상 선택 시, 표기 바꿔주기   
  $("#video1").change(function(e) {
	  //용량제한
	  var videoSize = document.getElementById("video1").files[0].size;
		if(videoSize > 1024 * 1024 * 10){
			// 용량 초과시 경고후 해당 파일의 용량도 보여줌
			alert('10MB 이하 동영상만 등록할 수 있습니다.\n\n' + '현재파일 용량 : ' + (Math.round(videoSize / 1024 / 1024 * 100) / 100) + 'MB');
			$("#video1").val("");
			$("#videoTitle").val("");
			$("#newVideoTitle").val("");
			return false;
		}
	  
	  // 표기 바꾸기
	  let video1 = $("#video1").val();
	  $("#videoTitle").val("");
	  $("#videoTitle").attr("style","display:none");
	  $("#newVideoTitle").val(video1);
	  $("#newVideoTitle").attr("style", "display:unset");
  });
  
  
  
  
  
  
	//동영상 업로드 취소 
	$("#insertproduct-upload-button2").on("click", function(){
	$("#video1").val("");
	$("#videoTitle").val("");
	$("#newVideoTitle").val("");

	});
  
  
  
  
  // 이미지 파일 업로드 
  $("#imgFile").change(function(e) {
		var Imgcount = $("#count").html();
		
		// 이미지 파일 개수 count  
		if(Imgcount>=6){
			alert("사진은 6개까지 등록 가능합니다.");
			return false;
		}
		if(Imgcount<6){
		 	Imgcount++;
		 	$("#count").html(Imgcount);
			}
		
		

		var form = $("#uploadForm")[0];
		var data = new FormData(form);

		$.ajax({
		url : "/ajaxUpload",
		data : data,
		type : "post",
		dataType : "json",

		encType : "multipart/form-data",
		processData : false,  
		contentType : false,  

		success : function(resp){ 
			
			
			var str = '<span>';
			str += "<img src='/upload/"+resp.result+"' height=65 width=65 style='cursor:pointer' onclick='delImg(this)' >";
            str += '</span>';

            $(str).appendTo('#here');
			
			
			// ajax 로 받아온걸 file에 순서대로 집어 넣음 
		 	switch ("") {
		 	case $("#file1").val():
		 		 $("#file1").val(resp.result);
		 	    break;
		    case $("#file2").val():
		 		 $("#file2").val(resp.result);
		 	    break;
		 	case $("#file3").val():
		 		 $("#file3").val(resp.result);
		 	    break;
		 	case $("#file4").val():
		 		 $("#file4").val(resp.result);
		 	    break;
		 	case $("#file5").val():
		 		 $("#file5").val(resp.result);
		 	    break;
		 	case $("#file6").val():
		 		 $("#file6").val(resp.result);
		 	    break;
		 	}
				} // success 
			}); // ajax 
		}); // change 
});  // onload
</script>
</head>



	<div class="main-container">
        <!-- header-section -->
        <jsp:include page="/WEB-INF/views/header.jsp"> <jsp:param value="false" name="mypage"/></jsp:include>
        <!-- content-section -->
        <div class="content-container">
			<div class="insertproduct-container">

		<h1 class="insertproduct-title" class="title"> 게시물 수정</h1> 



<form class="product-insert-table" id="uploadForm" action="/product/${updateProduct.id}/updateprocess" method="post" enctype="multipart/form-data">

<input type="text" name="title" value="${updateProduct.title}" required maxlength="30" style="font-size:30px;"> 
<textarea name="contents" rows="15" cols="60" required maxlength="3000">${updateProduct.contents}</textarea> 
<span id="dayPrice" style="width:300px;"><input type="number" name="price" value="${updateProduct.price}" required step="1" style="width:300px;" placeholder="1일 가격"><span id="priceInfo" style="background-color:silver; display:none;">1일 대여 가격을 입력해주세요.</span></span> 
<input type="text" name="boardRegion" value="${updateProduct.boardRegion}" readonly style="width:300px;">
<input type="text" name="userId" value="${updateProduct.userId}" style="display:none;"> 

<div class="product-insert-insert-file-box">
<span>
<img src="/pictures/jpgicon.png" height=40 width=40><label class="insertproduct-label-button " for="imgFile">파일선택</label> &nbsp;6개까지 등록 가능하며, 클릭 시 취소됩니다.
<input id="imgFile" class="insertproduct-upload-button" type="file" name="imgFile" accept=".jpg, .jpeg, .jfif, .tiff, .gif, .bmp, .png, .heif, .bmp, .exif"> <br>
<input id="file1" type="text" style="display:none" name="file1">
<input id="file2" type="text" style="display:none" name="file2">
<input id="file3" type="text" style="display:none" name="file3">
<input id="file4" type="text" style="display:none" name="file4">
<input id="file5" type="text" style="display:none" name="file5">
<input id="file6" type="text" style="display:none" name="file6">
 
<!-- 기존 이미지 파일들 불러오기 -->	
<div class="insertproduct-upload-result" id="here">
	<c:if test="${!empty updateProduct.img1}" >
	<span>
	<img id="img1" alt="상품이미지가 없습니다." width=65 height=65 src="/upload/${updateProduct.img1}" style='cursor:pointer' onclick='delImg(this)'>
	</span>
	<c:set var="count" value="1"/>
	</c:if>
	<c:if test="${!empty updateProduct.img2}" >
	<span>
	<img id="img2" alt="상품이미지가 없습니다." width=65 height=65 src="/upload/${updateProduct.img2}" style='cursor:pointer' onclick='delImg(this)'>
	</span>
	<c:set var="count" value="2"/>
	</c:if>
	<c:if test="${!empty updateProduct.img3}" >
	<span>
	<img id="img3" alt="상품이미지가 없습니다." width=65 height=65 src="/upload/${updateProduct.img3}" style='cursor:pointer' onclick='delImg(this)'>
	</span>
	<c:set var="count" value="3"/>
	</c:if>
	<c:if test="${!empty updateProduct.img4}" >
	<span>
	<img id="img4" alt="상품이미지가 없습니다." width=65 height=65 src="/upload/${updateProduct.img4}" style='cursor:pointer' onclick='delImg(this)'>
	</span>
	<c:set var="count" value="4"/>
	</c:if>
	<c:if test="${!empty updateProduct.img5}" >
	<span>
	<img id="img5" alt="상품이미지가 없습니다." width=65 height=65 src="/upload/${updateProduct.img5}" style='cursor:pointer' onclick='delImg(this)'>
	</span>
	<c:set var="count" value="5"/>
	</c:if>
	<c:if test="${!empty updateProduct.img6}" >
	<span>
	<img id="img6" alt="상품이미지가 없습니다." width=65 height=65 src="/upload/${updateProduct.img6}" style='cursor:pointer' onclick='delImg(this)'>
	</span>
	<c:set var="count" value="6"/>
	</c:if>
	</div>
</span>
	<!--c:set 이후 쥐치 필요  -->
	<div id="count" class="close">${count}</div>
	

	<span>
	<img src="/pictures/mp4icon.png" height=40 width=40><label class="insertproduct-label-button mt-2" for="video1">파일선택</label> 
	<input class="insertproduct-upload-button" type="file" name="video1" id="video1" accept=".mp4, .mov, .wmv, .avi, .avchd, .flv, .f4v, .swf, .mkv, .webm, .html5, .mpeg-2, .ogv">
	<input id="insertproduct-upload-button2" type="button" value="취소">
	<input id="videoTitle" type="text" style="display:unset" name="videoTitle" readonly>
	<input id="newVideoTitle" type="text" style="display:none" name="NewvideoTitle" readonly>
	
</span>		
</div>

<input id="updateproduct-button"  type="submit" value="수정" name="update" id="updatebtn">

</form>

</div>
</div>
</div>
<br>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"
integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3"
crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.min.js"
integrity="sha384-7VPbUDkoPSGFnVtYi0QogXtr74QeVeeIs99Qfg5YCF+TidwNdjvaKZX19NZ/e6oz"
crossorigin="anonymous"></script>
</body>
</html>