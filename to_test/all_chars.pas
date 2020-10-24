program all_chars;

uses crt;

var i :integer;

begin
	for i := 0 to 255 do write(' ', chr(i), ' ');

	//readkey;
	read(i);
end.