program check_chr_key;

uses crt;

var key :char;

begin
	while true do
	begin
		key := readkey;
		write(key, '-', ord(key), '':2);
	end;
end.