module BasicHelpers
  # Produces a basic HTML table given an enumerable +source+.
  # 
  # === Examples
  #
  #   rows = 
  #   [
  #     %w{John john@domain.com}, 
  #     %w{Doe doe@domain.com}
  #   ]
  #
  #   table(rows)
  #
  #   # <table>
  #   #   <tr>
  #   #     <td>John</td>
  #   #     <td>john@domain.com</td>
  #   #   </tr>
  #   #   <tr>
  #   #     <td>Doe</td>
  #   #     <td>doe@domain.com</td>
  #   #   </tr>
  #   # </table>
  #
  #   table([%w{Name E-mail}] + rows, :headers => true)
  #   table(rows, :headers => %w{Name E-mail})
  #
  #   # <table>
  #   #   <thead>
  #   #     <tr>
  #   #       <th>Name</th>
  #   #       <th>E-mail</th>
  #   #     </tr>
  #   #   </thead>
  #   #   <tr>
  #   #     <td>John</td>
  #   #     <td>john@domain.com</td>
  #   #   </tr>
  #   #   <tr>
  #   #     <td>Doe</td>
  #   #     <td>doe@domain.com</td>
  #   #   </tr>
  #   # </table>
  def table(source, options = {})
    return nil if source.blank? 

    html = ''

    if headers = options.delete(:headers)
      html << content_tag(:thead,
        content_tag(:tr,
          (headers == true ? source.delete_at(0) : headers).map {|col| content_tag(:th, col) }
        )
      )
    end

    source.inject(html) do |buffer,row|
      buffer << content_tag(:tr, row.map {|col| content_tag(:td, *(Array(col))) })
    end

    content_tag(:table, html, options)
  end

  # Produces a simple table for a given
  # collection of arbitrary objects.
  # 
  # === Examples
  #
  #   @people = 
  #   [
  #     Person.new('John', 'john@domain.com'), 
  #     Person.new('Doe', 'doe@domain.com')
  #   ]
  #
  #   table(:people, %w{name email})
  #
  #   # <table>
  #   #   <tr>
  #   #     <td>John</td>
  #   #     <td>john@domain.com</td>
  #   #   </tr>
  #   #   <tr>
  #   #     <td>Doe</td>
  #   #     <td>doe@domain.com</td>
  #   #   </tr>
  #   # </table>
  #
  #   table(rows, [:name, :email], :headers => true)
  #
  #   # <table>
  #   #   <thead>
  #   #     <tr>
  #   #       <th>Name</th>
  #   #       <th>Email</th>
  #   #     </tr>
  #   #   </thead>
  #   #   <tr>
  #   #     <td>John</td>
  #   #     <td>john@domain.com</td>
  #   #   </tr>
  #   #   <tr>
  #   #     <td>Doe</td>
  #   #     <td>doe@domain.com</td>
  #   #   </tr>
  #   # </table>
  def table_for(source, attrs = nil, options = {})
    source = instance_variable_get("@#{source}") if source.kind_of?(Symbol)

    if attrs.blank?
      rows = source.map {|x| [x.to_s] }
    else
      rows = source.map do |x|
        attrs.map do |att|
          case att
          when Proc
            att.call(x)
          else
            x.send(att)
          end
        end
      end
    end

    options[:headers] = attrs.map {|att| att.to_s.humanize } if options[:headers] == true

    table(rows, options)
  end
  
  def ul(items, options = {}, &block)
    return nil if items.blank?

    tag = options.delete(:tag) || :ul

    contents = if block_given?
      items.inject([]) do |html,item|
        html << content_tag(:li, *yield(item))
      end.join("\n")
    else
      "\n<li>#{items.join("</li>\n<li>")}</li>\n"
    end

    content_tag(tag, contents, options)
  end

  def ol(items, options = {}, &block)
    ul(items, options.merge(:tag => :ol), &block)
  end

  def dl(items, options = {}, &block)
    return nil if items.blank?

    items = items.map(&block) if block_given?

    content_tag(:dl, items.inject('') {|html,item| content_tag(:dt, item.first) + content_tag(:dd, item.last) }, options)
  end
end
