
//**********************************
//验证用户提交表单的数据
//
//
//**********************************
function CheckForm()
{
	var ReturlValue =true;
	//alert(form1.checkbox1.checked);
	if(form1.checkbox1.checked)
	{

		if(form1.UserName.value=="")
		{			
			ReturlValue= false;
			L2.innerHTML = "<font color='#ffaaaa'>请输入用户名称</font>";
		}
		if(form1.Password.value=="")
		{
			ReturlValue= false;
			L3.innerHTML = "<font color='#ffaaaa'>请输入用户密码</font>";
		}
		if(form1.Password2.value!=form1.Password.value)
		{
			ReturlValue= false;
			L4.innerHTML = "<font color='#ffaaaa'>请输入相同的用户密码</font>";
		}
		if(form1.Email.value=="")
		{
			ReturnValue = false;
			L5.innerHTML = "<font color='#ffaaaa'>请输入用户注册邮箱</font>";
		}
	}else{
		ReturlValue = false;
	}
	if(ReturlValue)
	{
		form1.Password.value = MD5(form1.Password.value);
		alert(MD5("ioriyaga"));
		form1.submit();
	}
	
}