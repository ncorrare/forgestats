require 'net/https'
require 'time'
require 'json'
require 'date'
forge = Net::HTTP.new("forgeapi.puppet.com",443)
forge.use_ssl = true
forge.verify_mode = OpenSSL::SSL::VERIFY_NONE
i = 0
num = 4300
offset = 100
start_time = DateTime.now
end_time =  DateTime.new(2015,6,8)
umc = 0
print "#{start_time}\n"
print "#{end_time}\n"
while i < num do
  request = Net::HTTP::Get.new("/v3/modules?show_deleted=false&limit=100&offset=#{offset}")
  i += offset
  response = forge.request(request)
  modules = JSON.parse(response.body)
  modules["results"].each { |forgemod|
	  updated = Date.parse forgemod["releases"][0]["created_at"]
	  if updated.between?(end_time, start_time)
		  umc += 1
	  end
  }
  print "Partial Count #{umc} | Offset at #{i}\n"
  i += offset
end
print "Updated module count: #{umc}"
