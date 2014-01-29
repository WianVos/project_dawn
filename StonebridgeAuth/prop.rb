require 'yaml'

users = {'wian' => {'password' => 'test'}}

File.open('/tmp/users.yaml', 'w') {|f| f.write users.to_yaml }