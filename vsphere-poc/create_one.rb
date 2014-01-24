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

vm_settings = { 
	'datacenter' =>  'KvK_Woerden',
	'template_path' => '_Templates/LIN_CENTOS_63_X64_ZMM',
	'name' => 'testvm1',
	#'data_store' => 'ds:///vmfs/volumes/524156-ec07032ca74-e117-6cae8b780b54'
	'data_store' => 'VMFS07_ZMM_OTA'
        } 
compute = Fog::Compute.new(credentials)
vm = compute.vm_clone(vm_settings) 
