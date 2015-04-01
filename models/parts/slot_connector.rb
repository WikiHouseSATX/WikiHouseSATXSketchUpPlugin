class WikiHouse::SlotConnector < WikiHouse::Connector

  def slot?
    true
  end
  def name
    :slot
  end
end