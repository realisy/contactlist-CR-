require_relative 'contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  puts "Here is a list of available commands:"
  puts "	new 	- Create a new contact"
  puts "	list 	- List all contacts"
  puts "	show 	- Show a contact"
  puts "	search 	- Search contacts"
  puts "	update 	- Update contact"
  puts "	destroy	- Destroy contact"


usr_input = gets.chomp

	if usr_input == 'list'
    list = Contact.all
    # binding.pry
    line_num = 0
    list.each do |person|
      person.each do |info|
        info.inspect
      end
      line_num += 1
      puts "#{person['id']}: #{person['name']} - #{person['email']}"
    end
		puts '---'
		puts "#{line_num} records total"
    # binding.pry
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
  elsif usr_input == 'update'
    puts "Enter user id to update"
    usr_id = gets.chomp
    id = usr_id.to_i
    the_contact = Contact.find(id)
    # binding.pry
    if the_contact == "not found"
      puts "Please enter your full name"
      new_name = gets.chomp
      puts "Please enter your email address"
      new_email = gets.chomp
      Contact.create(new_name, new_email)
    else
      puts "Type your name"
      new_name = gets.chomp
      the_contact.name = new_name
      puts "Type your email"
      new_email = gets.chomp
      the_contact.email = new_email
      the_contact.save
    end
  elsif usr_input == 'search'
    search_term = gets.chomp
    contacts = Contact.search(search_term)
    puts contacts.inspect
    # binding.pry
    # contacts.each do |contact|
      # puts contact.name + " " + contact.email
    # end
  else usr_input == 'destroy'
    puts "Enter user id"
    usr_id = gets.chomp
    id = usr_id.to_i
    the_contact = Contact.find(id)
    the_contact.destroy
  end

end
