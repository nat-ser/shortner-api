# README

url
- full_address: string, null: false

has_many :shortened_address_urls

shortened_address_url
validates :uniqueness, true

- address: string, null: false
- device_type: string,  null: false
- number_of_redirects: integer, default: 0

def time_since_creation
end

belongs_to :url




don't make device a separate model bc only 3 types

http://edgeguides.rubyonrails.org/api_app.html
