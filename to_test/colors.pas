program colors;

uses crt;

var
	i :byte;

begin
	CursorOff;
	ClrScr;

	for i := 0 to 15 do
	begin
		TextColor(i);
		Write('X':2);
	end;

	WriteLn;
	TextColor(15);

	for i := 0 to 15 do
	begin
		TextColor(i);
		Write(i:2);
	end;
	
	WriteLn;

	for i:= 0 to 7 do
	begin
		TextBackground(i);
		Write(' ':2);
	end;

	ReadKey;
end.