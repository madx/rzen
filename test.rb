require 'lib/rzen'
include RZen

def getpass
  Entry.get(:title => 'Password?', :text => 'Enter your password please', :hide_text => true)
end

password = getpass

while password.length < 8
  Error.show(:title => 'Password too short', :text => 'Your password is too short, chose another one please')
  password = getpass  
end
  
