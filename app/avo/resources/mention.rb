# एक व्यक्ती-उल्लेख नोंद -- बातमीत कोणाचा उल्लेख आहे.
class Avo::Resources::Mention < Avo::BaseResource
  self.title = :id

  def fields
    field :id, as: :id
    field :article, as: :belongs_to, name: "बातमी"
    field :person, as: :belongs_to, name: "व्यक्ती", searchable: true,
      help: "व्यक्ती यादीत नसल्यास आधी व्यक्ती विभागात नवीन नोंद तयार करा"
  end
end
