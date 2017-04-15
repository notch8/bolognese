require 'spec_helper'

describe Bolognese::Bibtex, vcr: true do
  let(:string) { IO.read(fixture_path + "crossref.bib") }

  subject { Bolognese::Bibtex.new(string: string) }

  context "get metadata" do
    it "Crossref DOI" do
      expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.7554/elife.01567")
      expect(subject.type).to eq("ScholarlyArticle")
      expect(subject.url).to eq("http://elifesciences.org/lookup/doi/10.7554/eLife.01567")
      expect(subject.resource_type_general).to eq("Text")
      expect(subject.author).to eq([{"@type"=>"Person", "givenName"=>"Martial", "familyName"=>"Sankar"},
                                    {"@type"=>"Person", "givenName"=>"Kaisa", "familyName"=>"Nieminen"},
                                    {"@type"=>"Person", "givenName"=>"Laura", "familyName"=>"Ragni"},
                                    {"@type"=>"Person", "givenName"=>"Ioannis", "familyName"=>"Xenarios"},
                                    {"@type"=>"Person", "givenName"=>"Christian S", "familyName"=>"Hardtke"}])
      expect(subject.title).to eq("Automated quantitative histology reveals vascular morphodynamics during Arabidopsis hypocotyl secondary growth")
      expect(subject.description["text"]).to start_with("Among various advantages, their small size makes model organisms preferred subjects of investigation.")
      expect(subject.license["id"]).to eq("http://creativecommons.org/licenses/by/3.0/")
      expect(subject.date_published).to eq("2014")
      expect(subject.is_part_of).to eq("type"=>"Periodical", "name"=>"eLife", "issn"=>"2050-084X")
    end
  end

  context "get metadata as datacite xml" do
    it "Crossref DOI" do
      datacite = Maremma.from_xml(subject.datacite).fetch("resource", {})
      expect(datacite.dig("resourceType", "resourceTypeGeneral")).to eq("Text")
      expect(datacite.dig("titles", "title")).to eq("Automated quantitative histology reveals vascular morphodynamics during Arabidopsis hypocotyl secondary growth")
      expect(datacite.dig("descriptions", "description", "__content__")).to start_with("Among various advantages, their small size makes model organisms preferred subjects of investigation.")
      expect(datacite.dig("creators", "creator").count).to eq(5)
      expect(datacite.dig("creators", "creator").first).to eq("creatorName"=>"Sankar, Martial", "givenName"=>"Martial", "familyName"=>"Sankar")
    end
  end

  context "get metadata as citeproc" do
    it "Crossref DOI" do
      json = JSON.parse(subject.citeproc)
      expect(json["type"]).to eq("article-journal")
      expect(json["id"]).to eq("https://doi.org/10.7554/elife.01567")
      expect(json["DOI"]).to eq("10.7554/elife.01567")
      expect(json["URL"]).to eq("http://elifesciences.org/lookup/doi/10.7554/eLife.01567")
      expect(json["title"]).to eq("Automated quantitative histology reveals vascular morphodynamics during Arabidopsis hypocotyl secondary growth")
      expect(json["author"]).to eq([{"family"=>"Sankar", "given"=>"Martial"},
                                    {"family"=>"Nieminen", "given"=>"Kaisa"},
                                    {"family"=>"Ragni", "given"=>"Laura"},
                                    {"family"=>"Xenarios", "given"=>"Ioannis"},
                                    {"family"=>"Hardtke", "given"=>"Christian S"}])
      expect(json["container-title"]).to eq("eLife")
      expect(json["issued"]).to eq("date-parts" => [[2014]])
    end
  end

  context "get metadata as ris" do
    it "Crossref DOI" do
      ris = subject.ris.split("\r\n")
      expect(ris[0]).to eq("TY - JOUR")
      expect(ris[1]).to eq("T1 - Automated quantitative histology reveals vascular morphodynamics during Arabidopsis hypocotyl secondary growth")
      expect(ris[2]).to eq("T2 - eLife")
      expect(ris[3]).to eq("AU - Sankar, Martial")
      expect(ris[8]).to eq("DO - 10.7554/elife.01567")
      expect(ris[9]).to eq("UR - http://elifesciences.org/lookup/doi/10.7554/eLife.01567")
      expect(ris[10]).to eq("AB - Among various advantages, their small size makes model organisms preferred subjects of investigation. Yet, even in model systems detailed analysis of numerous developmental processes at cellular level is severely hampered by their scale.")
      expect(ris[11]).to eq("PY - 2014")
      expect(ris[12]).to eq("VL - 3")
      expect(ris[13]).to eq("ER - ")
    end
  end

  context "get metadata as turtle" do
    it "Crossref DOI" do
      id = "10.7554/eLife.01567"
      subject = Bolognese::Crossref.new(id: id)
      expect(subject.valid?).to be true
      ttl = subject.turtle.split("\n")
      expect(ttl[0]).to eq("@prefix schema: <http://schema.org/> .")
      expect(ttl[2]).to eq("<https://doi.org/10.7554/elife.01567> a schema:ScholarlyArticle;")
    end
  end
end
