module DamsHelper
  def subtitle
    self.title.first ? self.title.first.subtitle : []
  end
  def subtitle=(val)
    if self.title == nil
      self.title = []
    end
    self.title.build.subtitle = val
  end

  def titleValue
    title[0] ? title[0].value : []
  end
  def titleValue=(val)
    title.build if title[0] == nil
    title[0].value = val
  end
  
  def titleType
    title[0] ? title[0].type : []
  end
  def titleType=(val)
    title.build if title[0] == nil
    title[0].type = val
  end
    

  ## Date ######################################################################
  def beginDate
    date[0] ? date[0].beginDate : []
  end
  def beginDate=(val)
    date.build if date[0] == nil
    date[0].beginDate = val
  end

  def endDate
    date[0] ? date[0].endDate : []
  end
  def endDate=(val)
    date.build if date[0] == nil
    date[0].endDate = val
  end
  def dateValue
    date[0] ? date[0].value : []
  end
  def dateValue=(val)
    date.build if date[0] == nil
    date[0].value = val
  end

  ## Note ######################################################################


  def scopeContentNoteType
    scopeContentNote.first ? scopeContentNote.first.type : []
  end
  def scopeContentNoteType=(val)
    if scopeContentNote == nil
      scopeContentNote = []
    end
    scopeContentNote.first.type = val
  end
  def scopeContentNoteDisplayLabel
    scopeContentNote.first ? scopeContentNote.first.displayLabel : []
  end
  def scopeContentNoteDisplayLabel=(val)
    if scopeContentNote == nil
      scopeContentNote = []
    end
    scopeContentNote.first.displayLabel = val
  end
  def scopeContentNoteValue
    scopeContentNote.first ? scopeContentNote.first.value : []
  end
  def scopeContentNoteValue=(val)
    if scopeContentNote == nil
      scopeContentNote = []
    end
    scopeContentNote.first.value = val
  end    
end
