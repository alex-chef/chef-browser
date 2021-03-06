require 'chef-browser/app'

module ChefBrowser
  class FileContent
    include Linguist::BlobHelper

    attr_accessor :name, :path, :data

    @highlight_options = { encoding: 'utf-8', formatter: 'html', linenos: 'inline' }
    @markup_files = %w(license contributing testing readme)

    def initialize(name, path, content)
      @name = name
      @path = path
      @data = content
    end

    class << self
      def show_file(file)
        content = FileContent.new(file.name, file.url, open(file.url).read)
        extname = File.extname(file.name).downcase
        if extname == '.md' || @markup_files.include?(file[:name].downcase)
          GitHub::Markup.render('README.md', content.data)
        else
          if content.image?
            path = content.path
            "<img src = '#{path}'><p></p>"
          elsif content.text?
            FileContent.highlight_file(content.name, extname, content.data)
          end
        end
      end

      def highlight_file(filename, extname, content)
        lexer = (Linguist::Language[extname.gsub(/^\./, '')] ||
                 Linguist::Language.find_by_filename(filename).first ||
                 Linguist::Language[Linguist.interpreter_from_shebang(content)]
                )
        if lexer
          lexer.colorize(content, options: @highlight_options)
        else
          Pygments.highlight(content, lexer: 'text', options: @highlight_options)
        end
      end
    end
  end
end
