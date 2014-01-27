
# JBuilder is cool!
# See: http://railscasts.com/episodes/320-jbuilder?view=asciicast
# and: https://github.com/rails/jbuilder/blob/master/README.md


# Render all the fields of the pbx user
json.(@pbx_user, :id, :name, :description, :md5_password, :extension)

# Render the last outbound and last inbound calls
last = @pbx_user.outbound_calls.placed_today.answered.last
first = @pbx_user.inbound_calls.placed_today.answered.last

if not last.nil?
  json.last_outbound_cid @pbx_user.outbound_calls.placed_today.answered.last.dst
else
  json.last_outbound_cid ''
end

if not first.nil?
  json.last_inbound_cid @pbx_user.inbound_calls.placed_today.answered.last.src
else
  json.last_inbound_cid ''
end
