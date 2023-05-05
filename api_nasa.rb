require 'uri'
require 'net/http'
require 'json'

def request(url_requested)
    url = URI(url_requested)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true # Se agrega esta línea
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER # Se agrega esta otra línea
    request = Net::HTTP::Get.new(url)

    response = http.request(request)
    return JSON.parse(response.body)

end

data_url = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10&api_key=ype1zWvoW5UA6aXrP8SD7eFA0d0P4mMGCph2EQBW"

data = request(data_url)['photos'][16..25]

def buid_web_page(data)

    photos = data.map {|x| x['img_src']}

    html_img = photos.map { |url_photo| "<li><img src='#{url_photo}'></li>" }.join("\n")

    html = "<!DOCTYPE html>\n<html lang='es'>\n<head></head>\n<body>\n<ul>\n\'#{html_img}\'</ul>\n</body>\n</html>"

    File.write('output.html', html)
end

buid_web_page(data)

def photos_count(photos_data)
    cameras = photos_data.map { |x| x['camera']['name'] }.uniq
    camera_name = {}
    cameras.each do |camera|
        count = photos_data.count { |x| x['camera']['name'] == camera }
        camera_name[camera] = count
    end
    camera_name
end

photos_count_hash = photos_count(data)
puts photos_count_hash
# photos = data.each do |dat|
#     datos = dat['img_src']
# end

