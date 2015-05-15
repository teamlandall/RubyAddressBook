require "./contact"

class AddressBook
	attr_reader :contacts

	def initialize
		@contacts =[]
	end

	def print_results(search, results)
		puts search
		results.each do |contact|
			puts contact.to_s('full_name')
			contact.print_phone_numbers
			contact.print_addresses
			puts "\n"
		end
	end

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

	def print_contact_list
		puts "Contact List: "
		contacts.each do |contact|
			puts contact.to_s("last_first")
		end
	end
end

address_book = AddressBook.new

landall = Contact.new
landall.first_name = "Landall"
landall.middle_name = "Don"
landall.last_name = "Proctor"
landall.add_phone_number("Home", "804-447-8021")
landall.add_phone_number("Cell", "313-969-8585")
landall.add_address("Home", "310 Durant St.", " ", "South Hill", "VA", "48207")

larry = Contact.new
larry.first_name = "Larry"
larry.middle_name = "Geraldo"
larry.last_name = "Smith"
larry.add_phone_number("Home", "123-456-7890")
larry.add_phone_number("Cell", "987-654-3210")
larry.add_address("Home", "123 Main St.", "Apt 12", "New York", "NY", "10002")


address_book.contacts.push(landall)
address_book.contacts.push(larry)

#address_book.print_contact_list
#address_book.find_by_name("r")

#address_book.find_by_phone_number("8")
address_book.find_by_address("3")