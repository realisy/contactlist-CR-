require_relative 'contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  puts "Here is a list of available commands:"
  puts "	new 	- Create a new contact"
  puts "	list 	- List all contacts"
  puts "	show 	- Show a contact"
  puts "	search 	- Search contacts"

usr_input = gets.chomp

	if usr_input == 'list'
		line_num = 0
		Contact.all.each do |person|
		line_num += 1
		puts "#{line_num}: #{person.name} (#{person.email})"
    end
		puts '---'
		puts "#{line_num} records total"
  elsif usr_input == 'new'
    puts "Please enter your full name"
    new_name = gets.chomp
    puts "Please enter your email address"
    new_email = gets.chomp
    Contact.create(new_name, new_email)
	elsif usr_input == 'show'
    puts "Enter user id"
    usr_id = gets.chomp
    id = usr_id.to_i
    Contact.find(id)
  else usr_input == 'search'
    search_term = gets.chomp
    contacts = Contact.search(search_term)
    puts contacts.inspect
    # binding.pry
    # contacts.each do |contact|
      # puts contact.name + " " + contact.email
    # end
  end

end
