require 'csv'
require 'pg'
require 'pry'

class Contact

  attr_accessor :name, :email

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

    puts 'Creating contacts...'
    conn.exec_params('INSERT INTO contacts (name, email) VALUES ($1, $2);', [name, email])

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
      conn.exec('SELECT * FROM contacts;') do |results|
        results.each do |contact|
          puts contact.inspect
        end
      end

      puts 'Closing the connection...'
      conn.close

      puts 'DONE'
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
        else
          puts result.values.flatten!.inspect
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
