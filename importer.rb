require 'open-uri'
require 'person'
require 'podcast'

class Importer
  URL = 'http://www.relay.fm'

  def import_hosts
    doc = Nokogiri.HTML(open("#{URL}/people"))
    doc.css('.medium-block-grid-4').first.css('li').each do |host|
      link = host.at_css('a')
      person = Person.find_or_create_by(name: link.text)
      person_doc = Nokogiri.HTML(open(URL + link['href']))
      person.podcasts = podcasts(person_doc)
    end
  end

  def import_guests
    guests.each do |guest|
      link = guest.at_css('a')
      person = Person.find_or_create_by(name: link.text)
      person_doc = Nokogiri.HTML(open(URL + link['href']))
      person.guest_podcasts = guest_podcasts(person_doc)
    end
  end

  private

  def guests
    (1..4).flat_map do |page|
      url = "#{URL}/people/page/#{page}"
      doc = Nokogiri.HTML(open(url))
      doc.css('.medium-block-grid-4')[1].css('li')
    end
  end

  def podcasts(doc)
    doc.css('.person__broadcasts h6').map do |podcast|
      link = podcast.at_css('a')
      Podcast.find_or_create_by(
        title: link.text,
        url: URL + link['href']
      )
    end
  end

  def guest_podcasts(doc)
    doc.css('.person__guest-appearances h6').map do |podcast|
      link = podcast.at_css('a')
      Podcast.find_by(url: URL + link['href'][%r{(.*)\/.+?$}, 1])
    end.uniq
  end
end
