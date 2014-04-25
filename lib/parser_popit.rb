require 'i18n'

def parser_popit data

  @api = @options[:api]

  data[:diputados].each do |diputado|

    bloque = {}
    bloque[:name] = diputado[:block]
    bloque[:slug] = slug bloque[:name]

    camara = {}
    camara[:name] = "Honorable Cámara de Diputados de la Nación"
    camara[:slug] = "hcdn"

    start_date      = diputado[:start_date]
    end_date        = diputado[:end_date]
    district        = diputado[:district]


    diputado_response = update_person diputado
    bloque_response = update_organization bloque
    camara_response = update_organization camara

    ##Memberships
    update_membership camara_response, diputado_response, "Diputado", start_date, end_date, district
    update_membership bloque_response, diputado_response, "Integrante", start_date, end_date, district
  end
end



def update_membership organization, person, role, start_date, end_date, district
  membership = {}
  membership[:organization_id] = organization["id"]
  membership[:person_id]       = person["id"]
  membership[:role]            = role
  membership[:start_date]      = start_date
  membership[:end_date]        = end_date
  membership[:district]        = district


  # Check to see if content exists
  exists = @api.search.memberships.get(
    :q => 'organization_id: "'+membership[:organization_id]+'" &&
           person_id: "'+membership[:person_id]+'" &&
           start_date: "'+membership[:start_date].to_s+'" &&
           end_date: "'+membership[:end_date].to_s+'"
    ')

  #puts exists

  if !exists.empty?
    puts "Membership already exists for " + person["id"].to_s + " as " + role + " to " + organization["id"  ].to_s + " amount existent: " +exists.count.to_s
  else
      #Create content
      puts "Adding membership for " + person["id"].to_s + " as " + role + " to " + organization["id"  ].to_s
      response = @api.memberships.post membership
  end
  rescue
    p membership
  raise
    
  return response
end

def update_person content
  # Check to see if content exists
  exists = @api.search.persons.get(:q => 'slug: "'+content[:slug]+'"')

  if !exists.empty?
    puts "Already exists " + content[:slug]
    response = exists.first
    #puts "Updating " + content[:slug]
    #response = @api.persons(exists.first["id"].to_s).put content
  else
      #Create content
      puts "Creating " + content[:slug]
      response = @api.persons.post content
  end
  rescue
    p content
  raise
    
  return response

end

def update_organization content
  # Check to see if content exists
  exists = @api.search.organizations.get(:q => 'slug: "'+content[:slug]+'"')

  if !exists.empty?
    #Update content with new information
    #puts "Updating " + content[:slug]
    puts "Already exists " + content[:slug]
    response = exists.first
    #response = @api.organizations(exists.first["id"].to_s).put content
  else
      #Create content
      puts "Creating " + content[:slug]
      response = @api.organizations.post content
  end
  rescue
    p content
  raise
    
  return response

end
