<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%

%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>用户注册</title>
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
}
.sFont {
	font-size: 12px;
}
.Flatcon {
	border: 1px solid #8390A1;
	width: 120px;
}
-->
</style>
<script src="include/UtilFunction.js"></script>
<script src="ClientCode/RegistUser.js"></script>
<script type="text/javascript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
</head>

<body onload="MM_preloadImages('images/top_r3_c4_1.png','images/top_r3_c8_1.png','images/top_r3_c10_1.png','images/top_r3_c12_1.png','images/top_r3_c16_1.png','images/OK1.png','images/reset1.png')">
<table width="1004" border="0" align="center" cellpadding="0" cellspacing="0">
  <!-- fwtable fwsrc="未命名-1.png" fwpage="页面 1" fwbase="top.png" fwstyle="Dreamweaver" fwdocid = "608440849" fwnested="0" -->
  <tr>
    <td><img src="images/spacer.png" width="180" height="1" border="0" alt="" /></td>
    <td><img src="images/spacer.png" width="7" height="1" border="0" alt="" /></td>
    <td><img src="images/spacer.png" width="210" height="1" border="0" alt="" /></td>
    <td><img src="images/spacer.png" width="5" height="1" border="0" alt="" /></td>
    <td><img src="images/spacer.png" width="3" height="1" border="0" alt="" /></td>
    <td><img src="images/spacer.png" width="88" height="1" border="0" alt="" /></td>
    <td><img src="images/spacer.png" width="9" height="1" border="0" alt="" /></td>
    <td><img src="images/spacer.png" width="96" height="1" border="0" alt="" /></td>
    <td><img src="images/spacer.png" width="12" height="1" border="0" alt="" /></td>
    <td><img src="images/spacer.png" width="96" height="1" border="0" alt="" /></td>
    <td><img src="images/spacer.png" width="27" height="1" border="0" alt="" /></td>
    <td><img src="images/spacer.png" width="88" height="1" border="0" alt="" /></td>
    <td><img src="images/spacer.png" width="8" height="1" border="0" alt="" /></td>
    <td><img src="images/spacer.png" width="3" height="1" border="0" alt="" /></td>
    <td><img src="images/spacer.png" width="58" height="1" border="0" alt="" /></td>
    <td><img src="images/spacer.png" width="96" height="1" border="0" alt="" /></td>
    <td><img src="images/spacer.png" width="18" height="1" border="0" alt="" /></td>
    <td><img src="images/spacer.png" width="1" height="1" border="0" alt="" /></td>
  </tr>
  <tr>
    <td rowspan="4"><img name="top_r1_c1" src="images/top_r1_c1.png" width="180" height="192" border="0" id="top_r1_c1" alt="" /></td>
    <td colspan="11"><img name="top_r1_c2" src="images/top_r1_c2.png" width="641" height="98" border="0" id="top_r1_c2" alt="" /></td>
    <td colspan="2"><img name="top_r1_c13" src="images/top_r1_c13.png" width="11" height="98" border="0" id="top_r1_c13" alt="" /></td>
    <td colspan="3" valign="top" background="images/top_r1_c13.png" bgcolor="#ffffff"></td>
    <td><img src="images/spacer.png" width="1" height="98" border="0" alt="" /></td>
  </tr>
  <tr>
    <td rowspan="3"><img name="top_r2_c2" src="images/top_r2_c2.png" width="7" height="94" border="0" id="top_r2_c2" alt="" /></td>
    <td rowspan="3" valign="top" background="images/top_r2_c2.png" bgcolor="#ffffff"></td>
    <td><img name="top_r2_c4" src="images/top_r2_c4.png" width="5" height="40" border="0" id="top_r2_c4" alt="" /></td>
    <td colspan="13" valign="top" background="images/top_r2_c4.png" bgcolor="#ffffff"></td>
    <td><img src="images/spacer.png" width="1" height="40" border="0" alt="" /></td>
  </tr>
  <tr>
    <td colspan="3"><a href="#" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image38','','images/top_r3_c4_1.png',1)"><img src="images/top_r3_c4.png" name="Image38" width="96" height="42" border="0" id="Image38" /></a></td>
    <td><img name="top_r3_c7" src="images/top_r3_c7.gif" width="9" height="42" border="0" id="top_r3_c7" alt="" /></td>
    <td><a href="#" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image39','','images/top_r3_c8_1.png',1)"><img src="images/top_r3_c8.png" name="Image39" width="96" height="42" border="0" id="Image39" /></a></td>
    <td><img name="top_r3_c9" src="images/top_r3_c9.gif" width="12" height="42" border="0" id="top_r3_c9" alt="" /></td>
    <td><a href="#" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image40','','images/top_r3_c10_1.png',1)"><img src="images/top_r3_c10.png" name="Image40" width="96" height="42" border="0" id="Image40" /></a></td>
    <td><img name="top_r3_c11" src="images/top_r3_c11.gif" width="27" height="42" border="0" id="top_r3_c11" alt="" /></td>
    <td colspan="2"><a href="#" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image41','','images/top_r3_c12_1.png',1)"><img src="images/top_r3_c12.png" name="Image41" width="96" height="42" border="0" id="Image41" /></a></td>
    <td colspan="2"><img name="top_r3_c14" src="images/top_r3_c14.gif" width="61" height="42" border="0" id="top_r3_c14" alt="" /></td>
    <td><a href="#" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image42','','images/top_r3_c16_1.png',1)"><img src="images/top_r3_c16.png" name="Image42" width="96" height="42" border="0" id="Image42" /></a></td>
    <td><img name="top_r3_c17" src="images/top_r3_c17.gif" width="18" height="42" border="0" id="top_r3_c17" alt="" /></td>
    <td><img src="images/spacer.png" width="1" height="42" border="0" alt="" /></td>
  </tr>
  <tr>
    <td colspan="2"><img name="top_r4_c4" src="images/top_r4_c4.png" width="8" height="12" border="0" id="top_r4_c4" alt="" /></td>
    <td colspan="12" valign="top" background="images/top_r4_c4.png" bgcolor="#ffffff"></td>
    <td><img src="images/spacer.png" width="1" height="12" border="0" alt="" /></td>
  </tr>
</table>
<table width="1004" border="0" align="center" cellpadding="0" cellspacing="1" >
  <tr>
    <td height="163" align="center" valign="top" bgcolor="#FFFFFF">
    <form id="form1" name="form1" method="post" action="CheckIn.jsp">
      <table width="832" border="0" align="center" cellpadding="0" cellspacing="0">
        <!-- fwtable fwsrc="未命名" fwpage="页面 1" fwbase="regist.gif" fwstyle="Dreamweaver" fwdocid = "1761552994" fwnested="0" -->
        <tr>
          <td><img src="images/spacer.gif" width="29" height="1" border="0" alt="" /></td>
          <td><img src="images/spacer.gif" width="7" height="1" border="0" alt="" /></td>
          <td><img src="images/spacer.gif" width="119" height="1" border="0" alt="" /></td>
          <td><img src="images/spacer.gif" width="4" height="1" border="0" alt="" /></td>
          <td><img src="images/spacer.gif" width="655" height="1" border="0" alt="" /></td>
          <td><img src="images/spacer.gif" width="18" height="1" border="0" alt="" /></td>
          <td><img src="images/spacer.gif" width="1" height="1" border="0" alt="" /></td>
        </tr>
        <tr>
          <td colspan="3"><img name="regist_r1_c1" src="images/regist_r1_c1.jpg" width="155" height="60" border="0" id="regist_r1_c1" alt="" /></td>
          <td><img name="regist_r1_c4" src="images/regist_r1_c4.jpg" width="4" height="60" border="0" id="regist_r1_c4" alt="" /></td>
          <td><img name="regist_r1_c5" src="images/regist_r1_c5.jpg" width="655" height="60" border="0" id="regist_r1_c5" alt="" /></td>
          <td><img name="regist_r1_c6" src="images/regist_r1_c6.jpg" width="18" height="60" border="0" id="regist_r1_c6" alt="" /></td>
          <td><img src="images/spacer.gif" width="1" height="60" border="0" alt="" /></td>
        </tr>
        <tr>
          <td rowspan="2"><img name="regist_r2_c1" src="images/regist_r2_c1.jpg" width="29" height="383" border="0" id="regist_r2_c1" alt="" /></td>
          <td><img name="regist_r2_c2" src="images/regist_r2_c2.jpg" width="7" height="365" border="0" id="regist_r2_c2" alt="" /></td>
          <td colspan="3" valign="top" background="images/regist_r2_c2.jpg" bgcolor="#ffffff"><table width="80%" border="0" align="center" cellpadding="0" cellspacing="0" class="sFont">
            <tr>
              <td width="120" height="25">输入注册验证码</td>
              <td width="150"><label>
                <input name="ValidCode" type="text" class="Flatcon" id="ValidCode" />
              </label></td>
              <td width="303" align="left"><img border="0" src="Code.jsp" /></td>
            </tr>
            <tr>
              <td width="120" height="25">请输入注册用户名</td>
              <td width="150"><input name="UserName" type="text" class="Flatcon" id="UserName" /></td>
              <td width="303" align="left" id="L2">&nbsp;</td>
            </tr>
            <tr>
              <td width="120" height="25">设置用户登录密码</td>
              <td width="150"><input name="Password" type="password" class="Flatcon" id="Password" /></td>
              <td width="303" align="left" id="L3">&nbsp;</td>
            </tr>
            <tr>
              <td width="120" height="25">重输入用户密码</td>
              <td width="150"><input name="Password2" type="password" class="Flatcon" id="Password2" /></td>
              <td width="303" align="left" id="L4">&nbsp;</td>
            </tr>
            <tr>
              <td width="120" height="25">输入注册邮箱地址</td>
              <td width="150"><input name="Email" type="text" class="Flatcon" id="Email" /></td>
              <td width="303" align="left" id="L5">&nbsp;</td>
            </tr>
            <tr>
              <td width="120" height="25">Pikup用户使用手则</td>
              <td colspan="2">&nbsp;</td>
            </tr>
            <tr>
              <td height="149" colspan="3" align="left" valign="top">
              <textarea name="textarea" cols="45" rows="10" style="width:450px" class="Flatcon" id="textarea"></textarea></td>
              </tr>
            <tr>
              <td height="23" colspan="3"><input type="checkbox" name="checkbox1" id="checkbox1" />
                我已阅读并同意Pikup用户手则</td>
              </tr>
            <tr>
              <td height="23" colspan="3" align="center"><a href="#" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image58','','images/OK1.png',1)"><img onclick="CheckForm()" src="images/OK.png" name="Image58" width="75" height="25" border="0" id="Image58" /></a><a href="#" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image59','','images/reset1.png',1)"><img src="images/reset.png" name="Image59" width="75" height="25" border="0" id="Image59" /></a></td>
              </tr>
          </table>            
            <p style="margin:0px"></p></td>
          <td rowspan="2"><img name="regist_r2_c6" src="images/regist_r2_c6.gif" width="18" height="383" border="0" id="regist_r2_c6" alt="" /></td>
          <td><img src="images/spacer.gif" width="1" height="365" border="0" alt="" /></td>
        </tr>
        <tr>
          <td colspan="4"><img name="regist_r3_c2" src="images/regist_r3_c2.jpg" width="785" height="18" border="0" id="regist_r3_c2" alt="" /></td>
          <td><img src="images/spacer.gif" width="1" height="18" border="0" alt="" /></td>
        </tr>
      </table>
    </form>
    </td>
  </tr>
  <tr>
    <td bgcolor="#FFFFFF">&nbsp;</td>
  </tr>
</table>
</body>
</html>
