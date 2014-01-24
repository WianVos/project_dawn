#!/usr/bin/env ruby
require 'fog'
require 'pp'
credentials = {
    :provider => "vsphere",
    :vsphere_username => 'NLKVKF94\dbxwvo',
    :vsphere_password=> 'kvk9kvk4',
    :vsphere_server => "se94avc01.win.k94.kvk.nl",
    :vsphere_ssl => 'true',
    :vsphere_expected_pubkey_hash => '67f377df9eb20595f901015be43b86ceeb0195f1f4dd749d582916148938823e'
}

clone = { 
	:instance_uuid => "",
	:name => 'testvm',
        } 
compute = Fog::Compute.new(credentials)
#p compute
vms = compute.list_virtual_machines(datacenter: 'KvK_Woerden', cluster: 'Cluster_ZMM')
pp vms

#pp compute.vm_clone(clone){"vm_ref=>'vm-test' task_ref=>'task-5'} 
