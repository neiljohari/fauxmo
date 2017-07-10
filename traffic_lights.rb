require 'sinatra'
require 'rpi_gpio'

RPi::GPIO.set_numbering :bcm

light_bcms = {
  red: 11,
  yellow: 12,
  green: 13
}

cmd_map = { on: 1, off: 0 }

get '/ha-api' do
  cmd = params[:cmd].to_sym
  scope = params[:scope].to_sym

  puts "Turning #{scope} lights to state #{cmd}"

  if scope == :all
    light_bcms.values.each do |pin|
      rpi_switch(pin, cmd_map[cmd])
    end
  else
    rpi_switch(light_bcms[scope], cmd_map[cmd])
  end

  status 200
  body ''
end

def rpi_switch(pin, state)
  puts "Setting pin #{pin} to #{state}"
  RPi::GPIO.setup pin, :as => :output
  RPi::GPIO.set_high pin if state==1
  RPi::GPIO.set_low pin if state==0
end
