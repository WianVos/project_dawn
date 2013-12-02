#!/usr/bin/env ruby
require 'yaml'
hash = { 'instances' => { 'jetty1' => { 'memory' => '512', 'cpu' => '1', 'deployit' => true}, 'jetty2' => {'cpu' => '1'} } , 'mq' => { 'queue1' => { 'name' => 'tst1'} } }  

File.open('/tmp/test.yml', 'w') {|f| f.write hash.to_yaml }
