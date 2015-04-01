class WikiHouse::TabConnector < WikiHouse::Connector
  def tab?
    true
  end
  def name
    :tab
  end
end