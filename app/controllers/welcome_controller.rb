class WelcomeController < ApplicationController
  require 'open-uri'
  require 'rubygems'
  require 'httparty'
  require 'json'

  def index
    #@graph = Koala::Facebook::API.new(current_user.oauth_token)
    #@friends = @graph.get_connections("me", "feed")
    #puts @friends
  end

  def parse
    i = 0
    j = 1
    response = HTTParty.get("https://graph.facebook.com/755985781119509/feed/?access_token=CAACEdEose0cBAJlIwmDgQzLe3LMj9QlO7NhPMrzfg3NH6nEecVZAbnBsFewKYUJYcIWklLVBMy9jkdztVhx6Iwos0TnC2hD0oxlZBg1PTZAJDOxShxhYECIa5taFkKKFx3fDiXw0HRfSWnkbkt6VKgpZBgMV1rOmAUgbcTGgSv82OJAbyMB4fnUXZCW257E0ZD")
    puts "putting response"
    json = JSON.parse(response.body)
    #response = open("")
    counter = Hash.new
    counter = response.body.strip.downcase.split(/[^\w']+/).group_by(&:to_s).map { |w| {w[0] => w[1].count} }
    counter.each do |c|
      c.map do |x, y|
        #puts "Key is " + x
        #puts  y
      end
    end
    like_hash = {}
    if json != nil
      json['data'].each do |d|
        d['likes']['data'].each do |x|
          get_likers(x, 0, like_hash)
        end
        puts "Likers on the main page--------------------------------------------------"
        #puts like_hash
        #puts like_hash
        d['likes']['paging'].each do |x|
          j = j+1
          next if j.even?
          if x[0] == "next"
            response1 = HTTParty.get(x[1])
            json = JSON.parse(response1.body)
            puts "Filling next page likers-----------------------------------------"
            json['data'].each do |y|
              i = i+1
              next if i.even?
              puts y[1]
              if like_hash[y[1]] == nil
                like_hash[y[1]] =1
              else
                like_hash[y[1]] = like_hash[y[1]] + 1
              end
            end
            #get_likers(json['data'], 0, like_hash)
            #getLikers(json, 0, like_hash)
          end

        end
        puts "Likers in another page..................................................."
      end
      puts "Final Mapppppppppppppppp#################################"
      #puts like_hash
    end

  end

  def get_likers(x, i, like_hash)
    x.each do |y|
      i = i+1
      next if i.even?
      #puts y[1]
      if like_hash[y[1]] == nil
        like_hash[y[1]] =1
      else
        like_hash[y[1]] = like_hash[y[1]] + 1
      end
    end

  end

  def connect

  end
end
