require 'open-uri'
require 'person'
require 'podcast'
require 'episode'

class Importer
  URL = 'http://www.relay.fm'

  def initialize
    doc = Nokogiri.HTML(open("#{URL}/people"))
    @hosts = doc.css('.medium-block-grid-4').first.css('li')
  end

  def import
    @hosts.each do |host|
      link = host.at_css('a')
      person = Person.find_or_create_by(name: link.text)
      person_doc = Nokogiri.HTML(open(URL + link['href']))
      person.podcasts = get_podcasts(person_doc)
      person.guest_episodes = get_guest_episodes(person_doc)
    end
  end

  private

  def get_podcasts(doc)
    doc.css('.person__broadcasts h6').map do |podcast|
      link = podcast.at_css('a')
      Podcast.find_or_create_by(
        title: link.text,
        url: URL + link['href']
      )
    end
  end

  def get_guest_episodes(doc)
    doc.css('.person__guest-appearances h6').map do |episode|
      link = episode.at_css('a')
      Episode.find_or_create_by(
        title: link.text,
        url: URL + link['href']
      ).tap do |ep|
        ep.podcast = Podcast.find_by(url: ep.url[%r{(.*)\/.+?$}, 1])
      end
    end
  end
end
