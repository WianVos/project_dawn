require 'sinatra'
require 'net/ldap'
require 'omniauth'
require 'omniauth-ldap'
require 'httplog'


class LoginManager < Sinatra::Application
  enable :sessions
  use OmniAuth::Builder do
    provider :ldap,  :title => "My LDAP",
                     :host => 'ldap1.prd.k94.kvk.nl',
                     :port => 389,
                     :method => :plain,
                     :base => 'cn=users,ou=diensten,o=KVK,c=NL',
                     :uid => 'samaccountName',
                     :name_proc => Proc.new {|name| name.gsub(/@.*$/,'')},
                     :bind_dn => 'DN=OS400-PROFILE=WSALLLOGON,CN=ACCOUNTS,OS400-SYS=AS94AMRE.K94.KVK.NL',
                     :password => 'L0G0NW4S',
                     :filter => "(&amp;(uid={0})(objectclass=kvkPerson))"
  end

  get '/' do
    <<-HTML
      <a href='/auth/ldap'>Sign in with Twitter</a>

      <form action='/auth/ldap' method='post'>
        <input type='text' name='identifier'/>
        <input type='submit' value='Sign in with OpenID'/>
      </form>
    HTML
  end

  post '/auth/:name/callback' do
    auth = request.env['omniauth.auth']
    # do whatever you want with the information!
  end

end