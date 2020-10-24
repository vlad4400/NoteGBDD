program background;

uses crt;

var
	i, j :integer;
	str :string;

begin
	ClrScr;
	ReadKey;
	//CursorOff;
	TextBackground(7);
	ClrScr;

	ReadKey;

	//TextColor(7);
	TextBackground(3);

	str := '';
	for i := 1 to 120 do str := str + ' ';

	GoToXY(1, 1);
	for i := 1 to 30 do
	begin
		Write(str);
	end;

	ReadKey;

	TextBackground(5);
	str := '';
	for i := 1 to 240 do str := str + ' ';

	GoToXY(1, 1);
	for i := 1 to 15 do
	begin
		Write(str);
	end;
	
	ReadKey;

	TextBackground(2);
	GoToXY(1, 1);
	Write(str, str, str, str, str, str, str);
	ReadKey;

	TextColor(6);
	TextBackground(6);

	for i := 1 to 30 do
	begin
		//GoToXY(1, i);
		for j := 1 to 120 do
		begin
			GoToXY(j, i);
			Write(' ');
		end;
	end;
	ReadKey;
end.
