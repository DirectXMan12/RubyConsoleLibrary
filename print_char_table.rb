def print_char_table
	(0..9).each do |n1|
		(0..9).each do |n2|
			eval 'puts \'\x'+n1.to_s+n2.to_s+'\' + "       \x' + n1.to_s + n2.to_s + '"'
		end
		('A'..'F').each do |n2|
			eval 'puts \'\x'+n1.to_s+n2.to_s+'\' + "       \x' + n1.to_s + n2.to_s + '"'
		end
	end

	('A'..'F').each do |n1|
		(0..9).each do |n2|
			eval 'puts \'\x'+n1+n2.to_s+'\' + "       \x' + n1.to_s + n2.to_s + '"'
		end
		('A'..'F').each do |n2|
			eval 'puts \'\x'+n1.to_s+n2.to_s+'\' + "       \x' + n1.to_s + n2.to_s + '"'
		end
	end
end
