unit Commucator;

interface


  const
    DLLName = 'PikupRtm.dll';

  function CheckUserLogin(Username:string;Passord:string;UID:string):string;stdcall;external DLLName;
implementation


end.
