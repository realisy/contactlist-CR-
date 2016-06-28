require 'csv'

class Contact

  attr_accessor :name, :email

  def initialize(name, email)
    @name = name
    @email = email
  end


  class << self

    def all
      csv = Array.new
      CSV.foreach('contacts.csv') do |row|
        csv << self.new(row[0], row[1])
        end
        csv
    end

    def create(name, email)
      create_contact = Contact.new(name, email)
      new_person = [create_contact.name, create_contact.email]
      CSV.open("contacts.csv", "a+") do |single|
        single << new_person
      end
    end

    def find(id)
      if CSV.read("contacts.csv")[id] == nil
        puts '"not found"'
      else
        puts CSV.read("contacts.csv")[id]
      end
    end

    def search(term)
      Contact.all.select do |contact| contact.name.downcase.include?(term)
      end
    end
  end
end
