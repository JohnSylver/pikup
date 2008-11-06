unit Servier;

interface
  uses MSXML2_TLB,comobj,activex,sysutils;
    function CheckUserLogin(Username:string;Passord:string;UID:string):string;stdcall;
    function UserIsLogin():boolean;
implementation

 function UserIsLogin():boolean;
 begin

 end;

 function CheckUserLogin(Username:string;Passord:string;UID:string):string;
  var
    XmlData:string;//定义输入的XML请求
  begin
    XmlData := '<Request>'+
                '<UserLoginRequest>'+
                  '<UserName>'+Username+'</UserName>'+
                  '<Password></Password>'+
                  '<ComGUID></ComGUID>'+
                '</UserLoginRequest>'+
               '</Request>';
  end;

end.
