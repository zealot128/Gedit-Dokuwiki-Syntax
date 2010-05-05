require "rubygems"
require "builder"

TITLE = "dokuwiki"

xml = Builder::XmlMarkup.new( :target => $stdout , :indent => 1 )
xml.instruct!
xml.language(:id => TITLE, :_name => TITLE, :_section => "Markup", :version => "2.0") do
  xml.styles do
    xml.style(:id => "string", :_name => "String", "map-to" => "def:string")
    xml.style(:id => "escaped-character", :_name => "Escaped Charater", "map-to" => "def:special-char")
    xml.style(:id => "preprocessor", :_name => "Preprocessor", "map-to" => "def:preprocessor")
    xml.style(:id => "included-file", :_name => "Included File", "map-to" => "def:string")
    xml.style(:id => "char", :_name => "Charcter", "map-to" => "def:character")
    xml.style(:id => "keyword", :_name => "Keyword", "map-to" => "def:keyword")
    xml.style(:id => "type", :_name => "Data Type", "map-to" => "def:special-constant")
    xml.style(:id => "lists", :_name => "List Type", "map-to" => "def:type")
    xml.style(:id => "comment", :_name => "Code", "map-to" => "def:comment")
    xml.style(:id => "underlined", :_name => "Underlined", "map-to" => "def:underlined")
=begin
    <style id="comment"                 _name="Comment"                 map-to="def:comment"/>
    <style id="tag"                     _name="Tag"                     map-to="def:special-constant"/>
    <style id="class-tag"               _name="Class Tag"               map-to="def:function"/>
    <style id="id-tag"                  _name="Id Tag"                  map-to="def:identifier"/>
    <style id="error"                   _name="Error"                   map-to="def:error"/>
    <style id="keyword"                 _name="Keyword"                 map-to="def:keyword"/>
    <style id="function"                _name="Function"                map-to="def:function"/>
    <style id="known-property-values"   _name="Known Property Value"    map-to="def:type"/>
    <style id="decimal"                 _name="Decimal"                 map-to="def:decimal"/>
    <style id="dimension"               _name="Dimension"               map-to="def:floating-point"/>
    <style id="color"                   _name="Color"                   map-to="def:base-n-integer"/>
=end
  end
  xml.definitions do

    xml.context(:id => "latex", "style-ref" => "keyword") do
      xml.start "<latex>"
      xml.tag!("end","</latex>")
      xml.include do
        xml.context(:ref => "latex:in-math")
      end
    end
    xml.context(:id => TITLE) do
      xml.include do
        xml.context(:id => "underlined", "extend-parent" => false, "style-ref" => "underlined") do
          xml.match "\\%{def:net-address}"
        end
        xml.context(:ref => "latex")
        xml.context(:id => "string", "style-ref" => "string") do
          xml.start "\\/\\/|\\*\\*|__"
          xml.tag!("end", "\\/\\/|\\*\\*|__|$")
        end

        xml.context(:id => "type", "style-ref" => "type") do
          xml.start "==+"
          xml.tag!("end","==+")
        end

        xml.context(:id => "comment-multiline", "style-ref" => "comment") do
          xml.start "<code[ a-z]*>"
          xml.tag!("end", "<\\/code>")
        end
        xml.context(:id =>"lists","style-ref" => "lists") do
          xml.match "([ ]{2})+[\\*-]"
        end
        xml.context(:id =>"footnote","style-ref" => "lists") do
          xml.match "\\(\\(.*\\)\\)"
        end
        xml.context(:id =>"picture","style-ref" => "lists") do
          xml.match "\\{\\{[^\\}]*\\}\\}"
        end

        xml.context(:id => "indent-multiline", "style-ref" => "comment") do
          xml.match "^[ ]{2}.*$"
        end
        xml.context(:id => "quotes", "style-ref" => "comment") do
          xml.match "^>+ .*"
        end

        xml.context(:id => "dwkeyword", "style-ref" => "keyword") do
          xml.keyword "FIXME"
          xml.keyword "DELETEME"
          xml.keyword "~~NOTOC~~"
          xml.keyword "~~ODF~~"
          xml.keyword "----"
          xml.keyword "\\\\"
        end

        # TODO Tables, Images
        xml.context(:id => "tables", "style-ref" => "comment") do
          xml.match("^[\\|\\^].*[\\|\\^]$")
        end



      end
    end
  end
end

