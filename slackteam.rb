#!/usr/bin/env ruby


require 'rubygems'
require 'rest_client'
require 'json'

ENDPOINT='https://slack.com/api/users.list'
warnings = []
auth_info = "token=#{ENV['TOKEN']}"
DOMAIN = ENV['DOMAIN']
full_url = ENDPOINT + "?#{auth_info}"
response = JSON.parse(RestClient.get(full_url))
users = response["members"]

def get_email(user)
  user['profile']['email']
end

def exists?(user)
  user['deleted'] == false
end

def is_neo_node?(user)
  get_email(user).end_with?(DOMAIN)
end

aliens = users.select { |user| ! is_neo_node?(user) && exists?(user) }

aliens.each do |alien|
  printf "WARNING: user %s (%s) doesn't seem to belong here\n", alien['profile']['real_name'], get_email(alien)
end

exit aliens.length # 0 is good, anything else bad
