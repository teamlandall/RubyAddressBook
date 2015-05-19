require "./contact"
require "yaml"

class AddressBook
	attr_reader :contacts

	def initialize
		@contacts = []
		open()
	end

	def open
		if File.exists?("contacts.yml")
			@contacts = YAML.load_file("contacts.yml")
		end
	end

	def save
		File.open("contacts.yml", "w") do |file|
			file.write(contacts.to_yaml)
		end
	end

	#Allows user to search for existing contact and 
	#Delete that contact from the address book. 
	#Wrote this block on my own. Was not part of the video instruction.
	#Boo Yah!
	def delete
		print "What contact do you want to delete? "
		search = gets.chomp.downcase
		contacts.each do |contact|
			if contact.full_name.downcase.include?(search)
				contacts.delete(contact)
			end
			save()
		end
	end

	#Runs through the main interface prompting users to make a selection.
	#Gets the user input and runs a case expression to call the corresponding method.
	def run
		loop do
			puts "-" * 50
			puts "Address Book"
			puts "-" * 50
			puts "a: Add Contact"
			puts "d: Delete Contact"
			puts "p: Print Address Book"
			puts "s: Search"
			puts "e: Exit"
			puts "-" * 50
			print "Enter your choice: "
			input = gets.chomp.downcase
			case input
			when 'a'
				add_contact
			when 'd'
				delete
			when 'p'
				print_contact_list
			when 's'
				print "Search term: "
				search = gets.chomp
				find_by_name(search)
				find_by_address(search)
				find_by_phone_number(search)
			when 'e'
				save()
				break
			end
		end
	end

	#User adds contacts name information.
	def add_contact
		contact = Contact.new
		puts "\n"
		print "First Name: "
		contact.first_name = gets.chomp
		print "Middle Name: "
		contact.middle_name= gets.chomp
		print "Last Name: "
		contact.last_name = gets.chomp

		#prompts user make an additional selection of adding phone number or address.
		#runs case expression on user response to capture the appropriate input.
		loop do
			puts "\n"
			puts "Add phone number or address? "
			puts "-" * 50
			puts "p: Add phone number"
			puts "a: Add address"
			puts "(Any other key to go back)"
			puts "-" * 50
			print ">> "
			response = gets.chomp.downcase
			case response
			when 'p'
				phone = PhoneNumber.new
				puts "\n"
				print "Phone number type (Home, Work, etc): "
				phone.kind = gets.chomp
				print "Number: "
				phone.number = gets.chomp
				contact.phone_numbers.push(phone)
			when 'a'
				address = Address.new
				puts "\n"
				print "Address type (Home, Work, etc): "
				address.kind = gets.chomp
				print "Address line 1: "
				address.street_1 = gets.chomp
				print "Address line 2: "
				address.street_2 = gets.chomp
				print "City: "
				address.city = gets.chomp
				print "State: "
				address.state = gets.chomp
				print "Postal Code: "
				address.postal_code = gets.chomp
				contact.addresses.push(address)
			else 
				print "\n"
				break
			end
		end
		contacts.push(contact)
	end

	#method created specifically to not repeat the same print code in each of the methods where 
	#printing to the screen is necessary. 
	def print_results(search, results)
		puts "\n"
		puts search
		results.each do |contact|
			puts contact.to_s('full_name')
			contact.print_phone_numbers
			contact.print_addresses
			puts "\n"
		end
	end

	#Allows user to search through the Contacts Array by name. 
	def find_by_name(name)
		results = []
		search = name.downcase
		contacts.each do |contact|
			if contact.full_name.downcase.include?(search)
				results.push(contact)
			end
		end
		print_results("Name search results (#{search})", results)
	end

	#Allows user to search through the Contacts Array by phone number.
	def find_by_phone_number(number)
		results = []
		search = number.gsub("-", "")
		contacts.each do |contact|
			contact.phone_numbers.each do |phone_number|
				if phone_number.number.gsub("-", "").include?(search)
					results.push(contact) unless results.include?(contact)
				end
			end
		end
		print_results("Phone Number search results (#{search})", results)
	end

	#Allows user to search through the Contacts Array by address.
	def find_by_address(query)
		results = []
		search = query.downcase
		contacts.each do |contact|
			contact.addresses.each do |address|
				if address.to_s('long').downcase.include?(search)
					results.push(contact) unless results.include?(contact)
				end
			end
		end
		print_results("Address search results (#{search})", results)
	end

	#User can print the names of the current contact list.
	def print_contact_list
		puts "-" * 50
		puts "Contact List: "
		puts "-" * 50
		contacts.each do |contact|
			puts contact.to_s("last_first")
		end
	end
end

address_book = AddressBook.new
address_book.run