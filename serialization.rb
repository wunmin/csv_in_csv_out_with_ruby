require "csv"
require "date"
require "byebug"

class Person
  attr_accessor :id, :first_name, :last_name, :email, :phone, :created_at
  def initialize(person = {})
    @id = person[:id]
    @first_name = person[:first_name] || "p"
    @last_name = person[:last_name]
    @email = person[:email]
    @phone = person[:phone]
    # @created_at = person[:created_at] || Time.now.to_s
    @created_at = object_created_at(Time.now.to_s)
  end

  def object_created_at(time_string)
    DateTime.parse(time_string)
  end
end

class PersonParser
  attr_reader :file

  def initialize(file)
    @file = file
    @people = nil
  end

  def people
    # If we've already parsed the CSV file, don't parse it again.
    # Remember: @people is +nil+ by default.
    return @people if @people

    # We've never called people before, now parse the CSV file
    # and return an Array of Person objects here.  Save the
    # Array in the @people instance variable.
    @people = CSV.read("people.csv")
    @people.each_with_index do |person, index|
      # p person[5]
      # byebug
      if index != 0
        person[5] = DateTime.parse(person[5])
      end
    end
  end

  # person will be a Person object
  def add_person(person)
    @people << [person.id, person.first_name, person.last_name, person.email, person.phone, person.created_at]
  end

  def delete_person(id)
    @people.each_with_index do |element, index|
      if element[0] == id
        @people.delete_at(index)
      end
    end
  end

  def save
    CSV.open("people.csv", "wb") do |csv|
      @people.each do |person|
        csv << person
      end

    end
    # CSV.open("people.csv", "ab") do |csv|
    #   csv << @people[-1]
    end
end

parser = PersonParser.new('people.csv')

puts "There are #{parser.people.size} people in the file '#{parser.file}'."

new_person = Person.new(id: "123456789", first_name: "Test", last_name: "Testing", email: "test@test.com", phone: "0123456789")

parser.add_person(new_person)
parser.save
p parser.people
# parser.delete_person("123456789")
# parser.save
# p parser.people