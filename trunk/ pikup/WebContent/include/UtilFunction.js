//------------------------------------------------------------------------------
//文件名称 ：UtilFunction.js
//用于定义程序用到的全局调用函数和方法
//创建日期：2007-7-21
//应用项目：e-Touch WEB版本
//受控版本号：ver 1.1.1.1
//人员：Kinpro
//-----------------------------------------------------------------------------

var _installed=false
//----------------------------------------------
//函数名称：CheckVideoCtl
//函数用途：检查播放组件是否已安装
//
//----------------------------------------------
function CheckVideoCtl()
{
var swf = null;
try{
swf=new ActiveXObject('eVideoOCX.eVideoCTL.1'); 
}catch(e){

}
if(swf==null)
{
   if(confirm("系统检测到你的Windows meida player版本过低或没相应的插件！需要安装天讯e安讯的WEB视频组件\n确认安装吗？"))
   {
    window.open("./Include/setup.exe");
   }else{
    window.close();
   }
}else{
    _installed=true;
}
}
//----------------------------------------------
//函数名称：SaveCookie
//函数用途：保存Cookie
//
//----------------------------------------------
function SaveCookie(_name,_value)
{
	DeleteCookie(_name);
    var expdate = new Date();
    expdate.setTime(expdate.getTime()+(_CookieValidity));
    SetCookie(_name,_value,expdate,"/",null,false);
}
//----------------------------------------------
//函数名称：SetCookie
//函数用途：设置名称为name,值为value的Cookie 
//----------------------------------------------
function SetCookie(name, value) { 
		var argv = SetCookie.arguments;
        var argc = SetCookie.arguments.length;
        var expires = (2<argc)? argv[2]:null;
        var path = (3<argc)?argv[3]:null;
        var domain = (4<argc)?argv[4]:null;
        var secure = (5<argc)?argv[5]:null;

        document.cookie = name+"="+escape(value)+
        ((expires == null)?" ":(";expires ="+expires.toGMTString()))+
        ((path == null)?"  ":(";path = "+path))+
        ((domain == null)?" ":(";domain =" +domain)) +
        ((secure==true)?";secure":" ");
} 
//----------------------------------------------
//函数名称：DeleteCookie
//函数用途：删除名称为name的Cookie 
//----------------------------------------------
function DeleteCookie(name) { 
		var exp = new Date(); 
		exp.setTime (exp.getTime() - 1); 
		var cval = GetCookie(name); 
		document.cookie = name + "=" + cval + "; expires=" + exp.toGMTString(); 
} 
//----------------------------------------------
//函数名称：ClearCookie
//函数用途：清除COOKIE
//----------------------------------------------
function ClearCookie() 
{ 
		var temp=document.cookie.split(";"); 
		var loop; 
		var ts; 
		for (loop=0;loop<temp.length;loop++) { 
		ts=temp[loop].split("=")[0]; 
		if(ts.indexOf("color")!=-1) 
		DeleteCookie(ts); 
	} 
} 

//----------------------------------------------
//函数名称：AutoTabByEnter
//函数用途：用于在文档框中输入enter后自动转为Tab
//
//----------------------------------------------
function AutoTabByEnter()
{
   if(event.keyCode==13)
   {
     event.keyCode =9;
   }
}


//----------------------------------------------
//函数名称：ChangeImg
//函数用途：用于图片替换
//函数参数：Obj   需要进行图片替换的图片对象
//          ImgURL    图片路径
//----------------------------------------------
function ChangeImg(Obj,ImgURL)
{
   // alert(ImgURL);
    Obj.src=ImgURL;
}

//----------------------------------------------
//函数名称：getIEVersonNumber
//函数用途：返回当前IE浏览器版本，若为0则非IE浏览器
//函数参数：Obj   需要进行图片替换的图片对象
//          ImgURL    图片路径
//----------------------------------------------
function getIEVersonNumber()
    {
        var ua = navigator.userAgent;
        var msieOffset = ua.indexOf("MSIE ");
        if(msieOffset < 0)
        {
            return 0;
        }
        return parseFloat(ua.substring(msieOffset + 5, ua.indexOf(";", msieOffset)));
    }
//----------------------------------------------
//函数名称：getCookieVal
//函数用途：取得项名称为offset的cookie值 
//----------------------------------------------
function getCookieVal(offset) { 
        var endstr = document.cookie.indexOf(";",offset);
        if (endstr == -1)
        {
                endstr = document.cookie.length;
        }
        return unescape(document.cookie.substring(offset,endstr));
} 
//----------------------------------------------
//函数名称：GetCookie
//函数用途：取得名称为name的cookie值 
//----------------------------------------------
function GetCookie(name) {
	 	var arg = name + "=";
        var alen = arg.length;
        var clen = document.cookie.length;
        var i= 0;
        while (i<clen)
        {
                var j = i+alen;
                        if (document.cookie.substring(i,j) == arg)
                        {
                                return getCookieVal(j);
                        }
                i = document.cookie.indexOf(" ",i)+1;
                if(i==0) break;
        }
        return null;
} 

//----------------------------------------------
//函数名称：UserInfo
//函数用途：定义用户信息类
//----------------------------------------------
function UserInfo()
{
	this.userID=0;
	
	this.userLoginName;

    this.LastAccessTime;
    
    this.userName;

    this.roleName;

    this.orgName;

    this.status;

    this.enabled;
    
    this.UserOrgID=0;
    
    this.UserPosition="";
    
    this.UserPower;
    
    this.UserOrgPath=0;
}

//----------------------------------------------
//函数名称：OrgTreeInfo
//函数用途：定义组织树信息类
//----------------------------------------------
function OrgTreeInfo()
{
    this.ItemID;

    this.ParentItemID;

    this.ItemType;

    this.tagURL;

    this.pItemName;

    this.ipv4Addr;

    this.port;

    this.channel;

    this.active;

    this.username;

    this.password;

    this.cID;
    
    this.subItem =new Array();
}

//----------------------------------------------
//函数名称：Hashtable
//函数用途：定义哈希表信息类
//----------------------------------------------
function Hashtable()
{
    this._hash        = new Object();
    this.add        = function(key,value){
                        if(typeof(key)!="undefined"){
                            if(this.contains(key)==false){
                                this._hash[key]=typeof(value)=="undefined"?null:value;
                                return true;
                            } else {
                                return false;
                            }
                        } else {
                            return false;
                        }
                    }
    this.remove        = function(key){delete this._hash[key];}
    this.count        = function(){var i=0;for(var k in this._hash){i++;} return i;}
    this.items        = function(key){return this._hash[key];}
    this.contains    = function(key){ return typeof(this._hash[key])!="undefined";}
    this.clear        = function(){for(var k in this._hash){delete this._hash[k];}}

}

function MD5(sMessage) {
function RotateLeft(lValue, iShiftBits) { return (lValue<<iShiftBits) | (lValue>>>(32-iShiftBits)); }
function AddUnsigned(lX,lY) {
var lX4,lY4,lX8,lY8,lResult;
lX8 = (lX & 0x80000000);
lY8 = (lY & 0x80000000);
lX4 = (lX & 0x40000000);
lY4 = (lY & 0x40000000);
lResult = (lX & 0x3FFFFFFF)+(lY & 0x3FFFFFFF);
if (lX4 & lY4) return (lResult ^ 0x80000000 ^ lX8 ^ lY8);
if (lX4 | lY4) {
if (lResult & 0x40000000) return (lResult ^ 0xC0000000 ^ lX8 ^ lY8);
else return (lResult ^ 0x40000000 ^ lX8 ^ lY8);
} else return (lResult ^ lX8 ^ lY8);
}
function F(x,y,z) { return (x & y) | ((~x) & z); }
function G(x,y,z) { return (x & z) | (y & (~z)); }
function H(x,y,z) { return (x ^ y ^ z); }
function I(x,y,z) { return (y ^ (x | (~z))); }
function FF(a,b,c,d,x,s,ac) {
a = AddUnsigned(a, AddUnsigned(AddUnsigned(F(b, c, d), x), ac));
return AddUnsigned(RotateLeft(a, s), b);
}
function GG(a,b,c,d,x,s,ac) {
a = AddUnsigned(a, AddUnsigned(AddUnsigned(G(b, c, d), x), ac));
return AddUnsigned(RotateLeft(a, s), b);
}
function HH(a,b,c,d,x,s,ac) {
a = AddUnsigned(a, AddUnsigned(AddUnsigned(H(b, c, d), x), ac));
return AddUnsigned(RotateLeft(a, s), b);
}
function II(a,b,c,d,x,s,ac) {
a = AddUnsigned(a, AddUnsigned(AddUnsigned(I(b, c, d), x), ac));
return AddUnsigned(RotateLeft(a, s), b);
}
function ConvertToWordArray(sMessage) {
var lWordCount;
var lMessageLength = sMessage.length;
var lNumberOfWords_temp1=lMessageLength + 8;
var lNumberOfWords_temp2=(lNumberOfWords_temp1-(lNumberOfWords_temp1 % 64))/64;
var lNumberOfWords = (lNumberOfWords_temp2+1)*16;
var lWordArray=Array(lNumberOfWords-1);
var lBytePosition = 0;
var lByteCount = 0;
while(lByteCount<lMessageLength ) {
lWordCount = (lByteCount-(lByteCount % 4))/4;
lBytePosition = (lByteCount % 4)*8;
lWordArray[lWordCount] = (lWordArray[lWordCount] | (sMessage.charCodeAt(lByteCount)<<lBytePosition));
lByteCount++;
}
lWordCount = (lByteCount-(lByteCount % 4))/4;
lBytePosition = (lByteCount % 4)*8;
lWordArray[lWordCount] = lWordArray[lWordCount] | (0x80<<lBytePosition);
lWordArray[lNumberOfWords-2] = lMessageLength<<3;
lWordArray[lNumberOfWords-1] = lMessageLength>>>29;
return lWordArray;
}
function WordToHex(lValue) {
var WordToHexValue="",WordToHexValue_temp="",lByte,lCount;
for (lCount = 0;lCount<=3;lCount++) {
lByte = (lValue>>>(lCount*8)) & 255;
WordToHexValue_temp = "0" + lByte.toString(16);
WordToHexValue = WordToHexValue + WordToHexValue_temp.substr(WordToHexValue_temp.length-2,2);
}
return WordToHexValue;
}
var x=Array();
var k,AA,BB,CC,DD,a,b,c,d
var S11=7, S12=12, S13=17, S14=22;
var S21=5, S22=9 , S23=14, S24=20;
var S31=4, S32=11, S33=16, S34=23;
var S41=6, S42=10, S43=15, S44=21;
// Steps 1 and 2. Append padding bits and length and convert to words
x = ConvertToWordArray(sMessage);
// Step 3. Initialise
a = 0x67452301; b = 0xEFCDAB89; c = 0x98BADCFE; d = 0x10325476;
// Step 4. Process the message in 16-word blocks
for (k=0;k<x.length;k+=16) {
AA=a; BB=b; CC=c; DD=d;
a=FF(a,b,c,d,x[k+0], S11,0xD76AA478);
d=FF(d,a,b,c,x[k+1], S12,0xE8C7B756);
c=FF(c,d,a,b,x[k+2], S13,0x242070DB);
b=FF(b,c,d,a,x[k+3], S14,0xC1BDCEEE);
a=FF(a,b,c,d,x[k+4], S11,0xF57C0FAF);
d=FF(d,a,b,c,x[k+5], S12,0x4787C62A);
c=FF(c,d,a,b,x[k+6], S13,0xA8304613);
b=FF(b,c,d,a,x[k+7], S14,0xFD469501);
a=FF(a,b,c,d,x[k+8], S11,0x698098D8);
d=FF(d,a,b,c,x[k+9], S12,0x8B44F7AF);
c=FF(c,d,a,b,x[k+10],S13,0xFFFF5BB1);
b=FF(b,c,d,a,x[k+11],S14,0x895CD7BE);
a=FF(a,b,c,d,x[k+12],S11,0x6B901122);
d=FF(d,a,b,c,x[k+13],S12,0xFD987193);
c=FF(c,d,a,b,x[k+14],S13,0xA679438E);
b=FF(b,c,d,a,x[k+15],S14,0x49B40821);
a=GG(a,b,c,d,x[k+1], S21,0xF61E2562);
d=GG(d,a,b,c,x[k+6], S22,0xC040B340);
c=GG(c,d,a,b,x[k+11],S23,0x265E5A51);
b=GG(b,c,d,a,x[k+0], S24,0xE9B6C7AA);
a=GG(a,b,c,d,x[k+5], S21,0xD62F105D);
d=GG(d,a,b,c,x[k+10],S22,0x2441453);
c=GG(c,d,a,b,x[k+15],S23,0xD8A1E681);
b=GG(b,c,d,a,x[k+4], S24,0xE7D3FBC8);
a=GG(a,b,c,d,x[k+9], S21,0x21E1CDE6);
d=GG(d,a,b,c,x[k+14],S22,0xC33707D6);
c=GG(c,d,a,b,x[k+3], S23,0xF4D50D87);
b=GG(b,c,d,a,x[k+8], S24,0x455A14ED);
a=GG(a,b,c,d,x[k+13],S21,0xA9E3E905);
d=GG(d,a,b,c,x[k+2], S22,0xFCEFA3F8);
c=GG(c,d,a,b,x[k+7], S23,0x676F02D9);
b=GG(b,c,d,a,x[k+12],S24,0x8D2A4C8A);
a=HH(a,b,c,d,x[k+5], S31,0xFFFA3942);
d=HH(d,a,b,c,x[k+8], S32,0x8771F681);
c=HH(c,d,a,b,x[k+11],S33,0x6D9D6122);
b=HH(b,c,d,a,x[k+14],S34,0xFDE5380C);
a=HH(a,b,c,d,x[k+1], S31,0xA4BEEA44);
d=HH(d,a,b,c,x[k+4], S32,0x4BDECFA9);
c=HH(c,d,a,b,x[k+7], S33,0xF6BB4B60);
b=HH(b,c,d,a,x[k+10],S34,0xBEBFBC70);
a=HH(a,b,c,d,x[k+13],S31,0x289B7EC6);
d=HH(d,a,b,c,x[k+0], S32,0xEAA127FA);
c=HH(c,d,a,b,x[k+3], S33,0xD4EF3085);
b=HH(b,c,d,a,x[k+6], S34,0x4881D05);
a=HH(a,b,c,d,x[k+9], S31,0xD9D4D039);
d=HH(d,a,b,c,x[k+12],S32,0xE6DB99E5);
c=HH(c,d,a,b,x[k+15],S33,0x1FA27CF8);
b=HH(b,c,d,a,x[k+2], S34,0xC4AC5665);
a=II(a,b,c,d,x[k+0], S41,0xF4292244);
d=II(d,a,b,c,x[k+7], S42,0x432AFF97);
c=II(c,d,a,b,x[k+14],S43,0xAB9423A7);
b=II(b,c,d,a,x[k+5], S44,0xFC93A039);
a=II(a,b,c,d,x[k+12],S41,0x655B59C3);
d=II(d,a,b,c,x[k+3], S42,0x8F0CCC92);
c=II(c,d,a,b,x[k+10],S43,0xFFEFF47D);
b=II(b,c,d,a,x[k+1], S44,0x85845DD1);
a=II(a,b,c,d,x[k+8], S41,0x6FA87E4F);
d=II(d,a,b,c,x[k+15],S42,0xFE2CE6E0);
c=II(c,d,a,b,x[k+6], S43,0xA3014314);
b=II(b,c,d,a,x[k+13],S44,0x4E0811A1);
a=II(a,b,c,d,x[k+4], S41,0xF7537E82);
d=II(d,a,b,c,x[k+11],S42,0xBD3AF235);
c=II(c,d,a,b,x[k+2], S43,0x2AD7D2BB);
b=II(b,c,d,a,x[k+9], S44,0xEB86D391);
a=AddUnsigned(a,AA); b=AddUnsigned(b,BB); c=AddUnsigned(c,CC); d=AddUnsigned(d,DD);
}
// Step 5. Output the 128 bit digest
var temp= WordToHex(a)+WordToHex(b)+WordToHex(c)+WordToHex(d);
return temp.toLowerCase();
}



function Thread(ProcessHandle)
{
	var win = self;
	var doc = win.document;
	var _Thread = this;
	var thArr = new Array();
	this.toString = function(){return "线程类对象"};
	this.Timer = ProcessHandle || 1000;
	this.Tag = doc.createElement("marquee");
	this.Tag.appendChild(doc.createTextNode("-"));
	this.Tag.scrollDelay = this.Timer;
	var _div = document.createElement("div");
	_div.style.height = 1;
	_div.style.overflow = "hidden";
	_div.appendChild(this.Tag);
	this.Tag.onscroll = function()
	{
		for(var i = 0; i < thArr.length; i++) 
		thArr[i]();
	}
	new function main()
	{
		if(doc.readyState != "complete") return setTimeout(main);
		doc.body.appendChild(_div);
	}
	this.Start = function(thread)
	{
		thArr.push(thread);
	}
}