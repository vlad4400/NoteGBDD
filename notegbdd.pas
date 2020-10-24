{Vladyslav Mambetov}
{Date 2016.05.28-2016.07.13}
program NoteGBBD;

uses Crt;

type ls = record
		mark :string[13];
		colour :string[10];
		serial_and_board_numbers :string[14];
		release_date :string[8];
		design_features :string[13];
		date_inspection :string[13];
		passport_data :string[20];
	end;

var
	i, quantity_records, numb :integer;
	key, key_test, key_edit :char;
	fdate :file of ls;
	table :array[1..99] of ls;
	visible_table :array[1..99] of boolean;
	flag_main_menu, flag_add_post, flag_edit, flag_exit :boolean;
	var_word, word_previous_navigation :string;
	text_background_main, text_color_main, text_color_main_selection, j, n :byte;

	//for main part
	key_previos :char; //!!!

	//for procedure show_all_post
	table_sorted :array[1..99] of ls;
	order, determinant_key, edit_header :boolean;
	column_number, column_number_previos :shortint;
	quantity_sorted_records :byte;

	//for procedure data_files
	name_data :array[0..15] of string[15];
	name_data_connect :array[0..15] of byte;
	quantity_name_data, previos_position_data_files, previos_position_data_files_connected :byte;
	flag_key_determine_data_files, flag_key_chr_zero, flag_set_password_data_files, flag_false_password :boolean;
	selected_position_data_files :integer;
	password_data_file :string[14];


procedure load_list_connect;
	type
		ls_connects = record
			interim_name_data :string[15];
			interim_name_data_connect :byte;
		end;

	var
		f_ls_connects :file of ls_connects;
		interim_ls_connects :ls_connects;

	begin
		assign(f_ls_connects, 'list connects');
		quantity_name_data := 0;
		reset(f_ls_connects);
		while not eof(f_ls_connects) do
			begin
				read(f_ls_connects, interim_ls_connects);
				name_data[quantity_name_data] := interim_ls_connects.interim_name_data;
				name_data_connect[quantity_name_data] := interim_ls_connects.interim_name_data_connect;
				quantity_name_data := quantity_name_data + 1;
			end;
		close(f_ls_connects);
	end;

procedure visualisation_table;
	begin
		assign(fdate, 'connects/' + name_data[selected_position_data_files]);
		reset(fdate);
		quantity_records := 0;
		while not eof(fdate) do
			begin
				quantity_records := quantity_records + 1;
				read(fdate, table[quantity_records]);
				visible_table[quantity_records] := true;
			end;
		close(fdate);
	end;
	
procedure save;
	begin
		assign(fdate, 'connects/' + name_data[previos_position_data_files_connected]);
		rewrite(fdate);
		for i := 1 to quantity_records do
			begin
				if visible_table[i] then
					write(fdate, table[i]);
			end;
		close(fdate);
	end;

procedure decrypt_table(var interim_word :string);
	var
		number_symbol, interim_j, interim_i, len_interim_word, interim_quantity_symbol :byte;
		interim_ord :integer;

	begin
		//mark :string[13];
		//colour :string[10];
		//serial_and_board_numbers :string[14];
		//release_date :string[8];
		//design_features :string[13];
		//date_inspection :string[13];
		//passport_data :string[20];

		flag_false_password := false;
		len_interim_word := length(interim_word);
		number_symbol := 0;

		for interim_j := 1 to quantity_records do
			begin
				if visible_table[interim_j] then
					begin
						
						interim_ord := ord(table[interim_j].mark[0]) + (256 - ord(interim_word[number_symbol + 1]));
						interim_ord := interim_ord mod 256;
						table[interim_j].mark[0] := chr(interim_ord);
						number_symbol := number_symbol + 1;
						number_symbol := number_symbol mod len_interim_word;

						if length(table[interim_j].mark) > 13 then
							begin
								flag_false_password := true;
								exit;
							end;

						for interim_i := 1 to length(table[interim_j].mark) do
							begin
								interim_ord := ord(table[interim_j].mark[interim_i]) + (256 - ord(interim_word[number_symbol + 1]));
								interim_ord := interim_ord mod 256;
								table[interim_j].mark[interim_i] := chr(interim_ord);

								number_symbol := number_symbol + 1;
								number_symbol := number_symbol mod len_interim_word;
							end;

						interim_ord := ord(table[interim_j].colour[0]) + (256 - ord(interim_word[number_symbol + 1]));
						interim_ord := interim_ord mod 256;
						table[interim_j].colour[0] := chr(interim_ord);
						number_symbol := number_symbol + 1;
						number_symbol := number_symbol mod len_interim_word;

						if length(table[interim_j].colour) > 10 then
							begin
								flag_false_password := true;
								exit;
							end;

						for interim_i := 1 to length(table[interim_j].colour) do
							begin
								interim_ord := ord(table[interim_j].colour[interim_i]) + (256 - ord(interim_word[number_symbol + 1]));
								interim_ord := interim_ord mod 256;
								table[interim_j].colour[interim_i] := chr(interim_ord);

								number_symbol := number_symbol + 1;
								number_symbol := number_symbol mod len_interim_word;
							end;

						interim_ord := ord(table[interim_j].serial_and_board_numbers[0]) + (256 - ord(interim_word[number_symbol + 1]));
						interim_ord := interim_ord mod 256;
						table[interim_j].serial_and_board_numbers[0] := chr(interim_ord);
						number_symbol := number_symbol + 1;
						number_symbol := number_symbol mod len_interim_word;

						if length(table[interim_j].serial_and_board_numbers) > 14 then
							begin
								flag_false_password := true;
								exit;
							end;

						for interim_i := 1 to length(table[interim_j].serial_and_board_numbers) do
							begin
								interim_ord := ord(table[interim_j].serial_and_board_numbers[interim_i]) + (256 - ord(interim_word[number_symbol + 1]));
								interim_ord := interim_ord mod 256;
								table[interim_j].serial_and_board_numbers[interim_i] := chr(interim_ord);

								number_symbol := number_symbol + 1;
								number_symbol := number_symbol mod len_interim_word;
							end;

						interim_ord := ord(table[interim_j].release_date[0]) + (256 - ord(interim_word[number_symbol + 1]));
						interim_ord := interim_ord mod 256;
						table[interim_j].release_date[0] := chr(interim_ord);
						number_symbol := number_symbol + 1;
						number_symbol := number_symbol mod len_interim_word;

						if length(table[interim_j].release_date) > 8 then
							begin
								flag_false_password := true;
								exit;
							end;

						for interim_i := 1 to length(table[interim_j].release_date) do
							begin
								interim_ord := ord(table[interim_j].release_date[interim_i]) + (256 - ord(interim_word[number_symbol + 1]));
								interim_ord := interim_ord mod 256;
								table[interim_j].release_date[interim_i] := chr(interim_ord);

								number_symbol := number_symbol + 1;
								number_symbol := number_symbol mod len_interim_word;
							end;

						interim_ord := ord(table[interim_j].design_features[0]) + (256 - ord(interim_word[number_symbol + 1]));
						interim_ord := interim_ord mod 256;
						table[interim_j].design_features[0] := chr(interim_ord);
						number_symbol := number_symbol + 1;
						number_symbol := number_symbol mod len_interim_word;

						if length(table[interim_j].design_features) > 13 then
							begin
								flag_false_password := true;
								exit;
							end;

						for interim_i := 1 to length(table[interim_j].design_features) do
							begin
								interim_ord := ord(table[interim_j].design_features[interim_i]) + (256 - ord(interim_word[number_symbol + 1]));
								interim_ord := interim_ord mod 256;
								table[interim_j].design_features[interim_i] := chr(interim_ord);

								number_symbol := number_symbol + 1;
								number_symbol := number_symbol mod len_interim_word;
							end;

						interim_ord := ord(table[interim_j].date_inspection[0]) + (256 - ord(interim_word[number_symbol + 1]));
						interim_ord := interim_ord mod 256;
						table[interim_j].date_inspection[0] := chr(interim_ord);
						number_symbol := number_symbol + 1;
						number_symbol := number_symbol mod len_interim_word;

						if length(table[interim_j].date_inspection) > 13 then
							begin
								flag_false_password := true;
								exit;
							end;

						for interim_i := 1 to length(table[interim_j].date_inspection) do
							begin
								interim_ord := ord(table[interim_j].date_inspection[interim_i]) + (256 - ord(interim_word[number_symbol + 1]));
								interim_ord := interim_ord mod 256;
								table[interim_j].date_inspection[interim_i] := chr(interim_ord);

								number_symbol := number_symbol + 1;
								number_symbol := number_symbol mod len_interim_word;
							end;

						interim_ord := ord(table[interim_j].passport_data[0]) + (256 - ord(interim_word[number_symbol + 1]));
						interim_ord := interim_ord mod 256;
						table[interim_j].passport_data[0] := chr(interim_ord);
						number_symbol := number_symbol + 1;
						number_symbol := number_symbol mod len_interim_word;

						if length(table[interim_j].date_inspection) > 20 then
							begin
								flag_false_password := true;
								exit;
							end;

						for interim_i := 1 to length(table[interim_j].passport_data) do
							begin
								interim_ord := ord(table[interim_j].passport_data[interim_i]) + (256 - ord(interim_word[number_symbol + 1]));
								interim_ord := interim_ord mod 256;
								table[interim_j].passport_data[interim_i] := chr(interim_ord);

								number_symbol := number_symbol + 1;
								number_symbol := number_symbol mod len_interim_word;
							end;

					end;
			end;
	end;

procedure encrypt_table(var interim_word :string);
	var
		number_symbol, interim_j, interim_i, len_interim_word :byte;
		interim_ord :integer;

	begin
		//mark :string[13];
		//colour :string[10];
		//serial_and_board_numbers :string[14];
		//release_date :string[8];
		//design_features :string[13];
		//date_inspection :string[13];
		//passport_data :string[20];

		len_interim_word := length(interim_word);
		number_symbol := 0;

		for interim_j := 1 to quantity_records do
			begin
				if visible_table[interim_j] then
					begin

						for interim_i := 0 to length(table[interim_j].mark) do
							begin
								interim_ord := ord(table[interim_j].mark[interim_i]) + ord(interim_word[number_symbol + 1]);
								interim_ord := interim_ord mod 256;
								table[interim_j].mark[interim_i] := chr(interim_ord);

								number_symbol := number_symbol + 1;
								number_symbol := number_symbol mod len_interim_word;
							end;

						for interim_i := 0 to length(table[interim_j].colour) do
							begin
								interim_ord := ord(table[interim_j].colour[interim_i]) + ord(interim_word[number_symbol + 1]);
								interim_ord := interim_ord mod 256;
								table[interim_j].colour[interim_i] := chr(interim_ord);

								number_symbol := number_symbol + 1;
								number_symbol := number_symbol mod len_interim_word;
							end;

						for interim_i := 0 to length(table[interim_j].serial_and_board_numbers) do
							begin
								interim_ord := ord(table[interim_j].serial_and_board_numbers[interim_i]) + ord(interim_word[number_symbol + 1]);
								interim_ord := interim_ord mod 256;
								table[interim_j].serial_and_board_numbers[interim_i] := chr(interim_ord);

								number_symbol := number_symbol + 1;
								number_symbol := number_symbol mod len_interim_word;
							end;

						for interim_i := 0 to length(table[interim_j].release_date) do
							begin
								interim_ord := ord(table[interim_j].release_date[interim_i]) + ord(interim_word[number_symbol + 1]);
								interim_ord := interim_ord mod 256;
								table[interim_j].release_date[interim_i] := chr(interim_ord);

								number_symbol := number_symbol + 1;
								number_symbol := number_symbol mod len_interim_word;
							end;

						for interim_i := 0 to length(table[interim_j].design_features) do
							begin
								interim_ord := ord(table[interim_j].design_features[interim_i]) + ord(interim_word[number_symbol + 1]);
								interim_ord := interim_ord mod 256;
								table[interim_j].design_features[interim_i] := chr(interim_ord);

								number_symbol := number_symbol + 1;
								number_symbol := number_symbol mod len_interim_word;
							end;

						for interim_i := 0 to length(table[interim_j].date_inspection) do
							begin
								interim_ord := ord(table[interim_j].date_inspection[interim_i]) + ord(interim_word[number_symbol + 1]);
								interim_ord := interim_ord mod 256;
								table[interim_j].date_inspection[interim_i] := chr(interim_ord);

								number_symbol := number_symbol + 1;
								number_symbol := number_symbol mod len_interim_word;
							end;

						for interim_i := 0 to length(table[interim_j].passport_data) do
							begin
								interim_ord := ord(table[interim_j].passport_data[interim_i]) + ord(interim_word[number_symbol + 1]);
								interim_ord := interim_ord mod 256;
								table[interim_j].passport_data[interim_i] := chr(interim_ord);

								number_symbol := number_symbol + 1;
								number_symbol := number_symbol mod len_interim_word;
							end;

					end;
			end;
	end;

procedure animation_start_navigation;
	begin
		textcolor(0);
		for i := 1 to 120 do
			begin
				for j := 1 to 3 do
					begin
						gotoxy(i, 2);
						write(chr(149));
						gotoxy(121 - i, 29);
						write(chr(149));
					end;
			end;
	end;

procedure animation_exit_navigation;
	begin
		window(1, 1, 120, 30);
		for i := 1 to 120 do
			begin
				for j := 1 to 3 do
					begin
						gotoxy(121 - i, 2);
						write(' ');
						gotoxy(i, 29);
						write(' ');
					end;
			end;
	end;

procedure animation_navigation_enter(str :string; speed :byte);
	begin
	if word_previous_navigation <> str then
		begin
			window(1, 1, 120, 30);

			textcolor(0);

			for i := 1 to length(str) + 2 do
			begin
				for j := 1 to speed do
				begin
					window(1, 2, i, 2);
					write(' ', str, ' ');
				end;
			end;

			for i := 1 to 20 do
			begin
				for j := 1 to speed + 1 do
				begin
					window(i, 2, i + length(str) + 2, 2);
					write(chr(149), ' ', str, ' ');
				end;
			end;

			word_previous_navigation := str;
			textcolor(text_color_main);
			textbackground(text_background_main);
			window(1, 4, 120, 26);
		end;
	end;

procedure animation_navigation_out(speed :shortint);
	begin
		window(1, 1, 120, 30);

		textcolor(0);

		if speed > 0 then
		begin
			for i := 20 to 120 - length(word_previous_navigation) + 2 do
			begin
				for j := 1 to speed do
				begin
					window(i, 2, i + length(word_previous_navigation) + 2, 2);
					write(chr(149), ' ', word_previous_navigation, ' ');
				end;
			end;

			for i := 120 - length(word_previous_navigation) - 1 to 120 do
			begin
				for j := 1 to speed * 10 do
				begin
					window(i, 2, i, 2);
					write(chr(149));
				end;
			end;
		end;

		if speed < 0 then
		begin
			for i := 20 downto 1 do
			begin
				for j := 1 to -1 * speed do
				begin
					window(i, 2, i + length(word_previous_navigation) + 2, 2);
					write(' ', word_previous_navigation, ' ', chr(149));
				end;
			end;

			for i := length(word_previous_navigation) + 2 downto 1 do
			begin
				for j := 1 to -1 * speed * 3 do
				begin
					window(i, 2, i, 2);
					write(chr(149));
				end;
			end;
		end;

		textcolor(text_color_main);
		textbackground(text_background_main);
		window(1, 4, 120, 26);
		clrscr;
	end;

procedure determine_data_files;
	begin
		if key_test = chr(0) then
			begin
				flag_key_chr_zero := true;
				exit;
			end;


		if flag_key_chr_zero then
			begin
				flag_key_determine_data_files := true;
				previos_position_data_files := selected_position_data_files;

				case key_test of
					'1', '2', '3', '4', '5', '6', '7', '8', '9':
						begin
							selected_position_data_files := ord(key_test) - 49;
						end;
					'P':
						begin
							selected_position_data_files :=selected_position_data_files + 1;
							selected_position_data_files :=selected_position_data_files mod quantity_name_data;
						end;
					'H':
						begin
							selected_position_data_files :=selected_position_data_files - 1;
							selected_position_data_files :=selected_position_data_files mod quantity_name_data;
							if selected_position_data_files = -1 then selected_position_data_files := quantity_name_data - 1;
						end;
				else flag_key_determine_data_files := false;
				end;

				flag_key_chr_zero := false;
			end;

	end;

procedure show_data_files;
	begin
		window(1, 6, 120, 26);

		textcolor(text_color_main);
		textbackground(text_background_main);

		for i := 0 to quantity_name_data - 1 do
			begin
				gotoxy(8, i + 1);
				write(name_data[i],'':20 - length(name_data[i]));
				if name_data_connect[i] = 0 then write('   Open   ');
				if name_data_connect[i] = 1 then write('  Secured ');
			end;
	end;

procedure show_data_files_move;
	begin
		window(1, 6, 120, 26);

		textbackground(text_background_main);

		textcolor(text_color_main);
		gotoxy(8, previos_position_data_files + 1);
		write(name_data[previos_position_data_files],'':20 - length(name_data[previos_position_data_files]));
		if name_data_connect[previos_position_data_files] = 0 then write('   Open   ');
		if name_data_connect[previos_position_data_files] = 1 then write('  Secured ');

		textcolor(text_color_main_selection);
		gotoxy(8, selected_position_data_files + 1);
		write(name_data[selected_position_data_files],'':20 - length(name_data[selected_position_data_files]));
		if name_data_connect[selected_position_data_files] = 0 then write('   Open   ');
		if name_data_connect[selected_position_data_files] = 1 then write('  Secured ');

		textcolor(text_color_main);
	end;

function write_password(name :string; min_len, max_len :byte):string;
	var
		str, interim_key_test :string;
		//chr_0 :boolean;
		interim_x, interim_y :byte;
		interim_r, interim_r_order, interim_1, interim_2 :longint;

	begin
		//window(1, 4, 120, 26);
		interim_x := wherex + length(name) + 5;
		interim_y := wherey;

		write('':3,name,': ');
		str := '';
		//cursoron;

		interim_1 := 1;
		interim_2 := 0;

		while true do
		begin
			while true do
				begin
					repeat
						if length(str) < min_len then textcolor(12)
						else textcolor(2);

						j := 25;
						
						if interim_1 <> 0 then
							begin
								gotoxy(65 + interim_1, interim_y + 1);
								write('-');
								delay(j);

								interim_1 := interim_1 + 1;

								if interim_1 = 16 then
									begin
										interim_1 := 0;
										interim_2 := 1;
									end;
							end;
						if interim_2 <> 0 then
							begin
								gotoxy(65 + interim_2, interim_y + 1);
								write('=');
								delay(j);
									
								interim_2 := interim_2 + 1;

								if interim_2 = 16 then
									begin
										interim_2 := 0;
										interim_1 := 1;
									end;
							end;

						//cursoron;
						textcolor(1);
				until keypressed;

				interim_key_test := readkey;

				if interim_key_test = chr(0) then
					begin
						flag_key_chr_zero := true;
						continue;
					end;

				if flag_key_chr_zero = false then
					begin
						if interim_key_test = chr(27) then
							begin
								//cursoroff;
								flag_set_password_data_files := false;
								gotoxy(66, interim_y + 1);
								write('':16);
								write_password := str;
								exit;
							end;
						if interim_key_test = chr(13) then
							begin
								if length(str) >= min_len then
									begin
										//writeln;
										//cursoroff;
										flag_set_password_data_files := true;
										gotoxy(66, interim_y + 1);
										write('':16);
										write_password := str;
										exit;
									end;
							end;
						if interim_key_test = chr(8) then
							begin
								if length(str) > 0 then
									begin
										gotoxy(interim_x, interim_y);
										write(chr(8));
										textcolor(8);
										write('|');
										textcolor(1);
										write(chr(8));
										delete(str, length(str), 1);

										interim_x := interim_x - 1;
									end;
							end
						else
							begin
								if length(str) <= max_len then
									begin
										case interim_key_test of
										'0'..'9', 'A'..'Z', 'a'..'z', ' ', '-', '~', '!', '@', '#', '$', '%', '^', '&', '(', ')', '_', '=', '[', ']', '|':
											begin
												gotoxy(interim_x, interim_y);
												//cursoroff;
														write(interim_key_test);
														//delay(150);

														for i := 1 to 4 do
															begin
																if length(str) < min_len then textcolor(12)
																else textcolor(2);

																j := 25;
																
																if interim_1 <> 0 then
																	begin
																		gotoxy(65 + interim_1, interim_y + 1);
																		write('-');
																		delay(j);

																		interim_1 := interim_1 + 1;

																		if interim_1 = 16 then
																			begin
																				interim_1 := 0;
																				interim_2 := 1;
																			end;
																	end;
																if interim_2 <> 0 then
																	begin
																		gotoxy(65 + interim_2, interim_y + 1);
																		write('=');
																		delay(j);
																			
																		interim_2 := interim_2 + 1;

																		if interim_2 = 16 then
																			begin
																				interim_2 := 0;
																				interim_1 := 1;
																			end;
																	end;
																textcolor(1);
															end;

														gotoxy(interim_x, interim_y);

														//write(chr(8));
												//cursoron;
												write(interim_key_test);
												write(chr(8));
												write('*');
												str := str + interim_key_test;
												interim_x := interim_x + 1;
											end;
										end;
									end;
							end;
					end;
					flag_key_chr_zero := false;

				end;
		end;
	end;

procedure animation_start_write_password_data_files;
	var
		interim_str :string;

	begin
		interim_str := '';
		for i := 1 to 17 do
			begin
				interim_str := interim_str + '|';
				delay(5);
				gotoxy(47, selected_position_data_files + 1);
				write('':i, interim_str, '':25 - i);
			end;
	end;

procedure animation_out_write_password_data_files;
	var
		interim_str :string;

	begin
		interim_str := '||||||||||||||||';
		for i := 1 to 17 do
			begin
				delay(5);
				gotoxy(65, selected_position_data_files + 1);
				write('':i * 2, interim_str);
				delete(interim_str, length(interim_str) - 1 , 1);
			end;
			gotoxy(wherex - 1, selected_position_data_files + 1);
			write(' ');
	end;

procedure set_connected;
	begin
		textbackground(text_background_main);
		textcolor(8);

		//flag_key_chr_zero := false;

		if name_data_connect[selected_position_data_files] = 0 then
			begin
				j := 15;

				for i := 1 to j do
					begin
						gotoxy(38, previos_position_data_files_connected + 1);
						write('':4, 'Connected');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, previos_position_data_files_connected + 1);
						write('':4, '|onnecte|');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, previos_position_data_files_connected + 1);
						write('':4, '||nnect||');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, previos_position_data_files_connected + 1);
						write('':4, '|||nec|||');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, previos_position_data_files_connected + 1);
						write('':4, '||||e||||');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, previos_position_data_files_connected + 1);
						write('':4, '|||||||||');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, previos_position_data_files_connected + 1);
						write('':4, ' ||||||| ');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, previos_position_data_files_connected + 1);
						write('':4, '  |||||  ');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, previos_position_data_files_connected + 1);
						write('':4, '  |||||  ');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, previos_position_data_files_connected + 1);
						write('':4, '   |||   ');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, previos_position_data_files_connected + 1);
						write('':4, '    |    ');
					end;	
				for i := 1 to j do
					begin
						gotoxy(38, previos_position_data_files_connected + 1);
						write('':4, '          ');
					end;	

				for i := 1 to j do
					begin
						gotoxy(38, selected_position_data_files + 1);
						write('':4, '         ');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, selected_position_data_files + 1);
						write('':4, '    |    ');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, selected_position_data_files + 1);
						write('':4, '   |||   ');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, selected_position_data_files + 1);
						write('':4, '  |||||  ');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, selected_position_data_files + 1);
						write('':4, ' |||||||| ');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, selected_position_data_files + 1);
						write('':4, '|||||||||');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, selected_position_data_files + 1);
						write('':4, '|||||||||');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, selected_position_data_files + 1);
						write('':4, '||||e||||');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, selected_position_data_files + 1);
						write('':4, '|||nec|||');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, selected_position_data_files + 1);
						write('':4, '||nnect||');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, selected_position_data_files + 1);
						write('':4, '|onnecte|');
					end;	
				for i := 1 to j do
					begin
						gotoxy(38, selected_position_data_files + 1);
						write('':4, 'Connected');
					end;

				//if name_data_connect[previos_position_data_files_connected] = 1 then encrypt_table(password_data_file);
				//save;

				if name_data_connect[previos_position_data_files_connected] = 1 then
					begin
						if flag_false_password = false then
							encrypt_table(password_data_file);
					end
				else
					flag_false_password := false;

				if flag_false_password = false then
					save;
				previos_position_data_files_connected := selected_position_data_files;
				visualisation_table;
				if name_data_connect[previos_position_data_files_connected] = 1 then decrypt_table(password_data_file);
			end;

		if name_data_connect[selected_position_data_files] = 1 then
			begin
				
				for i := 1 to j do
					begin
						gotoxy(38, previos_position_data_files_connected + 1);
						write('':4, 'Connected');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, previos_position_data_files_connected + 1);
						write('':4, '|onnecte|');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, previos_position_data_files_connected + 1);
						write('':4, '||nnect||');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, previos_position_data_files_connected + 1);
						write('':4, '|||nec|||');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, previos_position_data_files_connected + 1);
						write('':4, '||||e||||');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, previos_position_data_files_connected + 1);
						write('':4, '|||||||||');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, previos_position_data_files_connected + 1);
						write('':4, ' ||||||| ');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, previos_position_data_files_connected + 1);
						write('':4, '  |||||  ');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, previos_position_data_files_connected + 1);
						write('':4, '  |||||  ');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, previos_position_data_files_connected + 1);
						write('':4, '   |||   ');
					end;
				for i := 1 to j do
					begin
						gotoxy(38, previos_position_data_files_connected + 1);
						write('':4, '    |    ');
					end;	
				for i := 1 to j do
					begin
						gotoxy(38, previos_position_data_files_connected + 1);
						write('':4, '          ');
					end;	

				animation_start_write_password_data_files;

				//textcolor(1);
				gotoxy(47, selected_position_data_files + 1);
				//while true do
					//begin
						//repeat
							//write(1);
						//until keypressed;
						
						//var_word := readkey;
						//write(var_word);

						//write(0);

						//if (var_word = chr(13)) or (var_word = chr(27)) then break;
					//end;

				textcolor(1);
				password_data_file := write_password('Enter password', 6, 14);
				gotoxy(47, selected_position_data_files + 1);
				write('                                   ');
				textcolor(8);

				animation_out_write_password_data_files;

				if flag_set_password_data_files then
					begin
						j := 15;

						for i := 1 to j do
							begin
								gotoxy(38, selected_position_data_files + 1);
								write('':4, '         ');
							end;
						for i := 1 to j do
							begin
								gotoxy(38, selected_position_data_files + 1);
								write('':4, '    |    ');
							end;
						for i := 1 to j do
							begin
								gotoxy(38, selected_position_data_files + 1);
								write('':4, '   |||   ');
							end;
						for i := 1 to j do
							begin
								gotoxy(38, selected_position_data_files + 1);
								write('':4, '  |||||  ');
							end;
						for i := 1 to j do
							begin
								gotoxy(38, selected_position_data_files + 1);
								write('':4, ' |||||||| ');
							end;
						for i := 1 to j do
							begin
								gotoxy(38, selected_position_data_files + 1);
								write('':4, '|||||||||');
							end;
						for i := 1 to j do
							begin
								gotoxy(38, selected_position_data_files + 1);
								write('':4, '|||||||||');
							end;
						for i := 1 to j do
							begin
								gotoxy(38, selected_position_data_files + 1);
								write('':4, '||||e||||');
							end;
						for i := 1 to j do
							begin
								gotoxy(38, selected_position_data_files + 1);
								write('':4, '|||nec|||');
							end;
						for i := 1 to j do
							begin
								gotoxy(38, selected_position_data_files + 1);
								write('':4, '||nnect||');
							end;
						for i := 1 to j do
							begin
								gotoxy(38, selected_position_data_files + 1);
								write('':4, '|onnecte|');
							end;	
						for i := 1 to j do
							begin
								gotoxy(38, selected_position_data_files + 1);
								write('':4, 'Connected');
							end;

						//if name_data_connect[previos_position_data_files_connected] = 1 then encrypt_table(password_data_file);
						//save;

						if name_data_connect[previos_position_data_files_connected] = 1 then
							begin
								if flag_false_password = false then
									encrypt_table(password_data_file);
							end
						else
							flag_false_password := false;

						if flag_false_password = false then
							save;

						previos_position_data_files_connected := selected_position_data_files;
						visualisation_table;
						if name_data_connect[previos_position_data_files_connected] = 1 then decrypt_table(password_data_file);

					end
				else 
					begin
						j := 15;

						for i := 1 to j do
							begin
								gotoxy(38, previos_position_data_files_connected + 1);
								write('':4, '         ');
							end;
						for i := 1 to j do
							begin
								gotoxy(38, previos_position_data_files_connected + 1);
								write('':4, '    |    ');
							end;
						for i := 1 to j do
							begin
								gotoxy(38, previos_position_data_files_connected + 1);
								write('':4, '   |||   ');
							end;
						for i := 1 to j do
							begin
								gotoxy(38, previos_position_data_files_connected + 1);
								write('':4, '  |||||  ');
							end;
						for i := 1 to j do
							begin
								gotoxy(38, previos_position_data_files_connected + 1);
								write('':4, ' |||||||| ');
							end;
						for i := 1 to j do
							begin
								gotoxy(38, previos_position_data_files_connected + 1);
								write('':4, '|||||||||');
							end;
						for i := 1 to j do
							begin
								gotoxy(38, previos_position_data_files_connected + 1);
								write('':4, '|||||||||');
							end;
						for i := 1 to j do
							begin
								gotoxy(38, previos_position_data_files_connected + 1);
								write('':4, '||||e||||');
							end;
						for i := 1 to j do
							begin
								gotoxy(38, previos_position_data_files_connected + 1);
								write('':4, '|||nec|||');
							end;
						for i := 1 to j do
							begin
								gotoxy(38, previos_position_data_files_connected + 1);
								write('':4, '||nnect||');
							end;
						for i := 1 to j do
							begin
								gotoxy(38, previos_position_data_files_connected + 1);
								write('':4, '|onnecte|');
							end;	
						for i := 1 to j do
							begin
								gotoxy(38, previos_position_data_files_connected + 1);
								write('':4, 'Connected');
							end;
					end;

			end;

		//previos_position_data_files_connected := selected_position_data_files;

		//write(chr(124));

		textcolor(text_color_main);
	end;

procedure show_selected_connected_enter;
	begin
		j := 15;

		for i := 1 to j do
			begin
				gotoxy(38, selected_position_data_files + 1);
				write('':4, '         ');
			end;
		for i := 1 to j do
			begin
				gotoxy(38, selected_position_data_files + 1);
				write('':4, '    |    ');
			end;
		for i := 1 to j do
			begin
				gotoxy(38, selected_position_data_files + 1);
				write('':4, '   |||   ');
			end;
		for i := 1 to j do
			begin
				gotoxy(38, selected_position_data_files + 1);
				write('':4, '  |||||  ');
			end;
		for i := 1 to j do
			begin
				gotoxy(38, selected_position_data_files + 1);
				write('':4, ' |||||||| ');
			end;
		for i := 1 to j do
			begin
				gotoxy(38, selected_position_data_files + 1);
				write('':4, '|||||||||');
			end;
		for i := 1 to j do
			begin
				gotoxy(38, selected_position_data_files + 1);
				write('':4, '|||||||||');
			end;
		for i := 1 to j do
			begin
				gotoxy(38, selected_position_data_files + 1);
				write('':4, '||||e||||');
			end;
		for i := 1 to j do
			begin
				gotoxy(38, selected_position_data_files + 1);
				write('':4, '|||nec|||');
			end;
		for i := 1 to j do
			begin
				gotoxy(38, selected_position_data_files + 1);
				write('':4, '||nnect||');
			end;
		for i := 1 to j do
			begin
				gotoxy(38, selected_position_data_files + 1);
				write('':4, '|onnecte|');
			end;	
		for i := 1 to j do
			begin
				gotoxy(38, selected_position_data_files + 1);
				write('':4, 'Connected');
			end;
	end;

procedure data_files;
	begin
		animation_navigation_enter('Home/Data files', 1);

		window(1, 4, 120, 26);
		textbackground(7);
		textcolor(1);
		gotoxy(1, 1);
		write('':7, 'Name of file');
		write('':10, 'Status');

		//selected_position_data_files := 0;
		flag_key_chr_zero := false;

		//------------------------------------------
		selected_position_data_files := previos_position_data_files_connected;
		//-------------------------------------------

		show_data_files;
		show_data_files_move;

		//-------------------------------------------
		textcolor(8);
		show_selected_connected_enter;
		textcolor(1);
		//-------------------------------------------

		while true do
			begin
				key_test := readkey;
				if key_test = chr(13) then set_connected;
				if key_test = chr(27) then break;

				determine_data_files;

				if flag_key_determine_data_files then show_data_files_move;
			end;

		animation_navigation_out(-1);
	end;

procedure show_main_menu;
	begin
		window(10, 5, 30, 12);

        if key = '1' then textcolor(text_color_main_selection)
		else textcolor(text_color_main);
		writeln('Search');
		if key = '2' then textcolor(text_color_main_selection)
		else textcolor(text_color_main);
		writeln('Add note');
		if key = '3' then textcolor(text_color_main_selection)
		else textcolor(text_color_main);
		writeln('Edit');
		if key = '4' then textcolor(text_color_main_selection)
		else textcolor(text_color_main);
		writeln('Show all note');
		if key = '5' then textcolor(text_color_main_selection)
		else textcolor(text_color_main);
		writeln('Data files');
		writeln;
		if key = chr(27) then textcolor(text_color_main_selection)
		else textcolor(text_color_main);
		writeln('Exit');
	end;

procedure table_header;
	var space :byte;

	begin
		space := 2;

		write('':space, 'Mark','':13 - length('Mark'));
		write('':space, 'Colour','':10 - length('Colour'));
		write('':space, 'Serial numbers','':14 - length('Serial numbers'));
		write('':space, 'Release date','':12 - length('Release date'));
		write('':space, 'Design features','':15 - length('Design features'));
		write('':space, 'Date inspection','':15 - length('Date inspection'));
		write('':space, 'Passport data','':20 - length('Passport data'));
		writeln;
	end;

procedure write_list(number :byte);
	var space :byte;

	begin
		space := 2;

		write('':space, table[number].mark,'':13 - length(table[number].mark));
		write('':space, table[number].colour,'':10 - length(table[number].colour));
		write('':space, table[number].serial_and_board_numbers,'':14 - length(table[number].serial_and_board_numbers));
		write('':space, table[number].release_date,'':12 - length(table[number].release_date));
		write('':space, table[number].design_features,'':15 - length(table[number].design_features));
		write('':space, table[number].date_inspection,'':15 - length(table[number].date_inspection));
		write('':space, table[number].passport_data,'':20 - length(table[number].passport_data));
		writeln;
	end;

function write_in(name :string; len :byte):string;
	var
		str :string;
		chr_0 :boolean;

	begin
		write('':3,name,': ');
		str := '';
		cursoron;

		while true do
		begin
			key_test := readkey;
			
			if key_test = chr(27) then
				begin
					cursoroff;
					flag_add_post := false;
					write_in := str;
					exit;
				end;
			if key_test = chr(13) then
				begin
					writeln;
					write_in := str;
					cursoroff;
					exit;
				end;
			if key_test = chr(8) then
				begin if length(str) > 0 then
					write(chr(8));
					write(chr(0));
					write(chr(8));
					delete(str, length(str), 1);
				end
			else
				begin
					if length(str) <= len then
						begin
							case key_test of
							'0'..'9', 'A'..'Z', 'a'..'z', ' ', '-':
								begin
									write(key_test);
									str := str + key_test;
								end;
							end;
						end;
				end;
		end;
	end;
	
procedure add_post;
	begin
		clrscr;
		animation_navigation_enter('Home/Create note', 2);

		quantity_records := quantity_records + 1;

		flag_add_post := true;

		if flag_add_post then table[quantity_records].mark := write_in('Mark', 13);
		if flag_add_post then table[quantity_records].colour := write_in('Colour', 10);
		if flag_add_post then table[quantity_records].serial_and_board_numbers := write_in('Serial and board numbers', 14);
		if flag_add_post then table[quantity_records].release_date := write_in('Release date', 8);
		if flag_add_post then table[quantity_records].design_features := write_in('Design features', 13);
		if flag_add_post then table[quantity_records].date_inspection := write_in('Date inspection', 13);
		if flag_add_post then table[quantity_records].passport_data := write_in('Passport data', 20);
		
		if flag_add_post then visible_table[quantity_records] := true
		else dec(quantity_records);

		animation_navigation_out(-1);
	end;

procedure determine_visible_table_sorted;
	begin
		if key_test = chr(0) then
		begin
			determinant_key := true;
			exit;
		end
		else determinant_key := false;

		edit_header := true;

		case key_test of
			'1', '2', '3', '4', '5', '6', '7':
				begin
					column_number := ord(key_test) - 49;
				end;
			'H', 'P':
				begin
					if order then order := false
					else order := true;
				end;
			'M':
				begin
					column_number := column_number + 1;
					column_number := column_number mod 7;
				end;
			'K':
				begin
					column_number := column_number - 1;
					column_number := column_number mod 7;
					if column_number = -1 then column_number := 6;
				end;
		else edit_header := false;
		end;

	end;

procedure show_table_header_sorted;
	begin
		window(1, 4, 120, 6);

	textcolor(text_color_main);
	case column_number_previos of
		0:
			begin
				gotoxy(7, 1);
				write(chr(0));
				write('Mark');
			end;
		1:
			begin
			 	gotoxy(22, 1);
			 	write(chr(0));
			 	write('Colour');
			end;
		2:
			begin
			 	gotoxy(34, 1);
			 	write(chr(0));
			 	write('Serial numbers');
			end;
		3:
			begin
				gotoxy(50, 1);
				write(chr(0));
				write('Release date');
			end;
		4:
			begin
				gotoxy(64, 1);
				write(chr(0));
				write('Design features');
			end;
		5:
			begin
				gotoxy(81, 1);
				write(chr(0));
				write('Date inspection');
			end;
		6:
			begin
				gotoxy(98, 1);
				write(chr(0));
				write('Passport data');
			end;
		end;

		textcolor(text_color_main_selection);
		case column_number of
		0:
			begin
				gotoxy(7, 1);
				if order then write('+') else write('-');
				write('Mark');
			end;
		1:
			begin
			 	gotoxy(22, 1);
			 	if order then write('+') else write('-');
			 	write('Colour');
			end;
		2:
			begin
			 	gotoxy(34, 1);
			 	if order then write('+') else write('-');
			 	write('Serial numbers');
			end;
		3:
			begin
				gotoxy(50, 1);
				if order then write('+') else write('-');
				write('Release date');
			end;
		4:
			begin
				gotoxy(64, 1);
				if order then write('+') else write('-');
				write('Design features');
			end;
		5:
			begin
				gotoxy(81, 1);
				if order then write('+') else write('-');
				write('Date inspection');
			end;
		6:
			begin
				gotoxy(98, 1);
				if order then write('+') else write('-');
				write('Passport data');
			end;
		end;

		column_number_previos := column_number;
	end;

procedure sorted_table;
	var
		free_ls :ls;

	begin

		//mark :string[13];
		//colour :string[10];
		//serial_and_board_numbers :string[14];
		//release_date :string[8];
		//design_features :string[13];
		//date_inspection :string[13];
		//passport_data :string[20];
		quantity_sorted_records := 0;
		for i := 1 to quantity_records do
		begin
			if visible_table[i] then
			begin
				quantity_sorted_records := quantity_sorted_records + 1;
				table_sorted[quantity_sorted_records] := table[i];
				//quantity_sorted_records := quantity_sorted_records + 1;
			end;
		end;

		case column_number of
			0:
				begin
					for i := 1 to quantity_sorted_records do
					begin
						for j := 1 to quantity_sorted_records - i do
						begin
							if table_sorted[j].mark > table_sorted[j + 1].mark then
							begin
								free_ls := table_sorted[j];
								table_sorted[j] := table_sorted[j + 1];
								table_sorted[j + 1] := free_ls;
							end;
						end;
					end;

				end;
			1:
				begin
					for i := 1 to quantity_sorted_records do
					begin
						for j := 1 to quantity_sorted_records - i do
						begin
							if table_sorted[j].colour > table_sorted[j + 1].colour then
							begin
								free_ls := table_sorted[j];
								table_sorted[j] := table_sorted[j + 1];
								table_sorted[j + 1] := free_ls;
							end;
						end;
					end;
				end;
			2:
				begin
					for i := 1 to quantity_sorted_records do
					begin
						for j := 1 to quantity_sorted_records - i do
						begin
							if table_sorted[j].serial_and_board_numbers > table_sorted[j + 1].serial_and_board_numbers then
							begin
								free_ls := table_sorted[j];
								table_sorted[j] := table_sorted[j + 1];
								table_sorted[j + 1] := free_ls;
							end;
						end;
					end;
				end;
			3:
				begin
					for i := 1 to quantity_sorted_records do
					begin
						for j := 1 to quantity_sorted_records - i do
						begin
							if table_sorted[j].release_date > table_sorted[j + 1].release_date then
							begin
								free_ls := table_sorted[j];
								table_sorted[j] := table_sorted[j + 1];
								table_sorted[j + 1] := free_ls;
							end;
						end;
					end;
				end;
			4:
				begin
					for i := 1 to quantity_sorted_records do
					begin
						for j := 1 to quantity_sorted_records - i do
						begin
							if table_sorted[j].design_features > table_sorted[j + 1].design_features then
							begin
								free_ls := table_sorted[j];
								table_sorted[j] := table_sorted[j + 1];
								table_sorted[j + 1] := free_ls;
							end;
						end;
					end;
				end;
			5:
				begin
					for i := 1 to quantity_sorted_records do
					begin
						for j := 1 to quantity_sorted_records - i do
						begin
							if table_sorted[j].date_inspection > table_sorted[j + 1].date_inspection then
							begin
								free_ls := table_sorted[j];
								table_sorted[j] := table_sorted[j + 1];
								table_sorted[j + 1] := free_ls;
							end;
						end;
					end;
				end;
			6:
				begin
					for i := 1 to quantity_sorted_records do
					begin
						for j := 1 to quantity_sorted_records - i do
						begin
							if table_sorted[j].passport_data > table_sorted[j + 1].passport_data then
							begin
								free_ls := table_sorted[j];
								table_sorted[j] := table_sorted[j + 1];
								table_sorted[j + 1] := free_ls;
							end;
						end;
					end;
				end;
		end;

		if order = false then
		begin
			for i := 1 to quantity_sorted_records do
				begin
					for j := 1 to quantity_sorted_records - i do
					begin
						free_ls := table_sorted[j];
						table_sorted[j] := table_sorted[j + 1];
						table_sorted[j + 1] := free_ls;
					end;
				end;
		end;

	end;

procedure show_table_sorted;
	var
		space :byte;

	begin
		window(1, 6, 120, 27);
		gotoxy(1, 1);
		textcolor(text_color_main);
		//write('You press key #13');

		sorted_table;
		clrscr;

		space := 2;

		//gotoxy(8, 1);
		//for i := 1 to quantity_sorted_records do

		//write(table_sorted[1].mark);

		for i := 1 to quantity_sorted_records do
		begin
			//write(i:5);
			//write_list(i);
			//writeln('':5, table_sorted[i]);

			write(i:5);

			write('':space, table_sorted[i].mark,'':13 - length(table_sorted[i].mark));
			write('':space, table_sorted[i].colour,'':10 - length(table_sorted[i].colour));
			write('':space, table_sorted[i].serial_and_board_numbers,'':14 - length(table_sorted[i].serial_and_board_numbers));
			write('':space, table_sorted[i].release_date,'':12 - length(table_sorted[i].release_date));
			write('':space, table_sorted[i].design_features,'':15 - length(table_sorted[i].design_features));
			write('':space, table_sorted[i].date_inspection,'':15 - length(table_sorted[i].date_inspection));
			write('':space, table_sorted[i].passport_data,'':20 - length(table_sorted[i].passport_data));
			writeln;

		end;

	end;

procedure show_all_post;
	begin
		animation_navigation_enter('Home/All notes', 2);

		column_number := 0;
		order := true;
		determinant_key := false;

		write('':1);
		write('':2 , 'N':2);
		table_header;
		show_table_header_sorted;
		//writeln;
		show_table_sorted;

		while true do
		begin
			key_test := readkey;
			if key_test = chr(13) then show_table_sorted;
			if key_test = chr(27) then break;

			determine_visible_table_sorted;

			if edit_header then show_table_header_sorted;
		end;

		//word_previous_navigation := '>>>>>>>>>';
		animation_navigation_out(-1);
	end;

procedure search;
	var
		flag_search, flag_search_all :boolean;

	begin
		animation_navigation_enter('Home/Search', 2);

		flag_add_post := true;

		while true do
			begin
			flag_search_all := false;

			gotoxy(1, 1);
			var_word :=  write_in('Search', 20);

			if not(flag_add_post) then break;

			word_previous_navigation := '>>>>>>>>>';
			animation_navigation_out(1);
			word_previous_navigation := '';
			animation_navigation_enter('Home/Search('+var_word+')', 1);

			clrscr;
			writeln;
			writeln;

			write('':2);
			write('  ','N':2);
			table_header;
			writeln;

			j := 0;

			for i := 1 to quantity_records do
			begin
				flag_search := false;
				if table[i].mark = var_word then flag_search := true;
				if table[i].colour = var_word then flag_search := true;
				if table[i].serial_and_board_numbers = var_word then flag_search := true;
				if table[i].release_date = var_word then flag_search := true;
				if table[i].design_features = var_word then flag_search := true;
				if table[i].date_inspection = var_word then flag_search := true;
				if table[i].passport_data = var_word then flag_search := true;

				if flag_search then flag_search_all := true;

				if flag_search then
				begin
					j := j + 1;
					write('':2);
					write('  ', j:2);
					write_list(i);
				end;
			end;
			if not(flag_search_all) then
			begin
				clrscr;
				gotoxy(1, 3);
				textcolor(4);
				write('':4, 'Not found');
				textcolor(text_color_main);
			end;
		end;

		animation_navigation_out(-1);
	end;


procedure show_table;
	begin
		animation_navigation_enter('Home/Edit', 2);

		writeln;
		write('  ');
		table_header;
		writeln;

		for i := 1 to quantity_records do
		begin
			if visible_table[i] then
			begin
				if i = numb then write('=>')
				else write('  ');
				write_list(i);
			end;
		end;

	end;

procedure determine_position_edit;
	begin
		flag_edit := true;
		case key_edit of
		'I','H':
			begin
				if numb = 1 then numb := quantity_records else dec(numb);
				while visible_table[numb] = false do
					if numb = 1 then numb := quantity_records else dec(numb);
			end;
		'Q','P':
			begin
				if numb = quantity_records then numb := 1 else inc(numb);
				while visible_table[numb] = false do
					if numb = quantity_records then numb := 1 else inc(numb);
			end;
		'S':
			begin
				if numb > 0 then
				begin
					animation_navigation_out(1);
					word_previous_navigation := '';
					animation_navigation_enter('Home/Edit', 2);
					visible_table[numb] := false;

					n := numb;
					if numb = quantity_records then numb := 1 else inc(numb);
					while visible_table[numb] = false do
					begin
						inc(numb);
						if numb > quantity_records then
						begin
							while visible_table[numb] = false do
							begin
								numb := numb - 1;
								if numb = 0 then break;
							end;
							if numb = 0 then break;
						end;
					end;
				end;
			end;
		chr(13): ;
		else flag_edit := false;
		end;
	end;

procedure edit_string;
	begin
		animation_navigation_enter('Home/Edit/Edit String', 1);

		write('   Old: ');
		write_list(numb);

		flag_add_post := true;

		writeln('   New Table: ');
		writeln;

		if flag_add_post then table[numb].mark := write_in('Mark', 13);
		if flag_add_post then table[numb].colour := write_in('Colour', 10);
		if flag_add_post then table[numb].serial_and_board_numbers := write_in('Serial numbers', 14);
		if flag_add_post then table[numb].release_date := write_in('Release date', 12);
		if flag_add_post then table[numb].design_features := write_in('Design features', 15);
		if flag_add_post then table[numb].date_inspection := write_in('Date inspection', 15);
		if flag_add_post then table[numb].passport_data := write_in('Passport data', 20);

		animation_navigation_out(1);
	end;

procedure edit;
	begin
		numb := 1;
		flag_edit := true;

		while (key_edit <> chr(27)) and (key_edit <> '8') do
		begin
			if flag_edit then show_table;

			gotoxy(1, 1);

			key_edit := readkey;
			determine_position_edit;

			if key_edit = chr(13) then
			begin
				animation_navigation_out(1);
				edit_string;
			end;
		end;

		key_edit := '0';

		animation_navigation_out(-1);
	end;

procedure menu_selection;
	begin
		case key of
			'1':
				begin
					animation_navigation_out(2);
					search;
				end;
			'2':
				begin
					animation_navigation_out(2);
					add_post;
				end;
			'3':
				begin
					animation_navigation_out(2);
					edit;
				end;
			'4':
				begin
					animation_navigation_out(2);
					show_all_post;
				end;
			'5':
				begin
					animation_navigation_out(2);
					data_files;
				end;
			chr(27):
				begin
					animation_navigation_out(-2);
					animation_exit_navigation;
					if name_data_connect[previos_position_data_files_connected] = 1 then
						begin
							if flag_false_password = false then
								encrypt_table(password_data_file);
						end
					else
						flag_false_password := false;

					if flag_false_password = false then
						save;
				end;
		end;
	end;
	
procedure determine_position;
	begin
		case key_test of
			'1','2','3','4','5',chr(27): key := key_test;
			'6': key := chr(27);
			'I','H':
				case key of
				'1': key := chr(27);
				'2': key := '1';
				'3': key := '2';
				'4': key := '3';
				'5': key := '4';
				chr(27): key := '5';
				end;
			'Q','P':
				case key of
				'1': key := '2';
				'2': key := '3';
				'3': key := '4';
				'4': key := '5';
				'5': key := chr(27);
				chr(27): key := '1';
				end;
		else flag_main_menu := false;
		end;
	end;

begin
	clrscr;
	cursoroff;
	textbackground(7);
	//animation_start_home;
	window(1, 1, 120, 30);
	clrscr;
	animation_start_navigation;

	previos_position_data_files_connected := 2;
	selected_position_data_files := 2;

	load_list_connect;
	visualisation_table;
	
	key_test := '1';
	key := '1';
	flag_main_menu := true;
	flag_add_post := true;
	text_background_main := 7; //7
	text_color_main := 1; //1
	text_color_main_selection := 9; //9, 0, 4 | 12, 2 | 10, 15
	word_previous_navigation := '';

	animation_navigation_enter('Home', 2);
	
	textbackground(text_background_main);
	textcolor(text_color_main);

	//window(10, 5, 30, 11);
	//textcolor(text_color_main_selection);
	//writeln('Search');
	//textcolor(text_color_main);
	//writeln('Add note');
	//writeln('Edit');
	//writeln('Show all note');
	//writeln;
	//writeln('Exit');

	//key_previos := '1'

    while true do
	begin
		if flag_main_menu then show_main_menu;
		
		key_test := readkey;
		flag_main_menu := true;
		
		if key_test = chr(13) then
		begin
			menu_selection;
			animation_navigation_enter('Home', 2);
		end
		else determine_position;

		if (key_test = chr(13)) and (key = chr(27)) then exit;
	end;


end.
