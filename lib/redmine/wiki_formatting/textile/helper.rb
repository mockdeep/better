# Redmine - project management software
# Copyright (C) 2006-2011  See readme for details and license
#

module Redmine
  module WikiFormatting
    module Textile
      module Helper

        def initial_page_content(page) # spec_me cover_me heckle_me
          "h1. #{@page.pretty_title}"
        end

      end
    end
  end
end
