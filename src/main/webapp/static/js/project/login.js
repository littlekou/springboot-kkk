function getUserMsg(m) {
	$.get("/admin/getUserMsg.json?mobile="+m,{},function (data) {
		if(data.verity=='ok'){
			$(".verity").show();
		}else{
			$(".verity").hide();
		}
		if(data.google=='ok'){
			$(".google").show();
		}else{
			$(".google").hide();
		}
	});
}
function getVerifiCode() {
	$("#yzm_img").prop('src','admin/getVerifyCode.html?captchaId=${imgKey}&a='+new Date().getTime());
}