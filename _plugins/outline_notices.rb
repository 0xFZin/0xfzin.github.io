# Converts Outline-style notices (:::info ... :::) into Chirpy prompts.
module OutlineNotices
  TYPES = {
    "info"    => "info",
    "warning" => "warning",
    "tip"     => "tip",
    "success" => "tip"   # Chirpy has no "success", so tip (green) is closest
  }.freeze

  PATTERN = /^:::(\w+)[ \t]*\n(.*?)\n:::[ \t]*$/m

  def self.convert(text)
    text.gsub(PATTERN) do
      type = TYPES.fetch(Regexp.last_match(1).downcase, "info")
      body = Regexp.last_match(2).lines.map do |line|
        line.strip.empty? ? ">\n" : "> #{line}"
      end.join
      "\n#{body.chomp}\n{: .prompt-#{type} }\n"
    end
  end
end

Jekyll::Hooks.register [:pages, :documents], :pre_render do |doc|
  next unless File.extname(doc.path.to_s) =~ /\.(md|markdown)$/i
  doc.content = OutlineNotices.convert(doc.content)
end