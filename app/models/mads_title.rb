class MadsTitle
  include ActiveFedora::RdfObject
    include ActiveFedora::Rdf::DefaultNodes
  include DamsHelper
  rdf_type MADS.Title
  map_predicates do |map|
    map.name(:in => MADS, :to => 'authoritativeLabel')
    map.externalAuthorityNode(:in => MADS, :to => 'hasExactExternalAuthority')
    map.elementList(:in => MADS, :to => 'elementList', :class_name=>'TitleList')
  end

  def serialize
    if(!externalAuthority.nil?)
      if new?
        graph.insert([rdf_subject, MADS.hasExactExternalAuthority, externalAuthority])
      else
        graph.update([rdf_subject, MADS.hasExactExternalAuthority, externalAuthority])
      end
    end
    super
  end

  def externalAuthority=(val)
    if val.class == Array
     val = val.first
    end
    @extAuthority = RDF::Resource.new(val)
  end
  def externalAuthority
    if @extAuthority != nil
      @extAuthority
    elsif !externalAuthorityNode.nil?
      externalAuthorityNode.first
    else
        nil
    end
  end

  def label
    main = value
    subt = subtitle
    nons = nonSort
    pnam = partName
    pnum = partNumber

    # make sure we have values not arrays
    main = main.first if main.class == Array
    subt = subt.first if subt.class == Array
    nons = nons.first if nons.class == Array
    pnam = pnam.first if pnam.class == Array
    pnum = pnum.first if pnum.class == Array

    label = main
    label += ": " + subt if subt
    label += ", " + nons if nons
    label += ", " + pnam if pnam
    label += ", " + pnum if pnum
    label
  end
  def value
    getValue "MainTitleElement"
  end
  def nonSort
    getValue "NonSortElement"
  end
  def partName
    getValue "PartNameElement"
  end
  def partNumber
    getValue "PartNumberElement"
  end
  def subtitle
    getValue "SubTitleElement"
  end
  def value=(s)
    setValue( "MainTitleElement", s )
  end
  def nonSort=(s)
    setValue( "NonSortElement", s )
  end
  def partName=(s)
    setValue( "PartNameElement", s )
  end
  def partNumber=(s)
    setValue( "PartNumberElement", s )
  end
  def subtitle=(s)
    setValue( "SubTitleElement", s )
  end

  class TitleList < MadsDatastream::List
  end
  def getValue(type)
    elem = find_element type
    if elem != nil
      elem.elementValue.first
    else
      []
    end
  end
  def setValue(type,val)
    if val.class == Array
        val = val.first
    end

    if elementList[0] == nil
      elementList.build
    end

    existing_elem = find_element type

    #need to use eList.size to know where to insert/update the value
    if(existing_elem != nil )
      # set value of existing element
      existing_elem.elementValue = val
    else
      # create a new element of the correct type
      if type.include? "MainTitleElement"
        elem = MadsDatastream::List::MainTitleElement.new(elementList.first.graph)
      elsif type.include? "NonSortElement"
        elem = MadsDatastream::List::NonSortElement.new(elementList.first.graph)
      elsif type.include? "PartNameElement"
        elem = MadsDatastream::List::PartNameElement.new(elementList.first.graph)
      elsif type.include? "PartNumberElement"
        elem = MadsDatastream::List::PartNumberElement.new(elementList.first.graph)
      elsif type.include? "SubTitleElement"
        elem = MadsDatastream::List::SubTitleElement.new(elementList.first.graph)
      end
      elem.elementValue = val

      # add new element to the end of the list
      if elementList.first.nil?
        elementList.first.value = elem
      else
        elementList.first[elementList.first.size] = elem
      end
    end

#    # update authoritativeLabel
#    parts = {}
#    # marginally more efficient than using getValue?
#    chain = elementList.first
#    while chain != nil do
#      if chain.first.class.name.include? "MainTitleElement"
#        parts['main'] = chain.first.elementValue
#      elsif chain.first.class.name.include? "NonSortElement"
#        parts['nonsort'] = chain.first.elementValue
#      elsif chain.first.class.name.include? "PartNameElement"
#        parts['partname'] = chain.first.elementValue
#      elsif chain.first.class.name.include? "PartNumberElement"
#        parts['partnumber'] = chain.first.elementValue
#      elsif chain.first.class.name.include? "SubTitleElement"
#        parts['subtitle'] = chain.first.elementValue
#      end
#      chain = chain.tail
#    end
#    label = parts['main']
#    label += ": " + parts['subtitle'] if parts['subtitle']
#    label += ", " + parts['nonsort'] if parts['nonsort']
#    label += ", " + parts['partname'] if parts['partname']
#    label += ", " + parts['partnumber'] if parts['partnumber']
#    name = label # not working...
  end
  def find_element( type )
    chain = elementList.first
    elem = nil
    while  elem == nil && chain != nil do
      if chain.first.class.name.include? type
        elem = chain.first
      else
        chain = chain.tail
      end
    end
    elem
  end

end
