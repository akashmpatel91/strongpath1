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
    like_hash = {}
    comment_hash = {}
    common_hash = {}
    puts common_hash
    puts like_hash
    i = 0
    j = 1
    response = HTTParty.get("https://graph.facebook.com/755985781119509/feed/?access_token=CAACEdEose0cBAKRCwGYWGgs33XjZCbJO4yDMYZCYugnlOxqWqJueBA5E0AAhI28gRBDxRZCU1PEldprn67p0psauZCOcDIchFG9yTiIZCBS1M4XKc8pBsc4ZAXT151yZAqSxrfXgqseeZCthvpy9oETHNenZCGL4LZBIJ5c1WpM4DGSntgiSWw3CtL4cOh2eLlC8kZD")
    puts "putting response"
    json = JSON.parse(response.body)
    get_common_map(response, common_hash)

    if json['error'] == nil || json['error'] == ''
      json['data'].each do |d|
        d['likes']['data'].each do |x|
          get_likers(x, 0, like_hash)
        end
        d['likes']['paging'].each do |x|
          j = j+1
          next if j.even?
          if x[0] == "next"
            puts "Outside function" + x[1]
            likers_page(x[1], like_hash)
          end

        end
      end
      puts "Final Mapppppppppppppppp#################################"
      puts like_hash

    else
      puts "dingoooo.."
    end


  end

  def likers_page(url,like_hash)
    response1 = HTTParty.get(url)
    json = JSON.parse(response1.body)
    json['data'].each do |y|
      y.map do |a, b|
        if b.match(/^\d+$/)
          if like_hash[b] == nil
            like_hash[b] =1
          else
            like_hash[b] = like_hash[b] + 1
          end
        end
      end
    end
    if json['paging']['next']
      puts "In the recursion"
      puts like_hash
      likers_page(json['paging']['next'],like_hash)
    else
      puts "Out from recursion"
    end
  end

  def get_common_map(response, common_hash)
    counter = Hash.new
    counter = response.body.strip.downcase.split(/[^\w']+/).group_by(&:to_s).map { |w| {w[0] => w[1].count} }
    counter.each do |c|
      c.map do |x, y|
        if x.match(/^\d+$/)
          common_hash[x] = y
        end

      end
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
