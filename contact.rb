require 'csv'
require 'pg'
require 'pry'

class Contact

  attr_accessor :id, :name, :email

  def initialize(name, email)
    @name = name
    @email = email
  end

  def save
    puts 'Connecting to the database...'
    conn = PG.connect(
    host: 'localhost',
    dbname: 'contacts',
    user: 'development',
    password: 'development'
    )
    # binding.pry
    if Contact.find(id) == "not found"
      puts 'Creating contacts...'
      conn.exec_params('INSERT INTO contacts (name, email) VALUES ($1, $2);', [name, email])
    else
      puts 'Updating contacts...'
      conn.exec_params('UPDATE contacts SET name = $1, email = $2 WHERE id = $3::int;', [name, email, id])
    end

    puts 'Closing the connection...'
    conn.close

    puts 'DONE'
  end

  def destroy
    puts 'Connecting to the database...'
    conn = PG.connect(
    host: 'localhost',
    dbname: 'contacts',
    user: 'development',
    password: 'development'
    )

    puts 'Destroying contact'
    conn.exec('DELETE FROM contacts WHERE id = $1::int;', [id])

    puts 'Closing the connection...'
    conn.close

    puts 'DONE'
  end

  class << self

    def all
      puts 'Connecting to the database...'
      conn = PG.connect(
      host: 'localhost',
      dbname: 'contacts',
      user: 'development',
      password: 'development'
      )

      puts 'Finding contacts...'
      a = []
      all = conn.exec('SELECT * FROM contacts;').each do |result|
        a << result
      end
      # binding.pry

      puts 'Closing the connection...'
      conn.close

      puts 'DONE'
      a
    end

    def update(id)
      the_contact = Contact.find(id)
      the_contact.name = new_name
      the_contact.email = new_email
      the_contact.save(new_name, new_email)
    end

    def create(name, email)
      create_contact = Contact.new(name, email)
      create_contact.save
      # new_person = [create_contact.name, create_contact.email]
      # CSV.open("contacts.csv", "a+") do |single|
      #   single << new_person
      # end
    end

    def find(id)
      puts 'Connecting to the database...'
      conn = PG.connect(
      host: 'localhost',
      dbname: 'contacts',
      user: 'development',
      password: 'development'
      )

      puts 'Looking up user with specified ID...'
      result = conn.exec_params('SELECT * FROM contacts WHERE id = $1::int;', [id])
      # binding.pry
        if result.values.empty?
          puts "not found"
          return "not found"
        else
          puts result.values.flatten!.inspect
          new_contact = result[0]
          # binding.pry
          contact = Contact.new(new_contact['name'],             new_contact['email'])
          contact.id = new_contact['id']
          return contact
          # return result.values.flatten!.inspect
        end

      puts 'Closing the connection...'
      conn.close

      puts 'DONE'
      # if CSV.read("contacts.csv")[id] == nil
      #   puts '"not found"'
      # else
      #   puts CSV.read("contacts.csv")[id]
      # end
    end

    def search(term)
      puts 'Connecting to the database...'
      conn = PG.connect(
      host: 'localhost',
      dbname: 'contacts',
      user: 'development',
      password: 'development'
      )

      puts 'Looking up user with specified string...'
      t = "%" + term + "%"
      result = conn.exec_params("SELECT * FROM contacts WHERE name LIKE $1;", [t])
      # binding.pry
      puts result.values

      puts 'Closing the connection...'
      conn.close

      puts 'DONE'
      # Contact.all.select do |contact| contact.name.downcase.include?(term)
      # end
    end
  end
end
