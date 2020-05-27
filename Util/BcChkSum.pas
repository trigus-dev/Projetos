unit bcchksum;
{
Checksum Functions by Andreas Schmidt

21.07.1999


mailto://shmia@bizerba.de

or

mailto://a_j_schmidt@rocketmail.com
}


interface

uses SysUtils;

	{ used for EAN 8/13 }
  function CalculaModulo10(Numero : String): Char;
	function CheckSumModulo10(const data:string):string;

implementation


function CalculaModulo10(Numero : String): Char;
var
  i : Integer;
  Soma : Integer;
  Mult : Integer;
begin
  Soma := 0;
  Mult := 3;
  for i := Length(Numero) downto 1 do begin
    Soma := Soma + (Ord(Numero[i])-Ord('0'))*Mult;
    if Mult = 3 then
      Mult := 1
    else
      Mult := 3;
  end;
  if Soma mod 10 <> 0 then
    Result := Chr(10 - Soma mod 10 + Ord('0'))
  else
    Result := '0';
end;

function CheckSumModulo10(const data:string):string;
	var i,fak,sum : Integer;
begin
	sum := 0;
	fak := Length(data);
	for i:=1 to Length(data) do
	begin
		if (fak mod 2) = 0 then
			sum := sum + (StrToInt(data[i])*1)
		else
			sum := sum + (StrToInt(data[i])*3);
		dec(fak);
	end;
	if (sum mod 10) = 0 then
		result := data+'0'
	else
		result := data+IntToStr(10-(sum mod 10));
end;


end.
