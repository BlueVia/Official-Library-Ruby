require 'logger'

#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#


module BlueviaLogger
  def logger=(value)
    $logger = value
  end

  def logger
    $logger||=create_logger
  end

  def log_level=(level)
    logger.level = level
  end

  def create_logger(output=nil)
    output.nil? and output = STDOUT
    logger = Logger.new(output)
    logger.level = Logger::ERROR
    logger.datetime_format = "%Y-%m-%d %H:%M:%S"
    logger
  end
end
