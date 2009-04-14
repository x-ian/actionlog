module ClientCheckupHelper
    # This method was taken from Richard Livsey's browser_detect plugin
  # http://svn.livsey.org/plugins/browser_detect/
  def browser_is? name

    name = name.to_s.strip

    return true if browser_name == name
    return true if name == 'mozilla' && browser_name == 'gecko'
    return true if name == 'ie' && browser_name.index('ie')
    return true if name == 'webkit' && browser_name == 'safari'

  end

  # This method was taken from Richard Livsey's browser_detect plugin
  # with small nil-catching modification
  # http://svn.livsey.org/plugins/browser_detect/
  def browser_name
    @browser_name ||= begin

      ua = request.env['HTTP_USER_AGENT']
      return nil if ua.nil?
      ua.downcase!

      if ua.index('msie') && !ua.index('opera') && !ua.index('webtv')
        'ie'+ua[ua.index('msie')+5].chr
      elsif ua.index('gecko/')
        'gecko'
      elsif ua.index('opera')
        'opera'
      elsif ua.index('konqueror')
        'konqueror'
      elsif ua.index('applewebkit/')
        'safari'
      elsif ua.index('mozilla/')
        'gecko'
      end

    end
  end

  def ie?
    browser_name && browser_name[0..1] == "ie"
  end

  def browser_os
    @browser_od ||= begin
      ua = request.env['HTTP_USER_AGENT']
      return nil if ua.nil?
      ua.downcase!

      if ua.include?('mac os x') or ua.include?('mac_powerpc')
        'mac'
      elsif ua.include?('windows')
        'win'
      elsif ua.include?('linux')
        'linux'
      else
        nil
      end
    end
  end

end
